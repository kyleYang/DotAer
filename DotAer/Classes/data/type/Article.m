//
//  Article.m
//  DotAer
//
//  Created by Kyle on 13-3-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Article.h"
#import "BqsUtils.h"




#define kArticle @"article"


#define kArtId @"artid"
#define kContent @"content"
#define kSummary @"summary"
#define kMd5 @"md5"
#define kImageUrl @"imgeUrl"






@implementation Article
@synthesize articleId;
@synthesize content;
@synthesize md5;

- (void)dealloc{
    self.articleId = nil;
    self.content = nil;
    self.md5 = nil;
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[strategyid:%@,content:%@,md5:%@]",
            self.articleId,self.content,self.md5];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeStringTag:kArtId Value:self.articleId CData:NO];
    [wrt writeStringTag:kMd5 Value:self.md5 CData:NO];
    [wrt writeStringTag:kContent Value:self.content CData:YES];
    
}



+(Article *)parseXmlData:(NSData*)data {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
   Article *article = [[[Article alloc] init] autorelease];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL == tbxml.rootXMLElement) {
        [tbxml release];
        return nil;
    }
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    
    while(NULL != item) {
        
        NSString *name = [TBXML elementName:item];
        if([kArticle isEqualToString:name]) {
            
            TBXMLElement *si = item->firstChild;
            while(NULL != si) {
                
                NSString *siName = [TBXML elementName:si];
                NSString *sVale = [TBXML textForElement:si];
                if([kArtId isEqualToString:siName]) {
                    article.articleId = sVale;
                }else if([kMd5 isEqualToString:siName]){
                    article.md5 = sVale;
                }else if([kContent isEqualToString:siName]){
                    article.content = sVale;
                }else {
                    BqsLog(@"Unknown tag: %@", siName);
                }
                
                si = si->nextSibling;
            }
            
        }
        
        item = item->nextSibling;
    }
    
    [tbxml release];
    
    return article;
    
}

+(BOOL)saveToFile:(NSString*)path article:(Article*)obj{
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
    [wrt writeStartTag:kArticle];
    
        
        
    [obj writeXmlItem:wrt];
        
    [wrt writeEndTag:kArticle];
    

    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}



@end
