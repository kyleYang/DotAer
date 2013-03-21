//
//  category.m
//  DotAer
//
//  Created by Kyle on 13-3-8.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HMCategory.h"
#import "BqsUtils.h"


#define kList @"list"
#define kModule @"module"

#define kId @"id"
#define kName @"name"
#define kChildren @"children"
#define kChild @"child"

@implementation HMCategory
@synthesize catId;
@synthesize name;
@synthesize arrSubCat;


- (void)dealloc{
    self.name = nil;
    self.arrSubCat = nil;
    self.catId = nil;
    [super dealloc];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"[categoryID:%@,name:%@ arrSubCat:%@]",
            self.catId, self.name,self.arrSubCat];

}

-(void)writeXmlItem:(XmlWriter*)wrt{
    
    [wrt writeStringTag:kId Value:self.catId CData:NO];
    [wrt writeStringTag:kName Value:self.name CData:YES];
    
    [wrt writeStartTag:kChildren];
    for(HMCategory *cat in self.arrSubCat) {
        [wrt writeStartTag:kModule];
        [cat writeXmlItem:wrt];
        [wrt writeEndTag:kModule];
    }
    [wrt writeEndTag:kChildren];

   
    
}

+(NSArray *)parseArryXml:(TBXMLElement*)element{
    if(NULL == element || NULL == element->name) return nil;
    if(![kChildren isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    NSMutableArray *arry = [[[NSMutableArray alloc] init] autorelease];
    while(NULL != item) {
        
            NSString *siName = [TBXML elementName:item];
            if([kModule isEqualToString:siName]) {
                
                HMCategory *cat = [HMCategory parseXml:item];
                
                if(nil != cat) {
                    [arry addObject:cat];
                }
               
            }else {
                BqsLog(@"unknown tag: %@", siName);
            }

         item = item ->nextSibling;
    }
    
    return arry;

}



+(HMCategory *)parseXml:(TBXMLElement*)element{
    if(NULL == element || NULL == element->name) return nil;
    if(![kModule isEqualToString:[TBXML elementName:element]]){
        BqsLog(@"element is not a category");
        return nil;
    }
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    HMCategory *cate = [[[HMCategory alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kId isEqualToString:sName]) {
                cate.catId = text;
            }else if([kName isEqualToString:sName]){
                cate.name = text;
            } else if([kChildren isEqualToString:sName]) {
                cate.arrSubCat = [HMCategory parseArryXml:item];
            } else {
                BqsLog(@"unknown tag: %@", sName);
            }
        }
        
        
        item = item->nextSibling;
    }
    
    return cate;

    
}

+(NSArray *)parseXmlData:(NSData*)data{
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
                if([kModule isEqualToString:siName]) {
                    
                    HMCategory *cat = [HMCategory parseXml:si];
                    
                    if(nil != cat) {
                        [arr addObject:cat];
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
    
    for(HMCategory *cat in obj) {
        [wrt writeStartTag:kModule];
        
        [cat writeXmlItem:wrt];
        
        [wrt writeEndTag:kModule];
    }
    
    [wrt writeEndTag:kList];
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;

    
}


@end
