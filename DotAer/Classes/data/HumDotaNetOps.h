//
//  HumDotaNetOps.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"
#import "BqsUtils.h"
#import "Env.h"

@interface HumDotaNetOps : NSObject


//push notification
+(int)uploadToken:(NSString *)token Downloader:(Downloader *)dl Target:(id)target PkgFile:(PackageFile *)pkf Sel:(SEL)action Attached:(id)att;
+(int)lastPushNotificationDownloader:(Downloader *)dl Target:(id)target PkgFile:(PackageFile *)pkf Sel:(SEL)action Attached:(id)att;

//image 转码
+ (NSString *)imageConvert:(NSString  *)url width:(NSString *)widht heigh:(NSString *)heigh;

//user
+(int)logoinDownloader:(Downloader *)dl username:(NSString *)name password:(NSString *)password PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;
+(int)registerDownloader:(Downloader *)dl username:(NSString *)name password:(NSString *)password eMail:(NSString *)email PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;

+(int)changePasswordDownloader:(Downloader *)dl username:(NSString *)name newPassword:(NSString *)password oldPassword:(NSString *)oldPass PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;
+(int)changePasswordDownloader:(Downloader *)dl username:(NSString *)name newPassword:(NSString *)password eMail:(NSString *)email PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;

//news
+(int)newsMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att page:(int)page;

//video
+(int)oneVideoCateDownloader:(Downloader *)dl PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;
+(int)twoVideoCateDownloader:(Downloader *)dl PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;

+(int)videoMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att categoryId:(NSString *)catId page:(int)page;

//image
+(int)oneImageCateDownloader:(Downloader *)dl PkgFile:(PackageFile *)pkf Target:(id)target  Sel:(SEL)action Attached:(id)att;
+(int)imageMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att categoryId:(NSString *)catId page:(int)page;

//strategy
+(int)strategyMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att page:(int)page;
//simulator
+(int)checkUpdataForSimulatorDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att;

//feedback
+(NSInteger)tskPostFeedback:(NSString *)content Downloader:(Downloader*)dl Target:(id)target Callback:(SEL)op Attached:(id)att;
+(int)questionMessageDownloader:(Downloader *)dl Target:(id)target Sel:(SEL)action Attached:(id)att page:(int)page;
@end
