//
//  HumDotaNetOps.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaNetOps.h"


//notication
#define kSEUploadToken @"uploadtoken"
#define kSEDefUploadTokenURL @"/dota/front/uploadToken.action"


#define kSELastNotification @"uploadtoken"
#define kSEDefLastNotificationURL @"/dota/front/lastPushContent.action"



//login register
#define kSEUserLogin @"userlogoin"
#define kSEDefUserLoginURL @"/user/front/login.action"

#define kSEUsrRigister @"userregister"
#define kSEDftUserRegister @"user/front/addUser.action"

#define kSEUserChangePassword @"userchangepassword"
#define kSEDftChangePasswordURL @"user/front/changePassword.action"

#define kSEUserChangePasswordEmail @"userchangepasswordEmail"
#define kSEDftChangePasswordEmailURL @"user/front/changePasswordWithEmail.action"

//news
#define kSENewsMessagelList @"newsmessage.list"
#define kSEDefNewsMessageURL @"/dota/front/listNews.action"

#define kSEOneVideoCatList @"onevideocat.list"
#define kSEDefOneVideoCatURL @"/dota/front/listVideoModule.action"

#define kSETwoVideoCatList @"twovideocat.list"
#define kSEDefTwoVideoCatURL @"/dota/front/listVideoModule2.action"

#define kSEVideoMessagelList @"videomessage.list"
#define kSEDefVideoMessageURL @"/dota/front/listVideo.action"

#define kSEOneImageCatList @"oneimagecat.list"
#define kSEDefOneImageCatURL @"/dota/front/listImageModule.action"


#define kSEImageMessagelList @"imagemessage.list"
#define kSEDefImageMessageURL @"/dota/front/listImage.action"

#define kSEStrategyMessagelList @"strategmessage.list"
#define kSEDefStrategMessageURL @"/dota/front/listArticle.action?"


#define kSECheckUpdatSimulatorList @"simulatorUpdata.list"
#define kSEDefCheckUpdatSimulatorURL @"/dota/front/findMaxOrderSimulator.action"

#define kSEUserFeedbackPost @"dota.user.feedback"
#define kSEDeUserFeedbackPost @"/dota/front/postFeedback.action"

#define kSEUserListQuestion @"dota.list.question"
#define kSEDeListQuestion @"/dota/front/listQuestion.action"


@implementation HumDotaNetOps


+(int)uploadToken:(NSString *)token Downloader:(Downloader *)dl Target:(id)target PkgFile:(PackageFile *)pkf Sel:(SEL)action Attached:(id)att{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUploadToken Def:kSEDefUploadTokenURL];
    url = [BqsUtils setURL:url ParameterName:@"token" Value:token];
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
}


+(int)lastPushNotificationDownloader:(Downloader *)dl Target:(id)target PkgFile:(PackageFile *)pkf Sel:(SEL)action Attached:(id)att{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSELastNotification Def:kSEDefLastNotificationURL];
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
}

//
+ (NSString *)imageConvert:(NSString  *)url width:(NSString *)widht heigh:(NSString *)heigh
{
    NSString *sUrl = @"http://m.panguso.com";
    sUrl = [BqsUtils setURL:sUrl ParameterName:@"width" Value:widht];
    sUrl = [BqsUtils setURL:sUrl ParameterName:@"height" Value:heigh];
    sUrl = [BqsUtils setURL:sUrl ParameterName:@"url" Value:url];
    
    return sUrl;
}


//user
+(int)logoinDownloader:(Downloader *)dl username:(NSString *)name password:(NSString *)password PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserLogin Def:kSEDefUserLoginURL];
    url = [BqsUtils setURL:url ParameterName:@"name" Value:name];
    url = [BqsUtils setURL:url ParameterName:@"password" Value:password];
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
    
}

+(int)registerDownloader:(Downloader *)dl username:(NSString *)name password:(NSString *)password eMail:(NSString *)email PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUsrRigister Def:kSEDftUserRegister];
    url = [BqsUtils setURL:url ParameterName:@"name" Value:name];
    url = [BqsUtils setURL:url ParameterName:@"password" Value:password];
    url = [BqsUtils setURL:url ParameterName:@"email" Value:email];
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
    
}

+(int)changePasswordDownloader:(Downloader *)dl username:(NSString *)name newPassword:(NSString *)password oldPassword:(NSString *)oldPass PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserChangePassword Def:kSEDftChangePasswordURL];
    url = [BqsUtils setURL:url ParameterName:@"name" Value:name];
    url = [BqsUtils setURL:url ParameterName:@"password" Value:password];
    url = [BqsUtils setURL:url ParameterName:@"oldpassword" Value:oldPass];
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
    
}


+(int)changePasswordDownloader:(Downloader *)dl username:(NSString *)name newPassword:(NSString *)password eMail:(NSString *)email PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserChangePasswordEmail Def:kSEDftChangePasswordEmailURL];
    url = [BqsUtils setURL:url ParameterName:@"name" Value:name];
    url = [BqsUtils setURL:url ParameterName:@"password" Value:password];
    url = [BqsUtils setURL:url ParameterName:@"email" Value:email];
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
    
}




//news

+(int)newsMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att page:(int)page{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSENewsMessagelList Def:kSEDefNewsMessageURL];
    
    url = [BqsUtils setURL:url ParameterName:@"page" Value:[NSString stringWithFormat:@"%d",page]];
    return [dl addTask:url Target:target Callback:action Attached:att];
}





//video
+(int)oneVideoCateDownloader:(Downloader *)dl PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEOneVideoCatList Def:kSEDefOneVideoCatURL];

    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];

    
}
+(int)twoVideoCateDownloader:(Downloader *)dl PkgFile:(PackageFile *)pkf Target:(id)target Sel:(SEL)action Attached:(id)att{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSETwoVideoCatList Def:kSEDefTwoVideoCatURL];
    
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
    
}

+(int)videoMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att categoryId:(NSString *)catId page:(int)page{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEVideoMessagelList Def:kSEDefVideoMessageURL];
    
    url = [BqsUtils setURL:url ParameterName:@"page" Value:[NSString stringWithFormat:@"%d",page]];
    url = [BqsUtils setURL:url ParameterName:@"catId" Value:catId];
    return [dl addTask:url Target:target Callback:action Attached:att];

}


//image
+(int)oneImageCateDownloader:(Downloader *)dl PkgFile:(PackageFile *)pkf Target:(id)target Sel:(SEL)action Attached:(id)att{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEOneImageCatList Def:kSEDefOneImageCatURL];
    
    return [dl addCachedTask:url PkgFile:pkf Target:target Callback:action Attached:att];
}

+(int)imageMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att categoryId:(NSString *)catId page:(int)page{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEImageMessagelList Def:kSEDefImageMessageURL];
    
    url = [BqsUtils setURL:url ParameterName:@"page" Value:[NSString stringWithFormat:@"%d",page]];
    url = [BqsUtils setURL:url ParameterName:@"catId" Value:catId];
    return [dl addTask:url Target:target Callback:action Attached:att];
}


//strategy


+(int)strategyMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att page:(int)page{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEStrategyMessagelList Def:kSEDefStrategMessageURL];
    
    url = [BqsUtils setURL:url ParameterName:@"page" Value:[NSString stringWithFormat:@"%d",page]];
    return [dl addTask:url Target:target Callback:action Attached:att];
}

//simulator
+(int)checkUpdataForSimulatorDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att{
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSECheckUpdatSimulatorList Def:kSEDefCheckUpdatSimulatorURL];
    return [dl addTask:url Target:target Callback:action Attached:att];
}


#pragma mark - Rate
+(NSInteger)tskPostFeedback:(NSString *)content Downloader:(Downloader*)dl Target:(id)target Callback:(SEL)op Attached:(id)att {
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserFeedbackPost Def:kSEDeUserFeedbackPost];
    url = [BqsUtils setURL:url ParameterName:@"question" Value:content];
    return [dl addTask:url Target:target Callback:op Attached:att];
}

+(int)questionMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att page:(int)page{
    
    Env *env = [Env sharedEnv];
    NSString *url = [env getSEKey:kSEUserListQuestion Def:kSEDeListQuestion];
    
    url = [BqsUtils setURL:url ParameterName:@"page" Value:[NSString stringWithFormat:@"%d",page]];
    return [dl addTask:url Target:target Callback:action Attached:att];
}




@end
