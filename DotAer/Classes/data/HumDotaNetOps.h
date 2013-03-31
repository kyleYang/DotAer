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


//image 转码
+ (NSString *)imageConvert:(NSString  *)url width:(NSString *)widht heigh:(NSString *)heigh;

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
@end
