//
//  BqsAutoRegInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsAutoRegInfo.h"
#import "XmlParser.h"
#import "BqsUtils.h"

//#define kTagResult @"result"

#define kTagStatus @"status"
#define kTagMsg @"msg"
#define kTagUserName @"username"
#define kTagTemporal @"temporal"
#define kTagPhone @"phone"
#define kTagEmail @"email"
#define kTagUserId @"userid"
#define kTagGlobalUserId @"globaluserid"
#define kTagThirdUserId @"thirduserid"
#define kTagPassword @"password"
#define kTagReqSpUrl @"reqspurl"
#define kTagTimeOut @"timeout"

//#define kTagEMail @"email"
//#define kTagNickName @"nickname"
//#define kTagPassport @"passport"


@interface BqsAutoRegInfo() <XmlParserCallback>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end

@implementation BqsAutoRegInfo
@synthesize userInfo=_userInfo;
@synthesize reqSpUrl=_reqSpUrl;
@synthesize timeOut=_timeOut;
@synthesize sid=_sid;
@synthesize status=_status;
@synthesize msg=_msg;

-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
//    _bInItem = NO;
    _timeOut = 10;
    _userInfo = [[BqsUserInfo alloc] init];
    
    return self;
}

-(void)dealloc {
    [_userInfo release];
    [_reqSpUrl release];
    [_sid release];
    [_status release];
    [_msg release];
    
    [super dealloc];
}


+ (BqsAutoRegInfo*)parseXmlData:(NSData*)data {
    XmlParser *psr = [[XmlParser alloc] init];
	BqsAutoRegInfo *usr = [[[BqsAutoRegInfo alloc] init] autorelease];
	
	if(![psr parseData:data Callback: usr]) {
		BqsLog(@"Failed to parse autoreg xml data: %@", data);
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
    } else if([kTagUserName isEqualToString:sElementame]) {
        self.userInfo.userName = value;
    } else if([kTagTemporal isEqualToString:sElementame]) {
        self.userInfo.isTmp = [BqsUtils parseBoolean:value Def:NO];
    } else if([kTagPhone isEqualToString:sElementame]) {
        self.userInfo.phone = value;
    } else if([kTagEmail isEqualToString:sElementame]) {
        self.userInfo.email = value;
    } else if([kTagUserId isEqualToString:sElementame]) {
        self.userInfo.userId = value;
    } else if([kTagGlobalUserId isEqualToString:sElementame]) {
        self.userInfo.globalUserId = value;
    } else if([kTagThirdUserId isEqualToString:sElementame]) {
        self.userInfo.thirdUserId = value;
    } else if([kTagPassword isEqualToString:sElementame]) {
        self.userInfo.password = [BqsUtils bqsPasswordDec: value];
        BqsLog(@"password dec: %@->%@", value, self.userInfo.password);
    } else {
        BqsLog(@"unknown tag: %@ -> %@", sElementame, value);
    }
}

@end

