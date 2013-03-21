//
//  BqsUserInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-5-20.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAccountStateNone 0
#define kAccountStateNeedActivate 1 // not yet activate
#define kAccountStateNeedLogon 2 // register ok, not yet logon
#define kAccountStateActivated 3 // account activated, passport avaiable

#define kAccountGenderMale 0
#define kAccountGenderFemale 1

@interface BqsUserInfo : NSObject<NSCopying> {
    NSString *_logonName; // the name user input when logon
    
    NSString *_userName;
    NSString *_email;
    NSString *_email_notverify;
    NSString *_phone;
    NSString *_phone_notverify;
    NSString *_nickName;
    NSString *_password;
    NSString *_userId;
    NSString *_thirdUserId;
    NSString *_globalUserId;
    NSString *_status;
    
    BOOL _isTmp; // is the account tmp user ?
    
    NSInteger _accountState;
    NSString *_passport;
    
    
    //BOOL _bInItem;
    
}

@property (nonatomic, copy) NSString *logonName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *email_notverify;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *phone_notverify;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *thirdUserId;
@property (nonatomic, copy) NSString *globalUserId;
@property (nonatomic, assign) int gender; // sex 0-male 1-female
@property (nonatomic, copy) NSString *birthday; // yyyy-MM-dd
@property (nonatomic, assign) BOOL isTmp;
@property (nonatomic, assign) NSInteger accountState;
@property (nonatomic, copy) NSString *passport;
@property (nonatomic, copy) NSString *status;

+(BqsUserInfo*)parseDictionary:(NSDictionary*)dict;
-(NSDictionary*)toDictionary;
+(BqsUserInfo*)parseXmlData:(NSData*)data;

+(BOOL)isNicknameValid:(NSString*)nick;
+(BOOL)isPasswordValid:(NSString*)pass;

-(BOOL)isTmpUser;
-(BOOL)isValidUser;


@end
