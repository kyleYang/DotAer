//
//  MptAVPlayer.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayer.h"
#import "MptAVPlayerControlActionDelegate.h"
#import "MptAVPlayerControlView.h"
#import "MptAVPlayerLayout.h"
#import "MptAVPlayerView.h"
#import "MptAVPlayerControlView+MptPrivate.h"
#import "MptAVPlayerLayout+MptPrivate.h"
#import "MptAVPlayerLayerView.h"
#import "MptScrubber.h"


/* Asset keys */
NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";
NSString * const kDrautionKey        = @"duration";
NSString * const kPlaybackBufferEmpty = @"playbackBufferEmpty";
NSString * const kPlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp";

/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";
NSString * const kAirPlayVideoActiveKye =@"airPlayVideoActive";


#define kMptInitialTimeToSkip                    10.     // this value gets added the first time (seconds)
#define kMptepeatedTimeToSkipStartValue          5.     // this is the starting value the gets added repeatedly while user presses button (increases over time)
#define kMptDefaultSeekingToleranceTime           2.
#define kMptDefaultInitialPlaybackToleranceTime   1000.


@interface MptAVPlayer () <MptAVPlayerControlActionDelegate> {
    // flags for methods implemented in the delegate
    struct {
        unsigned int didStartPlayback:1;
        unsigned int didFailToLoad:1;
        unsigned int didFinishPlayback:1;
        unsigned int didPausePlayback:1;
        unsigned int didResumePlayback:1;
        
        unsigned int didBeginScrubbing:1;
        unsigned int didEndScrubbing:1;
        unsigned int didClickOtt:1;
        
        unsigned int didChangeStatus:1;
        unsigned int didChangePlaybackRate:1;
		unsigned int didChangeAirPlayActive:1;
        unsigned int didChangeControlStyle:1;
        unsigned int didUpdateCurrentTime:1;
	} _delegateFlags;
    
    BOOL _seekToInitialPlaybackTimeBeforePlay;
    float _rateToRestoreAfterScrubbing;
}

@property (nonatomic, retain, readwrite) AVPlayer *player;  // re-defined as read/write
@property (nonatomic, assign, readwrite, getter = isScrubbing) BOOL scrubbing; // re-defined as read/write
@property (nonatomic, retain) AVAsset *asset;
@property (nonatomic, retain) AVPlayerItem *playerItem;
@property (nonatomic, readonly) CMTime CMDuration;
@property (nonatomic, retain) id playerTimeObserver;

@property (nonatomic, assign) NSTimeInterval timeToSkip;
@property (nonatomic, mpt_weak) NSTimer *skippingTimer;
@property (nonatomic, mpt_weak) NSTimer *playableDurationTimer;


@end


static void *MptAVPlayerItemStatusContext = &MptAVPlayerItemStatusContext;
static void *MptAVPlayerItemBufferEmpty = &MptAVPlayerItemBufferEmpty;
static void *MptAVPlayerItemLikelyToKeepUp = &MptAVPlayerItemLikelyToKeepUp;
static void *MptAVPlayerItemDurationContext = &MptAVPlayerItemDurationContext;
static void *MptAVPlayerCurrentItemContext = &MptAVPlayerCurrentItemContext;
static void *MptAVPlayerRateContext = &MptAVPlayerRateContext;
static void *MptAVPlayerAirPlayVideoActiveContext = &MptAVPlayerAirPlayVideoActiveContext;


@implementation MptAVPlayer
@synthesize player = _player;
@synthesize view = _view;
@synthesize URL = _URL;
@synthesize delegate = _delegate;
@synthesize videoGravity = _videoGravity;
@synthesize playing,playingLivestream,scrubbing,airPlayEnabled = _airPlayEnabled,airPlayVideoActive = _airPlayVideoActive;
@synthesize autostartWhenReady = _autostartWhenReady;
@synthesize currentPlaybackTime = _currentPlaybackTime;
@synthesize duration = _duration;
@synthesize initialPlaybackTime = _initialPlaybackTime;
@synthesize initialPlaybackToleranceTime = _initialPlaybackToleranceTime;
@synthesize seekingToleranceTime = _seekingToleranceTime;

@synthesize asset = _asset;
@synthesize playerItem = _playerItem;
@synthesize CMDuration = _CMDuration;
@synthesize timeToSkip;
@synthesize skippingTimer = _skippingTimer;
@synthesize playableDurationTimer = _playableDurationTimer;
@synthesize mptControlAble = _mptControlAble;

- (void)dealloc {
    AVPlayer *player = _view.playerLayer.player;
    
    [_skippingTimer invalidate];
    _skippingTimer = nil;
    [_playableDurationTimer invalidate];
    _playableDurationTimer = nil;
    _delegate = nil;
   
    
    [self stopObservingPlayerTimeChanges];
    [player pause];
    
    [_URL release]; _URL = nil;
    self.asset = nil;
    self.name = nil;
    
    [self.player removeTimeObserver:self.playerTimeObserver];
    self.playerTimeObserver = nil;
    
    [player removeObserver:self forKeyPath:kRateKey];
    [player removeObserver:self forKeyPath:kCurrentItemKey];
	[_playerItem removeObserver:self forKeyPath:kStatusKey];
    [_playerItem removeObserver:self forKeyPath:kDrautionKey];
    [_playerItem removeObserver:self forKeyPath:kPlaybackBufferEmpty];
    [_playerItem removeObserver:self forKeyPath:kPlaybackLikelyToKeepUp];
    

    if ([AVPlayer instancesRespondToSelector:@selector(allowsAirPlayVideo)]) {
        [player removeObserver:self forKeyPath:kAirPlayVideoActiveKye];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:_playerItem];
     self.playerItem = nil;
    _view.playerLayer.player = nil;
    
    self.player = nil;
    _view.delegate = nil;
    _view.controlsView.delegate = nil;
    [_view removeFromSuperview];
    [_view release]; _view = nil;
    
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
////////////////////////////////////////////////////////////////////////

+ (void)setAudioSessionCategory:(MptAVPlayerAudioSessionCategory)audioSessionCategory {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:MptAVAudioSessionCategoryFromMptAVPlayerAudioSessionCategory(audioSessionCategory)
                                           error:&error];
    
    if (error != nil) {
        NSLog(@"There was an error setting the AudioCategory to AVAudioSessionCategoryPlayback");
    }
}

+ (void)initialize {
    if (self == [MptAVPlayer class]) {
        [self setAudioSessionCategory:MptAVPlayerAudioSessionCategoryPlayback];
    }
}


///////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime {
    return [self initWithURL:URL initialPlaybackTime:initialPlaybackTime name:@""];
}


- (id)initWithURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime name:(NSString *)videoName {
    if ((self = [super init])) {
        _autostartWhenReady = YES; //default is YES
        _mptControlAble = NO;//default is NO
        _seekToInitialPlaybackTimeBeforePlay = YES;
        _airPlayEnabled = [AVPlayer instancesRespondToSelector:@selector(allowsAirPlayVideo)];
        _rateToRestoreAfterScrubbing = 1.;
        _initialPlaybackTime = initialPlaybackTime;
        _seekingToleranceTime = kMptDefaultSeekingToleranceTime;
        _initialPlaybackToleranceTime = kMptDefaultInitialPlaybackToleranceTime;
        _videoGravity = MptAVPlayerVideoGravityResize;
        // calling setter here on purpose
        self.name = videoName; //must befor url,beacuse self.url can build many message
        self.URL = URL;
       
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL initialPlaybackTime:0.];
}

- (id)initWithURL:(NSURL *)URL name:(NSString *)videoName{
    return [self initWithURL:URL initialPlaybackTime:0. name:videoName];
}

- (id)init {
    return [self initWithURL:nil];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject KVO
////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == MptAVPlayerItemStatusContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerStatusUnknown: {
                [self stopObservingPlayerTimeChanges];
                [self.view updateWithCurrentTime:self.currentPlaybackTime duration:self.duration];
                if (_delegateFlags.didFailToLoad) {
                    //[self.delegate moviePlayer:self didFailToLoadURL:self.URL]; //some problem
                }
                break;
            }
                
            case AVPlayerStatusReadyToPlay: {
                // TODO: Enable buttons & scrubber
                if (!self.scrubbing) {
                    if (self.autostartWhenReady && self.view.superview != nil && [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        _autostartWhenReady = NO;
                        [self play];
                    }
                }
                
                break;
            }
                
            case AVPlayerStatusFailed: {
                [self stopObservingPlayerTimeChanges];
                [self.view updateWithCurrentTime:self.currentPlaybackTime duration:self.duration];
                // TODO: Disable buttons & scrubber
                break;
            }
        }
        
        [self.view updateWithPlaybackStatus:self.playing];
        
        if (_delegateFlags.didChangeStatus) {
            [self.delegate moviePlayer:self didChangeStatus:status];
        }  
    }else if(context == MptAVPlayerItemBufferEmpty){
        NSLog(@"the MptAVPlayerItemBufferEmpty is did");
        [self.view showActivityViewAnimated:YES];
        [self pause];
    }else if(context == MptAVPlayerItemLikelyToKeepUp){
        AVPlayerItem * item = (AVPlayerItem *)object;
        NSLog(@"the MptAVPlayerItemLikelyToKeepUp is did");
        
        if(item.playbackLikelyToKeepUp) {
            [self play];
            NSLog(@"Play item due to likelyToKeepUp");
        } else {
            [self pause];
            NSLog(@"Pause item due to likelyToKeepUp");
        }
        [self.view hideActivityViewAnimated:YES];
    
    }else if (context == MptAVPlayerItemDurationContext) {
       
        [self.view updateWithCurrentTime:self.currentPlaybackTime duration:self.duration];
    }else if (context == MptAVPlayerCurrentItemContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (newPlayerItem == (id)[NSNull null]) {
            [self stopObservingPlayerTimeChanges];
            // TODO: Disable buttons & scrubber
        } else {
            [self.view updateWithPlaybackStatus:self.playing];
            [self startObservingPlayerTimeChanges];
            self.videoGravity = _videoGravity;
        }
    }else if (context == MptAVPlayerRateContext) {
        [self.view updateWithPlaybackStatus:self.playing];
        
        if (_delegateFlags.didChangePlaybackRate) {
            [self.delegate moviePlayer:self didChangePlaybackRate:self.player.rate];
        }
    }else if (context == MptAVPlayerAirPlayVideoActiveContext) {
        if ([AVPlayer instancesRespondToSelector:@selector(isAirPlayVideoActive)]) {
            [self.view updateViewsForCurrentScreenState];
            
            if (_delegateFlags.didChangeAirPlayActive) {
                BOOL airPlayVideoActive = self.player.airPlayVideoActive;
                self.player.usesAirPlayVideoWhileAirPlayScreenIsActive = YES;
                [self.delegate moviePlayer:self didChangeAirPlayActive:airPlayVideoActive];
            }
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayer Video Playback
////////////////////////////////////////////////////////////////////////

- (void)play {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        if (_seekToInitialPlaybackTimeBeforePlay && _initialPlaybackTime >= 0.) {
            CMTime time = CMTimeMakeWithSeconds(_initialPlaybackTime, NSEC_PER_SEC);
            CMTime tolerance = self.initialPlaybackToleranceCMTime;
            __block MptAVPlayer *weakSelf = self;
            dispatch_block_t afterSeekAction = ^{
                [weakSelf.view hidePlaceholderViewAnimated:YES];
                
                [weakSelf moviePlayerDidStartToPlay];
                [weakSelf updateControlsViewForLivestreamStatus];
                
                if (_delegateFlags.didStartPlayback) {
                    [weakSelf.delegate moviePlayer:weakSelf didStartPlaybackOfURL:weakSelf.URL];
                }
            };
            
            if ([self.player respondsToSelector:@selector(seekToTime:toleranceBefore:toleranceAfter:completionHandler:)]) {
                [self.view showPlaceholderViewAnimated:NO];
                [self.player seekToTime:time
                        toleranceBefore:tolerance
                         toleranceAfter:tolerance
                      completionHandler:^(BOOL finished) {
                          afterSeekAction();
                      }];
            } else {
                [self.player seekToTime:time toleranceBefore:tolerance toleranceAfter:tolerance];
                afterSeekAction();
            }
            
            _seekToInitialPlaybackTimeBeforePlay = NO;
        } else {
            [self.view hidePlaceholderViewAnimated:YES];
            
            if (_delegateFlags.didResumePlayback) {
                [self.delegate moviePlayerDidResumePlayback:self];
            }
            
            [self moviePlayerDidResumePlayback];
        }
        
        [self.player play];
        [self.view setControlsVisible:YES animated:YES];
    } else {
        _autostartWhenReady = YES;
    }
    
    [self.playableDurationTimer invalidate];
    self.playableDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1.
                                                                  target:self
                                                                selector:@selector(updatePlayableDurationTimerFired:)
                                                                userInfo:nil
                                                                 repeats:YES];
}

- (void)pause {
    [self.player pause];
    
    [self.playableDurationTimer invalidate];
    self.playableDurationTimer = nil;
    [self.skippingTimer invalidate];
    self.skippingTimer = nil;
    
    if (_delegateFlags.didPausePlayback) {
        [self.delegate moviePlayerDidPausePlayback:self];
    }
    
    [self moviePlayerDidPausePlayback];
}

- (void)togglePlaybackState {
    if (self.playing) {
        [self pause];
    } else {
        [self play];
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayer Subclass Hooks
////////////////////////////////////////////////////////////////////////

- (void)moviePlayerDidStartToPlay {
    // do nothing here
}

- (void)moviePlayerDidPausePlayback {
    // do nothing here
}

- (void)moviePlayerDidResumePlayback {
    // do nothing here
}

- (void)moviePlayerDidUpdateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
    // do nothing here
}

- (void)moviePlayerWillShowControlsWithDuration:(NSTimeInterval)duration {
    // do nothing here
}

- (void)moviePlayerDidShowControls {
    // do nothing here
}

- (void)moviePlayerWillHideControlsWithDuration:(NSTimeInterval)duration {
    // do nothing here
}

- (void)moviePlayerDidHideControls {
    // do nothing here
}



////////////////////////////////////////////////////////////////////////
#pragma mark -MptAVPlayer View
////////////////////////////////////////////////////////////////////////

- (void)addToSuperview:(UIView *)view withFrame:(CGRect)frame {
    self.view.frame = frame;
    [view addSubview:self.view];
}

- (void)removeFromeSuperView
{
    if (_view) {
        [_view removeFromSuperview];
        
        [self.playableDurationTimer invalidate];
        self.playableDurationTimer = nil;
    }
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayer control
////////////////////////////////////////////////////////////////////////
- (void)setMptControlAble:(BOOL)value{
    if (_mptControlAble == value) {
        return;
    }
    _mptControlAble = value;
    _view.controlsView.mptControlAble = _mptControlAble;
    
}


////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayer Properties
////////////////////////////////////////////////////////////////////////

- (MptAVPlayerView *)view {
    if (_view == nil) {
        _view = [[MptAVPlayerView alloc] initWithFrame:CGRectZero name:self.name] ;
        _view.delegate = self;
        
        // layout that is used per default
        self.layout = [[[MptAVPlayerDefaultLayout alloc] init] autorelease]
        ;
    }
    
    return _view;
}

- (AVPlayer *)player {
    return self.view.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player {
    if (player != self.view.playerLayer.player) {
        // Support AirPlay?
        if (self.airPlayEnabled) {
            [player setAllowsAirPlayVideo:YES];
            [player setUsesAirPlayVideoWhileAirPlayScreenIsActive:YES];
            
            [self.view.playerLayer.player removeObserver:self forKeyPath:kAirPlayVideoActiveKye];
            
            [player addObserver:self
                     forKeyPath:kAirPlayVideoActiveKye
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                        context:MptAVPlayerAirPlayVideoActiveContext];
        }

        self.view.playerLayer.player = player;
        self.view.delegate = self;
    }
}

- (void)setAirPlayEnabled:(BOOL)airPlayEnabled {
    if ([AVPlayer instancesRespondToSelector:@selector(allowsAirPlayVideo)]) {
        if (airPlayEnabled != _airPlayEnabled) {
            _airPlayEnabled = airPlayEnabled;
        }
    }
}

- (BOOL)isAirPlayVideoActive {
    return [AVPlayer instancesRespondToSelector:@selector(isAirPlayVideoActive)] && self.player.airPlayVideoActive;
}

- (void)setURL:(NSURL *)URL {
    if (_URL != URL) {
        [_URL release]; _URL = nil;
        _URL = [URL copy];
        
        if (_view != nil) {
            [self.player pause];
            [self.player removeObserver:self forKeyPath:kRateKey];
            [self.player removeObserver:self forKeyPath:kCurrentItemKey];
            if ([AVPlayer instancesRespondToSelector:@selector(allowsAirPlayVideo)]) {
                [self.player removeObserver:self forKeyPath:kAirPlayVideoActiveKye];
            }
            self.player = nil;
            
        }
        
        if (URL != nil) {
            NSArray *keys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
            __block MptAVPlayer *weakSelf = self;
                    
            [self setAsset:[AVURLAsset URLAssetWithURL:URL options:nil]];
            [self.asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf doneLoadingAsset:weakSelf.asset withKeys:keys];
                });
            }];
            
            [self.view updateWithCurrentTime:0. duration:0.];
            [self.view showPlaceholderViewAnimated:(self.view.placeholderView.alpha != 1.f)];
        }
    }
}

- (void)setURL:(NSURL *)URL initialPlaybackTime:(NSTimeInterval)initialPlaybackTime {
    self.initialPlaybackTime = initialPlaybackTime;
    self.URL = URL;
}

- (void)setDelegate:(id<MptAVPlayerDelegate>)delegate {
    if (delegate != _delegate) {
        _delegate = delegate;
        
        _delegateFlags.didStartPlayback = [delegate respondsToSelector:@selector(moviePlayer:didStartPlaybackOfURL:)];
        _delegateFlags.didFailToLoad = [delegate respondsToSelector:@selector(moviePlayer:didFailToLoadURL:)];
        _delegateFlags.didFinishPlayback = [delegate respondsToSelector:@selector(moviePlayer:didFinishPlaybackOfURL:)];
        _delegateFlags.didPausePlayback = [delegate respondsToSelector:@selector(moviePlayerDidPausePlayback:)];
        _delegateFlags.didResumePlayback = [delegate respondsToSelector:@selector(moviePlayerDidResumePlayback:)];
        
        _delegateFlags.didBeginScrubbing = [delegate respondsToSelector:@selector(moviePlayerDidBeginScrubbing:)];
        _delegateFlags.didEndScrubbing = [delegate respondsToSelector:@selector(moviePlayerDidEndScrubbing:)];
        _delegateFlags.didClickOtt = [delegate respondsToSelector:@selector(moviePlayer:didClickOtt:)];
        
        _delegateFlags.didChangeStatus = [delegate respondsToSelector:@selector(moviePlayer:didChangeStatus:)];
        _delegateFlags.didChangePlaybackRate = [delegate respondsToSelector:@selector(moviePlayer:didChangePlaybackRate:)];
        _delegateFlags.didChangeAirPlayActive = [delegate respondsToSelector:@selector(moviePlayer:didChangeAirPlayActive:)];
        _delegateFlags.didChangeControlStyle = [delegate respondsToSelector:@selector(moviePlayer:didChangeControlStyle:)];
        _delegateFlags.didUpdateCurrentTime = [delegate respondsToSelector:@selector(moviePlayer:didUpdateCurrentTime:)];
    }
}

- (BOOL)isPlaying {
    return self.player != nil && self.player.rate != 0.f;
}

- (BOOL)isPlayingLivestream {
    return self.URL != nil && (isnan(self.duration) || self.duration <= 0.);
}

- (void)setVideoGravity:(MptAVPlayerVideoGravity)videoGravity {
    
    self.view.videoGravity = videoGravity;
}

- (MptAVPlayerVideoGravity)videoGravity {
    return MptAVPlayerVideoGravityFromAVLayerVideoGravity(self.view.playerLayer.videoGravity);
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)currentTime {
    currentTime = MAX(currentTime,0.);
    currentTime = MIN(currentTime,self.duration);
    
    CMTime time = CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC);
    CMTime tolerance = self.seekingToleranceCMTime;
    
    // completion handler only supported in iOS 5
    if ([self.player respondsToSelector:@selector(seekToTime:toleranceBefore:toleranceAfter:completionHandler:)]) {
        __block MptAVPlayer *weakSelf = self;
        [self.player seekToTime:time
                toleranceBefore:tolerance
                 toleranceAfter:tolerance
              completionHandler:^(BOOL finished) {
                  if (finished) {
                      [weakSelf.view updateWithCurrentTime:weakSelf.currentPlaybackTime duration:weakSelf.duration];
                  }
              }];
    } else {
        [self.player seekToTime:time toleranceBefore:tolerance toleranceAfter:tolerance];
        [self.view updateWithCurrentTime:currentTime duration:self.duration];
    }
}

- (NSTimeInterval)currentPlaybackTime {
    return CMTimeGetSeconds(self.player.currentTime);
}



- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.CMDuration);
}

- (NSTimeInterval)playableDuration {
    NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
    
    if (loadedTimeRanges.count > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        return (NSTimeInterval)(startSeconds + durationSeconds);
    } else {
        return 0.;
    }
}

- (void)setLayout:(MptAVPlayerLayout *)layout {
    layout.moviePlayer = self;
    self.view.controlsView.layout = layout;
    
    [layout invalidateLayout];
}

- (MptAVPlayerLayout *)layout {
    return self.view.controlsView.layout;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications
////////////////////////////////////////////////////////////////////////

- (void)playerItemDidPlayToEndTime:(NSNotification *)notification {
    [self.player pause];
    
    _seekToInitialPlaybackTimeBeforePlay = YES;
    [self.view setControlsVisible:YES animated:YES];
    
    if (_delegateFlags.didFinishPlayback) {
        [self.delegate moviePlayer:self didFinishPlaybackOfURL:self.URL];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Scrubbing/Skipping
////////////////////////////////////////////////////////////////////////

- (void)beginScrubbing {
    [self stopObservingPlayerTimeChanges];
    
    _rateToRestoreAfterScrubbing = self.player.rate;
    self.player.rate = 0.f;
    self.scrubbing = YES;
    
    if (_delegateFlags.didBeginScrubbing) {
        [self.delegate moviePlayerDidBeginScrubbing:self];
    }
}

- (void)endScrubbing {
    // TODO: We need to set this somewhere later (or find another workaround)
    // Current Bug: when the player is paused and the user scrubs player starts
    // playing again because we get a KVO notification that the status changed to ReadyForPlay
    self.scrubbing = NO;
    self.player.rate = _rateToRestoreAfterScrubbing;
    _rateToRestoreAfterScrubbing = 0.f;
    
    [self.skippingTimer invalidate];
    self.skippingTimer = nil;
    [self startObservingPlayerTimeChanges];
    
    if (_delegateFlags.didEndScrubbing) {
        [self.delegate moviePlayerDidEndScrubbing:self];
    }
}

- (void)beginSkippingBackwards {
    [self beginScrubbing];
    
    self.currentPlaybackTime -= kMptInitialTimeToSkip;
    self.timeToSkip = kMptepeatedTimeToSkipStartValue;
    
    self.skippingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(skipTimerFired:)
                                                        userInfo:[NSNumber numberWithInt:MptAVPlayerControlActionBeginSkippingBackwards]
                                                         repeats:YES];
}

- (void)beginSkippingForwards {
    [self beginScrubbing];
    
    self.currentPlaybackTime += kMptInitialTimeToSkip;
    self.timeToSkip = kMptepeatedTimeToSkipStartValue;
    
    self.skippingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(skipTimerFired:)
                                                        userInfo:[NSNumber numberWithInt:MptAVPlayerControlActionBeginSkippingForwards]
                                                         repeats:YES];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayerControlViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)moviePlayerControl:(id)control didPerformAction:(MptAVPlayerControlAction)action {
    [self.view stopFadeOutControlsViewTimer];
    
    switch (action) {
        case MptAVPlayerControlActionStartToPlay: {
            [self play];
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
        case MptAVPlayerControlActionDismiss:{
            [self.delegate moviePlayerDidDismissPlay:self];
        }
            
        case MptAVPlayerControlActionTogglePlayPause: {
            [self togglePlaybackState];
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        case MptAVPlayerControlActionToggleZoomState: {
            if (self.view.videoGravity == MptAVPlayerVideoGravityResize) {
                self.view.videoGravity = MptAVPlayerVideoGravityResizeAspectFill;
            } else {
                self.view.videoGravity = MptAVPlayerVideoGravityResize;
            }
            
            [self.view restartFadeOutControlsViewTimer];
            
            break;
        }
            
        case MptAVPlayerControlActionBeginSkippingBackwards: {
            [self beginSkippingBackwards];
            break;
        }
            
        case MptAVPlayerControlActionBeginSkippingForwards: {
            [self beginSkippingForwards];
            break;
        }
            
        case MptAVPlayerControlActionBeginScrubbing: {
            [self beginScrubbing];
            break;
        }
            
        case MptAVPlayerControlActionScrubbingValueChanged: {
            if ([control isKindOfClass:[MptScrubber class]]) {
                MptScrubber *slider = (MptScrubber *)control;
                
               float value = slider.value;
                [self setCurrentPlaybackTime:value];
                _seekToInitialPlaybackTimeBeforePlay = NO;
            }
            
            break;
        }
            
        case MptAVPlayerControlActionEndScrubbing:
        case MptAVPlayerControlActionEndSkipping: {
            [self endScrubbing];
            [self.view restartFadeOutControlsViewTimer];
            _seekToInitialPlaybackTimeBeforePlay = NO;
            break;
        }
        case MptAVPlayerControlActionOttConnect: { //click ott button
            if (_delegateFlags.didClickOtt) {
                [self.delegate moviePlayer:self didClickOtt:nil];
            }
        }
            
        case MptAVPlayerControlActionVolumeChanged: {
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        case MptAVPlayerControlActionWillShowControls: {
            [self moviePlayerWillShowControlsWithDuration:kMptFadeDuration];
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        case MptAVPlayerControlActionDidShowControls: {
            [self moviePlayerDidShowControls];
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        case MptAVPlayerControlActionWillHideControls: {
            [self moviePlayerWillHideControlsWithDuration:kMptFadeDuration];
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        case MptAVPlayerControlActionDidHideControls: {
            [self moviePlayerDidHideControls];
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        case MptAVPlayerControlActionAirPlayMenuActivated: {
            [self.view restartFadeOutControlsViewTimer];
            break;
        }
            
        default:
            // do nothing
            break;
            
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////


- (CMTime)CMDuration {
    CMTime duration = kCMTimeInvalid;
    
    // Peferred in HTTP Live Streaming
    if ([self.playerItem respondsToSelector:@selector(duration)] && // 4.3
        self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        if (CMTIME_IS_VALID(self.playerItem.duration)) {
            duration = self.playerItem.duration;
        }
    }
    
    // when playing over AirPlay the previous duration always returns 1, so we check again,When HTTP Live Streaming the duration.timescale == 0
    if ((!CMTIME_IS_VALID(duration) ||duration.timescale == 0 || duration.value/duration.timescale < 2) && CMTIME_IS_VALID(self.player.currentItem.asset.duration)) {
        duration = self.player.currentItem.asset.duration;
    }
    return duration;
}

- (void)doneLoadingAsset:(AVAsset *)asset withKeys:(NSArray *)keys {
    if (!asset.playable) {
        if (_delegateFlags.didFailToLoad) {
            [self.delegate moviePlayer:self didFailToLoadURL:self.URL];
        }
        
        return;
    }
    
    // Check if all keys are OK
    for (NSString *key in keys) {
        NSLog(@"key is %@",key);
        NSError *error = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
        
        if (status == AVKeyValueStatusUnknown|| status == AVKeyValueStatusFailed || status == AVKeyValueStatusCancelled) {
            if (_delegateFlags.didFailToLoad) {
                [self.delegate moviePlayer:self didFailToLoadURL:self.URL];
            }
            
            return;
        }
    }
    
    // Remove observer from old playerItem and create new one
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:kStatusKey];
        [self.playerItem removeObserver:self forKeyPath:kDrautionKey];
        [self.playerItem removeObserver:self forKeyPath:kPlaybackBufferEmpty];
        [self.playerItem removeObserver:self forKeyPath:kPlaybackLikelyToKeepUp];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
    
    [self setPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    
    // Observe status, ok -> play
    [self.playerItem addObserver:self
                      forKeyPath:kStatusKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MptAVPlayerItemStatusContext];
    
    // Durationchange
    [self.playerItem addObserver:self
                      forKeyPath:kDrautionKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MptAVPlayerItemDurationContext];
    
    [self.playerItem addObserver:self forKeyPath:kPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:MptAVPlayerItemBufferEmpty];
    [self.playerItem addObserver:self forKeyPath:kPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:MptAVPlayerItemLikelyToKeepUp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    _seekToInitialPlaybackTimeBeforePlay = YES;
    
    // Create the player
    if (!self.player) {
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
        
        // Observe currentItem, catch the -replaceCurrentItemWithPlayerItem:
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MptAVPlayerCurrentItemContext];
        
        // Observe rate, play/pause-button?
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MptAVPlayerRateContext];
        
    }
    
    // New playerItem?
    if (self.player.currentItem != self.playerItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.view updateWithPlaybackStatus:self.playing];
    }
}

- (void)startObservingPlayerTimeChanges {
    if (self.playerTimeObserver == nil) {
         __block MptAVPlayer *strongSelf = self;
        
        self.playerTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(.5, NSEC_PER_SEC)
                                                                            queue:dispatch_get_main_queue()
                                                                       usingBlock:^(CMTime time) {
                                                                          
                                                                           if (strongSelf != nil && [strongSelf isKindOfClass:[MptAVPlayer class]]) {
                                                                               if (CMTIME_IS_VALID(strongSelf.player.currentTime) && CMTIME_IS_VALID(strongSelf.CMDuration)) {
                                                                                   [strongSelf.view updateWithCurrentTime:strongSelf.currentPlaybackTime
                                                                                                                 duration:strongSelf.duration];
                                                                                   
                                                                                   [strongSelf moviePlayerDidUpdateCurrentPlaybackTime:strongSelf.currentPlaybackTime];
                                                                                   
                                                                                   if (strongSelf->_delegateFlags.didUpdateCurrentTime) {
                                                                                       [strongSelf.delegate moviePlayer:strongSelf didUpdateCurrentTime:strongSelf.currentPlaybackTime];
                                                                                   }
                                                                               }
                                                                           }
                                                                       }];
    }
}

- (void)stopObservingPlayerTimeChanges {
    if (self.playerTimeObserver != nil) {
        [self.player removeTimeObserver:self.playerTimeObserver];
        self.playerTimeObserver = nil;
    }
}

- (void)updateControlsViewForLivestreamStatus {
    // layout might change when playing livestream
    [self.layout invalidateLayout];
}

- (void)skipTimerFired:(NSTimer *)timer {
    MptAVPlayerControlAction action = [timer.userInfo intValue];
    
    if (action == MptAVPlayerControlActionBeginSkippingBackwards) {
        self.currentPlaybackTime -= self.timeToSkip++;
    } else if (action == MptAVPlayerControlActionBeginSkippingForwards) {
        self.currentPlaybackTime += self.timeToSkip++;
    }
}

- (void)updatePlayableDurationTimerFired:(NSTimer *)timer {
    self.view.controlsView.playableDuration = self.playableDuration;
}

- (CMTime)seekingToleranceCMTime {
    if (self.seekingToleranceTime >= 1000.) {
        return kCMTimePositiveInfinity;
    } else if (self.seekingToleranceTime <= 0.001) {
        return kCMTimeZero;
    } else {
        return CMTimeMakeWithSeconds(self.seekingToleranceTime, NSEC_PER_SEC);
    }
}

- (CMTime)initialPlaybackToleranceCMTime {
    if (self.initialPlaybackToleranceTime >= 1000.) {
        return kCMTimePositiveInfinity;
    } else if (self.initialPlaybackToleranceTime <= 0.001) {
        return kCMTimeZero;
    } else {
        return CMTimeMakeWithSeconds(self.initialPlaybackToleranceTime, NSEC_PER_SEC);
    }
}




@end
