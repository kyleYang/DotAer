//
//  UserOpResultInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-5-26.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "UserOpResultInfo.h"
#import "XmlParser.h"
#import "BqsUtils.h"


#define kTagStatus @"status"
#define kTagMsg @"msg"

@interface UserOpResultInfo() <XmlParserCallback>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end

@implementation UserOpResultInfo
@synthesize status;
@synthesize msg;


-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    return self;
}

-(void)dealloc {
    
    self.status = nil;
    self.msg = nil;
    
    [super dealloc];
}


+ (UserOpResultInfo*)parseXmlData:(NSData*)data {
    XmlParser *psr = [[XmlParser alloc] init];
	UserOpResultInfo *usr = [[[UserOpResultInfo alloc] init] autorelease];
	
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
    } else {
        BqsLog(@"unknown tag: %@ -> %@", sElementame, value);
    }
}

@end
