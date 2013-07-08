//
//  NGMoviePlayerControlView+NGPrivate.h
//  NGMoviePlayer
//
//  Created by Matthias Tretter on 10.09.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGMoviePlayerControlView.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>


@class NGMoviePlayerLayout;
@class NGScrubber;
@class NGVolumeControl;


@interface NGMoviePlayerControlView (NGPrivate)

@property (nonatomic, strong) NGMoviePlayerLayout *layout;

@property (nonatomic, strong, readonly) UIView *topControlsView;
@property (nonatomic, strong, readonly) UIView *bottomControlsView;
@property (nonatomic, strong, readonly) UIView *topControlsContainerView;
@property (nonatomic, strong, readonly) UIImageView *settingControlsView;

@property (nonatomic, strong, readonly) UIButton *playPauseControl;
@property (nonatomic, strong, readonly) NGScrubber *scrubberControl;
@property (nonatomic, strong, readonly) UIButton *rewindControl;
@property (nonatomic, strong, readonly) UIButton *forwardControl;
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;
@property (nonatomic, strong, readonly) UILabel *remainingTimeLabel;

@property (nonatomic, strong, readonly) NGVolumeControl *volumeControl;
@property (nonatomic, strong, readonly) UIControl *airPlayControlContainer;
@property (nonatomic, strong, readonly) MPVolumeView *airPlayControl;
@property (nonatomic, strong, readonly) UIButton *settingControl;
@property (nonatomic, strong, readonly) UIButton *downloadControl;
@property (nonatomic, strong, readonly) UILabel *videoTitle;
@property (nonatomic, strong, readonly) UIButton *zoomControl;

@property (nonatomic, assign, readonly) BOOL stepExpaned;


@end
