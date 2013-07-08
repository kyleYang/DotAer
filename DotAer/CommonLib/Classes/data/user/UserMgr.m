//
//  UserMgr.m
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "UserMgr.h"
#import "Downloader.h"
#import "Env.h"
#import "BqsCallbackObj.h"


#define kCfgUserInfo @"usermgr.userInfo"

// service entries
#define kSEUserGetInfo @"user.getinfo"
#define kSEUserGetInfoDef @"/ucenter/basic/getuserinfo.action"

#define kSEUserAutoRegister @"user.autoregister"
#define kSEUserAutoRegisterDef @"/ucenter/basic/autoregister.action"

#define kSEUserUpdateUserNameAndPassword @"user.update.usernameandpassword"
#define kSEUserUpdateUserNameAndPasswordDef @"/ucenter/basic/moduserpwd.action"


#define kSEUserRegReqVCode @"user.register.reqvcode"
#define kSEUserRegReqVCodeDef @"/ucenter/basic/newregreqvcode.action"
#define kSEUserRegister @"user.register"
#define kSEUserRegisterDef @"/ucenter/basic/newreg.action"

#define kSEUserUpgradeReqVCode @"user.upgrade.reqvcode"
#define kSEUserUpgradeReqVCodeDef @"/ucenter/basic/requestvcode.action"
#define kSEUserUpgrade @"user.upgrade"
#define kSEUserUpgradeDef @"/ucenter/basic/upgradeuser.action"

#define kSEUserResetPasswordReqVCode @"user.findpassword.reqvcode"
#define kSEUserResetPasswordReqVCodeDef @"/ucenter/basic/clientfindpwd.action"
#define kSEUserResetPassword @"user.findpassword.resetpassword"
#define kSEUserResetPasswordDef @"/ucenter/basic/resetpwd.action"

#define kSEUserUpdateUserMiscInfo @"user.updateinfo"
#define kSEUserUpdateUserMiscInfoDef @"/ucenter/basic/updateuserinfo.action"

#define kSEUserBindWeibo @"user.bindweibo"
#define kSEUserBindWeiboDef @"/ucenter/basic/bindweibo.action"

#define kSEUserSetEmailOrPhone @"user.bind.specify"
#define kSEUserSetEmailOrPhoneDef @"/ucenter/basic/bindspecify.action"
#define kSEUserVerifyEmailOrPhone @"user.bind.verify"
#define kSEUserVerifyEmailOrPhoneDef @"/ucenter/basic/bindverify.action"

@interface UserMgr()
@property (nonatomic, retain, readwrite) BqsUserInfo *userInfo;
@property (nonatomic, retain, readwrite) BqsUserInfo *tmpRegUserInfo;
@property (nonatomic,retain) NSMutableDictionary *dicCallbacks;

-(void)saveUserInfo;
-(void)onFinishRefreshUserInfoFromServer:(DownloaderCallbackObj*)cb;
@end

@implementation UserMgr
@synthesize userInfo = _userInfo;
@synthesize tmpRegUserInfo;
@synthesize downloader=_downloader;
@synthesize dicCallbacks;

+(UserMgr*)instance {
    return [Env sharedEnv].bkSvc.userMgr;
}

-(id)initWithDownloader:(Downloader *)dl {
    self = [super init];
    if(nil == self) return nil;
    
    self.dicCallbacks = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    
    _downloader = [dl retain];
    
    // load cfg
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kCfgUserInfo];
    if(nil != dict) {
        _userInfo = [[BqsUserInfo parseDictionary:dict] retain];
    }
    
    return self;
}

-(void)dealloc {
    [_downloader release];
    [_userInfo release];
    
    self.dicCallbacks = nil;
    
    [super dealloc];
}

-(void)saveUserInfo {
    [[NSUserDefaults standardUserDefaults] setObject:[_userInfo toDictionary] forKey:kCfgUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNtfUserAccountChanged object:nil];
}

-(void)ntfCookieNewPassportReturn:(NSString*)newPassport UserName:(NSString*)sUserName{
    BqsLog(@"ntfCookieNewPassportReturn:%@, %@", newPassport, sUserName);
    
    if(nil != sUserName && ![sUserName isEqualToString:_userInfo.logonName]) {
        BqsLog(@"specified user not not current user, ignore the new passport: %@ != %@", sUserName, _userInfo.logonName);
        return;
    }
    
    _userInfo.passport = newPassport;
    [self saveUserInfo];
}
-(void)updateCurrentUser:(BqsUserInfo*)newUser {
    self.userInfo = newUser;
    BqsLog(@"update user: %@", _userInfo);
    [self saveUserInfo];
}
-(void)setNewRegUser:(BqsUserInfo*)newRegUser {
    self.tmpRegUserInfo = newRegUser;
    [self saveUserInfo];
}

-(void)logout {
    _userInfo.password = @"";
    _userInfo.passport = @"";
    _userInfo.accountState = kAccountStateNeedLogon;
    [self saveUserInfo];
}

#pragma mark - net tasks
-(NSInteger)tskAutoRegisterWithWeiboId:(NSString*)weiboId WeiboUid:(NSString*)weiboUid WeiboNick:(NSString*)weiboNickname Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *url = [env getSEKey:kSEUserAutoRegister Def:kSEUserAutoRegisterDef];
    
    // set udid as imsi
    url = [BqsUtils setURL:url ParameterName:@"imsi" Value:env.macUdid];
    url = [BqsUtils setURL:url ParameterName:@"supportenc" Value:@"true"];
    url = [BqsUtils setURL:url ParameterName:@"checkmark" Value:
           [BqsUtils bqsPasswordEnc:
            [NSString stringWithFormat:@"%@,%@,%@", env.macUdid, (weiboId.length > 0 ? weiboId : @""), (weiboUid.length > 0 ? weiboUid : @"")]]];
    url = [BqsUtils setURL:url ParameterName:@"channel" Value:env.market];
    url = [BqsUtils setURL:url ParameterName:@"psVendor" Value:@"apple"];
    url = [BqsUtils setURL:url ParameterName:@"psType" Value:[myDevice.model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    if(![BqsUtils curDisplayChinese]) {
        url = [BqsUtils setURL:url ParameterName:@"custom" Value:@"eng"];
    }
    
    if(nil != weiboId && [weiboId length] > 0 && nil != weiboUid && [weiboId length] > 0) {
        url = [BqsUtils setURL:url ParameterName:@"weiboId" Value:weiboId];
        url = [BqsUtils setURL:url ParameterName:@"weiboUserId" Value:weiboUid];
        
        if(nil != weiboNickname && [weiboNickname length] > 0) {
            url = [BqsUtils setURL:url ParameterName:@"weiboNickName" Value:weiboNickname];
        }
    }
    
    // clear passport
    url = [BqsUtils setURL:url ParameterName:@"bqsPassport" Value:@"abc"];
    [BqsUtils clearCookiesForUrl:[BqsUtils fixURLHost:url]];

    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:NO];
    
}

-(NSInteger)tskLoginName:(NSString*)sUserName Password:(NSString*)sPassword Target:(id)target Callback:(SEL)op Attached:(id)att {
    NSString *url = [[Env sharedEnv] getSEKey:kSEUserGetInfo Def:kSEUserGetInfoDef];
    url = [BqsUtils setURL:url ParameterName:@"bqsPassport" Value:@"abc"];
    [BqsUtils clearCookiesForUrl:[BqsUtils fixURLHost:url]];
    
    // lowercase email
    NSString *suer = sUserName;
    if([BqsUtils isEmailAddress:sUserName]) {
        suer = [sUserName lowercaseString];
    }
    return [_downloader addTask:url Target:target Callback:op Attached:nil UserName:suer Password:sPassword];
}

-(NSInteger)tskRegisterReqVCodeName:(NSString*)sUserName SupportUserName:(BOOL)bSupportUserName Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserRegReqVCode Def:kSEUserRegReqVCodeDef];
    
    url = [BqsUtils setURL:url ParameterName:@"user" Value:sUserName];
    url = [BqsUtils setURL:url ParameterName:@"supportusername" Value:bSupportUserName ? @"1" : @"0"];
    url = [BqsUtils setURL:url ParameterName:@"checksum" Value:[BqsUtils bqsPasswordEnc:sUserName]];
    
    url = [BqsUtils setURL:url ParameterName:@"bqsPassport" Value:@"abc"];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:NO];

}
-(NSInteger)tskRegisterName:(NSString*)sUserName Password:(NSString*)sPassword Nick:(NSString*)nick VCode:(NSString*)vCode Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];

    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *url = [env getSEKey:kSEUserRegister Def:kSEUserRegisterDef];
    
    url = [BqsUtils setURL:url ParameterName:@"user" Value:sUserName];
    url = [BqsUtils setURL:url ParameterName:@"passwordenc" Value:[BqsUtils bqsPasswordEnc:sPassword]];
    if(nil != nick && nick.length > 0) {
        url = [BqsUtils setURL:url ParameterName:@"nickname" Value:nick];
    }
    url = [BqsUtils setURL:url ParameterName:@"vcode" Value:vCode];
    
    url = [BqsUtils setURL:url ParameterName:@"channel" Value:env.market];
    url = [BqsUtils setURL:url ParameterName:@"psVendor" Value:@"apple"];
    url = [BqsUtils setURL:url ParameterName:@"psType" Value:[myDevice.model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    url = [BqsUtils setURL:url ParameterName:@"appType" Value:env.swType];
    url = [BqsUtils setURL:url ParameterName:@"appVersion" Value:env.swVersion];
    
    url = [BqsUtils setURL:url ParameterName:@"bqsPassport" Value:@"abc"];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:NO];

}

-(NSInteger)tskModifyUserNewName:(NSString*)sNewName NewPassword:(NSString*)sNewPassword Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserUpdateUserNameAndPassword Def:kSEUserUpdateUserNameAndPasswordDef];
    
    if([sNewName length] > 0) {
        url = [BqsUtils setURL:url ParameterName:@"user" Value:sNewName];
    }
    if([sNewPassword length] > 0) {
        url = [BqsUtils setURL:url ParameterName:@"passwordenc" Value:[BqsUtils bqsPasswordEnc: sNewPassword]];
    }
    
        
    return [_downloader addTask:url Target:target Callback:op Attached:att];
}

-(NSInteger)tskRefreshUserInfoFromServerDownloader:(Downloader*)dl Target:(id)target Callback:(SEL)op Attached:(id)att {
    NSString *logonName = self.userInfo.logonName;
    NSString *password = self.userInfo.password;
    
    if(nil == logonName || logonName.length < 1 ||
       nil == password || password.length < 1 ||
       kAccountStateActivated != self.userInfo.accountState) {
        BqsLog(@"Invalid account info. user: %@", self.userInfo);
        return -1;
    }
    
    BqsCallbackObj *cb = [[[BqsCallbackObj alloc] init] autorelease];
    cb.obj = target;
    cb.sel = op;
    cb.assignAttached = att;
    
    NSString *url = [[Env sharedEnv] getSEKey:kSEUserGetInfo Def:kSEUserGetInfoDef];

    int taskId = [dl addTask:url Target:self Callback:@selector(onFinishRefreshUserInfoFromServer:) Attached:cb UserName:nil Password:nil];
     
     if(taskId > 0) {
         [self.dicCallbacks setObject:cb forKey:[NSNumber numberWithInt:taskId]];
     }
    
    return taskId;
}

-(void)onFinishRefreshUserInfoFromServer:(DownloaderCallbackObj*)cb {
    BqsLog(@"onFinishRefreshUserInfoFromServer: %@", [BqsUtils stringFromData:cb.rspData Encoding:nil]);
	if(nil == cb) {
		BqsLog(@"cb is nil");
        return;
	}
    
    NSNumber *key = [NSNumber numberWithInt:cb.taskId];
    BqsCallbackObj *prevCb = [self.dicCallbacks objectForKey:key];
    [[prevCb retain] autorelease];
    [self.dicCallbacks removeObjectForKey:key];
	cb.attached = prevCb.assignAttached;
    
	if(nil != cb.error) {
		BqsLog(@"Error: %@", cb.error);
        @try {
            
            [prevCb.obj performSelector:prevCb.sel withObject:cb];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
		return;
	}
    
	// parse xml
	BqsUserInfo *bp = [BqsUserInfo parseXmlData:cb.rspData];
	
    NSString *logonName = nil;
    if([logonName length] < 1) logonName = bp.phone;
    if([logonName length] < 1) logonName = bp.email;
    if([logonName length] < 1) logonName = bp.userName;
    
    if([logonName length] < 1 || [bp.userId length] < 1 || kAccountStateActivated != self.userInfo.accountState) {
        BqsLog(@"Invalid info: net: %@, self: %@", bp, self.userInfo);
        @try {
            [prevCb.obj performSelector:prevCb.sel withObject:cb];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        return;
    }
        
    bp.logonName = logonName;
    bp.password = self.userInfo.password;
    bp.accountState = kAccountStateActivated;

    // check reg user info for re-bind
    if(kAccountStateNeedActivate == self.tmpRegUserInfo.accountState &&
       ([bp.email isEqualToString:self.tmpRegUserInfo.email] || [bp.phone isEqualToString:self.tmpRegUserInfo.phone])) {
        
        BqsLog(@"phone/email already bound, clear activate state. email: %@, phone: %@", bp.email, bp.phone);
        [self setTmpRegUserInfo:nil];
    }
    
    // success
    [self updateCurrentUser:bp];
    
    
    @try {
        [prevCb.obj performSelector:prevCb.sel withObject:cb];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

-(NSInteger)tskUpgradeUser:(NSString *)sPhoneOrEmail Password:(NSString*)sPassword NickName:(NSString*)sNickName VCode:(NSString*)sVCode Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *url = [env getSEKey:kSEUserUpgrade Def:kSEUserUpgradeDef];
    
    url = [BqsUtils setURL:url ParameterName:@"user" Value:sPhoneOrEmail];
    url = [BqsUtils setURL:url ParameterName:@"vcode" Value:sVCode];
    url = [BqsUtils setURL:url ParameterName:@"nickname" Value:sNickName];
    url = [BqsUtils setURL:url ParameterName:@"passwordenc" Value:[BqsUtils bqsPasswordEnc: sPassword]];
    
    url = [BqsUtils setURL:url ParameterName:@"channel" Value:env.market];
    url = [BqsUtils setURL:url ParameterName:@"psVendor" Value:@"apple"];
    url = [BqsUtils setURL:url ParameterName:@"psType" Value:[myDevice.model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    url = [BqsUtils setURL:url ParameterName:@"osVersion" Value:myDevice.systemVersion];
    url = [BqsUtils setURL:url ParameterName:@"appVersion" Value:env.swVersion]; 
        
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];

}

-(NSInteger)tskRequestUpgradeVCode:(NSString*)sPhoneOrEmail Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserUpgradeReqVCode Def:kSEUserUpgradeReqVCodeDef];
    
    url = [BqsUtils setURL:url ParameterName:@"user" Value:sPhoneOrEmail];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}

-(NSInteger)tskResetPasswordUser:(NSString *)sPhoneOrEmail Password:(NSString*)sPassword VCode:(NSString*)sVCode Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *url = [env getSEKey:kSEUserResetPassword Def:kSEUserResetPasswordDef];
    
    NSString *passwdEnc = [BqsUtils bqsPasswordEnc:sPassword];
    
    url = [BqsUtils setURL:url ParameterName:@"email" Value:sPhoneOrEmail];
    url = [BqsUtils setURL:url ParameterName:@"sid" Value:sVCode];
    url = [BqsUtils setURL:url ParameterName:@"passwordenc" Value:passwdEnc];
    url = [BqsUtils setURL:url ParameterName:@"repassword" Value:passwdEnc];
    
    url = [BqsUtils setURL:url ParameterName:@"channel" Value:env.market];
    url = [BqsUtils setURL:url ParameterName:@"psVendor" Value:@"apple"];
    url = [BqsUtils setURL:url ParameterName:@"psType" Value:[myDevice.model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    url = [BqsUtils setURL:url ParameterName:@"osVersion" Value:myDevice.systemVersion];
    url = [BqsUtils setURL:url ParameterName:@"appVersion" Value:env.swVersion]; 
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}

-(NSInteger)tskRequestResetPasswordVCode:(NSString*)sPhoneOrEmail Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserResetPasswordReqVCode Def:kSEUserResetPasswordReqVCodeDef];
    
    url = [BqsUtils setURL:url ParameterName:@"findName" Value:sPhoneOrEmail];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}

-(NSInteger)tskUpdateNickname:(NSString*)aNickName Gender:(int)aGender Birthday:(NSString*)aBirthDay Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserUpdateUserMiscInfo Def:kSEUserUpdateUserMiscInfoDef];
    
    if(nil != aNickName && [aNickName length] > 0) {
        url = [BqsUtils setURL:url ParameterName:@"nickname" Value:aNickName];
    }
    if(aGender >= 0) {
        url = [BqsUtils setURL:url ParameterName:@"gender" Value:[NSString stringWithFormat:@"%d", aGender]];
    }
    if(nil != aBirthDay && [aBirthDay length] > 0) {
        url = [BqsUtils setURL:url ParameterName:@"birthday" Value:aBirthDay];
    }
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}

-(NSInteger)tskBindWeiboId:(NSString*)weiboId WeiboUserId:(NSString*)weiboUserId Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserBindWeibo Def:kSEUserBindWeiboDef];
    
    url = [BqsUtils setURL:url ParameterName:@"weiboId" Value:weiboId];
    url = [BqsUtils setURL:url ParameterName:@"weiboUserId" Value:weiboUserId];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}

-(NSInteger)tskSetPhoneOrEmail:(NSString*)phoneOrEmail ReqVCode:(BOOL)bReqVCode Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserSetEmailOrPhone Def:kSEUserSetEmailOrPhoneDef];
    
    url = [BqsUtils setURL:url ParameterName:@"user" Value:phoneOrEmail];
    url = [BqsUtils setURL:url ParameterName:@"requestvcode" Value:bReqVCode ? @"1" : @"0"];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}

-(NSInteger)tskBindPhoneOrEmail:(NSString*)phoneOrEmail VCode:(NSString*)vCode Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserVerifyEmailOrPhone Def:kSEUserVerifyEmailOrPhoneDef];
    
    url = [BqsUtils setURL:url ParameterName:@"user" Value:phoneOrEmail];
    url = [BqsUtils setURL:url ParameterName:@"vcode" Value:vCode];
    
    return [_downloader addTask:url Target:target Callback:op Attached:att AppendPassport:YES];
}


@end
