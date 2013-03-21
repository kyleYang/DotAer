//
//  BqsRegisterInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-5-26.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsRegisterInfo.h"
#import "XmlParser.h"
#import "BqsUtils.h"

//#define kTagResult @"result"

#define kTagStatus @"status"
#define kTagMsg @"msg"
#define kTagSp @"sp"
#define kTagCmd @"cmd"

@interface BqsRegisterInfo() <XmlParserCallback>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end

@implementation BqsRegisterInfo
@synthesize status;
@synthesize msg;
@synthesize sp;
@synthesize cmd;


-(id)init {
    self = [super init];
    if(nil == self) return nil;
        
    return self;
}

-(void)dealloc {
    
    self.status = nil;
    self.msg = nil;
    self.sp = nil;
    self.cmd = nil;
    
    [super dealloc];
}


+ (BqsRegisterInfo*)parseXmlData:(NSData*)data {
    XmlParser *psr = [[XmlParser alloc] init];
	BqsRegisterInfo *usr = [[[BqsRegisterInfo alloc] init] autorelease];
	
	if(![psr parseData:data Callback: usr]) {
		BqsLog(@"Failed to parse xml data: %@", data);
        usr = nil;
	}
	[psr release];
    
	return usr;
    
}

- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr {
}

- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value {
	
	if(2 != level) return;
	
	//NSBqsLog(@"%@=%@", sElementame, value);
	
	
    
    if([kTagStatus isEqualToString:sElementame]) {
        self.status = value;
    } else if([kTagMsg isEqualToString:sElementame]) {
        self.msg = value;
    } else if([kTagSp isEqualToString:sElementame]) {
        self.sp = value;
    } else if([kTagCmd isEqualToString:sElementame]) {
        self.cmd = value;
    } else {
        BqsLog(@"unknown tag: %@ -> %@", sElementame, value);
    }
}

@end
