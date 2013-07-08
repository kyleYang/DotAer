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
@class Video;
@class News;
@class Photo;
@class Strategy;


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

@property (nonatomic, retain,readonly) NSMutableArray *arrFavVideo;
@property (nonatomic, retain,readonly) NSMutableArray *arrFavNews;
@property (nonatomic, retain,readonly) NSMutableArray *arrFavImage;
@property (nonatomic, retain,readonly) NSMutableArray *arrFavStrategy;


+ (HumDotaDataMgr*)instance;
- (PackageFile*)onlineCacheFilePath;
- (PackageFile*)imgCacheFilePath;


- (void)cleanOtherCacheFile;
- (void)cleanImageCacheFile;

-(NSString *)fileSizeForDir:(NSString*)path;
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


//pathofvideo



#pragma mark favorate
//video
- (NSString *)favVideoPathOfFile;
- (NSArray *)arrOfLocalFavVideo;
- (BOOL)addFavoVideo:(Video *)video;
- (BOOL)judgeFavVideo:(Video *)video;

//news

- (NSString *)favNewsPathOfFile;
- (BOOL)addFavNews:(News *)news;
- (NSArray *)arrOfLocalFavNews;
- (BOOL)judgeFavNews:(News *)news;

- (NSString *)favImagePathOfFile;
- (NSArray *)arrOfLocalFavImage;
- (BOOL)addFavoImage:(Photo *)photo;
- (BOOL)judgeFavImage:(Photo *)photo;

- (NSString *)favStrategyPathOfFile;
- (NSArray *)arrOfLocalFavStragety;
- (BOOL)addFavoStragtegy:(Strategy *)strategy;
- (BOOL)judgeFavStrategy:(Strategy *)strategy;


@end
