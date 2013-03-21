//
//  ModifyUserResultInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-5-26.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "ModifyUserResultInfo.h"
#import "XmlParser.h"
#import "BqsUtils.h"


#define kTagStatus @"status"
#define kTagMsg @"msg"
#define kTagSupport @"support"
#define kTagUserName @"username"
#define kTagPassword @"password"

@interface ModifyUserResultInfo() <XmlParserCallback>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end

@implementation ModifyUserResultInfo
@synthesize status;
@synthesize msg;
@synthesize support;
@synthesize userName;
@synthesize password;


-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    self.support = YES;
    
    return self;
}

-(void)dealloc {
    
    self.status = nil;
    self.msg = nil;
    self.userName = nil;
    self.password = nil;
    
    [super dealloc];
}


+ (ModifyUserResultInfo*)parseXmlData:(NSData*)data {
    XmlParser *psr = [[XmlParser alloc] init];
	ModifyUserResultInfo *usr = [[[ModifyUserResultInfo alloc] init] autorelease];
	
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
	
	//BqsLog(@"%@=%@", sElementame, value);
	
	
    
    if([kTagStatus isEqualToString:sElementame]) {
        self.status = value;
    } else if([kTagMsg isEqualToString:sElementame]) {
        self.msg = value;
    } else if([kTagSupport isEqualToString:sElementame]) {
        self.support = [BqsUtils parseBoolean:value Def:YES];
    } else if([kTagUserName isEqualToString:sElementame]) {
        self.userName = value;
    } else if([kTagPassword isEqualToString:sElementame]) {
        self.password = [BqsUtils bqsPasswordDec: value];
        BqsLog(@"password dec: %@->%@", value, self.password);
    } else {
        BqsLog(@"unknown tag: %@ -> %@", sElementame, value);
    }
}

@end
