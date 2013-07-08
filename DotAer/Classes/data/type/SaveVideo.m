//
//  SaveVideo.m
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "SaveVideo.h"
#import "Env.h"
#import "BqsUtils.h"
#import "News.h"


#define kList @"list"

#define kVideo @"video"

#define kCategroy @"category"
#define kVideoId @"id"
#define kYoukuId @"ykId"
#define kPrgress @"progress"
#define kDownlading @"downloading"
#define kDownloaded @"downloaded"
#define kTitle @"title"
#define kTime @"time"
#define kVideoStep @"videoStep"
#define kContent @"content"
#define kSummary @"summary"
#define kImageUrl @"imgeUrl"


@implementation SaveVideo

@synthesize category;
@synthesize videoId;
@synthesize youkuId;
@synthesize progress;
@synthesize title;
@synthesize downedStatus;
@synthesize downingStatus;
@synthesize time;
@synthesize videoStep;
@synthesize content;
@synthesize summary;
@synthesize imageUrl;

- (void)dealloc{
    self.category = nil;
    self.videoId = nil;
    self.youkuId = nil;
    self.title = nil;
    self.imageUrl = nil;
    self.time = nil;
    self.content = nil;
    self.summary = nil;
    
    [super dealloc];
}

- (id)initWithVideo:(Video *)video withStep:(VideoScreen)vStep{
    self = [super init];
    if (self && video) {
        self.category = video.category;
        self.videoId = video.videoId;
        self.youkuId = video.youkuId;
        self.progress = 0.0f;
        self.downingStatus = TRUE;
        self.downedStatus = FALSE;
        self.title = video.title;
        self.time = video.time;
        self.videoStep = vStep;
        switch (vStep) {
            case VideoScreenNormal:
                self.content = video.norContent;
                break;
            case VideoScreenClear:
                self.content = video.content;
                break;
            case VideoScreenHD:
                self.content = video.hdContent;
                break;
            default:
                self.content = video.content;
                break;
        }
        self.summary = video.summary;
        self.imageUrl = video.imageUrl;
    }
    return self;
}
- (id)initWithNews:(News *)news withStep:(VideoScreen)vStep{
    self = [super init];
    if (self && news) {
        
        self.category = [NSString stringWithFormat:@"%d",news.category];
        self.videoId = news.newsId;
        self.youkuId = news.youkuId;
        self.progress = 0.0f;
        self.downingStatus = TRUE;
        self.downedStatus = FALSE;
        self.title = news.title;
        self.time = news.time;
        self.videoStep = vStep;
        switch (vStep) {
            case VideoScreenNormal:
                self.content = news.norContent;
                break;
            case VideoScreenClear:
                self.content = news.content;
                break;
            case VideoScreenHD:
                self.content = news.hdContent;
                break;
            default:
                self.content = news.content;
                break;
        }
        self.summary = news.summary;
        self.imageUrl = news.imageUrl;
    }
    return self;
}


-(NSString*)description {
    return [NSString stringWithFormat:@"[category:%@, videoId:%@, youkuId:%@, progress:%.1f ,downloadState: %d downloadingState :%d,title:%@,time:%@, videoStep:%d ,content:%@, summary:%@, imageurl:%@]",
            self.category, self.videoId,self.youkuId,self.progress,self.downedStatus,self.downingStatus,self.title,self.time,self.videoStep,self.content,self.summary,self.imageUrl];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeStringTag:kCategroy Value:self.category CData:NO];
    [wrt writeStringTag:kVideoId Value:self.videoId CData:NO];
    [wrt writeStringTag:kYoukuId Value:self.youkuId CData:YES];
    [wrt writeIntTag:kDownlading Value:self.downingStatus];
    [wrt writeIntTag:kDownloaded Value:self.downedStatus];
    [wrt writeDoubleTag:kPrgress Value:self.progress];
    [wrt writeStringTag:kTitle Value:self.title CData:YES];
    [wrt writeStringTag:kTime Value:self.time CData:NO];
    [wrt writeIntTag:kVideoStep Value:self.videoStep];
    [wrt writeStringTag:kContent Value:self.content CData:YES];
    [wrt writeStringTag:kSummary Value:self.summary CData:YES];
    [wrt writeStringTag:kImageUrl Value:self.imageUrl CData:YES];
    
}

+(SaveVideo *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kVideo isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    SaveVideo *news = [[[SaveVideo alloc] init] autorelease];
    
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
            }else if([kDownlading isEqualToString:sName]){
                news.downingStatus = [text boolValue];
            }else if([kDownloaded isEqualToString:sName]) {
                news.downedStatus = [text boolValue];
            } else if([kTitle isEqualToString:sName]) {
                news.title = text;
            } else if([kImageUrl isEqualToString:sName]) {
                news.imageUrl = text;
            } else if([kTime isEqualToString:sName]) {
                news.time = text;
            } else if([kVideoStep isEqualToString:sName]) {
                news.videoStep = [text intValue];
            } else if([kContent isEqualToString:sName]) {
                news.content = text;
            }else if([kSummary isEqualToString:sName]) {
                news.summary = text;
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
                    
                    SaveVideo *news = [SaveVideo parseXml:si];
                    
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
    
    for(SaveVideo *news in obj) {
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
