//
//  SysNoticeInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-5-27.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "SysNoticeInfo.h"
#import "XmlParser.h"
#import "BqsUtils.h"


#define kTagTitle @"title"
#define kTagContent @"content"
#define kTagDate @"date"

@interface SysNoticeInfo() <XmlParserCallback>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end

@implementation SysNoticeInfo
@synthesize title;
@synthesize content;
@synthesize date;


-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    return self;
}

-(void)dealloc {

    self.title = nil;
    self.content = nil;
    self.date = nil;
    
    [super dealloc];
}


+ (SysNoticeInfo*)parseXmlData:(NSData*)data {
    XmlParser *psr = [[XmlParser alloc] init];
	SysNoticeInfo *usr = [[[SysNoticeInfo alloc] init] autorelease];
	
	if(![psr parseData:data Callback: usr]) {
		BqsLog(@"Failed to parse xml data: %@", data);
        usr = nil;
	}
	[psr release];
    
    if([usr.title length] < 1 && [usr.content length] < 1) {
        return nil;
    }
    
	return usr;
    
}

- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr {
}

- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value {
	
	if(2 != level) return;
	
	//BqsLog(@"%@=%@", sElementame, value);
	
	
    
    if([kTagTitle isEqualToString:sElementame]) {
        self.title = value;
    } else if([kTagContent isEqualToString:sElementame]) {
        self.content = value;
    } else if([kTagDate isEqualToString:sElementame]) {
        self.date = value;
    } else {
        BqsLog(@"unknown tag: %@ -> %@", sElementame, value);
    }
}

@end
