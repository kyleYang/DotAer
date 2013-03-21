//
//  HumDotaDataMgr.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"
@class PackageFile;


#define kNtfDotaOneVideoChanged @"ntf.dota.one.video.category"
#define kNtfDotaTwoVideoChanged @"ntf.dota.Two.video.category"
#define kNtfDotaOneImageChanged @"ntf.dota.Two.image.category"

@interface HumDotaDataMgr : NSObject

@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, copy) NSString *newsPath;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *strategyPath;



+ (HumDotaDataMgr*)instance;
- (PackageFile*)onlineCacheFilePath;
- (PackageFile*)imgCacheFilePath;


- (NSString *)pathOfDotaOneVideoCategory;
- (NSString *)pathOfDotaTwoVideoCategory;
- (NSString *)pathOfDotaOneImageCategory;

- (NSArray *)readDotaOneVieoCategory;
- (BOOL)saveDotaOneVideoCagegory:(NSArray *)arry;

- (NSArray *)readDotaTwoVieoCategory;
- (BOOL)saveDotaTwoVideoCagegory:(NSArray *)arry;

- (NSArray *)readDotaOneImageCategory;
- (BOOL)saveDotaOneImageCagegory:(NSArray *)arry;


//news save path
- (NSString *)pathOfNewsMessage;
- (NSArray *)readLocalSaveNewsData;
- (BOOL)saveNewsData:(NSArray *)arr;

//video save path
- (NSString *)pathOfVideoMessageForCat:(NSString *)category;
- (NSArray *)readLocalSaveVideoDataCat:(NSString *)category;
- (BOOL)saveVideoData:(NSArray *)arr forCat:(NSString *)category;

//image save path
- (NSString *)pathOfImageMessageForCat:(NSString *)category;
- (NSArray *)readLocalSaveImageDataCat:(NSString *)category;
- (BOOL)saveImageData:(NSArray *)arr forCat:(NSString *)category;

//strategy save path
- (NSString *)pathOfStrategyMessageForCat:(NSString *)category;
- (NSArray *)readLocalSaveStrategyDataCat:(NSString *)category;
- (BOOL)saveStrategyData:(NSArray *)arr forCat:(NSString *)category;

@end
