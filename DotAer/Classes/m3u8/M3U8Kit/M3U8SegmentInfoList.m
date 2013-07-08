//
//  M3U8SegmentInfoList.m
//  M3U8Kit
//
//  Created by Oneday on 13-1-11.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "M3U8SegmentInfoList.h"
#import "BqsUtils.h"
#import "Env.h"

#define KeySegmentInfList       @"key.segmentList"

#define kResult @"result"
#define kSegmentCount @"total"
#define kSegmentList @"segmentList"


@interface M3U8SegmentInfoList() {
@private
    NSMutableArray  *_segmentInfoList;
}


@property (nonatomic, assign ,readwrite) NSUInteger count;
@property (nonatomic, strong, readwrite) NSMutableArray *segmentInfoList;

@end


@implementation M3U8SegmentInfoList
@synthesize segmentInfoList = _segmentInfoList;


- (id)init {
    self = [super init];
    if (self) {
        _segmentInfoList = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - NSCopyding
- (id)copyWithZone:(NSZone *)zone {
    M3U8SegmentInfoList *copy = [[[self class] allocWithZone:zone] init];
    
    for (int i = 0; i < [self count]; i++) {
        M3U8SegmentInfo *infoCopy = [[self segmentInfoAtIndex:i] copyWithZone:zone];
        [copy addSegementInfo:infoCopy];
    }
    
    return copy;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_segmentInfoList forKey:KeySegmentInfList];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _segmentInfoList = [aDecoder decodeObjectForKey:KeySegmentInfList];
    }
    
    return self;
}

#pragma mark - Getter && Setter
- (NSUInteger)count {
    return [_segmentInfoList count];
}

#pragma mark - Public
- (void)addSegementInfo:(M3U8SegmentInfo *)segment {
    [_segmentInfoList addObject:segment];
}

- (M3U8SegmentInfo *)segmentInfoAtIndex:(NSUInteger)index {
    return [_segmentInfoList objectAtIndex:index];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _segmentInfoList];
}

- (NSString *)originalM3U8PlanStringValue {
    NSMutableString *m3u8String = [[NSMutableString alloc] init];
    
    [m3u8String appendString:@"#EXTM3U\n"];
    [m3u8String appendString:@"#EXT-X-TARGETDURATION:32\n"];
    [m3u8String appendString:@"#EXT-X-VERSION:3\n"];
    [m3u8String appendString:@"#EXT-X-DISCONTINUITY\n"];
    
    for (M3U8SegmentInfo *segmentInfo in _segmentInfoList) {
        [m3u8String appendString:[NSString stringWithFormat:@"#EXTINF:%.2f,\n", segmentInfo.duration]];
        [m3u8String appendString:[NSString stringWithFormat:@"%@\n", segmentInfo.mediaURL]];
    }
    [m3u8String appendString:@"#EXT-X-ENDLIST\n"];
    
    NSString *returnString = [m3u8String copy];
    
    return returnString;
}


#pragma mark 
#pragma mark XML

+(M3U8SegmentInfoList *)parseXmlData:(NSData*)data; {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
    M3U8SegmentInfoList *segmentList = [[M3U8SegmentInfoList alloc] init];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL == tbxml.rootXMLElement) {
        return nil;
    }
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    
    while(NULL != item) {
        
        NSString *name = [TBXML elementName:item];
        if([kSegmentList isEqualToString:name]) {
            
            TBXMLElement *si = item->firstChild;
            while(NULL != si) {
                
                NSString *siName = [TBXML elementName:si];
                NSString *text = [TBXML textForElement:si];
                if([kSegmentCount isEqualToString:siName]) {
                    
                    segmentList.count = [text intValue];
                    
                }else if([kSegmentInfo isEqualToString:siName]) {
                    
                    M3U8SegmentInfo *segmengInfo = [M3U8SegmentInfo parseXml:si];
                    
                    if(nil != segmengInfo) {
                        [segmentList.segmentInfoList addObject:segmengInfo];
                    }
                    
                } else {
                    BqsLog(@"Unknown tag: %@", siName);
                }
                
                si = si->nextSibling;
            }
            
        }
        
        item = item->nextSibling;
    }
    
    return segmentList;
    
}

+(BOOL)saveToFile:(NSString*)path segmentInfoList:(M3U8SegmentInfoList*)obj{
	if(nil == obj || nil == path) {
		BqsLog(@"Invalid param path: %@, obj: %@", path, obj);
		return NO;
	}
	
	XmlWriter *wrt = [[XmlWriter alloc] initWithFile:path];
	if(nil == wrt) {
		BqsLog(@"Can't write to file %@", path);
		return NO;
	}
    
    [wrt writeStartTag:kResult];
    [wrt writeIntTag:kSegmentCount Value:obj.count];
    [wrt writeStartTag:kSegmentList];
    
    for(M3U8SegmentInfo *info in obj.segmentInfoList) {
        [wrt writeStartTag:kSegmentInfo];
        
        [info writeXmlItem:wrt];
        
        [wrt writeEndTag:kSegmentInfo];
    }
    
    [wrt writeEndTag:kSegmentList];
    [wrt writeEndTag:kResult];
    
	BOOL bError = wrt.bError;	
	return !bError;
    
}


@end
