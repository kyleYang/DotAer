//
//  DownloadObjectDelegate.h
//  XB
//
//  Created by luoxubin on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@class SegmentDownloader;
@protocol SegmentDownloadDelegate <NSObject>
@optional
-(void)segmentDownloadFinished:(SegmentDownloader *)request;
-(void)segmentDownloadFailed:(SegmentDownloader *)request;

@end


@class M3u8Downloader;
@protocol VideoDownloadDelegate <NSObject>
@optional
-(void)videoDownloaderFinished:(M3u8Downloader*)request;
-(void)videoDownloader:(M3u8Downloader*)request precent:(CGFloat)percent;
-(void)videoDownloaderFailed:(M3u8Downloader*)request;
@end