//
//  M3u8Downloader.h
//  DotAer
//
//  Created by Kyle on 13-5-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "DownloadDelegate.h"
#import "ASIProgressDelegate.h"
#import "M3U8Kit/M3U8SegmentInfoList.h"
#import "SegmentDownloader.h"

#define kDownloadM3u8 @"movie.m3u8"
#define kLocalServiceFormat @"http://127.0.0.1:12345/%@/"

@class SaveVideo;

@interface M3u8Downloader : NSObject<SegmentDownloadDelegate>
{
    NSMutableArray *downloadArray;
    M3U8SegmentInfoList* playlist;
    float totalprogress;
    id<VideoDownloadDelegate> delegate;
    BOOL bDownloading;
    BOOL downingState;
    NSString *youkuId;
    NSString *m3u8Url;
    NSString *fileDir;
}

@property (nonatomic, retain)id<VideoDownloadDelegate> delegate;
@property (nonatomic, retain)M3U8SegmentInfoList* playlist;
@property (nonatomic, assign) BOOL downingState;
@property (nonatomic, assign)float totalprogress;
@property (nonatomic, retain) SaveVideo *sVideo;
@property (nonatomic, copy) NSString *youkuId;
@property (nonatomic, copy) NSString *m3u8Url;
@property (nonatomic, copy) NSString *fileDir;

-(id)initWithM3U8List:(M3U8SegmentInfoList *)list withSaveVideo:(SaveVideo *)sVdeo withDir:(NSString *)dir;
-(id)initWithM3U8List:(M3U8SegmentInfoList *)list withSaveVideo:(SaveVideo *)sVdeo;


//开始下载
-(void)startDownloadVideo;

//暂停下载
-(void)stopDownloadVideo;

//取消下载，而且清楚下载的部分文件
-(void)cancelDownloadVideo;

-(NSString*)createLocalM3U8file;



@end
