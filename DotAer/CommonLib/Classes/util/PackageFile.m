//
//  PackageFile.m
//  iMobeeNews
//
//  Created by ellison on 11-6-9.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "PackageFile.h"
#import "BqsUtils.h"
#import "BqsAvlMap.h"
//#include <io.h>

#define kIdxCount 512
#define kDeletedHash 0xffffffff // for deleted data entry
#define kMaxDataSize (100*1024*1024) // max single data size: 100 MB
//#define kInvalidIndex 0xffffffff // for free/deleted item idx

#define kCSBqsFileTag "BqsPakFl"
#define kBqsPkgFileVer 1

typedef struct {
	unsigned int nameHash; // data name hash
	unsigned int offset; // data offset
    unsigned int size; // data size
    union {
        unsigned int time; // data update time,
        void *ptr;// for free item/deleted item, this is used as next item pointer
    }i;
} t_DATA_ITEM;

typedef struct {
	unsigned char tag[8]; // file type "BqsPakFl"
    unsigned int ver; // file ver: 1
	unsigned int cnt; // data count
    unsigned int extHeaderOffset;// extend header offset
    unsigned int reserved[4]; // reserved 
    t_DATA_ITEM items[kIdxCount];
} t_FILE_HEADER;

typedef struct {
    unsigned char tag[8]; // file type "BqsPakFl"
    unsigned int nextExtHeaderOffset; // next extend header offset
    t_DATA_ITEM items[kIdxCount];
} t_EXTEND_HEADER;

@interface PackageFile()
@property (nonatomic, copy) NSString *path;
@property (nonatomic, retain) NSMutableData *fileHeader; // t_FILE_HEADER
@property (nonatomic, retain) NSMutableArray *extHeaders; // array of NSMutableData(t_EXTEND_HEADER)
@property (nonatomic, retain) BqsAvlMapUIntPtr *mapDatas; // hash -> t_DATA_ITEM*
//@property (nonatomic, retain) NSMutableArray *arrFreeSpaces; // NSValue(t_DATA_ITEM*)

-(BOOL) initFile;
-(BOOL) createNewFile;
-(void) buildDataHash:(unsigned int)delDataBefore;
-(BOOL) flushIndex:(FILE*)fHanlder;
-(t_DATA_ITEM*) findDeletedSpaceForNewData:(int)datalen;
-(void)insertSpaceIntoDeletedSpaces:(t_DATA_ITEM*)item;
-(void)optimizeDeletedSpace;

-(t_DATA_ITEM*)allocFreeItem;

@end

@implementation PackageFile
@synthesize path;
@synthesize fileHeader;
@synthesize extHeaders;
@synthesize mapDatas;
//@synthesize arrFreeSpaces;

-(id)initWithPath:(NSString*)sPath {
    
    return [self initWithPath:sPath DelOldDataBefore:0];
}
-(id)initWithPath:(NSString *)sPath DelOldDataBefore:(unsigned int)ts {
    return [self initWithPath:sPath DelOldDataBefore:ts ReadOnly:NO];
}
-(id)initWithPath:(NSString *)sPath DelOldDataBefore:(unsigned int)ts  ReadOnly:(BOOL)bReadOnly {

    self = [super init];
    if(nil == self) return nil;
    
    _firstFreeItem = NULL;
    _firstDeletedItem = NULL;
    
    self.path = sPath;
    self.extHeaders = [NSMutableArray arrayWithCapacity:10];
    _bReadOnly = bReadOnly;
    
    if(![self initFile]) {
        BqsLog(@"Failed to init file: %@", sPath);
        
        if(_bReadOnly) {
            [self release];
            return nil;
        }
        
        if(![self createNewFile]) {
            [self release];
            return nil;
        }
        
    }
    [self buildDataHash:ts];
    
    if(!_bReadOnly) {
        [self optimizeDeletedSpace];
    }
    
    return self;
}

-(void)dealloc {
    BqsLog(@"dealloc: %@", self.path);
    self.path = nil;
    self.fileHeader = nil;
    self.extHeaders = nil;
    self.mapDatas = nil;
    [super dealloc];
}

-(BOOL)writeDataName:(NSString*)name Data:(NSData*)data {
    if(_bReadOnly) {
        BqsLog(@"readonly package file. not allow to write");
        return NO;
    }
    
    if([name length] < 1) {
        BqsLog(@"Invalid name: %@", name);
        return NO;
    }
    
    NSString *md5 = [BqsUtils calcMD5forString:name];
    
    int len = [data length];
    if(len < 1) {
        [self deleteDataName:name Flush:YES];
        return YES;
    }
    if(len > kMaxDataSize) {
        BqsLog(@"Invalid data size: %d", len);
        return NO;
    }
    
    // delete old item
    [self deleteDataName:name Flush:YES];
    
    t_DATA_ITEM *item = [self findDeletedSpaceForNewData:len];
    if(nil == item) {
        item = [self allocFreeItem];
        if(nil != item) {
            item->size = 0;
        }
    }
    
    if(nil == item) {
        BqsLog(@"Failed to alloc item for data: %@", name);
        return NO;
    }
    
    // write data

    FILE *fl = fopen([self.path UTF8String], "rb+");
    if(NULL == fl) {
        BqsLog(@"Failed to open file %@", path);
        return NO;
    }
    if(0 != fseek(fl, item->offset, SEEK_SET)) {
        BqsLog(@"Failed to seek file: %@", self.path);
        fclose(fl);
        return NO;
    }
    
    int size = fwrite([data bytes], len, 1, fl);
    if(size != 1) {
        BqsLog(@"Failed to write file: %d!=%d, %@", size, len, path);
        fclose(fl);
        return NO;
    }
    
    // update index
    item->nameHash = [md5 hash];
    if(0 == item->size) {
        // new item, extend file size
        _fileSize += len;
        BqsLog(@"filesize extended: %d", _fileSize);
    }
    item->size = len;
    item->i.time = (unsigned int)[NSDate timeIntervalSinceReferenceDate];
    [self.mapDatas setPtr:item forKey:item->nameHash];
    //[self.mapDatas setObject:[NSValue valueWithPointer:item] forKey:[NSNumber numberWithUnsignedInt:item->nameHash]];
    _inUsedSpace += len;
    
    t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
    fh->cnt ++;
    
    // flush index
    [self flushIndex:fl];
    
    fclose(fl);
    
    BqsLog(@"Write file: %@->%x,%x, len: %d", name,[md5 hash], item->nameHash, len);
    
    return YES;
}

-(NSData*)readDataName:(NSString*)name {
    if([name length] < 1) {
        BqsLog(@"Invalid name: %@", name);
        return nil;
    }
    
    NSString *md5 = [BqsUtils calcMD5forString:name];
    
//    NSValue *v = [self.mapDatas objectForKey:[NSNumber numberWithUnsignedInt:[name hash]]];
//    if(nil == v) {
//        BqsLog(@"data not exist: %@", name);
//        return nil;
//    }
//    
//    t_DATA_ITEM *item = (t_DATA_ITEM*)[v pointerValue];
    t_DATA_ITEM *item = [self.mapDatas getPtrForKey:[md5 hash]];
    if(NULL == item) {
        BqsLog(@"data not exist: %@", name);
        return nil;
    }
    
    BqsLog(@"readData: %@->%x,%x, len: %d", name, [md5 hash],item->nameHash, item->size);
    
    if(item->size > kMaxDataSize) {
        BqsLog(@"Invalid data size: %d", item->size);
        return nil;
    }
    if(item->offset + item->size > _fileSize) {
        BqsLog(@"Invalid item: offset: %d, size: %d, filesize: %d", item->offset, item->size, _fileSize);
        return nil;
    }
    
    FILE *fl = fopen([self.path UTF8String], "rb");
    if(NULL == fl) {
        BqsLog(@"Failed to open file %@", path);
        return nil;
    }
    if(0 != fseek(fl, item->offset, SEEK_SET)) {
        BqsLog(@"Failed to seek file: %@", self.path);
        fclose(fl);
        return NO;
    }
    
    NSMutableData *ret = [NSMutableData dataWithLength:item->size];
    int size = fread([ret mutableBytes], item->size, 1, fl);
    if(size != 1) {
        BqsLog(@"Failed to read file: %@", path);
        fclose(fl);
        return NO;
    }
    
    fclose(fl);

    
    return ret;
}

-(unsigned int)getDataLength:(NSString*)name {
    if([name length] < 1) {
        BqsLog(@"Invalid name: %@", name);
        return 0;
    }
    
//    NSValue *v = [self.mapDatas objectForKey:[NSNumber numberWithUnsignedInt:[name hash]]];
//    if(nil == v) {
//        BqsLog(@"data not exist: %@", name);
//        return nil;
//    }
//    
//    t_DATA_ITEM *item = (t_DATA_ITEM*)[v pointerValue];
    NSString *md5 = [BqsUtils calcMD5forString:name];
    
    t_DATA_ITEM *item = [self.mapDatas getPtrForKey:[md5 hash]];
    if(NULL == item) {
//        BqsLog(@"data not exist: %@", name);
        return 0;
    }

    return item->size;
}

-(unsigned int)getDataTime:(NSString*)name {
    if([name length] < 1) {
        BqsLog(@"Invalid name: %@", name);
        return 0;
    }
    
    NSString *md5 = [BqsUtils calcMD5forString:name];
    
    
    t_DATA_ITEM *item = [self.mapDatas getPtrForKey:[md5 hash]];
    if(NULL == item) {
        BqsLog(@"data not exist: %@", name);
        return 0;
    }
    
    return item->i.time;

}

-(void)updateDataTimeToNow:(NSString*)name Flush:(BOOL)bFlush {
    if([name length] < 1) {
        BqsLog(@"Invalid name: %@", name);
        return ;
    }
    NSString *md5 = [BqsUtils calcMD5forString:name];
    
    
    t_DATA_ITEM *item = [self.mapDatas getPtrForKey:[md5 hash]];
    if(NULL == item) {
        BqsLog(@"data not exist: %@", name);
        return ;
    }
    
    item->i.time = (unsigned int)[NSDate timeIntervalSinceReferenceDate];

    if(bFlush) {
        [self flushIndex:nil];
    }
    
    return;

}

-(void)flushIndex {
    if(_bReadOnly) {
        BqsLog(@"readonly package file. not allow to write");
        return ;
    }

    [self flushIndex:nil];
}


-(void)deleteDataName:(NSString*)name Flush:(BOOL)bFlush {
    if(_bReadOnly) {
        BqsLog(@"readonly package file. not allow to write");
        return;
    }

    if([name length] < 1) {
        BqsLog(@"Invalid name: %@", name);
        return;
    }
    
    NSString *md5 = [BqsUtils calcMD5forString:name];
    
    
    NSUInteger key = [md5 hash];
    t_DATA_ITEM *item = [self.mapDatas getPtrForKey:key];
    if(NULL == item) {
//        BqsLog(@"data not exist: %@", name);
        return;
    }
    
    BOOL bTruncate = NO;
    
//    if(item->size + item->offset == _fileSize) {
//        
//        FILE *fl = fopen([self.path UTF8String], "rb+");
//        if(NULL != fl) {
//            BqsLog(@"deleting last item, truncate file size to: %u", _fileSize - item->size);
//            if(0 == chsize(fileno(fl), _fileSize - item->size)) {
//                _fileSize -= item->size;
//                bTruncate = YES;
//            } else {
//                BqsLog(@"Failed to change file size.");
//            }
//            fclose(fl);
//        } else {
//            BqsLog(@"Failed to open file %@", path);
//        }
//        
//        
//    }

    _inUsedSpace -= item->size;
    
    if(bTruncate) {
        item->nameHash = 0;
        item->offset = 0;
        item->size = 0;
        
        item->i.ptr = _firstFreeItem;
        _firstFreeItem = item;
    } else {
        item->nameHash = kDeletedHash;
        [self insertSpaceIntoDeletedSpaces:item];
    }
    
    t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
    fh->cnt --;
    
//    [self.mapDatas removeObjectForKey:key];
    [self.mapDatas deletePtrForKey:key];

    
    BqsLog(@"delete data: offset: %d, size: %d", item->offset, item->size);
    
    if(bFlush) {
        [self flushIndex:nil];
    }

    return;
}

//-(void)deleteMultiDataName:(NSArray*)names {
//    
//    BOOL bDeleteOne = NO;
//    
//    for(NSString *name in names) {
//        if([name length] < 1) {
//            BqsLog(@"Invalid name: %@", name);
//            continue;
//        }
//        
//        NSUInteger key = [name hash];
//        t_DATA_ITEM *item = [self.mapDatas getPtrForKey:key];
//        if(NULL == item) {
//            BqsLog(@"data not exist: %@", name);
//            continue;
//        }
//                
//        item->nameHash = kDeletedHash;
//        _inUsedSpace -= item->size;
//        
//        [self insertSpaceIntoDeletedSpaces:item];
//
//        
//        t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
//        fh->cnt --;
//        
//        [self.mapDatas deletePtrForKey:key];
//        
//        bDeleteOne = YES;
//        BqsLog(@"delete data: offset: %d, size: %d", item->offset, item->size);
//    }
//    if(bDeleteOne) {
//        [self flushIndex:nil];
//    }
//}

-(unsigned int)getDeletedSpaceSize {
    return _deletedSpaceSize;
}
-(unsigned int)getDeletedItemCnt {
    return _deletedItemCnt;
}
-(unsigned int)getInUsedSpace {
    return _inUsedSpace;
}
-(unsigned int)getFileSize {
    return _fileSize;
}

#pragma mark - internal methods
-(BOOL) initFile {
    int fsize = [BqsUtils fileSize:self.path];
    
    if(fsize < sizeof(t_FILE_HEADER)) {
        return NO;
    }
    _fileSize = fsize;
    
    
    FILE *fl = fopen([self.path UTF8String], "rb");
    if(NULL == fl) {
        BqsLog(@"Failed to open file %@", path);
        return NO;
    }
    
    if(0 != fseek(fl, 0, SEEK_SET)) {
        BqsLog(@"Failed to seek file: %@", self.path);
        fclose(fl);
        return NO;
    }
    
    self.fileHeader = [NSMutableData dataWithLength:sizeof(t_FILE_HEADER)];
    t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
    
    int size = fread(fh, sizeof(t_FILE_HEADER), 1, fl);
    if(size != 1) {
        BqsLog(@"failed to read file: %@", self.path);
        fclose(fl);
        return NO;
    }
    
    // check file type
    if(0 != memcmp(fh->tag, kCSBqsFileTag, sizeof(fh->tag))) {
        BqsLog(@"Not my file tag. %@", self.path);
        fclose(fl);
        return NO;
    }
    
    BqsLog(@"file ver: %d", fh->ver);
    
    // load ext headers
    unsigned int extHdrOffset = fh->extHeaderOffset;
    if(extHdrOffset > fsize - sizeof(t_EXTEND_HEADER)) {
        BqsLog(@"invalid ext header offset: %d", extHdrOffset);
        fh->extHeaderOffset = 0;
        extHdrOffset = 0;
    }

    while(0 != extHdrOffset) {
        if(0 != fseek(fl, extHdrOffset, SEEK_SET)) {
            BqsLog(@"Failed to seek file: %@", self.path);
            fclose(fl);
            return NO;
        }
        
        NSMutableData *extHdrData = [[NSMutableData alloc] initWithLength:sizeof(t_EXTEND_HEADER)];
        t_EXTEND_HEADER *extH = [extHdrData mutableBytes];
        size = fread(extH, sizeof(t_EXTEND_HEADER), 1, fl);
        if(size != 1) {
            BqsLog(@"failed to read file: %@", self.path);
            fclose(fl);
            [extHdrData release];
            return NO;
        }
        // check file type
        if(0 != memcmp(extH->tag, kCSBqsFileTag, sizeof(fh->tag))) {
            BqsLog(@"Not my ext header tag. %@", self.path);
            fclose(fl);
            [extHdrData release];
            return NO;
        }

        [self.extHeaders addObject:extHdrData];
        [extHdrData release];
        
        extHdrOffset = extH->nextExtHeaderOffset;
        if(extHdrOffset > fsize - sizeof(t_EXTEND_HEADER)) {
            BqsLog(@"invalid next ext header offset: %d", extHdrOffset);
            extH->nextExtHeaderOffset = 0;
            extHdrOffset = 0;
        }
    }
    fclose(fl);
    
    return YES;
}

-(BOOL) createNewFile {
    if(_bReadOnly) {
        BqsLog(@"readonly package file. not allow to write");
        return NO;
    }

    BqsLog(@"create new file: %@", self.path);
    
    self.fileHeader = [NSMutableData dataWithLength:sizeof(t_FILE_HEADER)];
    t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
    
    BqsLog(@"taglen: %d, itemlen: %d", sizeof(fh->tag), sizeof(fh->items));
    memcpy(fh->tag, kCSBqsFileTag, sizeof(fh->tag));
    fh->ver = kBqsPkgFileVer;
    fh->cnt = 0;
    memset(fh->items, 0, sizeof(fh->items));
    fh->extHeaderOffset = 0;
    
    [BqsUtils trashPath:self.path];
    [BqsUtils checkCreateDir:[self.path stringByDeletingLastPathComponent]];
    if(![self.fileHeader writeToFile:self.path atomically:NO]) {
        BqsLog(@"Failed to write to file: %@", self.path);
        return NO;
    }
    
    _fileSize = sizeof(t_FILE_HEADER);
    
    return YES;
}

-(void) buildDataHash:(unsigned int)delDataBefore {
    if(nil == self.fileHeader || [self.fileHeader length] < sizeof(t_FILE_HEADER)) {
        BqsLog(@"Invalid index data.");
        return;
    }
    
    t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
    
    int cnt = fh->cnt;
//    self.mapDatas = [NSMutableDictionary dictionaryWithCapacity:cnt];
    self.mapDatas = [[[BqsAvlMapUIntPtr alloc] initWithCapacity:cnt] autorelease];
    //self.arrFreeSpaces = [NSMutableArray arrayWithCapacity:1024];
    _deletedItemCnt = 0;
    _deletedSpaceSize = 0;
    _inUsedSpace = 0;
    _firstFreeItem = NULL;
    _firstDeletedItem = NULL;
    
    unsigned int i;
    for(i = 0; i < kIdxCount; i ++) {
        t_DATA_ITEM *item = &fh->items[i];
        if(kDeletedHash == item->nameHash || 0 == item->nameHash) {
            if(item->size >= 1 && kDeletedHash == item->nameHash) {
                [self insertSpaceIntoDeletedSpaces:item];
            } else {
                item->nameHash = 0;
                
                // insert into free item list
                item->i.ptr = _firstFreeItem;
                _firstFreeItem = item;
            }
        } else if(0 != item->nameHash) {
            
            if(0 != delDataBefore && item->i.time < delDataBefore) {
                BqsLog(@"del oldItem: %d %d<%d", item->nameHash, item->i.time, delDataBefore);
                // delete old data
                item->nameHash = kDeletedHash;
                [self insertSpaceIntoDeletedSpaces:item];
            } else {
    //            [self.mapDatas setObject:[NSValue valueWithPointer:item] forKey:[NSNumber numberWithUnsignedInt:item->nameHash]];
                [self.mapDatas setPtr:item forKey:item->nameHash];
                _inUsedSpace += item->size;
            }
        }
    }
    
    unsigned int numExtHeaders = [self.extHeaders count];
    for(unsigned int extHC = 0; extHC < numExtHeaders; extHC ++) {
        NSMutableData *dat = [self.extHeaders objectAtIndex:extHC];
        if(nil == dat || [dat length] < sizeof(t_EXTEND_HEADER)) {
            BqsLog(@"data is invalid. extHC: %d, len: %d", extHC, [dat length]);
            continue;
        }
        t_EXTEND_HEADER *extH = [dat mutableBytes];
        
        for(i = 0; i < kIdxCount; i ++) {
            t_DATA_ITEM *item = &extH->items[i];
            if(kDeletedHash == item->nameHash || 0 == item->nameHash) {
                if(item->size >= 1 && kDeletedHash == item->nameHash) {
                    [self insertSpaceIntoDeletedSpaces:item];
                } else {
                    item->nameHash = 0;
                    
                    // insert into free item list
                    item->i.ptr = _firstFreeItem;
                    _firstFreeItem = item;
                }
            } else if(0 != item->nameHash) {
                if(0 != delDataBefore && item->i.time < delDataBefore) {
                    BqsLog(@"del oldItem: %d %d<%d", item->nameHash, item->i.time, delDataBefore);
                    // delete old data
                    item->nameHash = kDeletedHash;
                    [self insertSpaceIntoDeletedSpaces:item];
                    
                } else {
    //                [self.mapDatas setObject:[NSValue valueWithPointer:item] forKey:[NSNumber numberWithUnsignedInt:item->nameHash]];
                    [self.mapDatas setPtr:item forKey:item->nameHash];
                    _inUsedSpace += item->size;
                }
            }
        }
    }
    
    fh->cnt = [self.mapDatas count];
    
    BqsLog(@"num of data: %d, num of deleted: %d, space of deleted: %d. space in use: %d, filesize: %d%@", [self.mapDatas count], _deletedItemCnt, _deletedSpaceSize, _inUsedSpace, _fileSize, self.path);
}


-(BOOL) flushIndex:(FILE*)fHanlder {
    if(_bReadOnly) {
        BqsLog(@"readonly package file. not allow to write");
        return NO;
    }

    if(nil == self.fileHeader || [self.fileHeader length] < sizeof(t_FILE_HEADER)) {
        BqsLog(@"Invalid index data.");
        return NO;
    }
    
    FILE *fl = fHanlder;
    if(nil == fl) {
        fl = fopen([self.path UTF8String], "rb+");
    }
    
    if(NULL == fl) {
        BqsLog(@"Failed to open file %@", path);
        return NO;
    }
    
    if(0 != fseek(fl, 0, SEEK_SET)) {
        BqsLog(@"Failed to seek file: %@", self.path);
        fclose(fl);
        return NO;
    }
    
    t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
    BqsLog(@"headersize: %d", sizeof(t_FILE_HEADER));
    int size = fwrite((void*)fh, sizeof(t_FILE_HEADER), 1, fl);
    if(size != 1) {
        BqsLog(@"Failed to write file: %@", path);
        fclose(fl);
        return NO;
    }
    
    if(0 != fseek(fl, fh->extHeaderOffset, SEEK_SET)) {
        BqsLog(@"Failed to seek file: %@", self.path);
        fclose(fl);
        return NO;
    }
    
    int numExtHeaders = [self.extHeaders count];
    for(int extHC = 0; extHC < numExtHeaders; extHC ++) {
        NSMutableData *dat = [self.extHeaders objectAtIndex:extHC];
        if(nil == dat || [dat length] < sizeof(t_EXTEND_HEADER)) {
            BqsLog(@"data is invalid. extHC: %d, len: %d", extHC, [dat length]);
            continue;
        }
        t_EXTEND_HEADER *extH = [dat mutableBytes];
        size = fwrite(extH, sizeof(t_EXTEND_HEADER), 1, fl);
        if(size != 1) {
            BqsLog(@"Failed to write file: %@", path);
            fclose(fl);
            return NO;
        }
        
        if(0 != fseek(fl, extH->nextExtHeaderOffset, SEEK_SET)) {
            BqsLog(@"Failed to seek file: %@", self.path);
            fclose(fl);
            return NO;
        }
    }
    
    if(nil == fHanlder) {
        fclose(fl);
    }

    BqsLog(@"index flushed. %@", path);
    return YES;
}

-(t_DATA_ITEM*) findDeletedSpaceForNewData:(int)datalen {
    
    t_DATA_ITEM *prev = NULL;
    t_DATA_ITEM *ti = _firstDeletedItem;
    while(NULL != ti) {
        if(ti->size >= datalen) {
            t_DATA_ITEM *ni = NULL;
            
            // save the left space back
            int left = ti->size - datalen;
            if(left > 0) {
                ni = [self allocFreeItem];
                if(nil == ni) {
                    BqsLog(@"Failed to alloc new free item");
                    return NULL;
                }
                ni->offset = ti->offset + datalen;
                ni->nameHash = kDeletedHash;
                ni->size = left;
            }
            
            // pick out
            if(NULL != prev) {
                prev->i.ptr = ti->i.ptr;
            } else {
                _firstDeletedItem = ti->i.ptr;
            }
            
            _deletedItemCnt --;
            _deletedSpaceSize -= ti->size;
            
            // insert the left space back
            if(NULL != ni) {
                [self insertSpaceIntoDeletedSpaces:ni];
            }
            
            ti->size = datalen;
            return ti;

        }
        
        prev = ti;
        ti = ti->i.ptr;
    }
    
    return NULL;
}

-(void)insertSpaceIntoDeletedSpaces:(t_DATA_ITEM*)item {
    if(NULL == item) {
        BqsLog(@"Invalid param. item: %x", item);
    }
    
    t_DATA_ITEM *prev = NULL;
    t_DATA_ITEM *ti = _firstDeletedItem;
    while(NULL != ti) {
        if(ti->size > item->size) {
            break;
        }
        
        prev = ti;
        ti = ti->i.ptr;
    }
    
    item->i.ptr = ti;
    if(NULL != prev) {
        prev->i.ptr = item;
    } else {
        _firstDeletedItem = item;
    }
    
    _deletedItemCnt ++;
    _deletedSpaceSize += item->size;
    
    return;
}

-(t_DATA_ITEM*)allocFreeItem {
    if(nil == self.fileHeader || [self.fileHeader length] < sizeof(t_FILE_HEADER)) {
        BqsLog(@"Invalid index data.");
        return NULL;
    }
    
    if(NULL == _firstFreeItem) {
        // add new header
        int curCnt = [self.extHeaders count];
        BqsLog(@"add new ext header.new cnt: %d", curCnt+1);
        
        
        // set next ext header offset
        if(curCnt < 1) {
            t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
            fh->extHeaderOffset = _fileSize;
        } else {
            NSMutableData *lastExtHeaderData = [self.extHeaders objectAtIndex:curCnt -1];
            t_EXTEND_HEADER *extH = [lastExtHeaderData mutableBytes];
            extH->nextExtHeaderOffset = _fileSize;
        }
        
        
        NSMutableData *extHdrData = [[NSMutableData alloc] initWithLength:sizeof(t_EXTEND_HEADER)];
        t_EXTEND_HEADER *extH = [extHdrData mutableBytes];
        
        memcpy(extH->tag, kCSBqsFileTag, sizeof(extH->tag));
        extH->nextExtHeaderOffset = 0;
        memset(extH->items, 0, sizeof(extH->items));
        [self.extHeaders addObject:extHdrData];
        [extHdrData release];
        
        // init items
        for(int i = 0; i < kIdxCount; i ++) {
            t_DATA_ITEM *item = &extH->items[i];
            
            // insert into free item list
            item->i.ptr = _firstFreeItem;
            _firstFreeItem = item;
        }
        
        if(![self flushIndex:nil]) {
            BqsLog(@"Failed to flush index");
            [self.extHeaders removeObject:extHdrData];
            _firstFreeItem = NULL;
            
            if(curCnt < 1) {
                t_FILE_HEADER *fh = (t_FILE_HEADER*)[self.fileHeader mutableBytes];
                fh->extHeaderOffset = 0;
            } else {
                NSMutableData *lastExtHeaderData = [self.extHeaders objectAtIndex:curCnt -1];
                t_EXTEND_HEADER *extH = [lastExtHeaderData mutableBytes];
                extH->nextExtHeaderOffset = 0;
            }
            return NULL;
        }
        _fileSize += sizeof(t_EXTEND_HEADER);
    }
    

    if(NULL == _firstFreeItem) {
        BqsLog(@"No first free item.");
        return NULL;
    }
    
    t_DATA_ITEM *item = _firstFreeItem;
    _firstFreeItem = item->i.ptr;
    
    item->offset = _fileSize;
    item->size = 0;
    return item;
}

-(void)optimizeDeletedSpace {
    if(_bReadOnly) {
        BqsLog(@"readonly package file. not allow to write");
        return;
    }

    if(NULL == _firstDeletedItem) return;
    
    BOOL bChanged = NO;
    BqsAvlMapUIntPtr *mapFreeEnd = [[BqsAvlMapUIntPtr alloc] initWithCapacity:1024];

    t_DATA_ITEM *prev = NULL;
    t_DATA_ITEM *ti = _firstDeletedItem;

    // build free set end
    while(NULL != ti) {
        [mapFreeEnd setPtr:ti forKey:(ti->offset+ti->size)];
        prev = ti;
        ti = ti->i.ptr;
    }
    
    // concat free spaces
    
    BOOL bDoCat = YES;
    
    while(bDoCat) {
        bDoCat = NO;
        prev = NULL;
        ti = _firstDeletedItem;
        while(NULL != ti) {
            {
                unsigned int k = ti->offset;
                //NSValue *op = [mapFreeEnd objectForKey:k];
                t_DATA_ITEM *tP = [mapFreeEnd getPtrForKey:k];
                if(nil != tP && tP != ti) {                
                    //BqsLog(@"Cat two freespace: offset: %d, cnt: %d <-> offset: %d, cnt: %d", tP->offset, tP->size, ti->offset, ti->size);
                    
                    tP->size += ti->size;
                    ti->nameHash = 0;
                    ti->offset = 0;
                    ti->size = 0;
                    
                    if(NULL == prev) {
                        _firstDeletedItem = ti->i.ptr;
                    } else {
                        prev->i.ptr = ti->i.ptr;
                    }
                    ti->i.ptr = _firstFreeItem;
                    _firstFreeItem = ti;
                    
                    [mapFreeEnd deletePtrForKey:k];
                    [mapFreeEnd setPtr:tP forKey:(tP->offset + tP->size)];
                    
                    bChanged = YES;
                    
                    bDoCat = YES;
                }

            }
            prev = ti;
            ti = ti->i.ptr;
        }
    }
    BqsLog(@"deleted item cnt after cat: %d", [mapFreeEnd count]);
    [mapFreeEnd release];
    
    if(bChanged) {
        [self flushIndex:nil];
    }

}

@end
