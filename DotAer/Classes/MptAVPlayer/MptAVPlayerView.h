//
//  MptAVPlayerView.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MptAVPlayerControlStyle.h"
#import "MptWeak.h"
#import "MptAVPlayerVideoGravity.h"
#import "MBProgressHUD.h"



@class MptAVPlayerLayerView;
@class MptAVPlayerControlView;
@protocol MptAVPlayerControlActionDelegate;


@interface MptAVPlayerView : UIView


@property (nonatomic, mpt_weak) id<MptAVPlayerControlActionDelegate> delegate;

/** The wrapped player layer */
@property (nonatomic, readonly) AVPlayerLayer *playerLayer;

/** The view that contains the controls and fades in/out */
@property (nonatomic, retain, readonly) MptAVPlayerControlView *controlsView;
/** The placeholder view that gets shown before the movie plays */
@property (nonatomic, retain) UIView *placeholderView;
/** The ActivityView that gets shown when the buffer is empty **/
@property (nonatomic, retain) MBProgressHUD *activityView;

/** flag that indicates whether the player controls are currently visible. changes are made non-animated */
@property (nonatomic, assign) BOOL controlsVisible;
/** Controls whether the player controls are currently in fullscreen- or inlinestyle */
@property (nonatomic, assign) MptAVPlayerControlStyle controlStyle;

@property (nonatomic, assign) MptAVPlayerVideoGravity videoGravity;

@property (nonatomic, readonly) CGFloat topControlsViewHeight;
@property (nonatomic, readonly) CGFloat bottomControlsViewHeight;

@property (nonatomic, readonly) MptAVPlayerScreenState screenState;

/** Changes the visibility of the controls, can be animated with a fade */
- (void)setControlsVisible:(BOOL)controlsVisible animated:(BOOL)animated;

/** Show the ActivityVie view when can not play */
- (void)showActivityViewAnimated:(BOOL)animated;

/** Hide the ActivityVie view when can  play */
- (void)hideActivityViewAnimated:(BOOL)animated;

/** Hides the placeholder view with the play button */
- (void)hidePlaceholderViewAnimated:(BOOL)animated;
/** shows the placeholder view with the play button */
- (void)showPlaceholderViewAnimated:(BOOL)animated;

/** setups the UI corresponding to the State (Airplay, VGA, or just playing) */
- (void)updateViewsForCurrentScreenState;

- (void)stopFadeOutControlsViewTimer;
- (void)restartFadeOutControlsViewTimer;

/** Updates the UI to reflect the current time */
- (void)updateWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;
- (void)updateWithPlaybackStatus:(BOOL)isPlaying;

/** Adds an overlay view to the view that is beneath the controls but on top of the video */
- (void)addVideoOverlayView:(UIView *)overlayView;

/**
 Performs the actions on the playerView to start playback.
 Call this method on your custom placeholderView implementation
 
 @param playControl the control used to start playback
 
 */
- (void)handlePlayButtonPress:(id)playControl;


- (id)initWithFrame:(CGRect)frame name:(NSString *)videoName;

@end
