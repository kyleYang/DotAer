//
//  NGMoviePlayerDefaultLayout.m
//  NGMoviePlayer
//
//  Created by Matthias Tretter on 10.09.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGMoviePlayerDefaultLayout.h"
#import "NGScrubber.h"
#import "NGVolumeControl.h"
#import "NGMoviePlayer.h"
#import "NGMoviePlayerView.h"
#import "HumDotaUserCenterOps.h"
#import "Video.h"

#define kMinWidthToDisplaySkipButtons          420.f
#define kControlWidth                          (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 44.f : 50.f)
#define kControlFullWidth (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 64.f : 80.f)

#define kSettingWidth (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 80.f : 80.f)
#define kSettingHeigh (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 120.f : 80.f)

@interface NGMoviePlayerDefaultLayout () {
    NSMutableArray *_topControlsButtons;
}

@property (nonatomic, readonly) UIImage *bottomControlFullscreenImage;

@end


@implementation NGMoviePlayerDefaultLayout

@synthesize bottomControlFullscreenImage = _bottomControlFullscreenImage;

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)init {
    if ((self = [super init])) {
        _scrubberFillColor = [UIColor grayColor];
        _minWidthToDisplaySkipButtons = kMinWidthToDisplaySkipButtons;

        _topControlsButtons = [NSMutableArray array];
        _topControlsViewAlignment = NGMoviePlayerControlViewTopControlsViewAlignmentCenter;
        _zoomOutButtonPosition = NGMoviePlayerControlViewZoomOutButtonPositionLeft;
        _topControlsViewButtonPadding = 35.f;
    }

    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayerLayout
////////////////////////////////////////////////////////////////////////

- (void)customizeTopControlsViewWithControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    // do nothing special here
}

- (void)customizeBottomControlsViewWithControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    // update styling of bottom controls view
    UIImageView *bottomControlsImageView = (UIImageView *)self.bottomControlsView;

    if (controlStyle == NGMoviePlayerControlStyleFullscreen) {
        bottomControlsImageView.backgroundColor = [UIColor clearColor];
        bottomControlsImageView.image = self.bottomControlFullscreenImage;
    } else if (controlStyle == NGMoviePlayerControlStyleInline) {
        bottomControlsImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        bottomControlsImageView.image = nil;
    }
}

- (void)customizeControlsWithControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    [self setupScrubber:self.scrubberControl controlStyle:controlStyle];
}

- (void)layoutTopControlsViewWithControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    CGFloat topControlsViewTop = 0.f;
    
    CGSize windowSize = self.moviePlayer.view.window.bounds.size;
    CGSize playerViewSize = self.moviePlayer.view.frame.size;
    CGSize playerViewInvertedSize = CGSizeMake(playerViewSize.height, playerViewSize.width);
    if (CGSizeEqualToSize(windowSize, playerViewSize) || CGSizeEqualToSize(windowSize, playerViewInvertedSize)) {
        topControlsViewTop = 20.f; //change by kyle yang on 27 6 2013
    }

    self.topControlsView.frame = CGRectMake(0.f,
                                            topControlsViewTop,
                                            self.width,
                                            [self topControlsViewHeightForControlStyle:controlStyle]);

    if (self.topControlsViewAlignment == NGMoviePlayerControlViewTopControlsViewAlignmentCenter) {
        // center custom controls in top container
        self.topControlsContainerView.frame = CGRectMake(MAX((self.topControlsView.frame.size.width - self.topControlsContainerView.frame.size.width)/2.f, 0.f),
                                                         topControlsViewTop,
                                                         self.topControlsContainerView.frame.size.width,
                                                         [self topControlsViewHeightForControlStyle:controlStyle]);
    } else {
        self.topControlsContainerView.frame = CGRectMake(2.f,
                                                         topControlsViewTop,
                                                         self.topControlsContainerView.frame.size.width,
                                                         [self topControlsViewHeightForControlStyle:controlStyle]);
    }
}

- (void)layoutBottomControlsViewWithControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    CGFloat controlsViewHeight = [self bottomControlsViewHeightForControlStyle:controlStyle];
    CGFloat offset = (self.controlStyle == NGMoviePlayerControlStyleFullscreen ? 0.f : 0.f);

    self.bottomControlsView.frame = CGRectMake(offset,
                                               self.height-controlsViewHeight,
                                               self.width - 2.f*offset,
                                               controlsViewHeight-offset);
}

- (void)layoutControlsWithControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    if (controlStyle == NGMoviePlayerControlStyleInline) {
        [self layoutSubviewsForControlStyleInline];
    } else {
        [self layoutSubviewsForControlStyleFullscreen];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayerDefaultLayout
////////////////////////////////////////////////////////////////////////

- (void)setScrubberFillColor:(UIColor *)scrubberFillColor {
    self.scrubberControl.fillColor = scrubberFillColor;
    self.volumeControl.minimumTrackColor = scrubberFillColor;

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

- (CGFloat)topControlsViewHeightForControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    if (controlStyle == NGMoviePlayerControlStyleFullscreen) {
        return 32.f;
    } else {
        return 44.f;
    }

}

- (CGFloat)bottomControlsViewHeightForControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    if (controlStyle == NGMoviePlayerControlStyleFullscreen) {
        return 62.f;
    } else {
        return 40.f;
    }
}



////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupScrubber:(NGScrubber *)scrubber controlStyle:(NGMoviePlayerControlStyle)controlStyle {
    CGFloat height = 8.f;
    CGFloat radius = 4.f;

    if (controlStyle == NGMoviePlayerControlStyleFullscreen) {
        [scrubber setThumbImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/scrubberKnobFullscreen"]
                       forState:UIControlStateNormal];
    } else {
        radius = 2.f;
        height = 5.f;

        [scrubber setThumbImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/scrubberKnob"]
                       forState:UIControlStateNormal];
    }

    //Build a roundedRect of appropriate size at origin 0,0
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, 0.f, height, height) cornerRadius:radius];
    //Color for Stroke
    CGColorRef strokeColor = [[UIColor grayColor] CGColor];

    
    // create minimum track image
    UIGraphicsBeginImageContext(CGSizeMake(height, height));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, [UIColor colorWithRed:40.0f/255.0f green:137.0f/255.0f blue:230.0f/255.0f alpha:1.0f].CGColor);
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
    CGContextSetFillColorWithColor(currentContext, [UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:81.0f/255.0f alpha:.7f].CGColor);
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

    if (controlStyle == NGMoviePlayerControlStyleFullscreen) {
        scrubber.playableValueRoundedRectRadius = radius;
    } else {
        scrubber.playableValueRoundedRectRadius = 2.f;
    }

    // force re-draw of playable value of scrubber
    scrubber.playableValue = scrubber.playableValue;
}

- (UIImage *)bottomControlFullscreenImage {
    if (_bottomControlFullscreenImage == nil) {
        _bottomControlFullscreenImage = [UIImage imageNamed:@"NGMoviePlayer.bundle/fullscreen-hud"];

        // make it a resizable image
        if ([_bottomControlFullscreenImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            _bottomControlFullscreenImage = [_bottomControlFullscreenImage resizableImageWithCapInsets:UIEdgeInsetsMake(48.f, 15.f, 46.f, 15.f)];
        } else {
            _bottomControlFullscreenImage = [_bottomControlFullscreenImage stretchableImageWithLeftCapWidth:15 topCapHeight:47];
        }
    }

    return _bottomControlFullscreenImage;
}

- (void)layoutSubviewsForControlStyleInline {
    CGFloat width = self.width;
    CGFloat controlsViewHeight = [self bottomControlsViewHeightForControlStyle:self.controlStyle];
    CGFloat leftEdge = 0.f;
    CGFloat rightEdge = width;   // the right edge of the last positioned button in the bottom controls view (starting from right)

    // skip buttons always hidden in inline mode
    self.rewindControl.hidden = YES;
    self.forwardControl.hidden = YES;

    // play button always on the left
    self.playPauseControl.frame = CGRectMake(0.f, 0.f, kControlWidth, controlsViewHeight);
    leftEdge = self.playPauseControl.frame.origin.x + self.playPauseControl.frame.size.width;

    // volume control and zoom button are always on the right
    self.zoomControl.frame = CGRectMake(width-kControlWidth, 0.f, kControlWidth, controlsViewHeight);
    [self.zoomControl setImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/zoomIn"] forState:UIControlStateNormal];
    
    self.videoTitle.hidden = YES;
    self.settingControl.hidden = YES;
    self.settingControlsView.hidden = YES;

//    self.volumeControl.frame = CGRectMake(rightEdge-kControlWidth, self.height-controlsViewHeight, kControlWidth, controlsViewHeight);
    self.volumeControl.hidden = YES;
    rightEdge = self.volumeControl.frame.origin.x;

    // we always position the airplay button, but only update the left edge when the button is visible
    // this is a workaround for a layout bug I can't remember
//    self.airPlayControlContainer.frame = CGRectMake(rightEdge-kControlWidth, 0.f, kControlWidth, controlsViewHeight);
//    if (self.airPlayControlVisible) {
//        rightEdge = self.airPlayControlContainer.frame.origin.x;
//    }
    
    self.scrubberControl.frame = CGRectMake(CGRectGetMaxX(self.playPauseControl.frame), 7.f, width-CGRectGetMaxX(self.playPauseControl.frame)-20, 15);

    self.remainingTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.scrubberControl.frame) - 55.f + 10.0f, CGRectGetMaxY(self.scrubberControl.frame), 55.f, 15.f);
    self.remainingTimeLabel.font = [UIFont boldSystemFontOfSize:11.];
    self.remainingTimeLabel.textAlignment = UITextAlignmentLeft;
    
    self.currentTimeLabel.frame = CGRectMake(CGRectGetMinX(self.remainingTimeLabel.frame)-55.0f, CGRectGetMinY(self.remainingTimeLabel.frame), 55.f, CGRectGetHeight(self.remainingTimeLabel.frame));
    self.currentTimeLabel.font = [UIFont boldSystemFontOfSize:11.];
    self.currentTimeLabel.textAlignment = UITextAlignmentRight;


    // scrubber uses remaining width
    
}

- (void)layoutSubviewsForControlStyleFullscreen {
    BOOL displaySkipButtons = !self.skipButtonsHidden && !self.playingLivestream && (self.bottomControlsView.frame.size.width > self.minWidthToDisplaySkipButtons);
    CGFloat width = self.bottomControlsView.bounds.size.width;
    CGFloat outerPadding = UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 5.f : 10.f;
    CGFloat controlWidth = UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 44.f : 50.f;
    CGFloat offset = UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPhone ? 54.f : 66.f;
    CGFloat controlHeight = 44.f;
    CGFloat topY = 2.f;
    
    //layoutSubviewsForControlStyleFullscreen dismissControl onthe left and zoombutton hidden
  
    // zoom button can be left or right
    UIImage *zoomButtonImage = [UIImage imageNamed:@"NGMoviePlayer.bundle/zoomOut"];
    CGFloat zoomButtonWidth = MAX(zoomButtonImage.size.width, 50.f);
    [self.zoomControl setImage:zoomButtonImage forState:UIControlStateNormal];
    if (self.zoomOutButtonPosition == NGMoviePlayerControlViewZoomOutButtonPositionLeft) {
        self.zoomControl.frame = CGRectMake(0.f, 0.f, zoomButtonWidth, self.topControlsView.bounds.size.height);
    } else {
        self.zoomControl.frame = CGRectMake(self.width - zoomButtonWidth, 0.f, zoomButtonWidth, self.topControlsView.bounds.size.height);
    }
    
    CGRect rct = CGRectMake(CGRectGetMaxX(self.zoomControl.frame), CGRectGetMinY(self.zoomControl.frame), CGRectGetWidth(self.topControlsView.frame)-CGRectGetMaxX(self.zoomControl.frame)-CGRectGetWidth(self.settingControl.frame), CGRectGetHeight(self.topControlsContainerView.frame));
    self.videoTitle.frame = rct;
    self.videoTitle.hidden = NO;
    
    self.settingControl.hidden = NO;
    self.settingControl.frame = CGRectMake(self.width - 90, 0.f, 60, self.topControlsView.bounds.size.height);;
    int playStep = [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    NSString *vidoStep = @"";
    switch (playStep) {
        case VideoScreenNormal:
            vidoStep = NSLocalizedString(@"settin.video.qulity.one", nil);
            break;
        case VideoScreenClear:
            vidoStep = NSLocalizedString(@"settin.video.qulity.two", nil);
            break;
        case VideoScreenHD:
            vidoStep = NSLocalizedString(@"settin.video.qulity.three", nil);
            break;
            
        default:
            break;
    }
    [self.settingControl setTitle:vidoStep forState:UIControlStateNormal];

    
    self.settingControlsView.hidden = NO;
    self.settingControlsView.frame = CGRectMake(width-kSettingWidth, 120, kSettingWidth, kSettingHeigh);
   
    
    rct = self.downloadControl.frame;
    rct.origin.y = 5;
    rct.origin.x = 10;
    self.downloadControl.frame = rct;
    
    rct.origin.y = CGRectGetMaxY(self.downloadControl.frame)+5;
    self.airPlayControlContainer.frame = rct;

    // play/skip segment centered in first row
    CGFloat controlsViewHeight = [self bottomControlsViewHeightForControlStyle:self.controlStyle];
      self.playPauseControl.frame = CGRectMake(0.f, 0.f, kControlFullWidth, controlsViewHeight);
//    self.rewindControl.frame = CGRectOffset(self.playPauseControl.frame, -offset, 0.f);
//    self.forwardControl.frame = CGRectOffset(self.playPauseControl.frame, offset, 0.f);
//    self.rewindControl.hidden = !displaySkipButtons;
//    self.forwardControl.hidden = !displaySkipButtons;

    // volume right-aligned in first row
    self.volumeControl.hidden = NO;
    self.volumeControl.frame = CGRectMake(width-controlWidth-8.0f, self.height-controlHeight-8, controlWidth, controlHeight);
    // airplay left-aligned
    

    // next row of controls
    topY += controlHeight + 5.f;

    self.scrubberControl.frame = CGRectMake(CGRectGetMaxX(self.playPauseControl.frame) + 8.f, 15, width-CGRectGetMaxX(self.playPauseControl.frame)-CGRectGetWidth(self.volumeControl.frame) - 16.f, 20.f);
    
    self.remainingTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.scrubberControl.frame) - 55.f - outerPadding, CGRectGetMaxY(self.scrubberControl.frame)+3, 55.f, 20.f);
    self.remainingTimeLabel.font = [UIFont boldSystemFontOfSize:13.];
    self.remainingTimeLabel.textAlignment = UITextAlignmentLeft;
    
    self.currentTimeLabel.frame = CGRectMake(CGRectGetMinX(self.remainingTimeLabel.frame)-55.0f, CGRectGetMinY(self.remainingTimeLabel.frame), 55.f, CGRectGetHeight(self.remainingTimeLabel.frame));
    self.currentTimeLabel.font = [UIFont boldSystemFontOfSize:13.];
    self.currentTimeLabel.textAlignment = UITextAlignmentRight;
  
  
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
