//
//  MptAVPlayerControlView+MptPrivate.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MptAVPlayerControlView.h"



@class MptAVPlayerLayout;
@class MptVolumeControl;
@class MPVolumeView;
@class MptScrubber;

@interface MptAVPlayerControlView (MptPrivate)

@property (nonatomic, retain) MptAVPlayerLayout *layout;
@property (nonatomic, retain, readonly) UIView *topControlsView;
@property (nonatomic, retain, readonly) UIView *bottomControlsView;
@property (nonatomic, retain, readonly) UIView *topControlsContainerView;

@property (nonatomic, retain, readonly) MptScrubber *scrubberControl;;
@property (nonatomic, retain, readonly) UILabel *currentTimeLabel;
@property (nonatomic, retain, readonly) UILabel *totalTimeLabel;

@property (nonatomic, retain, readonly) UIButton *playPauseControl;
@property (nonatomic, strong, readonly) UIButton *rewindControl;
@property (nonatomic, retain, readonly) UIButton *forwardControl;
@property (nonatomic, retain, readonly) MptVolumeControl *volumeControl;
@property (nonatomic, retain, readonly) UIControl *airPlayControlContainer;
@property (nonatomic, retain, readonly) MPVolumeView *airPlayControl;
@property (nonatomic, retain, readonly) UIButton *dismissControl;
@property (nonatomic, retain, readonly) UIButton *zoomControl;



@end
