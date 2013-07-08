//
//  MptAVPlayerView.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerView.h"
#import "MptAVPlayerLayerView.h"
#import "MptAVPlayerControlView.h"
#import "MptAVPlayerControlView+MptPrivate.h"
#import "MptAVPlayerPlaceholderView.h"
#import "MptAVPlayerControlActionDelegate.h"
#import "MptWeak.h"


#define kNGControlVisibilityDuration        5.

#define kReadyForDisplayKye @"readyForDisplay"

static void *mptPlayerLayerReadyForDisplayContext = &mptPlayerLayerReadyForDisplayContext;


@interface MptAVPlayerView () <UIGestureRecognizerDelegate> {
    BOOL _statusBarVisible;
    UIStatusBarStyle _statusBarStyle;
    BOOL _shouldHideControls;
}

@property (nonatomic, retain, readwrite) MptAVPlayerControlView *controlsView;  // re-defined as read/write
@property (nonatomic, retain) MptAVPlayerLayerView *playerLayerView;
@property (nonatomic, retain) UIWindow *externalWindow;
@property (nonatomic, retain) UIView *externalScreenPlaceholder;
@property (nonatomic, retain) UIView *videoOverlaySuperview;
@property (nonatomic, retain) NSString *deviceOutputType;
@property (nonatomic, retain) NSString *airplayDeviceName;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, readonly, getter = isAirPlayVideoActive) BOOL airPlayVideoActive;

@end



@implementation MptAVPlayerView
@synthesize delegate = _delegate;
@synthesize playerLayer = _playerLayer;
@synthesize controlsView = _controlsView;
@synthesize placeholderView = _placeholderView;
@synthesize controlsVisible = _controlsVisible;
@synthesize controlStyle = _controlStyle;
@synthesize topControlsViewHeight = _topControlsViewHeight;
@synthesize bottomControlsViewHeight = _bottomControlsViewHeight;
@synthesize screenState = _screenState;
@synthesize playerLayerView = _playerLayerView;
@synthesize externalWindow;
@synthesize externalScreenPlaceholder = _externalScreenPlaceholder;
@synthesize videoOverlaySuperview = _videoOverlaySuperview;
@synthesize airPlayVideoActive;
@synthesize videoGravity = _videoGravity;
@synthesize activityView;
@synthesize deviceOutputType;
@synthesize airplayDeviceName;
@synthesize name;


////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame name:@""];
}

- (id)initWithFrame:(CGRect)frame name:(NSString *)videoName{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.name = videoName;
        [self setup];
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    
    return self;
}

- (void)dealloc {
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[_playerLayerView layer];
    
    self.activityView = nil;
    
    [_placeholderView removeFromSuperview];
    [_placeholderView release]; _placeholderView = nil;
    [_playerLayerView removeFromSuperview];
    [_playerLayerView release]; _playerLayerView = nil;
    
    [playerLayer removeFromSuperlayer];
    [playerLayer removeObserver:self forKeyPath:kReadyForDisplayKye];
    
    [_externalScreenPlaceholder removeFromSuperview];
    [_externalScreenPlaceholder release]; _externalScreenPlaceholder = nil;
    [_videoOverlaySuperview removeFromSuperview];
    [_videoOverlaySuperview release]; _videoOverlaySuperview = nil;
    
    [_controlsView release]; _controlsView = nil;
    self.externalWindow = nil;
    self.deviceOutputType = nil;
    self.airplayDeviceName = nil;
    self.name = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
    
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject KVO
////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == mptPlayerLayerReadyForDisplayContext) {
        BOOL readyForDisplay = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        
        if (self.playerLayerView.layer.opacity == 0.f && readyForDisplay) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            
            animation.duration = kMptFadeDuration;
            animation.fromValue = [NSNumber numberWithFloat:0.];
            animation.toValue = [NSNumber numberWithFloat:1.];
            animation.removedOnCompletion = NO;
            
            self.playerLayerView.layer.opacity = 1.f;
            [self.playerLayerView.layer addAnimation:animation forKey:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        [self.playerLayer.player pause];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [self.playerLayer.player pause];
    }
    
    [super willMoveToWindow:newWindow];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayerView Properties
////////////////////////////////////////////////////////////////////////
- (void)setVideoGravity:(MptAVPlayerVideoGravity)videoGravity
{
    if(_videoGravity != videoGravity){
        _videoGravity = videoGravity;
        self.playerLayer.videoGravity = MptAVLayerVideoGravityFromMptAVPlayerVideoGravity(videoGravity);
        // Hack: otherwise the video gravity doesn't change immediately
        self.playerLayer.bounds = self.playerLayer.bounds;
        [self.controlsView updateZoomWithVideoGravity:videoGravity];
        NSLog(@"the layer bounds is widht =%f, height = %f",CGRectGetWidth(self.playerLayer.bounds),CGRectGetHeight(self.playerLayer.bounds));
    }
    
}


- (void)setDelegate:(id<MptAVPlayerControlActionDelegate>)delegate {
    if (delegate != _delegate) {
        _delegate = delegate;
    }
    
    self.controlsView.delegate = _delegate;
}

- (void)setControlsVisible:(BOOL)controlsVisible {
    [self setControlsVisible:controlsVisible animated:NO];
}

- (void)setControlsVisible:(BOOL)controlsVisible animated:(BOOL)animated {
    if (controlsVisible) {
        [self bringSubviewToFront:self.controlsView];
    } else {
//        [self.controlsView.volumeControl setExpanded:NO animated:YES];
    }
    
    if (controlsVisible != _controlsVisible) {
        _controlsVisible = controlsVisible;
        
        NSTimeInterval duration = animated ? kMptFadeDuration : 0.;
        MptAVPlayerControlAction willAction = controlsVisible ? MptAVPlayerControlActionWillShowControls : MptAVPlayerControlActionWillHideControls;
        MptAVPlayerControlAction didAction = controlsVisible ? MptAVPlayerControlActionDidShowControls : MptAVPlayerControlActionDidHideControls;
        
        [self.delegate moviePlayerControl:self.controlsView didPerformAction:willAction];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
        // Doesn't work on device (doesn't fade but jumps from alpha 0 to 1) -> currently deactivated
        // rasterization fades out the view as a whole instead of setting alpha on each subview
        // it's similar to setting UIViewGroupOpacity, but only for this particular view
        // self.controlsView.scrubberControl.layer.shouldRasterize = YES;
        // self.controlsView.scrubberControl.layer.rasterizationScale = [UIScreen mainScreen].scale;
        __block MptAVPlayerView *weakSelf = self;
        [UIView animateWithDuration:duration
                              delay:0.
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.controlsView.alpha = controlsVisible ? 1.f : 0.f;
                         } completion:^(BOOL finished) {
                             [weakSelf restartFadeOutControlsViewTimer];
                             [weakSelf.delegate moviePlayerControl:weakSelf.controlsView didPerformAction:didAction];
                             
                             //self.controlsView.scrubberControl.layer.shouldRasterize = NO;
                         }];
        
        if (self.controlStyle == MptAVPlayerControlStyleFullscreen) {
            [[UIApplication sharedApplication] setStatusBarHidden:(!controlsVisible) withAnimation:UIStatusBarAnimationFade];
        }
    }
}
/******* ActivityView ********/
- (void)showActivityViewAnimated:(BOOL)animated{
    [self bringSubviewToFront:self.activityView];
    [self.controlsView updateButtonsWithPlayBufferEnable:NO];
    [self.activityView show:animated];
}

- (void)hideActivityViewAnimated:(BOOL)animated{
    [self sendSubviewToBack:self.activityView];
    [self.controlsView updateButtonsWithPlayBufferEnable:YES];
    [self.activityView hide:animated];
//    [self bringSubviewToFront:self.activityView];
//    [self.activityView show:animated];
}


/******* PlaceHoldView ********/

- (void)setPlaceholderView:(UIView *)placeholderView {
    if (placeholderView != _placeholderView) {
        [_placeholderView removeFromSuperview];
        [_placeholderView release];
        _placeholderView = nil;
        
        _placeholderView = [placeholderView retain];
        _placeholderView.frame = self.bounds;
        _placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_placeholderView];
    }
}

- (void)hidePlaceholderViewAnimated:(BOOL)animated {
    self.backgroundColor = [UIColor blackColor];
    __block MptAVPlayerView *weakSelf = self;
    if (animated) {
        [UIView animateWithDuration:kMptFadeDuration
                         animations:^{
                            weakSelf.placeholderView.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [weakSelf.placeholderView removeFromSuperview];
                         }];
    } else {
        [self.placeholderView removeFromSuperview];
    }
}

- (void)showPlaceholderViewAnimated:(BOOL)animated {
    if ([self.placeholderView isKindOfClass:[MptAVPlayerPlaceholderView class]]) {
        MptAVPlayerPlaceholderView *placeholderView = (MptAVPlayerPlaceholderView *)self.placeholderView;
        
        [placeholderView resetToInitialState];
    }
    
    if (animated) {
        self.placeholderView.alpha = 0.f;
        [self addSubview:self.placeholderView];
         __block MptAVPlayerView *weakSelf = self;
        [UIView animateWithDuration:kMptFadeDuration
                         animations:^{
                             weakSelf.placeholderView.alpha = 1.f;
                         }];
    } else {
        self.placeholderView.alpha = 1.f;
        [self addSubview:self.placeholderView];
    }
}

- (void)setControlStyle:(MptAVPlayerControlStyle)controlStyle {
    if (controlStyle != self.controlsView.controlStyle) {
        self.controlsView.controlStyle = controlStyle;
        [self.controlsView updateButtonsWithPlaybackStatus:self.playerLayer.player.rate > 0.f];
        
        BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        // hide status bar in fullscreen, restore to previous state
        if (controlStyle == MptAVPlayerControlStyleFullscreen) {
            [[UIApplication sharedApplication] setStatusBarStyle: (isIPad ? UIStatusBarStyleBlackOpaque : UIStatusBarStyleBlackTranslucent)];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
            [[UIApplication sharedApplication] setStatusBarHidden:!_statusBarVisible withAnimation:UIStatusBarAnimationFade];
        }
    }
    
    self.controlsVisible = NO;
}

- (MptAVPlayerControlStyle)controlStyle {
    return self.controlsView.controlStyle;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)[self.playerLayerView layer];
}

- (MptAVPlayerScreenState)screenState {
    if (self.externalWindow != nil) {
        return MptAVPlayerScreenStateExternal;
    } else if (self.airPlayVideoActive) {
        return MptAVPlayerScreenStateAirPlay;
    } else {
        return MptAVPlayerScreenStateDevice;
    }
}

- (UIView *)externalScreenPlaceholder {
    if(_externalScreenPlaceholder == nil) {
        BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        _externalScreenPlaceholder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_playerBackground"]];
        _externalScreenPlaceholder.userInteractionEnabled = YES;
        _externalScreenPlaceholder.frame = self.bounds;
        _externalScreenPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIView *externalScreenPlaceholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, (isIPad ? 280 : 140))];
        
        UIImageView *externalScreenPlaceholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(isIPad ? @"MptPlayer.bundle/iPhone/wildcatNoContentVideos@2x" : @"MptPlayer.bundle/iPhone/wildcatNoContentVideos")]];
        externalScreenPlaceholderImageView.frame = CGRectMake((320-externalScreenPlaceholderImageView.image.size.width)/2, 0, externalScreenPlaceholderImageView.image.size.width, externalScreenPlaceholderImageView.image.size.height);
        [externalScreenPlaceholderView addSubview:externalScreenPlaceholderImageView];
        [externalScreenPlaceholderImageView release];
        
        
        UILabel *externalScreenLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, externalScreenPlaceholderImageView.frame.size.height + (isIPad ? 15 : 5), 262, 30)];
        externalScreenLabel.font = [UIFont systemFontOfSize:(isIPad ? 26.0f : 20.0f)];
        externalScreenLabel.textAlignment = UITextAlignmentCenter;
        externalScreenLabel.backgroundColor = [UIColor clearColor];
        externalScreenLabel.textColor = [UIColor darkGrayColor];
        externalScreenLabel.text = self.airPlayVideoActive ? self.airplayDeviceName : @"VGA";
        [externalScreenPlaceholderView addSubview:externalScreenLabel];
        [externalScreenLabel release];
        
        UILabel *externalScreenDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, externalScreenLabel.frame.origin.y + (isIPad ? 35 : 20), 320, 30)];
        externalScreenDescriptionLabel.font = [UIFont systemFontOfSize:(isIPad ? 14.0f : 10.0f)];
        externalScreenDescriptionLabel.textAlignment = UITextAlignmentCenter;
        externalScreenDescriptionLabel.backgroundColor = [UIColor clearColor];
        externalScreenDescriptionLabel.textColor = [UIColor lightGrayColor];
        externalScreenDescriptionLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"player.playing.which.device", @"mptplayer",nil), externalScreenLabel.text];
        [externalScreenPlaceholderView addSubview:externalScreenDescriptionLabel];
        [externalScreenDescriptionLabel release];
        
        externalScreenPlaceholderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        externalScreenPlaceholderView.center = _externalScreenPlaceholder.center;
        
        [_externalScreenPlaceholder addSubview:externalScreenPlaceholderView];
        [externalScreenPlaceholderView release];
    }
    
    return _externalScreenPlaceholder;
}

- (CGFloat)topControlsViewHeight {
    return CGRectGetMaxY(self.controlsView.topControlsView.frame);
}

- (CGFloat)bottomControlsViewHeight {
    CGFloat height = CGRectGetHeight(self.controlsView.frame);
    
    return  height - CGRectGetMinY(self.controlsView.bottomControlsView.frame) + 2*(height - CGRectGetMaxY(self.controlsView.bottomControlsView.frame));
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayerView UI Update
////////////////////////////////////////////////////////////////////////

- (void)updateWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    NSLog(@"currentTime is %f",currentTime);
    if (!isnan(currentTime) && !isnan(duration)) {
        [self.controlsView updateScrubberWithCurrentTime:currentTime duration:duration];
    }
}

- (void)updateWithPlaybackStatus:(BOOL)isPlaying {
    [self.controlsView updateButtonsWithPlaybackStatus:isPlaying];
    
    _shouldHideControls = isPlaying;
}

- (void)addVideoOverlayView:(UIView *)overlayView {
    if (overlayView != nil) {
        if (_videoOverlaySuperview == nil) {
            UIView *superview = self.playerLayerView.superview;
            
            _videoOverlaySuperview = [[UIView alloc] initWithFrame:superview.bounds];
            _videoOverlaySuperview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [superview insertSubview:_videoOverlaySuperview aboveSubview:self.playerLayerView];
        }
        
        [self.videoOverlaySuperview addSubview:overlayView];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Controls
////////////////////////////////////////////////////////////////////////

- (void)stopFadeOutControlsViewTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
}

- (void)restartFadeOutControlsViewTimer {
    [self stopFadeOutControlsViewTimer];
    
    [self performSelector:@selector(fadeOutControls) withObject:nil afterDelay:kNGControlVisibilityDuration];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - External Screen (VGA)
////////////////////////////////////////////////////////////////////////

- (void)setupExternalWindowForScreen:(UIScreen *)screen {
    if (screen != nil) {
        self.externalWindow = [[[UIWindow alloc] initWithFrame:screen.applicationFrame] autorelease];
        self.externalWindow.hidden = NO;
        self.externalWindow.clipsToBounds = YES;
        
        if (screen.availableModes.count > 0) {
            UIScreenMode *desiredMode = [screen.availableModes objectAtIndex:screen.availableModes.count-1];
            screen.currentMode = desiredMode;
        }
        
        self.externalWindow.screen = screen;
        [self.externalWindow makeKeyAndVisible];
    } else {
        [self.externalWindow removeFromSuperview];
        [self.externalWindow resignKeyWindow];
        self.externalWindow.hidden = YES;
        self.externalWindow = nil;
    }
}

- (void)updateViewsForCurrentScreenState {
    [self positionViewsForState:self.screenState];
    
    [self setControlsVisible:NO];
    
    if (self.placeholderView.superview == nil) {
        int64_t delayInSeconds = 1.;
        __block MptAVPlayerView *weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf setControlsVisible:YES animated:YES];
        });
    }
}

- (void)positionViewsForState:(MptAVPlayerScreenState)screenState {
    UIView *viewBeneathOverlayViews = self.playerLayerView;
    
    switch (screenState) {
        case MptAVPlayerScreenStateExternal: {
            self.playerLayerView.frame = self.externalWindow.bounds;
            [self.externalWindow addSubview:self.playerLayerView];
            [self insertSubview:self.externalScreenPlaceholder belowSubview:self.placeholderView];
            viewBeneathOverlayViews = self.externalScreenPlaceholder;
            break;
        }
            
        case MptAVPlayerScreenStateAirPlay: {
            self.playerLayerView.frame = self.bounds;
            [self insertSubview:self.playerLayerView belowSubview:self.placeholderView];
            [self insertSubview:self.externalScreenPlaceholder belowSubview:self.placeholderView];
            viewBeneathOverlayViews = self.externalScreenPlaceholder;
            break;
        }
            
        case MptAVPlayerScreenStateDevice:
        default: {
            self.playerLayerView.frame = self.bounds;
            [self insertSubview:self.playerLayerView belowSubview:self.placeholderView];
            [self.externalScreenPlaceholder removeFromSuperview];
            self.externalScreenPlaceholder = nil;
            break;
        }
    }
    
    UIView *superview = self.playerLayerView.superview;
    
    self.videoOverlaySuperview.frame = self.playerLayerView.frame;
    [superview insertSubview:self.videoOverlaySuperview aboveSubview:viewBeneathOverlayViews];
    
    [self bringSubviewToFront:self.controlsView];
    [self bringSubviewToFront:self.placeholderView];
    [self bringSubviewToFront:self.activityView];
}

- (void)externalScreenDidConnect:(NSNotification *)notification {
    UIScreen *screen = [notification object];
    
    [self setupExternalWindowForScreen:screen];
    [self positionViewsForState:self.screenState];
}

- (void)externalScreenDidDisconnect:(NSNotification *)notification {
    [self setupExternalWindowForScreen:nil];
    [self positionViewsForState:self.screenState];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIGestureRecognizerDelegate
////////////////////////////////////////////////////////////////////////

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.controlsVisible || self.placeholderView.alpha > 0.f) {
        id playButton = nil;
        
        if (self.controlsView.explaned) {
            return NO;
        }
        
        if ([self.placeholderView respondsToSelector:@selector(playButton)]) {
            playButton = [self.placeholderView performSelector:@selector(playButton)];
        }
        
        // We here rely on the fact that nil terminates a list, because playButton can be nil
        // ATTENTION: DO NOT CONVERT THIS TO MODERN OBJC-SYNTAX @[]
        NSArray *controls = [NSArray arrayWithObjects:self.controlsView.topControlsView, self.controlsView.bottomControlsView, playButton, nil];
        
        // We dont want to to hide the controls when we tap em
        for (UIView *view in controls) {
            if ([view pointInside:[touch locationInView:view] withEvent:nil]) {
                return NO;
            }
        }
    }
    
    return YES;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setup {
    self.controlStyle = MptAVPlayerControlStyleInline;
    _controlsVisible = NO;
    _videoGravity = MptAVPlayerVideoGravityResizeAspect;
    
    _statusBarVisible = ![UIApplication sharedApplication].statusBarHidden;
    _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    // Player Layer
    _playerLayerView = [[MptAVPlayerLayerView alloc] initWithFrame:self.bounds];
    _playerLayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _playerLayerView.alpha = 0.f;
    
    [self.playerLayer addObserver:self
                       forKeyPath:kReadyForDisplayKye
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:mptPlayerLayerReadyForDisplayContext];
    
    // Controls
    _controlsView = [[MptAVPlayerControlView alloc] initWithFrame:self.bounds];
    _controlsView.alpha = 0.f;
    _controlsView.videoTitle.text = self.name;
    [self addSubview:_controlsView];
    
//    [_controlsView.volumeControl addTarget:self action:@selector(volumeControlValueChanged:) forControlEvents:UIControlEventValueChanged];
//    
    // Placeholder
    MptAVPlayerPlaceholderView *placeholderView = [[MptAVPlayerPlaceholderView alloc] initWithFrame:self.bounds];
    placeholderView.infoText = self.name;
    [placeholderView addBackButtonTarget:self action:@selector(handleBackButtonPress:)];
    
    [_placeholderView release]; _placeholderView = nil;
    _placeholderView = [placeholderView retain];
    [self addSubview:placeholderView];
    [placeholderView release];
    
    NSLog(@"the bouns width = %f heigh = %f ",CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds));
    
  
    self.activityView = [[[MBProgressHUD alloc] initWithView:self] autorelease];
    self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.activityView.mode = MBProgressHUDModeIndeterminate;
    self.activityView.animationType = MBProgressHUDAnimationZoom;
    self.activityView.screenType = MBProgressHUDSectionScreen;
    self.activityView.opacity = 0.5;
    self.activityView.labelText = NSLocalizedStringFromTable(@"player.loading.more", @"mptplayer",nil);
    [self  addSubview:self.activityView];
    [self.activityView hide:YES];
    
    // Gesture Recognizer for self
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    [doubleTapGestureRecognizer release];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    singleTapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
    
    // Gesture Recognizer for controlsView
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.delegate = self;
    [self.controlsView addGestureRecognizer:doubleTapGestureRecognizer];
    [doubleTapGestureRecognizer release];
    
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    singleTapGestureRecognizer.delegate = self;
    [self.controlsView addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
    
    // Check for external screen
    if ([UIScreen screens].count > 1) {
        for (UIScreen *screen in [UIScreen screens]) {
            if (screen != [UIScreen mainScreen]) {
                [self setupExternalWindowForScreen:screen];
                break;
            }
        }
        
        NSAssert(self.externalWindow != nil, @"External screen counldn't be determined, no window was created");
    }
    
    [self positionViewsForState:self.screenState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
}

- (void)fadeOutControls {
    if (_shouldHideControls && self.screenState == MptAVPlayerScreenStateDevice) {
        [self setControlsVisible:NO animated:YES];
    }
}

- (BOOL)isAirPlayVideoActive {
    if ([AVPlayer instancesRespondToSelector:@selector(isAirPlayVideoActive)]) {
        
        CFDictionaryRef currentRouteDescriptionDictionary = nil;
        UInt32 dataSize = sizeof(currentRouteDescriptionDictionary);
        AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &currentRouteDescriptionDictionary);
        
        self.deviceOutputType = nil;
        self.airplayDeviceName = nil;
        if(currentRouteDescriptionDictionary) {
            CFArrayRef outputs = CFDictionaryGetValue(currentRouteDescriptionDictionary, kAudioSession_AudioRouteKey_Outputs);
            if(outputs!=nil &&CFArrayGetCount(outputs) > 0) {
                CFDictionaryRef currentOutput = CFArrayGetValueAtIndex(outputs, 0);
                
                //Get the output type (will show airplay / hdmi etc
                CFStringRef outputType = CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
                
                //If you're using Apple TV as your ouput - this will get the name of it (Apple TV Kitchen) etc
                CFStringRef outputName = CFDictionaryGetValue(currentOutput, @"RouteDetailedDescription_Name");
                
                self.deviceOutputType = (NSString *)outputType;
                self.airplayDeviceName = (NSString *)outputName;
            }
        }
        
        return self.playerLayer.player.airPlayVideoActive;
    }
    
    return NO;
}



- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if ((tap.state & UIGestureRecognizerStateRecognized) == UIGestureRecognizerStateRecognized) {
        if (self.placeholderView.alpha == 0.f) {
            // Toggle control visibility on single tap
            [self setControlsVisible:!self.controlsVisible animated:YES];
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if ((tap.state & UIGestureRecognizerStateRecognized) == UIGestureRecognizerStateRecognized) {
        if (self.placeholderView.alpha == 0.f) {
            // Toggle video gravity on double tap
            self.playerLayer.videoGravity = MptAVLayerVideoGravityNext(self.playerLayer.videoGravity);
            // BUG: otherwise the video gravity doesn't change immediately
            self.playerLayer.bounds = self.playerLayer.bounds;
        }
    }
}

- (void)handlePlayButtonPress:(id)playControl {
    [self.delegate moviePlayerControl:playControl didPerformAction:MptAVPlayerControlActionStartToPlay];
}

- (void)handleBackButtonPress:(id)playControl {
    [_placeholderView removeFromSuperview];
    [_placeholderView release]; _placeholderView = nil;
    [self.delegate moviePlayerControl:playControl didPerformAction:MptAVPlayerControlActionDismiss];
}

- (void)volumeControlValueChanged:(id)sender {
    [self restartFadeOutControlsViewTimer];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.activityView.center = self.center;
}

@end
