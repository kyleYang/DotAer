//
//  Simulator.m
//  DotAer
//
//  Created by Kyle on 13-3-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Simulator.h"

#import "BqsUtils.h"


#define kSimulator @"simulator"
#define kSimulatorId @"id"
#define kTilte @"title"
#define kContent @"content"
#define kSummary @"summary"



@implementation Simulator
@synthesize title;
@synthesize content;
@synthesize summary;

- (void)dealloc{
    self.title = nil;
    self.content = nil;
    self.summary = nil;
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[title:%@,content:%@,summary:%@]",
            self.title,self.content,self.summary];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeStringTag:kTilte Value:self.title CData:NO];
    [wrt writeStringTag:kContent Value:self.content CData:NO];
    [wrt writeStringTag:kSummary Value:self.summary CData:YES];
    
}



+(Simulator *)parseXmlData:(NSData*)data {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
    Simulator *simulator = [[[Simulator alloc] init] autorelease];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL == tbxml.rootXMLElement) {
        [tbxml release];
        return nil;
    }
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    
    while(NULL != item) {
        
        NSString *name = [TBXML elementName:item];
        if([kSimulator isEqualToString:name]) {
            
            TBXMLElement *si = item->firstChild;
            while(NULL != si) {
                
                NSString *siName = [TBXML elementName:si];
                NSString *sVale = [TBXML textForElement:si];
                if([kTilte isEqualToString:siName]) {
                    simulator.title = sVale;
                }else if([kContent isEqualToString:siName]){
                    simulator.content = sVale;
                }else if([kSummary isEqualToString:siName]){
                    simulator.summary = sVale;
                }else {
                    BqsLog(@"Unknown tag: %@", siName);
                }
                
                si = si->nextSibling;
            }
            
        }
        
        item = item->nextSibling;
    }
    
    [tbxml release];
    
    return simulator;
    
}

+(BOOL)saveToFile:(NSString*)path article:(Simulator*)obj{
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
    [wrt writeStartTag:kSimulator];
    
    
    
    [obj writeXmlItem:wrt];
    
    [wrt writeEndTag:kSimulator];
    
    
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}



@end
