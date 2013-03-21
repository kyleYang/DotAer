//
//  MptAVPlayerDefaultLayout.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerLayout.h"

typedef enum {
    MptAVPlayerControlViewZoomOutButtonPositionRight = 0,
    MptAVPlayerControlViewZoomOutButtonPositionLeft
} MptAVPlayerControlViewZoomOutButtonPosition;

typedef enum {
    MptAVPlayerControlViewTopControlsViewAlignmentCenter = 0,
    MptAVPlayerControlViewTopControlsViewAlignmentLeft
} MptAVPlayerControlViewTopControlsViewAlignment;

@interface MptAVPlayerDefaultLayout : MptAVPlayerLayout
@property (nonatomic, readonly) NSArray *topControlsButtons;

@property (nonatomic, assign) BOOL scrubberHidden;
@property (nonatomic, assign) BOOL skipButtonsHidden;
@property (nonatomic, assign) CGFloat minWidthToDisplaySkipButtons;

/** the color of the scrubber */
@property (nonatomic, retain) UIColor *scrubberFillColor;
/** the padding between the buttons in topControlsView */
@property (nonatomic, assign) CGFloat topControlsViewButtonPadding;
/** the position of the zoomout-button in fullscreen-style */
@property (nonatomic, assign) MptAVPlayerControlViewTopControlsViewAlignment topControlsViewAlignment;
/** the position of the zoomout-button in fullscreen-style */
@property (nonatomic, assign) MptAVPlayerControlViewZoomOutButtonPosition zoomOutButtonPosition;


- (CGFloat)topControlsViewHeightForControlStyle:(MptAVPlayerControlStyle)controlStyle;
- (CGFloat)bottomControlsViewHeightForControlStyle:(MptAVPlayerControlStyle)controlStyle;

- (void)addTopControlsViewButton:(UIButton *)button;


@end
