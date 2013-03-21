//
//  PackageFile.h
//  iMobeeNews
//
//  Created by ellison on 11-6-9.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PackageFile : NSObject {
    int _fileSize;
    
    void* _firstFreeItem;
    void* _firstDeletedItem;
    unsigned int _deletedSpaceSize; // deleted space size
    unsigned int _deletedItemCnt; // deleted space ount
    unsigned int _inUsedSpace; // space in use
    
    BOOL _bReadOnly;

}

-(id)initWithPath:(NSString*)path;
-(id)initWithPath:(NSString *)path DelOldDataBefore:(unsigned int)ts;
-(id)initWithPath:(NSString *)path DelOldDataBefore:(unsigned int)ts ReadOnly:(BOOL)bReadOnly;
-(BOOL)writeDataName:(NSString*)name Data:(NSData*)data;
-(NSData*)readDataName:(NSString*)name;
-(void)deleteDataName:(NSString*)name Flush:(BOOL)bFlush;
-(void)flushIndex;

-(void)updateDataTimeToNow:(NSString*)name Flush:(BOOL)bFlush;

-(unsigned int)getDataLength:(NSString*)name;
-(unsigned int)getDataTime:(NSString*)name;

-(unsigned int)getDeletedSpaceSize;
-(unsigned int)getDeletedItemCnt;
-(unsigned int)getInUsedSpace;
-(unsigned int)getFileSize;
@end
