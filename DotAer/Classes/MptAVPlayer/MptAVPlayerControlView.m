//
//  MptAVPlayerControlView.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerControlView.h"

#import "MptAVPlayerControlView+MptPrivate.h"
#import "MptAVPlayerControlActionDelegate.h"
#import "MptAVPlayerFunctions.h"
#import "MptAVPlayerLayout.h"
#import "MptVolumeControl.h"
#import "MptScrubber.h"


#define kButtomBtWidht 40
#define kButtomBtHeigh 40


static NSString *AirPlayAvailabilityChanged = @"AirPlayAvailabilityChanged";
static NSString *AirPlayAlpha = @"alpha";

@interface MptAVPlayerControlView ()<MptVolumeDelegate> {
    BOOL _statusBarHidden;
    BOOL _isAirPlayAvailable;
}

@property (nonatomic, readonly, getter = isPlayingLivestream) BOOL playingLivestream;

// Properties from NGMoviePlayerControlView+NGPrivate


@property (nonatomic, retain) MptAVPlayerLayout *layout;
@property (nonatomic, retain, readwrite) UIView *topControlsView;
@property (nonatomic, retain, readwrite) UIView *bottomControlsView;
@property (nonatomic, retain, readwrite) UIView *topControlsContainerView;
@property (nonatomic, retain, readwrite) UIImageView *buttomControlsContainerView;

@property (nonatomic, retain, readwrite) MptScrubber *scrubberControl;
@property (nonatomic, retain, readwrite) UILabel *currentTimeLabel;
@property (nonatomic, retain, readwrite) UILabel *totalTimeLabel;

@property (nonatomic, retain, readwrite) UIButton *playPauseControl;
@property (nonatomic, retain, readwrite) UIButton *rewindControl;
@property (nonatomic, retain, readwrite) UIButton *forwardControl;
@property (nonatomic, retain, readwrite) MptVolumeControl *volumeControl;
@property (nonatomic, retain, readwrite) UIControl *airPlayControlContainer;
@property (nonatomic, retain, readwrite) MPVolumeView *airPlayControl;
@property (nonatomic, retain, readwrite) UIButton *dismissControl;
@property (nonatomic, retain, readwrite) UILabel *videoTitle;
@property (nonatomic, retain, readwrite) UIButton *zoomControl;

@property (nonatomic, retain) UIButton *airplayButton;

@end


@implementation MptAVPlayerControlView
@synthesize delegate;
@synthesize layout = _layout;
@synthesize topControlsView = _topControlsView;
@synthesize bottomControlsView = _bottomControlsView;
@synthesize topControlsContainerView = _topControlsContainerView;
@synthesize buttomControlsContainerView = _buttomControlsContainerView;
@synthesize scrubberControl = _scrubberControl;
@synthesize currentTimeLabel = _currentTimeLabel;
@synthesize totalTimeLabel = _totalTimeLabel;
@synthesize playPauseControl = _playPauseControl;
@synthesize rewindControl = _rewindControl;
@synthesize forwardControl = _forwardControl;
@synthesize airPlayControlContainer = _airPlayControlContainer;
@synthesize airPlayControl = _airPlayControl;
@synthesize dismissControl = _dismissControl;
@synthesize videoTitle = _videoTitle;
@synthesize zoomControl = _zoomControl;
@synthesize volumeControl = _volumeControl;
@synthesize airplayButton;
@synthesize mptControlAble = _mptControlAble;

- (void)dealloc
{
    [self.airplayButton removeObserver:self forKeyPath:AirPlayAlpha];
    self.delegate = nil;
    MptSafeRelease(_layout);
    MptSafeRelease(_topControlsView);
    MptSafeRelease(_bottomControlsView);
    MptSafeRelease(_topControlsContainerView);
    MptSafeRelease(_buttomControlsContainerView);
    MptSafeRelease(_scrubberControl);
    MptSafeRelease(_currentTimeLabel);
    MptSafeRelease(_totalTimeLabel);
    MptSafeRelease(_videoTitle);
    _playPauseControl = nil;
    _rewindControl = nil;
    _forwardControl = nil;
    _zoomControl = nil;
    _dismissControl = nil;
    MptSafeRelease(_airPlayControl);
    MptSafeRelease(_airPlayControlContainer);
    _volumeControl.delegate = nil;
    MptSafeRelease(_volumeControl);
    [super dealloc];

}

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _mptControlAble = NO; //defalut is NO;
        
        
        _topControlsView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topControlsView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        _topControlsView.userInteractionEnabled = YES;
        _topControlsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_topControlsView];
        
        _topControlsContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _topControlsContainerView.backgroundColor = [UIColor clearColor];
        [_topControlsView addSubview:_topControlsContainerView];
        
        _bottomControlsView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomControlsView.userInteractionEnabled = YES;
        _bottomControlsView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomControlsView];
        
        _buttomControlsContainerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _buttomControlsContainerView.backgroundColor = [UIColor clearColor];
        _buttomControlsContainerView.userInteractionEnabled = YES;
        [_bottomControlsView addSubview:_buttomControlsContainerView];

        
        // volume control needs to get added to self instead of bottomControlView because otherwise the expanded slider
        // doesn't receive any touch events
        
        _scrubberControl = [[MptScrubber alloc] initWithFrame:CGRectZero];
        _scrubberControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_scrubberControl addTarget:self action:@selector(handleBeginScrubbing:) forControlEvents:UIControlEventTouchDown];
        [_scrubberControl addTarget:self action:@selector(handleScrubbingValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_scrubberControl addTarget:self action:@selector(handleEndScrubbing:) forControlEvents:UIControlEventTouchUpInside];
        [_scrubberControl addTarget:self action:@selector(handleEndScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
        [_bottomControlsView addSubview:_scrubberControl];
    
        /******* leave for time on view *******/
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.shadowColor = [UIColor blackColor];
        _currentTimeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        _currentTimeLabel.font = [UIFont boldSystemFontOfSize:13.];
        _currentTimeLabel.textAlignment = UITextAlignmentRight;
        _currentTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_bottomControlsView addSubview:_currentTimeLabel];
        
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.shadowColor = [UIColor blackColor];
        _totalTimeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        _totalTimeLabel.font = [UIFont boldSystemFontOfSize:13.];
        _totalTimeLabel.textAlignment = UITextAlignmentLeft;
        _totalTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_bottomControlsView addSubview:_totalTimeLabel];
        
        
        
        _playPauseControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseControl.frame = CGRectMake(0.f, 0.f, 40, kButtomBtHeigh);
        _playPauseControl.contentMode = UIViewContentModeCenter;
        _playPauseControl.showsTouchWhenHighlighted = YES;
        _playPauseControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_playPauseControl addTarget:self action:@selector(handlePlayPauseButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_buttomControlsContainerView addSubview:_playPauseControl];
        _playPauseControl.backgroundColor = [UIColor clearColor];
        
        
        _rewindControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _rewindControl.frame = CGRectMake(95.f, 0.f, 40, kButtomBtHeigh);
        _rewindControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _rewindControl.showsTouchWhenHighlighted = YES;
        [_rewindControl setImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/prevtrack"] forState:UIControlStateNormal];
        [_rewindControl addTarget:self action:@selector(handleRewindButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_rewindControl addTarget:self action:@selector(handleRewindButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_rewindControl addTarget:self action:@selector(handleRewindButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
//        [_bottomControlsView addSubview:_rewindControl];

        
        _forwardControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwardControl.frame = CGRectMake(95.f, 0.f, 40, kButtomBtHeigh);
        _forwardControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _forwardControl.showsTouchWhenHighlighted = YES;
        [_forwardControl setImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/nexttrack"] forState:UIControlStateNormal];
        [_forwardControl addTarget:self action:@selector(handleForwardButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_forwardControl addTarget:self action:@selector(handleForwardButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_forwardControl addTarget:self action:@selector(handleForwardButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [_buttomControlsContainerView addSubview:_forwardControl];
        
        
        
        _volumeControl = [[MptVolumeControl alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        _volumeControl.delegate = self;
        _volumeControl.backgroundColor = [UIColor clearColor];
        [_buttomControlsContainerView addSubview:_volumeControl];
        
        // We use the MPVolumeView just for displaying the AirPlay icon
        _isAirPlayAvailable = FALSE;
        if ([AVPlayer instancesRespondToSelector:@selector(allowsAirPlayVideo)]) {
            _airPlayControl = [[MPVolumeView alloc] initWithFrame:(CGRect) { .size = CGSizeMake(50.f, 50.f) }];
            _airPlayControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
            
            _isAirPlayAvailable = FALSE;
    
            for (UIButton *button in _airPlayControl.subviews) {
                if ([button isKindOfClass:[UIButton class]]) {
                    self.airplayButton = button; // @property retain
                    [self.airplayButton setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_airplay"] forState:UIControlStateNormal];
                    [self.airplayButton setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_airplay_hilight"] forState:UIControlStateHighlighted];
                    [self.airplayButton setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_airplay_hilight"] forState:UIControlStateSelected];
                    [self.airplayButton setBounds:CGRectMake(0, 0, 40, kButtomBtn_H)];
                    [self.airplayButton addObserver:self forKeyPath:AirPlayAlpha options:NSKeyValueObservingOptionNew context:nil];
                    [self.airplayButton setBackgroundColor:[UIColor clearColor]];
                    [self.airplayButton sizeToFit];
                }
            }
          [_airPlayControl sizeToFit];
            
            _airPlayControl.contentMode = UIViewContentModeCenter;
            _airPlayControl.showsRouteButton = YES;
            _airPlayControl.showsVolumeSlider = NO;
            
            _airPlayControlContainer = [[UIControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 75, kButtomBtn_H)];
            _airPlayControlContainer.backgroundColor = [UIColor clearColor];
           
            [_airPlayControlContainer addTarget:self action:@selector(handleAirPlayButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [_airPlayControlContainer addSubview:_airPlayControl];
            [_buttomControlsContainerView addSubview:_airPlayControlContainer];
        }

        

        _dismissControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissControl.showsTouchWhenHighlighted = YES;
        _dismissControl.frame = (CGRect) { .size = CGSizeMake(60.f, 40.f) };
        _dismissControl.contentMode = UIViewContentModeCenter;
        [_dismissControl setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_back"] forState:UIControlStateNormal];
        [_dismissControl addTarget:self action:@selector(handleBackButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_topControlsView addSubview:_dismissControl];
        
        
        _videoTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _videoTitle.backgroundColor = [UIColor clearColor];
        _videoTitle.textColor = [UIColor whiteColor];
        _videoTitle.shadowColor = [UIColor blackColor];
        _videoTitle.shadowOffset = CGSizeMake(0.f, 1.f);
        _videoTitle.font = [UIFont boldSystemFontOfSize:15.];
        _videoTitle.textAlignment = UITextAlignmentCenter;
        _videoTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_topControlsView addSubview:_videoTitle];
        
        
//        _zoomControl = [UIButton buttonWithType:UIButtonTypeCustom];
//        _zoomControl.showsTouchWhenHighlighted = YES;
//        _zoomControl.contentMode = UIViewContentModeCenter;
//        _zoomControl.frame = CGRectMake(0, 0, 60, 40);
//        [_zoomControl addTarget:self action:@selector(handleZoomButtonPress:) forControlEvents:UIControlEventTouchUpInside];
//         UIImage *zoomButtonImage = [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_zoom_out"];
//        [_zoomControl setImage:zoomButtonImage forState:UIControlStateNormal];
//        [_topControlsView addSubview:_zoomControl];
    
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        _controlStyle = MptAVPlayerControlStyleFullscreen;
        _scrubbingTimeDisplay = MptAVPlayerControlScrubbingTimeDisplayPopup;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)setAlpha:(CGFloat)alpha {
    // otherwise the airPlayButton isn't positioned correctly on first show-up
    if (alpha > 0.f) {
        [self setNeedsLayout];
    }
    
    [super setAlpha:alpha];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.layout layoutTopControlsViewWithControlStyle:self.controlStyle];
    [self.layout layoutBottomControlsViewWithControlStyle:self.controlStyle];
    [self.layout layoutControlsWithControlStyle:self.controlStyle AirplayAvailable:_isAirPlayAvailable];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL insideTopControlsView = CGRectContainsPoint(self.topControlsView.frame, point);
    BOOL insideBottomControlsView = CGRectContainsPoint(self.bottomControlsView.frame, point);
    
    return  insideTopControlsView || insideBottomControlsView;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayerControlView
////////////////////////////////////////////////////////////////////////
- (void)setMptControlAble:(BOOL)value{
    if (_mptControlAble == value) {
        return;
    }
    _mptControlAble = value;
}



- (void)setControlStyle:(MptAVPlayerControlStyle)controlStyle {
    _controlStyle = controlStyle;
    [self.layout updateControlStyle:controlStyle];
}

- (void)setLayout:(MptAVPlayerLayout *)layout {
    if (layout != _layout) {
        [_layout release]; _layout = nil;
        _layout = [layout retain];
    }
    
    [layout updateControlStyle:self.controlStyle];
}

- (void)setScrubbingTimeDisplay:(MptAVPlayerControlScrubbingTimeDisplay)scrubbingTimeDisplay {
    if (scrubbingTimeDisplay != _scrubbingTimeDisplay) {
        _scrubbingTimeDisplay = scrubbingTimeDisplay;
       
        self.scrubberControl.showPopupDuringScrubbing = (scrubbingTimeDisplay == MptAVPlayerControlScrubbingTimeDisplayPopup);
    }
}
/****** this way for play progress *******/

- (void)setPlayableDuration:(NSTimeInterval)playableDuration {
    self.scrubberControl.playableValue = playableDuration;
}

- (NSTimeInterval)playableDuration {
    return self.scrubberControl.playableValue;
}

- (void)updateScrubberWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    self.currentTimeLabel.text = MptAVPlayerGetTimeFormatted(currentTime);
    self.totalTimeLabel.text = MptAVPlayerGetRemainingTimeFormatted(currentTime, duration);
    
    [self.scrubberControl setMinimumValue:0.];
    [self.scrubberControl setMaximumValue:duration];
    [self.scrubberControl setValue:currentTime];
}

- (void)updateButtonsWithPlaybackStatus:(BOOL)isPlaying {
    UIImage *image = nil;
    
    if (self.controlStyle == MptAVPlayerControlStyleInline) {
        image = isPlaying ? [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_pause"] : [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_play"];
    } else {
        image = isPlaying ? [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_pause"] : [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_play"];
    }
    
    [self.playPauseControl setImage:image forState:UIControlStateNormal];
}

- (void)updateZoomWithVideoGravity:(MptAVPlayerVideoGravity)videoGravity
{
    UIImage *image = nil;

    if (videoGravity == MptAVPlayerVideoGravityResize) {
        image = [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_zoom_out"];
    }else if(videoGravity == MptAVPlayerVideoGravityResizeAspectFill){
        image = [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_zoom_in"];
    }
    [_zoomControl setImage:image forState:UIControlStateNormal];
}

- (void)updateButtonsWithPlayBufferEnable:(BOOL)playAble{ //update button state when play can play,sometimes the buffer is empty
    
    [self updateButtonsWithPlaybackStatus:playAble];
    
    if (playAble) {
        _rewindControl.enabled = YES;
        _forwardControl.enabled = YES;
        _playPauseControl.enabled = YES;
    }else{
        _rewindControl.enabled = NO;
        _forwardControl.enabled = NO;
        _playPauseControl.enabled = NO;
    }
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)handlePlayPauseButtonPress:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionTogglePlayPause];
}

- (void)handleRewindButtonTouchDown:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionBeginSkippingBackwards];
}

- (void)handleRewindButtonTouchUp:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionEndSkipping];
}

- (void)handleForwardButtonTouchDown:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionBeginSkippingForwards];
}

- (void)handleForwardButtonTouchUp:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionEndSkipping];
}

- (void)handleOttConnectButtonPress:(id)sender{
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionOttConnect];
}

- (void)handleBackButtonPress:(id)sender{
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionDismiss];
}

- (void)handleZoomButtonPress:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionToggleZoomState];
}

- (void)handleBeginScrubbing:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionBeginScrubbing];
}

- (void)handleScrubbingValueChanged:(id)sender {
    if (self.scrubbingTimeDisplay == MptAVPlayerControlScrubbingTimeDisplayCurrentTime) {
        self.currentTimeLabel.text = MptAVPlayerGetTimeFormatted(self.scrubberControl.value);
        self.totalTimeLabel.text = MptAVPlayerGetRemainingTimeFormatted(self.scrubberControl.value, self.scrubberControl.maximumValue);
    }
    
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionScrubbingValueChanged];
}

- (void)handleEndScrubbing:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionEndScrubbing];
}

- (void)handleVolumeChanged:(id)sender {
    [self.delegate moviePlayerControl:sender didPerformAction:MptAVPlayerControlActionVolumeChanged];
}

- (void)handleAirPlayButtonPress:(id)sender {
    // forward touch event to airPlay-button
    for (UIView *subview in self.airPlayControl.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [self.delegate moviePlayerControl:self.airPlayControl didPerformAction:MptAVPlayerControlActionAirPlayMenuActivated];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![object isKindOfClass:[UIButton class]])
        return;
    
    if ([object isKindOfClass:[UIButton class]] && [[change valueForKey:NSKeyValueChangeNewKey] intValue] == 1) {
     
        [(UIButton *)object setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_airplay"] forState:UIControlStateNormal];
        [(UIButton *)object setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_airplay_hilight"] forState:UIControlStateHighlighted];
        [(UIButton *)object setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_airplay_hilight"] forState:UIControlStateSelected];
        [(UIButton *)object setBounds:CGRectMake(0, 0, 40, 50)];
    }

    BOOL isNowAvailable = [[change valueForKey:NSKeyValueChangeNewKey] floatValue] == 1;
    if ( isNowAvailable != _isAirPlayAvailable )
    {
        _isAirPlayAvailable = isNowAvailable;
//       [self.layout layoutControlsWithControlStyle:self.controlStyle AirplayAvailable:_isAirPlayAvailable];
    }
}

#pragma mark volumeDelegate
- (void)mptVolume:(MptVolumeControl *)volume Option:(MptVolumeType)type
{
    if (type == MptVolumChange) {
        [self.delegate moviePlayerControl:volume didPerformAction:MptAVPlayerControlActionVolumeChanged];
    }
}

@end
