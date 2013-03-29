//
//  MptAVPlayer.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MptAVPlayerDelegate.h"
#import "MptAVPlayerView.h"
#import "MptWeak.h"
#import "MptAVPlayerControlView.h"
#import "MptAVPlayerVideoGravity.h"
#import "MptAVPlayerAudioSessionCategory.h"
#import "MptAVPlayerViewController.h"
#import "MptAVPlayerPlaceholderView.h"
#import "MptAVPlayerLayout.h"
#import "MptAVPlayerDefaultLayout.h"



@interface MptAVPlayer : NSObject

/** The wrapped AVPlayer object */
@property (nonatomic, retain, readonly) AVPlayer *player;
/** The player view */
@property (nonatomic, retain, readonly) MptAVPlayerView *view;

/** The URL of the video to play, start player by setting the URL */
@property (nonatomic, copy) NSURL *URL;
/** The Play of Video Name */
@property (nonatomic, copy) NSString *name;
/** flag to indicate if the player is currently playing */
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;
/** Indicates whether the current played URL is a livestream */
@property (nonatomic, readonly, getter = isPlayingLivestream) BOOL playingLivestream;
/** flag that indicates whether the player is currently scrubbing */
@property (nonatomic, assign, readonly, getter = isScrubbing) BOOL scrubbing;
/** The delegate of the player */
@property (nonatomic, mpt_weak) id<MptAVPlayerDelegate> delegate;
/** The gravity of the video */
@property (nonatomic, assign) MptAVPlayerVideoGravity videoGravity;

/** AirPlay is only supported on >= iOS 5, defaults to YES on iOS >= 5, NO otherwise */
@property (nonatomic, assign, getter = isAirPlayEnabled) BOOL airPlayEnabled;
/** Is AirPlay currently active? */
@property (nonatomic, readonly, getter = isAirPlayVideoActive) BOOL airPlayVideoActive;
/** flag to indicate whether the video autoplays when it's ready loading, defaults to NO */
@property (nonatomic, assign) BOOL autostartWhenReady;

@property (nonatomic, assign) BOOL mptControlAble;

/** current playback time of the player */
@property (nonatomic, assign) NSTimeInterval currentPlaybackTime;
/** total duration of played video */
@property (nonatomic, readonly) NSTimeInterval duration;
/** currently downloaded duration which is already playable */
@property (nonatomic, readonly) NSTimeInterval playableDuration;
/** initialPlaybackTime for playing the video */
@property (nonatomic, assign) NSTimeInterval initialPlaybackTime;


/** tolerance offset in seconds that is used when playing from an initial playback time, use greater values for faster seeking. Defaults to kCMTimePositiveInfinity seconds */
@property (nonatomic, assign) NSTimeInterval initialPlaybackToleranceTime;
/** tolerance offset in seconds that is used when seeking to a specific time, use greater values for faster seeking. Defaults to 2 seconds */
@property (nonatomic, assign) NSTimeInterval seekingToleranceTime;



+ (void)setAudioSessionCategory:(MptAVPlayerAudioSessionCategory)audioSessionCategory;

- (id)initWithURL:(NSURL *)URL;

- (id)initWithURL:(NSURL *)URL name:(NSString *)videoName;

- (id)initWithURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime;
- (id)initWithURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime name:(NSString *)videoName;
- (void)setURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime;



- (void)play;
- (void)pause;
- (void)togglePlaybackState;




- (void)addToSuperview:(UIView *)view withFrame:(CGRect)frame;
- (void)removeFromeSuperView;


- (void)moviePlayerDidStartToPlay;
- (void)moviePlayerDidPausePlayback;
- (void)moviePlayerDidResumePlayback;
- (void)moviePlayerDidUpdateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime;

- (void)moviePlayerWillShowControlsWithDuration:(NSTimeInterval)duration;
- (void)moviePlayerDidShowControls;
- (void)moviePlayerWillHideControlsWithDuration:(NSTimeInterval)duration;
- (void)moviePlayerDidHideControls;


@end
