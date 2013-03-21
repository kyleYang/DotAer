//
//  News.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "News.h"
#import "Env.h"
#import "BqsUtils.h"


#define kList @"list"
#define kNews @"news"

#define kCategroy @"category"
#define kNewsId @"id"
#define kTitle @"title"
#define kTime @"time"
#define kContent @"content"
#define kSummary @"summary"
#define kImageUrl @"imgeUrl"
#define kImgUrls @"imgUrls"
#define kImg @"img"
#define kUrl @"url"
#define kIntroduce @"introduce"

@implementation NewsImg
@synthesize url;
@synthesize introduce;

-(void)dealloc{
    self.url = nil;
    self.introduce = nil;
    [super dealloc];
}


- (void)writeXmlItem:(XmlWriter*)wrt {    
    [wrt writeStringTag:kUrl Value:self.url CData:YES];
    [wrt writeStringTag:kIntroduce Value:self.introduce CData:YES];
}


+(NewsImg *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kImg isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    NewsImg *newsImg = [[[NewsImg alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kUrl isEqualToString:sName]) {
                newsImg.url = text;
            }else if([kIntroduce isEqualToString:sName]){
                newsImg.introduce = text;
            } else {
                BqsLog(@"unknown tag: %@", sName);
            }
        }
        
        
        item = item->nextSibling;
    }
    
    return newsImg;

    
}


+(NSArray *)parseArrayXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kImgUrls isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    while(NULL != item) {
        NewsImg *newsImg = [NewsImg parseXml:item];
        if (newsImg != nil) {
            [array addObject:newsImg];
        }
    
        item = item->nextSibling;
    }

    return array;
    
}


@end




@implementation News
@synthesize category;
@synthesize newsId;
@synthesize title;
@synthesize time;
@synthesize content;
@synthesize summary;
@synthesize imageUrl;
@synthesize imgeArry;


- (void)dealloc{
    self.newsId = nil;
    self.title = nil;
    self.imageUrl = nil;
    self.time = nil;
    self.content = nil;
    self.imgeArry = nil;
    self.summary = nil;
    
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[newsid:%@,title:%@,imageurl:%@,time:%@,type:%d]",
            self.newsId, self.title,self.imageUrl,self.time,self.category];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeIntTag:kCategroy Value:self.category];
    [wrt writeStringTag:kNewsId Value:self.newsId CData:NO];
    [wrt writeStringTag:kTitle Value:self.title CData:YES];
    [wrt writeStringTag:kTime Value:self.time CData:NO];
    [wrt writeStringTag:kContent Value:self.content CData:NO];
    [wrt writeStringTag:kSummary Value:self.summary CData:NO];
    [wrt writeStringTag:kImageUrl Value:self.imageUrl CData:NO];
    [wrt writeStartTag:kImgUrls];
    
    for(NewsImg *newImg in self.imgeArry) {
        [wrt writeStartTag:kImg];
        
        [newImg writeXmlItem:wrt];
        
        [wrt writeEndTag:kImg];
    }
    
    [wrt writeEndTag:kImgUrls];

    
}

+(News *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kNews isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    News *news = [[[News alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kCategroy isEqualToString:sName]) {
                news.category = [text intValue];
            }else if([kNewsId isEqualToString:sName]){
                news.newsId = text;
            } else if([kTitle isEqualToString:sName]) {
                news.title = text;
            } else if([kImageUrl isEqualToString:sName]) {
                news.imageUrl = text;
            } else if([kTime isEqualToString:sName]) {
                news.time = text;
            } else if([kContent isEqualToString:sName]) {
                news.content = text;
            }else if([kSummary isEqualToString:sName]) {
                news.summary = text;
            }else if([kImgUrls isEqualToString:sName]) {
                news.imgeArry = [NewsImg parseArrayXml:item];
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
                if([kNews isEqualToString:siName]) {
                    
                    News *news = [News parseXml:si];
                    
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
    
    for(News *news in obj) {
        [wrt writeStartTag:kNews];
        
        [news writeXmlItem:wrt];
        
        [wrt writeEndTag:kNews];
    }
    
    [wrt writeEndTag:kList];
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}



@end
