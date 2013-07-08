//
//  M3U8SegmentInfo.m
//  M3U8Kit
//
//  Created by Oneday on 13-1-11.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "M3U8SegmentInfo.h"
#import "BqsUtils.h"
#import "Env.h"


#define kDuration @"duration"
#define kMediaUrl @"mediaurl"

// key for Copying
NSString *keyM3U8SegmentDuration = @"key.M3U8SegmentDuration";
NSString *keyM3U8SegmentMediaURLString = @"key.M3U8SegmentMediaURLString";

// key for Coding
#define KeySegmentDuration      @"key.SegmentDuration"
#define KeyMeidaURL             @"key.MediaURL"


@interface M3U8SegmentInfo()


@property (nonatomic, readwrite) NSUInteger duration;


@end


@implementation M3U8SegmentInfo

- (id)initWithDictionary:(NSDictionary *)params {
    self = [super init];
    if (self) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            if ([key isEqualToString:keyM3U8SegmentDuration]) {
                _duration = [obj integerValue];
            } else if ([key isEqualToString:keyM3U8SegmentMediaURLString]) {
                if ((NSString *)obj != nil) {
                    _mediaURL = [obj copy];
                }
            }
        }];
    }
    
    return self;
}


- (NSDictionary *)dictionaryValue {
    NSString *mediaURLString = (_mediaURL == nil || (_mediaURL && !_mediaURL.length)) ?
    (NSString *)[NSNull null] : _mediaURL;
    NSDictionary *dictionay = @{keyM3U8SegmentDuration: @(self.duration),
    keyM3U8SegmentMediaURLString: mediaURLString};
    
    return dictionay;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SegmentInfo:<duration: %d>, <url:%@>", self.duration, self.mediaURL];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    M3U8SegmentInfo *copy = [[[self class] allocWithZone:zone] initWithDictionary:[self dictionaryValue]];
    
    return copy;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:_duration forKey:KeySegmentDuration];
    [aCoder encodeObject:_mediaURL forKey:KeyMeidaURL];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _duration = [aDecoder decodeFloatForKey:KeySegmentDuration];
        _mediaURL = [[aDecoder decodeObjectForKey:KeyMeidaURL] copy];
    }
    
    return self;
}


#pragma mark
#pragma mark XML



- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeDoubleTag:kDuration Value:self.duration];
    [wrt writeStringTag:kMediaUrl Value:self.mediaURL CData:NO];
}

+(M3U8SegmentInfo *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kSegmentInfo isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    M3U8SegmentInfo *segment = [[M3U8SegmentInfo alloc] init];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kDuration isEqualToString:sName]) {
                segment.duration = [text integerValue];
            }else if([kMediaUrl isEqualToString:sName]){
                segment.mediaURL = text;
            }else {
                BqsLog(@"unknown tag: %@", sName);
            }
        }
        
        
        item = item->nextSibling;
    }
    
    return segment;
    
}


@end
