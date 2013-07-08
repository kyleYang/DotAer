//
//  Video.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Video.h"

#import "Env.h"
#import "BqsUtils.h"



#define kList @"list"

#define kVideo @"video"

#define kCategroy @"category"
#define kVideoId @"id"
#define kYoukuId @"youkuid"
#define kTitle @"title"
#define kTime @"time"
#define kContent @"content"
#define kHdContent @"hd2"
#define kNorContent @"flv"
#define kSummary @"summary"
#define kImageUrl @"imgeUrl"
#define kMd5 @"md5"



@implementation Video

@synthesize category;
@synthesize videoId;
@synthesize youkuId;
@synthesize title;
@synthesize time;
@synthesize content;
@synthesize hdContent;
@synthesize norContent;
@synthesize summary;
@synthesize imageUrl;
@synthesize md5;

- (void)dealloc{
    self.category = nil;
    self.videoId = nil;
    self.youkuId = nil;
    self.title = nil;
    self.imageUrl = nil;
    self.time = nil;
    self.content = nil;
    self.hdContent = nil;
    self.norContent = nil;
    self.summary = nil;
    self.md5 = nil;
    [super dealloc];
}


-(NSString*)description {
    return [NSString stringWithFormat:@"[category:%@, videoId:%@, youkuId: %@,title:%@,time:%@, content:%@, hdContent:%@, norContent:%@, summary:%@, imageurl:%@ ,md5:%@]",
            self.category, self.videoId,self.youkuId,self.title,self.time,self.content,self.hdContent,self.norContent,self.summary,self.imageUrl,self.md5];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeStringTag:kCategroy Value:self.category CData:NO];
    [wrt writeStringTag:kVideoId Value:self.videoId CData:NO];
    [wrt writeStringTag:kYoukuId Value:self.youkuId CData:YES];
    [wrt writeStringTag:kTitle Value:self.title CData:YES];
    [wrt writeStringTag:kTime Value:self.time CData:NO];
    [wrt writeStringTag:kContent Value:self.content CData:YES];
    [wrt writeStringTag:kHdContent Value:self.hdContent CData:YES];
    [wrt writeStringTag:kNorContent Value:self.norContent CData:YES];
    [wrt writeStringTag:kSummary Value:self.summary CData:YES];
    [wrt writeStringTag:kImageUrl Value:self.imageUrl CData:YES];
    [wrt writeStringTag:kMd5 Value:self.md5 CData:YES];
}

+(Video *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kVideo isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    Video *news = [[[Video alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kCategroy isEqualToString:sName]) {
                news.category = text;
            }else if([kVideoId isEqualToString:sName]){
                news.videoId = text;
            }else if([kYoukuId isEqualToString:sName]){
                news.youkuId = text;
            }else if([kTitle isEqualToString:sName]) {
                news.title = text;
            } else if([kImageUrl isEqualToString:sName]) {
                news.imageUrl = text;
            } else if([kTime isEqualToString:sName]) {
                news.time = text;
            }else if([kContent isEqualToString:sName]) {
                news.content = text;
            }else if([kHdContent isEqualToString:sName]) {
                news.hdContent = text;
            }else if([kNorContent isEqualToString:sName]) {
                news.norContent = text;
            }else if([kSummary isEqualToString:sName]) {
                news.summary = text;
            }else if([kMd5 isEqualToString:sName]) {
                news.md5 = text;
            }else {
                BqsLog(@"unknown tag: %@", sName);
            }
        }
        
        
        item = item->nextSibling;
    }
    
    return news;
    
}

+(NSArray *)parseXmlData:(NSData*)data {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL == tbxml.rootXMLElement) {
        [tbxml release];
        return nil;
    }
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    
    while(NULL != item) {
        
        NSString *name = [TBXML elementName:item];
        if([kList isEqualToString:name]) {
            
            TBXMLElement *si = item->firstChild;
            while(NULL != si) {
                
                NSString *siName = [TBXML elementName:si];
                if([kVideo isEqualToString:siName]) {
                    
                    Video *news = [Video parseXml:si];
                    
                    if(nil != news) {
                        [arr addObject:news];
                    }
                    
                } else {
                    BqsLog(@"Unknown tag: %@", siName);
                }
                
                si = si->nextSibling;
            }
            
        }
        
        item = item->nextSibling;
    }
    
    [tbxml release];
    
    return arr;
    
}

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj{
	if(nil == obj || nil == path) {
		BqsLog(@"Invalid param path: %@, obj: %@", path, obj);
		return NO;
	}
	
	XmlWriter *wrt = [[XmlWriter alloc] initWithFile:path];
	if(nil == wrt) {
		BqsLog(@"Can't write to file %@", path);
		return NO;
	}
    
    [wrt writeStartTag:@"result"];
    [wrt writeIntTag:@"total" Value:obj.count];
    [wrt writeStartTag:kList];
    
    for(Video *news in obj) {
        [wrt writeStartTag:kVideo];
        
        [news writeXmlItem:wrt];
        
        [wrt writeEndTag:kVideo];
    }
    
    [wrt writeEndTag:kList];
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}




@end
