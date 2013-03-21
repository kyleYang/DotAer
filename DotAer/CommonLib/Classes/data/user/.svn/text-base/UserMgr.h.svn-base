//
//  UserMgr.h
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BqsUserInfo.h"
#import "Downloader.h"

#define kNtfUserAccountChanged @"bqs.user.ntf.accountchanged"

@interface UserMgr : NSObject {
    Downloader *_downloader;
    BqsUserInfo *_userInfo;
}

@property (nonatomic, retain, readonly) BqsUserInfo *userInfo;
@property (nonatomic, retain, readonly) Downloader *downloader;

+(UserMgr*)instance;

-(id)initWithDownloader:(Downloader*)dl;

-(void)ntfCookieNewPassportReturn:(NSString*)newPassport UserName:(NSString*)sUserName;
-(void)updateCurrentUser:(BqsUserInfo*)newUser;

-(void)logout;

-(NSInteger)tskAutoRegisterWithWeiboId:(NSString*)weiboId WeiboUid:(NSString*)weiboUid WeiboNick:(NSString*)weiboNickname Target:(id)target Callback:(SEL)op Attached:(id)att;
-(NSInteger)tskLoginName:(NSString*)sUserName Password:(NSString*)sPassword Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskRegisterReqVCodeName:(NSString*)sUserName SupportUserName:(BOOL)bSupportUserName Target:(id)target Callback:(SEL)op Attached:(id)att;
-(NSInteger)tskRegisterName:(NSString*)sUserName Password:(NSString*)sPassword Nick:(NSString*)nick VCode:(NSString*)vCode Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskModifyUserNewName:(NSString*)sNewName NewPassword:(NSString*)sNewPassword Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskRefreshUserInfoFromServerDownloader:(Downloader*)dl Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskUpgradeUser:(NSString *)sPhoneOrEmail Password:(NSString*)sPassword NickName:(NSString*)sNickName VCode:(NSString*)sVCode Target:(id)target Callback:(SEL)op Attached:(id)att;
-(NSInteger)tskRequestUpgradeVCode:(NSString*)sPhoneOrEmail Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskResetPasswordUser:(NSString *)sPhoneOrEmail Password:(NSString*)sPassword VCode:(NSString*)sVCode Target:(id)target Callback:(SEL)op Attached:(id)att;
-(NSInteger)tskRequestResetPasswordVCode:(NSString*)sPhoneOrEmail Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskUpdateNickname:(NSString*)aNickName Gender:(int)aGender Birthday:(NSString*)aBirthDay Target:(id)target Callback:(SEL)op Attached:(id)att;

-(NSInteger)tskBindWeiboId:(NSString*)weiboId WeiboUserId:(NSString*)weiboUserId Target:(id)target Callback:(SEL)op Attached:(id)att;
-(NSInteger)tskSetPhoneOrEmail:(NSString*)phoneOrEmail ReqVCode:(BOOL)bReqVCode Target:(id)target Callback:(SEL)op Attached:(id)att;
-(NSInteger)tskBindPhoneOrEmail:(NSString*)phoneOrEmail VCode:(NSString*)vCode Target:(id)target Callback:(SEL)op Attached:(id)att;
@end
