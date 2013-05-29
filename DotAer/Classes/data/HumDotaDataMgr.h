//
//  HumDotaDataMgr.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"
#import "PackageFile.h"
@class Article;

#define kNtfDotaOneVideoChanged @"ntf.dota.one.video.category"
#define kNtfDotaTwoVideoChanged @"ntf.dota.Two.video.category"
#define kNtfDotaOneImageChanged @"ntf.dota.Two.image.category"

@interface HumDotaDataMgr : NSObject

@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, copy) NSString *newsPath;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *strategyPath;
@property (nonatomic, copy) NSString *articlePath;
@property (nonatomic, copy) NSString *simulatorPath;


+ (HumDotaDataMgr*)instance;
- (PackageFile*)onlineCacheFilePath;
- (PackageFile*)imgCacheFilePath;


- (void)cleanOtherCacheFile;
- (void)cleanImageCacheFile;

-(long)fileSizeForDir:(NSString*)path;
- (void)cleanAllFileForDir:(NSString *)path;

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

- (NSString *)pathOfArticlForArticleID:(NSString *)artId;
- (Article *)articleContentOfAritcleID:(NSString *)artId;
- (BOOL)saveArticleContent:(Article *)article ArticleID:(NSString *)artId;


//simulator
- (NSString *)pathOfSimlatorTempFile;
- (NSString *)pathofSimulatorDir;

//path of heroinfo for simulator
- (NSString *)pathOfHeroInfoXML;

//path of equipinfo for simulator
- (NSString *)pathOfEquipInfoXML;

- (NSString *)pathOfHeroImageDir;
- (NSString *)pathofTestM3u8:(NSUInteger)index;


//pathoftestvied
- (NSString *)pathofTestM3u8;


@end
