//
//  MptAVPlayerDelegate.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MptAVPlayerControlStyle.h"

@class MptAVPlayer;



@protocol MptAVPlayerDelegate <NSObject>

@optional


- (void)moviePlayer:(MptAVPlayer *)moviePlayer didStartPlaybackOfURL:(NSURL *)URL;
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didFailToLoadURL:(NSURL *)URL;
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didFinishPlaybackOfURL:(NSURL *)URL;
- (void)moviePlayerDidPausePlayback:(MptAVPlayer *)moviePlayer;
- (void)moviePlayerDidResumePlayback:(MptAVPlayer *)moviePlayer;
- (void)moviePlayerDidDismissPlay:(MptAVPlayer *)moviePlayer;

- (void)moviePlayerDidBeginScrubbing:(MptAVPlayer *)moviePlayer;
- (void)moviePlayerDidEndScrubbing:(MptAVPlayer *)moviePlayer;

//for ott
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didClickOtt:(id)sender;

- (void)moviePlayer:(MptAVPlayer *)moviePlayer didChangeStatus:(AVPlayerStatus)playerStatus;
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didChangePlaybackRate:(float)rate;
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didChangeAirPlayActive:(BOOL)airPlayVideoActive;
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didChangeControlStyle:(MptAVPlayerControlStyle)controlStyle;
- (void)moviePlayer:(MptAVPlayer *)moviePlayer didUpdateCurrentTime:(NSTimeInterval)currentTime;



@end


