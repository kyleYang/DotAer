//
//  MptAVPlayerDefaultLayout.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerDefaultLayout.h"
#import "MptVolumeControl.h"
#import "MptScrubber.h"

#define kMinWidthToDisplaySkipButtons          420.f
#define kControlWidth                          (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 44.f : 50.f)


@interface MptAVPlayerDefaultLayout () {
   NSMutableArray *_topControlsButtons;
}

@property (nonatomic, readonly) UIImage *bottomControlFullscreenImage;
@property (nonatomic, readonly) UIImage *TopControlFullscreenImage;

@end

@implementation MptAVPlayerDefaultLayout
@synthesize bottomControlFullscreenImage = _bottomControlFullscreenImage;
@synthesize TopControlFullscreenImage = _TopControlFullscreenImage;
@synthesize topControlsButtons = _topControlsButtons;
@synthesize scrubberHidden = _scrubberHidden;
@synthesize skipButtonsHidden = _skipButtonsHidden;
@synthesize minWidthToDisplaySkipButtons = _minWidthToDisplaySkipButtons;
@synthesize scrubberFillColor = _scrubberFillColor;
@synthesize topControlsViewButtonPadding = _topControlsViewButtonPadding;
@synthesize topControlsViewAlignment = _topControlsViewAlignment;
@synthesize zoomOutButtonPosition = _zoomOutButtonPosition;


- (void)dealloc
{
    _bottomControlFullscreenImage = nil;
    _TopControlFullscreenImage = nil;
    _topControlsButtons = nil;
    [_scrubberFillColor release]; _scrubberFillColor = nil;
    
    [super dealloc];
    
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)init {
    if ((self = [super init])) {
        _scrubberFillColor = [[UIColor greenColor] retain];
        _minWidthToDisplaySkipButtons = kMinWidthToDisplaySkipButtons;
        
        _topControlsButtons = [NSMutableArray array];
        _topControlsViewAlignment = MptAVPlayerControlViewTopControlsViewAlignmentCenter;
        _zoomOutButtonPosition = MptAVPlayerControlViewZoomOutButtonPositionRight;
        _topControlsViewButtonPadding = 35.f;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayerLayout
////////////////////////////////////////////////////////////////////////

- (void)customizeTopControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    UIImageView *topControlsImageView = (UIImageView *)self.topControlsView;
    
    if (controlStyle == MptAVPlayerControlStyleFullscreen) {
        topControlsImageView.backgroundColor = [UIColor clearColor];
        topControlsImageView.image = self.TopControlFullscreenImage;
    } else if (controlStyle == MptAVPlayerControlStyleInline) {
        topControlsImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        topControlsImageView.image = nil;
    }

    
}

- (void)customizeBottomControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    // update styling of bottom controls view
    UIImageView *bottomControlsImageView = (UIImageView *)self.bottomControlsView;
    
    if (controlStyle == MptAVPlayerControlStyleFullscreen) {
        bottomControlsImageView.backgroundColor = [UIColor clearColor];
        bottomControlsImageView.image = self.bottomControlFullscreenImage;
    } else if (controlStyle == MptAVPlayerControlStyleInline) {
        bottomControlsImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        bottomControlsImageView.image = nil;
    }
}

- (void)customizeControlsWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    [self setupScrubber:self.scrubberControl controlStyle:controlStyle];
}

- (void)layoutTopControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    self.topControlsView.frame = CGRectMake(0.f,
                                            20.f,
                                            self.width,
                                            [self topControlsViewHeightForControlStyle:controlStyle]);
    
    if (self.topControlsViewAlignment == MptAVPlayerControlViewTopControlsViewAlignmentCenter) {
        // center custom controls in top container
        self.topControlsContainerView.frame = CGRectMake(MAX((self.topControlsView.frame.size.width - self.topControlsContainerView.frame.size.width)/2.f, 0.f),
                                                         0.f,
                                                         self.topControlsContainerView.frame.size.width,
                                                         [self topControlsViewHeightForControlStyle:controlStyle]);
    } else {
        self.topControlsContainerView.frame = CGRectMake(2.f,
                                                         0.f,
                                                         self.topControlsContainerView.frame.size.width,
                                                         [self topControlsViewHeightForControlStyle:controlStyle]);
    }
}

- (void)layoutBottomControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    CGFloat controlsViewHeight = [self bottomControlsViewHeightForControlStyle:controlStyle];
    CGFloat offset = (self.controlStyle == MptAVPlayerControlStyleFullscreen ? 0.f : 0.f);
    
    self.bottomControlsView.frame = CGRectMake(offset,
                                               self.height-controlsViewHeight,
                                               self.width - 2.f*offset,
                                               controlsViewHeight-offset);
}

- (void)layoutControlsWithControlStyle:(MptAVPlayerControlStyle)controlStyle AirplayAvailable:(BOOL)airPlayAvailable{
    if (controlStyle == MptAVPlayerControlStyleInline) {
        [self layoutSubviewsForControlStyleInlineAirplayAvailable:airPlayAvailable];
    } else {
        [self layoutSubviewsForControlStyleFullscreenAirplayAvailable:airPlayAvailable];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayerDefaultLayout
////////////////////////////////////////////////////////////////////////

- (void)setScrubberFillColor:(UIColor *)scrubberFillColor {
   self.scrubberControl.fillColor = scrubberFillColor;
//    self.volumeControl.minimumTrackColor = scrubberFillColor;
    
    // customize scrubber with new color
    [self updateControlStyle:self.controlStyle];
}

- (void)setScrubberHidden:(BOOL)scrubberHidden {
   if (scrubberHidden != _scrubberHidden) {
        _scrubberHidden = scrubberHidden;
        [self invalidateLayout];
    }
}

- (void)setSkipButtonsHidden:(BOOL)skipButtonsHidden {
    if (skipButtonsHidden != _skipButtonsHidden) {
        _skipButtonsHidden = skipButtonsHidden;
        
        [self invalidateLayout];
    }
}

- (void)addTopControlsViewButton:(UIButton *)button {
    CGFloat maxX = 0.f;
    CGFloat height = [self topControlsViewHeightForControlStyle:self.controlStyle];
    
    for (UIView *subview in self.topControlsContainerView.subviews) {
        maxX = MAX(subview.frame.origin.x + subview.frame.size.width, maxX);
    }
    
    if (maxX > 0.f) {
        maxX += self.topControlsViewButtonPadding;
    }
    
    button.frame = CGRectMake(maxX, 0.f, button.frame.size.width, height);
    [self.topControlsContainerView addSubview:button];
    self.topControlsContainerView.frame = CGRectMake(0.f, 0.f, maxX + button.frame.size.width, height);
    
    [_topControlsButtons addObject:button];
}

- (void)setTopControlsViewButtonPadding:(CGFloat)topControlsViewButtonPadding {
    if (topControlsViewButtonPadding != _topControlsViewButtonPadding) {
        _topControlsViewButtonPadding = topControlsViewButtonPadding;
        
        [self layoutTopControlsViewButtons];
    }
}

- (CGFloat)topControlsViewHeightForControlStyle:(MptAVPlayerControlStyle)controlStyle {
    if (controlStyle == MptAVPlayerControlStyleFullscreen) {
        return 40.f; //all state is fullScreen ,heigh for topView
    } else {
        return 40.f;
    }

}

- (CGFloat)bottomControlsViewHeightForControlStyle:(MptAVPlayerControlStyle)controlStyle {
    if (controlStyle == MptAVPlayerControlStyleFullscreen) {
        return 80.f; //all state is fullScreen
    } else {
        return 40.f;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupScrubber:(MptScrubber *)scrubber controlStyle:(MptAVPlayerControlStyle)controlStyle {
    CGFloat height = 20.f;
    CGFloat radius = 8.f;
    
    if (controlStyle == MptAVPlayerControlStyleFullscreen) {
        height = 10.f;
        
        [scrubber setThumbImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/scrubberKnob"]
                       forState:UIControlStateNormal];

        
//        [scrubber setThumbImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/scrubberKnobFullscreen"]
//                       forState:UIControlStateNormal];
    } else {
        height = 10.f;
        
        [scrubber setThumbImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/scrubberKnob"]
                       forState:UIControlStateNormal];
    }
    
    //Build a roundedRect of appropriate size at origin 0,0
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, 0.f, height, height) cornerRadius:radius];
    //Color for Stroke
    CGColorRef strokeColor = [[UIColor blackColor] CGColor];
    
    // create minimum track image
    UIGraphicsBeginImageContext(CGSizeMake(height, height));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, self.scrubberControl.fillColor.CGColor);
    //Fill the color
    [roundedRect fill];
    //Draw stroke
    CGContextSetStrokeColorWithColor(currentContext, strokeColor);
    [roundedRect stroke];
    //Snap the picture and close the context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //generate stretchable Image
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
    } else {
        image = [image stretchableImageWithLeftCapWidth:radius topCapHeight:radius];
    }
    [scrubber setMinimumTrackImage:image forState:UIControlStateNormal];
    
    // create maximum track image
    UIGraphicsBeginImageContext(CGSizeMake(height, height));
    currentContext = UIGraphicsGetCurrentContext();
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, [UIColor colorWithWhite:1.f alpha:.2f].CGColor);
    //Fill the color
    [roundedRect fill];
    //Draw stroke
    CGContextSetStrokeColorWithColor(currentContext, strokeColor);
    [roundedRect stroke];
    //Snap the picture and close the context
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //generate stretchable Image
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
    } else {
        image = [image stretchableImageWithLeftCapWidth:radius topCapHeight:radius];
    }
    [scrubber setMaximumTrackImage:image forState:UIControlStateNormal];
    
    if (controlStyle == MptAVPlayerControlStyleFullscreen) {
        scrubber.playableValueRoundedRectRadius = radius;
    } else {
        scrubber.playableValueRoundedRectRadius = 2.f;
    }
    
    // force re-draw of playable value of scrubber
    scrubber.playableValue = scrubber.playableValue;
}


- (UIImage *)TopControlFullscreenImage{
    if (_TopControlFullscreenImage == nil) {
        _TopControlFullscreenImage = [[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_topview_bg"] stretchableImageWithLeftCapWidth:2 topCapHeight:20];
        
        // make it a resizable image
        if ([_TopControlFullscreenImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            _TopControlFullscreenImage = [_TopControlFullscreenImage resizableImageWithCapInsets:UIEdgeInsetsMake(48.f, 15.f, 46.f, 15.f)];
        } else {
            _TopControlFullscreenImage = [_TopControlFullscreenImage stretchableImageWithLeftCapWidth:15 topCapHeight:47];
        }

    }
    return _TopControlFullscreenImage;
}

- (UIImage *)bottomControlFullscreenImage {
    if (_bottomControlFullscreenImage == nil) {
        _bottomControlFullscreenImage = [[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_buttom_bg"] stretchableImageWithLeftCapWidth:2 topCapHeight:20];
        
        // make it a resizable image
        if ([_bottomControlFullscreenImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            _bottomControlFullscreenImage = [_bottomControlFullscreenImage resizableImageWithCapInsets:UIEdgeInsetsMake(48.f, 15.f, 46.f, 15.f)];
        } else {
            _bottomControlFullscreenImage = [_bottomControlFullscreenImage stretchableImageWithLeftCapWidth:15 topCapHeight:47];
        }
    }
    
    return _bottomControlFullscreenImage;
}

- (void)layoutSubviewsForControlStyleInlineAirplayAvailable:(BOOL)airPlayAvailable{
    CGFloat width = self.width;
    CGFloat controlsViewHeight = [self bottomControlsViewHeightForControlStyle:self.controlStyle];
    CGFloat leftEdge = 0.f;
    CGFloat rightEdge = width;   // the right edge of the last positioned button in the bottom controls view (starting from right)
    
    // skip buttons always hidden in inline mode
    self.forwardControl.hidden = YES;
    
    // play button always on the left
    self.playPauseControl.frame = CGRectMake(0.f, 0.f, kControlWidth, controlsViewHeight);
    leftEdge = self.playPauseControl.frame.origin.x + self.playPauseControl.frame.size.width;
    
    // volume control and zoom button are always on the right
    self.zoomControl.frame = CGRectMake(width-kControlWidth, 0.f, kControlWidth, controlsViewHeight);
    [self.zoomControl setImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/zoomIn"] forState:UIControlStateNormal];
    
//    self.volumeControl.frame = CGRectMake(rightEdge-kControlWidth, self.bottomControlsView.frame.origin.y, kControlWidth, controlsViewHeight);
//    rightEdge = self.volumeControl.frame.origin.x;
    
    // we always position the airplay button, but only update the left edge when the button is visible
    // this is a workaround for a layout bug I can't remember
    self.airPlayControlContainer.frame = CGRectMake(rightEdge-kControlWidth, 0.f, kControlWidth, controlsViewHeight);
    if (self.airPlayControlVisible) {
        rightEdge = self.airPlayControlContainer.frame.origin.x;
    }
    
//    self.currentTimeLabel.frame = CGRectMake(leftEdge, 0.f, 55.f, controlsViewHeight);
//    self.currentTimeLabel.textAlignment = UITextAlignmentCenter;
//    leftEdge = self.currentTimeLabel.frame.origin.x + self.currentTimeLabel.frame.size.width;
//    
//    self.remainingTimeLabel.frame = CGRectMake(rightEdge-60.f, 0.f, 60.f, controlsViewHeight);
//    self.remainingTimeLabel.textAlignment = UITextAlignmentCenter;
//    rightEdge = self.remainingTimeLabel.frame.origin.x;
    
    // scrubber uses remaining width
//    self.scrubberControl.frame = CGRectMake(leftEdge, 0.f, rightEdge - leftEdge, controlsViewHeight);
}

- (void)layoutSubviewsForControlStyleFullscreenAirplayAvailable:(BOOL)airPlayAvailable {
    BOOL displaySkipButtons = !self.skipButtonsHidden && !self.playingLivestream && (self.bottomControlsView.frame.size.width > self.minWidthToDisplaySkipButtons);
    CGFloat width = self.bottomControlsView.bounds.size.width;
    CGFloat outerPadding = UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 5.f : 10.f;
    CGFloat controlWidth = UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 44.f : 50.f;
    CGFloat offset = UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 54.f : 66.f;
    CGFloat controlHeight = 44.f;
    CGFloat topY = 2.f;
    
    self.dismissControl.frame = CGRectMake(15, 0, 40, 40);
    // zoom button can be left or right
   
    CGFloat zoomButtonWidth = CGRectGetWidth(self.zoomControl.frame);
   
    if (self.zoomOutButtonPosition == MptAVPlayerControlViewZoomOutButtonPositionLeft) {
        self.zoomControl.frame = CGRectMake(CGRectGetWidth(self.dismissControl.frame)+5, 0.f, zoomButtonWidth, self.topControlsView.bounds.size.height);
    } else {
        self.zoomControl.frame = CGRectMake(self.width - zoomButtonWidth-10, 0.f, zoomButtonWidth, self.topControlsView.bounds.size.height);
    }
    
    CGFloat offX = 0.0f;
    CGFloat paddingX = 0.0f;
    if (!airPlayAvailable) {
        paddingX = 20.0f;
    }
    
    
    
    if (self.screenType == UIDeviceResolution_iPhoneRetina4) {
        offX = 10.0f;
    }
    
    self.scrubberControl.frame = CGRectMake(12.f, 0,  width- 24.f, 15.f);
    
    self.currentTimeLabel.frame = CGRectMake(outerPadding, CGRectGetMaxY(self.scrubberControl.frame), 55.f, 15.f);
    self.currentTimeLabel.textAlignment = UITextAlignmentCenter;
    self.totalTimeLabel.frame = CGRectMake(width - 55.f - outerPadding, CGRectGetMinY(self.currentTimeLabel.frame), 55.f, 15.f);
    self.totalTimeLabel.textAlignment = UITextAlignmentCenter;
    

    
    
    // play/skip segment centered in first row
    CGRect frame = self.rewindControl.frame;
    frame.origin.y = 30.0f;
    frame.origin.x = 0.0f;
    self.rewindControl.frame = frame;
    
    frame = self.playPauseControl.frame;
    frame.origin.x = CGRectGetMaxX(self.rewindControl.frame)+paddingX;
    frame.origin.y = CGRectGetMinY(self.rewindControl.frame);
    self.playPauseControl.frame = frame;
    
//    self.rewindControl.frame = CGRectOffset(self.playPauseControl.frame, -offset, 0.f);
    frame = self.forwardControl.frame;
    frame.origin.y = CGRectGetMinY(self.rewindControl.frame);
    frame.origin.x = CGRectGetMaxX(self.playPauseControl.frame);
    self.forwardControl.frame = frame;
//    self.rewindControl.hidden = !displaySkipButtons;
    self.forwardControl.enabled = !displaySkipButtons;
       
    
    frame = self.volumeControl.frame;
    frame.origin.x = CGRectGetMaxX(self.forwardControl.frame);
    frame.origin.y = CGRectGetMinY(self.rewindControl.frame);
    self.volumeControl.frame = frame;
    
    NSLog(@"the volumeControl orgX = %f, orgY = %f, widht = %f, heigh = %f", CGRectGetMinX(self.volumeControl.frame), CGRectGetMinY(self.volumeControl.frame), CGRectGetWidth(self.volumeControl.frame), CGRectGetHeight(self.volumeControl.frame));
    
    // volume right-aligned in first row
//    self.volumeControl.frame = CGRectMake(width + self.bottomControlsView.frame.origin.x - controlWidth - outerPadding, self.bottomControlsView.frame.origin.y + topY, controlWidth, controlHeight);
//    // airplay left-aligned
    
    frame = self.airPlayControlContainer.frame;
    frame.origin.x = CGRectGetMaxX(self.volumeControl.frame);
    self.airPlayControlContainer.frame = frame;
    
    // next row of controls
    topY += controlHeight + 5.f;
    
}
- (void)layoutTopControlsViewButtons {
    CGFloat maxX = 0.f;
    CGFloat height = [self topControlsViewHeightForControlStyle:self.controlStyle];
    
    for (UIView *button in self.topControlsButtons) {
        button.frame = CGRectMake(maxX, 0.f, button.frame.size.width, height);
        maxX = button.frame.origin.x + button.frame.size.width + self.topControlsViewButtonPadding;
    }
    
    maxX -= self.topControlsViewButtonPadding;
    self.topControlsContainerView.frame = CGRectMake(0.f, 0.f, maxX, height);
}

@end
