//
//  Photo.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Photo.h"
#import "Env.h"
#import "BqsUtils.h"


#define kList @"list"
#define kImage @"image"

#define kCategroy @"category"
#define kPhotoId @"id"
#define kTitle @"title"
#define kTime @"time"
#define kContent @"content"
#define kSummary @"summary"
#define kImageUrl @"imgeUrl"
#define kImgUrls @"imgUrls"
#define kImg @"img"
#define kUrl @"url"
#define kIntroduce @"introduce"


@implementation PhotoImg
@synthesize url;
@synthesize introduce;

-(void)dealloc{
    self.url = nil;
    self.introduce = nil;
    [super dealloc];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"[PhotoImg url:%@,introduce:%@]",
            self.url, self.introduce];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    [wrt writeStringTag:kUrl Value:self.url CData:YES];
    [wrt writeStringTag:kIntroduce Value:self.introduce CData:YES];
}



+(PhotoImg *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kImg isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    PhotoImg *newsImg = [[[PhotoImg alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kUrl isEqualToString:sName]) {
                newsImg.url = text;
            }else if([kIntroduce isEqualToString:sName]){
                newsImg.introduce = text;
            } else {
                BqsLog(@"PhotoImg unknown tag: %@", sName);
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
        PhotoImg *photoImg = [PhotoImg parseXml:item];
        if (photoImg != nil) {
            [array addObject:photoImg];
        }
        
        item = item->nextSibling;
    }
    
    return array;
    
}


@end




@implementation Photo
@synthesize imgCate;
@synthesize imgId;
@synthesize title;
@synthesize time;
@synthesize content;
@synthesize summary;
@synthesize imageUrl;
@synthesize arrImgUrls;

- (void)dealloc{
    self.imgCate = nil;
    self.title = nil;
    self.imageUrl = nil;
    self.time = nil;
    self.content = nil;
    self.arrImgUrls = nil;
    self.summary = nil;
    
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[photoId:%@,title:%@,imageurl:%@,time:%@,categoryId:%@]",
            self.imgId, self.title,self.imageUrl,self.time,self.imgCate];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeStringTag:kCategroy Value:self.imgCate CData:NO];
    [wrt writeStringTag:kPhotoId Value:self.title CData:YES];
    [wrt writeStringTag:kTitle Value:self.title CData:YES];
    [wrt writeStringTag:kTime Value:self.time CData:NO];
    [wrt writeStringTag:kContent Value:self.content CData:NO];
    [wrt writeStringTag:kSummary Value:self.summary CData:NO];
    [wrt writeStringTag:kImageUrl Value:self.imageUrl CData:NO];
    [wrt writeStartTag:kImgUrls];
    
    for(PhotoImg *photoImg in self.arrImgUrls) {
        [wrt writeStartTag:kImg];
        
        [photoImg writeXmlItem:wrt];
        
        [wrt writeEndTag:kImg];
    }
    
    [wrt writeEndTag:kImgUrls];
    
    
}

+(Photo *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kImage isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    Photo *news = [[[Photo alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kCategroy isEqualToString:sName]) {
                news.imgCate = text;
            }else if([kPhotoId isEqualToString:sName]){
                news.imgId = text;
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
                news.arrImgUrls = [PhotoImg parseArrayXml:item];
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
                if([kImage isEqualToString:siName]) {
                    
                    Photo *photo = [Photo parseXml:si];
                    
                    if(nil != photo) {
                        [arr addObject:photo];
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
    
    for(Photo *photo in obj) {
        [wrt writeStartTag:kImage];
        
        [photo writeXmlItem:wrt];
        
        [wrt writeEndTag:kImage];
    }
    
    [wrt writeEndTag:kList];
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}

@end
