//
//  MptAVPlayerControlView.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MptWeak.h"
#import "MptAVPlayerControlStyle.h"
#import "MptAVPlayerVideoGravity.h"




@class MptAVlayerLayout;
@protocol MptAVPlayerControlActionDelegate;

@interface MptAVPlayerControlView : UIView


@property (nonatomic, mpt_weak) id<MptAVPlayerControlActionDelegate> delegate;

/** Controls whether the player controls are currently in fullscreen- or inlinestyle */
@property (nonatomic, assign) MptAVPlayerControlStyle controlStyle;

@property (nonatomic, assign) BOOL mptControlAble;

@property (nonatomic, assign) MptAVPlayerControlScrubbingTimeDisplay scrubbingTimeDisplay;

@property (nonatomic, readonly) NSArray *topControlsViewButtons;
@property (nonatomic, assign) NSTimeInterval playableDuration;
@property (nonatomic, readonly, getter = isAirPlayButtonVisible) BOOL airPlayButtonVisible;

@property (nonatomic, assign, readonly) BOOL explaned; //YES accept touch

/******************************************
 @name Updating
 ******************************************/

- (void)updateScrubberWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;
- (void)updateButtonsWithPlaybackStatus:(BOOL)isPlaying;
- (void)updateZoomWithVideoGravity:(MptAVPlayerVideoGravity)videoGravity;
- (void)updateButtonsWithPlayBufferEnable:(BOOL)playAble; //update button state when play can play,sometimes the buffer is empty


@end
