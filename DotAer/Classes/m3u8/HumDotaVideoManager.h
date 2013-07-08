//
//  HumDotaVideoManager.h
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"
#import "M3U8SegmentInfoList.h"
#import "M3u8Downloader.h"

@class News;

#define kNtfVideoDownloadFinished @"videodownloadfinish"

@protocol HumDotaVideoManagerDelegate;

typedef enum
{
    TaskStatusUnKnow = 0,
    TaskStatusSuccess = 1,
    TaskStatusAlready = 2,
    TaskStatusExist = 3,
    TaskStatusFailed = 4,
}AddVideoTaskStatus;

@interface HumDotaVideoManager : NSObject


@property (nonatomic, retain) id<HumDotaVideoManagerDelegate> delegate;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, retain) NSMutableArray *downloadingArry;



+ (HumDotaVideoManager*)instance;


- (AddVideoTaskStatus)addDownloadTaskForVideo:(Video *)video withStep:(VideoScreen)step;
- (AddVideoTaskStatus)addDownloadTaskForNews:(News *)news withStep:(VideoScreen)step;
- (AddVideoTaskStatus)judgeStatusForVideo:(Video *)video;
- (void)cleanAllFileForDir:(NSString *)path;
- (void)removeVideoFileForId:(NSString *)videoId;

- (NSString *)pathOfSaveDownloadedFile;
- (NSMutableArray *)readDownloadedVideoFile;
- (BOOL)saveToDownloadedFilePath;

- (NSString *)pathOfSaveDownloadingFile;
- (NSMutableArray *)readDownloadingVideoFile;
- (BOOL)saveToDownloadingPath:(NSString *)path withArry:(NSArray *)arry;
- (BOOL)autoSaveDownloadingRemoveId:(NSString *)videoId;
- (BOOL)changeIndexOfDowanloadingFrom:(NSUInteger)source destain:(NSUInteger)destine;

- (NSString *)pathofM3U8DirWithVideoId:(NSString *)vidoId;
- (NSString *)pathOfDownloadM3u8FileForVideo:(NSString *)vidoId;
- (NSString *)localServicePathForM3u8FileWithVideoId:(NSString *)vidoId;
- (NSString *)localPlayPathForVideo:(NSString *)videoId;
- (NSString *)pathofM3U8XmlFileWithVideoId:(NSString *)videoId;
- (M3U8SegmentInfoList *)segmentInfoListForVideoId:(NSString *)videoId;


@end


@protocol HumDotaVideoManagerDelegate <NSObject>

- (void)videoDownloadPecentChangedForM3u8Downloader:(M3u8Downloader *)m3u8;

@end
