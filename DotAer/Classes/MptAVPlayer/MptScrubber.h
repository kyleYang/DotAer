//
//  NGSlider.h
//  NGMoviePlayer
//
//  Created by Philip Messlehner on 06.03.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//
//  This class is based on Ole Begemann's fantastic OBSlider: github.com/ole/OBSlider
//  Popup with current value based on: http://blog.neuwert-media.com/2011/04/customized-uislider-with-visual-value-tracking/
//  ARCified and cleaned up by Philip Messlehner and Matthias Tretter


@interface MptScrubber : UISlider

@property (atomic, assign, readonly) float scrubbingSpeed;
@property (atomic, retain) NSArray *scrubbingSpeeds;
@property (atomic, retain) NSArray *scrubbingSpeedChangePositions;

@property (nonatomic, assign) float playableValue;

@property (nonatomic, retain) UIColor *playableValueColor;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, assign) CGFloat playableValueRoundedRectRadius;

// defaults to YES
@property (nonatomic, assign) BOOL showPopupDuringScrubbing;

@end
