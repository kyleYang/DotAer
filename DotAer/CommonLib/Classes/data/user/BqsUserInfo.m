//
//  BqsUserInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-5-20.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsUserInfo.h"
#import "XmlParser.h"
#import "BqsUtils.h"
#import "Env.h"

//#define kTagResult @"result"

#define kTagLogonName @"_logonName"
#define kTagStatus @"status"
#define kTagUserName @"username"
#define kTagEMail @"email"
#define kTagEmailNotverify @"email_notverify"
#define kTagPhone @"phone"
#define kTagPhoneNotverify @"phone_notverify"
#define kTagNickName @"nickname"
#define kTagPassword @"password"
#define kTagUserId @"userid"
#define kTagThirdUserId @"thirduserid"
#define kTagGlobalUserId @"globaluserid"
#define kTagGender @"gender"
#define kTagBirthday @"birthday"
#define kTagIsTmp @"_isTmp"
#define kTagAccountState @"_accountState"
#define kTagPassport @"passport"

@interface BqsUserInfo() <XmlParserCallback>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end


@implementation BqsUserInfo
@synthesize logonName=_logonName;
@synthesize userName=_userName;
@synthesize email=_email;
@synthesize email_notverify=_email_notverify;
@synthesize phone=_phone;
@synthesize phone_notverify=_phone_notverify;
@synthesize nickName=_nickName;
@synthesize password=_password;
@synthesize userId=_userId;
@synthesize thirdUserId=_thirdUserId;
@synthesize globalUserId=_globalUserId;
@synthesize gender;
@synthesize birthday;
@synthesize isTmp=_isTmp;
@synthesize accountState=_accountState;
@synthesize passport=_passport;
@synthesize status=_status;


+(BOOL)isNicknameValid:(NSString*)nick {
    // 2 - 16 chars
    if(nick.length < 2 || nick.length > 16) return NO;
    return YES;
}
+(BOOL)isPasswordValid:(NSString*)pass {
    // 6 - 16 chars
    if(pass.length < 6 || pass.length > 16) return NO;
    return YES;
}


-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
//    _bInItem = NO;
    _isTmp = NO;
    self.gender = -1;
    
    return self;
}

-(void)dealloc {
    [_logonName release];
    [_userName release];
    [_email release];
    [_phone release];
    [_nickName release];
    [_password release];
    [_userId release];
    [_thirdUserId release];
    [_globalUserId release];
    self.birthday = nil;
    [_passport release];
    [_status release];
    
    [super dealloc];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"{logonName:%@, userName:%@, email:%@,email_notverify:%@, phone:%@, phone_notverify:%@, nickName:%@, password:%@, userId:%@, thirduserId:%@, globalUserId:%@, gender:%d,birthday:%@, passport:%@, status:%@, isTmp:%d, accountState:%d}",
            _logonName, _userName, _email,_email_notverify, _phone,_phone_notverify, _nickName, _password, _userId, _thirdUserId, _globalUserId,
            self.gender, self.birthday, 
            _passport, _status, _isTmp, _accountState];
}
-(id)copyWithZone:(NSZone*)zone {
    BqsUserInfo* other = [BqsUserInfo allocWithZone:zone];
    if(nil == other) return nil;
    
    other.logonName = self.logonName;
    other.userName = self.userName;
    other.email = self.email;
    other.email_notverify = self.email_notverify;
    other.phone = self.phone;
    other.phone_notverify = self.phone_notverify;
    other.nickName = self.nickName;
    other.password = self.password;
    other.userId = self.userId;
    other.thirdUserId = self.thirdUserId;
    other.globalUserId = self.globalUserId;
    other.gender = self.gender;
    other.birthday = self.birthday;
    other.passport = self.passport;
    other.status = self.status;
    other.isTmp = self.isTmp;
    other.accountState = self.accountState;
    
    return other;
}

-(BOOL)isTmpUser {
    if(_isTmp) return YES;
    
    NSString *udid = [Env sharedEnv].udid;
        
    if([_email length] < 1 && [_phone length] < 1) {
        
        if([udid isEqualToString:_userName] || [@"8888" isEqualToString:_password]) {
            return YES;
        }/* else {
            if(nil != _nickName && [_nickName isEqualToString:_userName] && [@"8888" isEqualToString:_password]) {
                return YES;
            }
        }*/
    }

    return NO;
}
-(BOOL)isValidUser {
    if(kAccountStateActivated != self.accountState || nil == self.userId || [self.userId length] < 1 ||
       nil == self.passport || [self.passport length] < 1) {
        return NO;
    }
    return YES;
}

+(BqsUserInfo*)parseDictionary:(NSDictionary*)dict {
    if(nil == dict) return nil;
    
    BqsUserInfo *bui = [[[BqsUserInfo alloc] init] autorelease];
    bui.logonName = (NSString*)[dict objectForKey:kTagLogonName];
    bui.userName = (NSString*)[dict objectForKey:kTagUserName];
    bui.email = (NSString*)[dict objectForKey:kTagEMail];
    bui.email_notverify = (NSString*)[dict objectForKey:kTagEmailNotverify];
    bui.phone = (NSString*)[dict objectForKey:kTagPhone];
    bui.phone_notverify = (NSString*)[dict objectForKey:kTagPhoneNotverify];
    bui.nickName = (NSString*)[dict objectForKey:kTagNickName];
    bui.password = (NSString*)[dict objectForKey:kTagPassword];
    bui.userId = (NSString*)[dict objectForKey:kTagUserId];
    bui.thirdUserId = (NSString*)[dict objectForKey:kTagThirdUserId];
    bui.globalUserId = (NSString*)[dict objectForKey:kTagGlobalUserId];
    bui.gender = [(NSNumber*)[dict objectForKey:kTagGender] intValue];
    bui.birthday = (NSString*)[dict objectForKey:kTagBirthday];
    bui.passport = (NSString*)[dict objectForKey:kTagPassport];
    bui.status = (NSString*)[dict objectForKey:kTagStatus];
    
    bui.isTmp = [BqsUtils parseBoolean:(NSString*)[dict objectForKey:kTagIsTmp] Def:NO];
    bui.accountState = [(NSNumber*)[dict objectForKey:kTagAccountState] intValue];
    
    return bui;
}

-(NSDictionary*)toDictionary {
    NSMutableDictionary *md = [[[NSMutableDictionary alloc] initWithCapacity:12] autorelease];
    if(nil != self.logonName) [md setObject:self.logonName forKey:kTagLogonName];
    if(nil != self.userName) [md setObject:self.userName forKey:kTagUserName];
    if(nil != self.email) [md setObject:self.email forKey:kTagEMail];
    if(nil != self.email_notverify) [md setObject:self.email_notverify forKey:kTagEmailNotverify];
    if(nil != self.phone) [md setObject:self.phone forKey:kTagPhone];
    if(nil != self.phone_notverify) [md setObject:self.phone_notverify forKey:kTagPhoneNotverify];
    if(nil != self.nickName) [md setObject:self.nickName forKey:kTagNickName];
    if(nil != self.password) [md setObject:self.password forKey:kTagPassword];
    if(nil != self.userId) [md setObject:self.userId forKey:kTagUserId];
    if(nil != self.thirdUserId) [md setObject:self.thirdUserId forKey:kTagThirdUserId];
    if(nil != self.globalUserId) [md setObject:self.globalUserId forKey:kTagGlobalUserId];
    [md setObject:[NSNumber numberWithInt:self.gender] forKey:kTagGender];
    if(nil != self.birthday) [md setObject:self.birthday forKey:kTagBirthday];
    if(nil != self.passport) [md setObject:self.passport forKey:kTagPassport];
    if(nil != self.status) [md setObject:self.status forKey:kTagStatus];
    
    [md setObject:(self.isTmp ? @"1" : @"0") forKey:kTagIsTmp];
    [md setObject:[NSNumber numberWithInt:self.accountState] forKey:kTagAccountState];
    
    return md;
}

+ (BqsUserInfo*)parseXmlData:(NSData*)data {
    XmlParser *psr = [[XmlParser alloc] init];
	BqsUserInfo *usr = [[[BqsUserInfo alloc] init] autorelease];
	
	if(![psr parseData:data Callback: usr]) {
		BqsLog(@"Failed to parse xml data: %@", data);
        usr = nil;
	}
	[psr release];
    
    if([usr.userId length] < 1 ||
       ([usr.userName length] < 1 && [usr.email length] < 1 && [usr.phone length] < 1)) {
        BqsLog(@"Invalid usr info: %@", usr);
        usr = nil;
    }
	
	return usr;

}

- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr {
//	if(1 == level && [kTagResult isEqualToString:sElementame]) {
//		_bInItem = YES;
//	}
}

- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value {
	
	if(2 != level) return;
	
	//NSBqsLog(@"%@=%@", sElementame, value);
	
	
//	if([kTagResult isEqualToString:sElementame]) {
//		_bInItem = NO;
//	} else {
		
    if([kTagStatus isEqualToString:sElementame]) {
        self.status = value;
    } else if([kTagPassport isEqualToString:sElementame]) {
        self.passport = value;
    } else if([kTagUserName isEqualToString:sElementame]) {
        self.userName = value;
    } else if([kTagEMail isEqualToString:sElementame]) {
        self.email = value;
    } else if([kTagEmailNotverify isEqualToString:sElementame]) {
        self.email_notverify = value;
    } else if([kTagPhone isEqualToString:sElementame]) {
        self.phone = value;
    } else if([kTagPhoneNotverify isEqualToString:sElementame]) {
        self.phone_notverify = value;
    } else if([kTagUserId isEqualToString:sElementame]) {
        self.userId = value;
    } else if([kTagNickName isEqualToString:sElementame]) {
        self.nickName = value;
    } else if([kTagGlobalUserId isEqualToString:sElementame]) {
        self.globalUserId = value;
    } else if([kTagThirdUserId isEqualToString:sElementame]) {
        self.thirdUserId = value;
    } else if([kTagGender isEqualToString:sElementame]) {
        self.gender = [value intValue];
    } else if([kTagBirthday isEqualToString:sElementame]) {
        self.birthday = value;
    } else {
        BqsLog(@"unknown tag: %@ -> %@", sElementame, value);
    }
//	}
}

@end
