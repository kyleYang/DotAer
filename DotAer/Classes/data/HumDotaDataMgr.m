//
//  HumDotaDataMgr.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaDataMgr.h"
#import "Env.h"
#import "BqsUtils.h"
#import "PackageFile.h"
#import "HumDotaNetOps.h"
#import "HMCategory.h"
#import "News.h"
#import "Video.h"
#import "Photo.h"
#import "Strategy.h"

#define kHumDota @"dotaer"
#define kHumNews @"news"
#define kHumVideo @"video"
#define kHumImage @"image"
#define kHumStrategy @"strategy"

#define kFileNameOnlineDataPkgFile @"online.pak"
#define kFileNameOnlineImagePkgFile @"image.pak"

#define kFileNameDotaOneVideoCategory @"dotaonevideo.xml"
#define kFileNameDotaTwoVideoCategory @"dotatwovideo.xml"

#define kFileNameDotaOneImageCategory @"dotaoneimage.xml"

#define kFileNameNewsMessageFile @"dotanewsessage.xml"
#define kFileNameVideoMessageCateFile @"dotavideo_%@.xml"
#define kFileNameImageMessageCateFile @"dotaimage_%@.xml"
#define kFileNameStrategyMessageCateFile @"dotastrategy_%@.xml"


#define kCfgOneVideoCatResfreshTS @"cfg.dota.one.video.category.refreshTS"
#define kRefreshOneVideoCatIntervalS (24*60*60.0)

#define kCfgTwoVideoCatResfreshTS @"cfg.dota.two.video.category.refreshTS"
#define kRefreshTwoVideoCatIntervalS (24*60*60.0)

#define kCfgOneImageCatResfreshTS @"cfg.dota.one.image.category.refreshTS"
#define kRefreshOneImageCatIntervalS (24*60*60.0)

#define kOnlineDataRemainTmS (20*24*60*60.0)
#define kMaxOnlinePkgFileSize (100*1024*1024) // 100 M

#define kImageDataRemainTmS (20*24*60*60.0)
#define kMaxImagePkgFileSize (100*1024*1024) // 100 M

@interface HumDotaDataMgr ()

@property (nonatomic, retain) Downloader *downloader;

@property (nonatomic, retain) PackageFile *onlineCachePkgFile; // store online data info
@property (nonatomic, retain) PackageFile *imgCachePkgFile; // store online image info

@property (nonatomic, retain) NSArray *arrOneVideoCat; //video category
@property (nonatomic, retain) NSArray *arrTwoVideoCat;

@property (nonatomic, retain) NSArray *arrOneImageCat;//image category

- (void)doNetworkUpdataChecks;
- (void)oneVideCategoryRefresh; // one for dotaOne, two for dotaTwo
- (void)twoVideCategoryRefresh;
- (void)oneImageCategoryRefresh;

@end


@implementation HumDotaDataMgr
@synthesize downloader;

@synthesize onlineCachePkgFile;
@synthesize imgCachePkgFile;
@synthesize rootPath;
@synthesize newsPath;
@synthesize videoPath;
@synthesize imagePath;
@synthesize strategyPath;

@synthesize arrOneVideoCat; //video category
@synthesize arrTwoVideoCat;

@synthesize arrOneImageCat;//image category

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.downloader cancelAll];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    self.downloader = nil;
    self.onlineCachePkgFile = nil;
    self.imgCachePkgFile = nil;
    self.rootPath = nil;
    self.newsPath = nil;
    self.videoPath = nil;
    self.imagePath = nil;
    self.strategyPath = nil;
    self.arrOneVideoCat = nil;
    self.arrTwoVideoCat = nil;
    self.arrOneImageCat = nil;
    [super dealloc];
}



+ (HumDotaDataMgr*)instance {
	
	NSString *key = [[HumDotaDataMgr class] description];
	
	NSMutableDictionary *dict = [Env sharedEnv].runtimeData;
	
	HumDotaDataMgr *bdm = (HumDotaDataMgr*)[dict objectForKey: key];
	if(nil == bdm) {
		bdm = [[HumDotaDataMgr alloc] init];
		[dict setObject:bdm forKey: key];
		[bdm release];
	}
	
	return bdm;
}


-(id)init
{
    self = [super init];
    if(nil == self) return nil;
    
    self.rootPath = [[Env sharedEnv].dirCache stringByAppendingPathComponent:kHumDota];
    self.newsPath = [self.rootPath stringByAppendingPathComponent:kHumNews];
    self.videoPath = [self.rootPath stringByAppendingPathComponent:kHumVideo];
    self.imagePath = [self.rootPath stringByAppendingPathComponent:kHumImage];
    self.strategyPath = [self.rootPath stringByAppendingPathComponent:kHumStrategy];
    
	BqsLog(@"dota rootPath=%@,newsPath = %@,videoPath = %@,imagePath = %@,strategyPath = %@ ", self.rootPath,self.newsPath,self.videoPath,self.imagePath,self.strategyPath);
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appTermNtf:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResumeNtf:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    return self;
}



-(PackageFile*)onlineCacheFilePath {
    if(nil != self.onlineCachePkgFile) {
        return [[self.onlineCachePkgFile retain] autorelease];
    }
    
    // load from disk
    unsigned tmOld = (unsigned int)([NSDate timeIntervalSinceReferenceDate]-kOnlineDataRemainTmS);
    
    NSString *path = [self.rootPath stringByAppendingPathComponent:kFileNameOnlineDataPkgFile];
    //    NSString *path = [self.rootPath stringByAppendingPathComponent:kFileNameBookOnlineDataPkgFile];
    BqsLog(@"the onlinePkgFile is Path %@",path);
    
    int fileSize = [BqsUtils fileSize:path];
    if(fileSize > kMaxOnlinePkgFileSize) {
        BqsLog(@"online pkg file too big, delete it. size: %d>%d", fileSize, kMaxOnlinePkgFileSize);
        [BqsUtils deletePath:path];
    }
    
    self.onlineCachePkgFile = [[[PackageFile alloc] initWithPath:path DelOldDataBefore:tmOld] autorelease];
    
    if(nil == self.onlineCachePkgFile) {
        BqsLog(@"Failed to load online pkg file");
        return nil;
    }
    return self.onlineCachePkgFile;
}

-(PackageFile*)imgCacheFilePath {
    if(nil != self.imgCachePkgFile) {
        return [[self.imgCachePkgFile retain] autorelease];
    }
    
    // load from disk
    unsigned tmOld = (unsigned int)([NSDate timeIntervalSinceReferenceDate]-kImageDataRemainTmS);
    
    NSString *path = [self.rootPath stringByAppendingPathComponent:kFileNameOnlineImagePkgFile];
    //    NSString *path = [self.rootPath stringByAppendingPathComponent:kFileNameBookOnlineDataPkgFile];
    BqsLog(@"the onlinePkgFile is Path %@",path);
    
    int fileSize = [BqsUtils fileSize:path];
    if(fileSize > kMaxImagePkgFileSize) {
        BqsLog(@"online pkg file too big, delete it. size: %d>%d", fileSize, kMaxOnlinePkgFileSize);
        [BqsUtils deletePath:path];
    }
    
    self.imgCachePkgFile = [[[PackageFile alloc] initWithPath:path DelOldDataBefore:tmOld] autorelease];
    
    if(nil == self.imgCachePkgFile) {
        BqsLog(@"Failed to load online pkg file");
        return nil;
    }
    return self.imgCachePkgFile;
}

#pragma mark
#pragma mark - ntf handler
-(void)appTermNtf:(NSNotification*)ntf {
    BqsLog(@"appTermNtf");
    
    [self.downloader cancelAll];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)appResumeNtf:(NSNotification*)ntf {
    BqsLog(@"appResumeNtf");
    
    [self performSelector:@selector(doNetworkUpdataChecks) withObject:nil afterDelay:3];
}


#pragma mark
#pragma makr message detail
//news save path
- (NSString *)pathOfNewsMessage{
    NSString *path = [self.newsPath stringByAppendingPathComponent:kFileNameNewsMessageFile];
    BqsLog(@"pathOfNewsMessage :%@",path);
	return path;
}

- (NSArray *)readLocalSaveNewsData{
    return [News parseXmlData:[NSData dataWithContentsOfFile:[self pathOfNewsMessage]]];
}

- (BOOL)saveNewsData:(NSArray *)arr{
    return [News saveToFile:[self pathOfNewsMessage] Arr:arr];
}

//video save path
- (NSString *)pathOfVideoMessageForCat:(NSString *)category{
    NSString *detailFile = [NSString stringWithFormat:kFileNameVideoMessageCateFile,category];
    NSString *path = [self.videoPath stringByAppendingPathComponent:detailFile];
    BqsLog(@"pathOfVideoMessageForCat :%@",path);
	return path;
}
- (NSArray *)readLocalSaveVideoDataCat:(NSString *)category{
    
    return [Video parseXmlData:[NSData dataWithContentsOfFile:[self pathOfVideoMessageForCat:category]]];
}
- (BOOL)saveVideoData:(NSArray *)arr forCat:(NSString *)category{
    return [Video saveToFile:[self pathOfVideoMessageForCat:category] Arr:arr];
}


//image save path
- (NSString *)pathOfImageMessageForCat:(NSString *)category{
    NSString *detailFile = [NSString stringWithFormat:kFileNameImageMessageCateFile,category];
    NSString *path = [self.imagePath stringByAppendingPathComponent:detailFile];
    BqsLog(@"pathOfImageMessageForCat :%@",path);
	return path;

}

- (NSArray *)readLocalSaveImageDataCat:(NSString *)category{
    return [Photo parseXmlData:[NSData dataWithContentsOfFile:[self pathOfImageMessageForCat:category]]];
}
- (BOOL)saveImageData:(NSArray *)arr forCat:(NSString *)category{
    return [Photo saveToFile:[self pathOfImageMessageForCat:category] Arr:arr];
}

//strategy save path
- (NSString *)pathOfStrategyMessageForCat:(NSString *)category{
    NSString *detailFile = [NSString stringWithFormat:kFileNameStrategyMessageCateFile,category];
    NSString *path = [self.strategyPath stringByAppendingPathComponent:detailFile];
    BqsLog(@"pathOfStrategyMessageForCat :%@",path);
	return path;
}

- (NSArray *)readLocalSaveStrategyDataCat:(NSString *)category{
    
}
- (BOOL)saveStrategyData:(NSArray *)arr forCat:(NSString *)category{
    
}



#pragma mark
#pragma mark category save message

- (NSString *)pathOfDotaOneVideoCategory{
    NSString *path = [self.videoPath stringByAppendingPathComponent:kFileNameDotaOneVideoCategory];
	return path;
    
}
- (NSString *)pathOfDotaTwoVideoCategory{
    NSString *path = [self.videoPath stringByAppendingPathComponent:kFileNameDotaTwoVideoCategory];
	return path;
}

- (NSString *)pathOfDotaOneImageCategory{
    NSString *path = [self.imagePath stringByAppendingPathComponent:kFileNameDotaOneImageCategory];
	return path;
}

- (NSArray *)readDotaOneVieoCategory{
    if (self.arrOneVideoCat != nil) return arrOneVideoCat;
    self.arrOneVideoCat = [HMCategory parseXmlData:[NSData dataWithContentsOfFile:[self pathOfDotaOneVideoCategory]]];
    if (nil == self.arrOneVideoCat) {
        [self oneVideCategoryRefresh];
    }
    
    return self.arrOneVideoCat;
}
- (BOOL)saveDotaOneVideoCagegory:(NSArray *)arry{
    return [HMCategory saveToFile:[self pathOfDotaOneVideoCategory] Arr:arry];
}


- (NSArray *)readDotaTwoVieoCategory{
    if (self.arrTwoVideoCat != nil) return arrTwoVideoCat;
    self.arrTwoVideoCat = [HMCategory parseXmlData:[NSData dataWithContentsOfFile:[self pathOfDotaTwoVideoCategory]]];
    if (nil == self.arrTwoVideoCat) {
        [self twoVideCategoryRefresh];
    }

    return self.arrTwoVideoCat;
    
    
}
- (BOOL)saveDotaTwoVideoCagegory:(NSArray *)arry{
    return [HMCategory saveToFile:[self pathOfDotaTwoVideoCategory] Arr:arry];
}


- (NSArray *)readDotaOneImageCategory{
    if (self.arrOneImageCat != nil) return arrOneImageCat;
    self.arrOneImageCat = [HMCategory parseXmlData:[NSData dataWithContentsOfFile:[self pathOfDotaOneImageCategory]]];
    if (nil == self.arrOneImageCat) {
        [self oneImageCategoryRefresh];
    }

    return self.arrOneImageCat;
}

- (BOOL)saveDotaOneImageCagegory:(NSArray *)arry{
    return [HMCategory saveToFile:[self pathOfDotaOneImageCategory] Arr:arry];
}


#pragma mark
#pragma mark UpdataCheck
- (void)doNetworkUpdataChecks{
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];

    float lastUploadTs = [defs floatForKey:kCfgOneVideoCatResfreshTS];
    [self readDotaOneVieoCategory];
    if (!self.arrOneVideoCat || self.arrOneVideoCat.count == 0 || fNow - lastUploadTs > kRefreshOneVideoCatIntervalS) {
        [self oneVideCategoryRefresh];
    }

    lastUploadTs = [defs floatForKey:kCfgTwoVideoCatResfreshTS];
    [self readDotaTwoVieoCategory];
    if (!self.arrTwoVideoCat || self.arrTwoVideoCat.count == 0 || fNow - lastUploadTs > kRefreshTwoVideoCatIntervalS) {
        [self twoVideCategoryRefresh];
    }
    
    lastUploadTs = [defs floatForKey:kCfgOneImageCatResfreshTS];
    [self readDotaOneImageCategory];
    if (!self.arrOneImageCat || self.arrOneImageCat.count == 0 || fNow - lastUploadTs > kRefreshOneImageCatIntervalS) {
        [self oneImageCategoryRefresh];
    }

    
}

- (void)oneVideCategoryRefresh{
    BqsLog(@"oneVideCategoryRefresh");
    [HumDotaNetOps oneVideoCateDownloader:self.downloader PkgFile:[self onlineCacheFilePath] Target:self Sel:@selector(oneVideoCateDataFinished:) Attached:nil];
    
}
- (void)twoVideCategoryRefresh{
    BqsLog(@"twoVideCategoryRefresh");
    [HumDotaNetOps twoVideoCateDownloader:self.downloader PkgFile:[self onlineCacheFilePath] Target:self Sel:@selector(twoVideoCateDataFinished:) Attached:nil];
    
}
- (void)oneImageCategoryRefresh{
    BqsLog(@"oneImageCategoryRefresh");
    [HumDotaNetOps oneImageCateDownloader:self.downloader PkgFile:[self onlineCacheFilePath] Target:self Sel:@selector(oneImageCateFinished:) Attached:nil];
    
}


#pragma mark
#pragma mark categor downloader callback
- (void)oneVideoCateDataFinished:(DownloaderCallbackObj *)cb{
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
        BqsLog(@"Failed to upload one video category http: %d err: %@", cb.httpStatus, cb.error);
        return;
    }
    
    self.arrOneVideoCat = [HMCategory parseXmlData:cb.rspData];
    
    if(!self.arrOneVideoCat){
        BqsLog(@"parseXmlData self.arrOneVideoCat = nil");
        return;
    }
    if(![HMCategory saveToFile:[self pathOfDotaOneVideoCategory] Arr:self.arrOneVideoCat]){
        BqsLog(@"save arrOneVideoCat wrong");
        return;
    }
    
    float fSaveTime = (float)[NSDate timeIntervalSinceReferenceDate];
    [[NSUserDefaults standardUserDefaults] setFloat:fSaveTime forKey:kCfgOneVideoCatResfreshTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNtfDotaOneVideoChanged object:nil];
    
}

- (void)twoVideoCateDataFinished:(DownloaderCallbackObj *)cb{
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
        BqsLog(@"Failed to upload two video category http: %d err: %@", cb.httpStatus, cb.error);
        return;
    }
    
    self.arrTwoVideoCat = [HMCategory parseXmlData:cb.rspData];
    
    if(!self.arrTwoVideoCat){
        BqsLog(@"parseXmlData self.arrOneVideoCat = nil");
        return;
    }
    if(![HMCategory saveToFile:[self pathOfDotaTwoVideoCategory] Arr:self.arrTwoVideoCat]){
        BqsLog(@"save arrOneVideoCat wrong");
        return;
    }
    
    float fSaveTime = (float)[NSDate timeIntervalSinceReferenceDate];
    [[NSUserDefaults standardUserDefaults] setFloat:fSaveTime forKey:kCfgTwoVideoCatResfreshTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNtfDotaTwoVideoChanged object:nil];
    
}


- (void)oneImageCateFinished:(DownloaderCallbackObj *)cb{
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
        BqsLog(@"Failed to upload one image category http: %d err: %@", cb.httpStatus, cb.error);
        return;
    }
    
    self.arrOneImageCat = [HMCategory parseXmlData:cb.rspData];
    
    if(!self.arrOneImageCat){
        BqsLog(@"parseXmlData self.arrOneImageCat = nil");
        return;
    }
    if(![HMCategory saveToFile:[self pathOfDotaOneImageCategory] Arr:self.arrOneImageCat]){
        BqsLog(@"save arrOneImageCat wrong");
        return;
    }
    
    float fSaveTime = (float)[NSDate timeIntervalSinceReferenceDate];
    [[NSUserDefaults standardUserDefaults] setFloat:fSaveTime forKey:kCfgOneImageCatResfreshTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNtfDotaOneImageChanged object:nil];
    
}




@end
