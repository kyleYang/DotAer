//
//  Strategy.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Strategy.h"
#import "Env.h"
#import "BqsUtils.h"



#define kList @"list"
#define kArticle @"article"

#define kCategroy @"category"
#define kNewsId @"id"
#define kTitle @"title"
#define kTime @"time"
#define kContent @"content"
#define kSummary @"summary"
#define kImageUrl @"imgeUrl"






@implementation Strategy
@synthesize category;
@synthesize articleId;
@synthesize title;
@synthesize time;
@synthesize content;
@synthesize summary;
@synthesize imageUrl;
@synthesize imgeArry;


- (void)dealloc{
    self.articleId = nil;
    self.title = nil;
    self.imageUrl = nil;
    self.time = nil;
    self.content = nil;
    self.imgeArry = nil;
    self.summary = nil;
    
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[strategyid:%@,title:%@,imageurl:%@,time:%@,type:%d]",
            self.articleId, self.title,self.imageUrl,self.time,self.category];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeIntTag:kCategroy Value:self.category];
    [wrt writeStringTag:kNewsId Value:self.articleId CData:NO];
    [wrt writeStringTag:kTitle Value:self.title CData:YES];
    [wrt writeStringTag:kTime Value:self.time CData:NO];
    [wrt writeStringTag:kContent Value:self.content CData:NO];
    [wrt writeStringTag:kSummary Value:self.summary CData:NO];
    [wrt writeStringTag:kImageUrl Value:self.imageUrl CData:NO];
    
}

+(Strategy *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kArticle isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    Strategy *strategy = [[[Strategy alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kCategroy isEqualToString:sName]) {
                strategy.category = [text intValue];
            }else if([kNewsId isEqualToString:sName]){
                strategy.articleId = text;
            } else if([kTitle isEqualToString:sName]) {
                strategy.title = text;
            } else if([kImageUrl isEqualToString:sName]) {
                strategy.imageUrl = text;
            } else if([kTime isEqualToString:sName]) {
                strategy.time = text;
            } else if([kContent isEqualToString:sName]) {
                strategy.content = text;
            }else if([kSummary isEqualToString:sName]) {
                strategy.summary = text;
            }else if([kImageUrl isEqualToString:sName]) {
                strategy.imageUrl = text;
            }else {
                BqsLog(@"unknown tag: %@", sName);
            }
        }
        
        
        item = item->nextSibling;
    }
    
    return strategy;
    
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
                if([kArticle isEqualToString:siName]) {
                    
                    Strategy *trategy = [Strategy parseXml:si];
                    
                    if(nil != trategy) {
                        [arr addObject:trategy];
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
    
    for(Strategy *strategy in obj) {
        [wrt writeStartTag:kArticle];
        
        [strategy writeXmlItem:wrt];
        
        [wrt writeEndTag:kArticle];
    }
    
    [wrt writeEndTag:kList];
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}



@end
