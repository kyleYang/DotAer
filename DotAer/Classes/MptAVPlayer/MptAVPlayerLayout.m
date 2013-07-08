//
//  MptAVPlayerLayout.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerLayout.h"
#import "MptAVPlayer.h"
#import "MptAVPlayerControlView+MptPrivate.h"

@interface MptAVPlayerLayout()



@property (nonatomic, retain, readwrite) UIView *topControlsView;
@property (nonatomic, retain, readwrite) UIView *bottomControlsView;
@property (nonatomic, retain, readwrite) UIView *topControlsContainerView;
@property (nonatomic, retain, readwrite) UIImageView *buttomControlsContainerView;

@property (nonatomic, assign, readwrite) UIDeviceScreenType screenType;

@property (nonatomic, retain, readwrite) MptScrubber *scrubberControl;;
@property (nonatomic, retain, readwrite) UILabel *currentTimeLabel;
@property (nonatomic, retain, readwrite) UILabel *totalTimeLabel;

@property (nonatomic, retain, readwrite) UIButton *playPauseControl;

@property (nonatomic, retain, readwrite) UIButton *rewindControl;
@property (nonatomic, retain, readwrite) UIButton *forwardControl;
@property (nonatomic, retain, readwrite) UIButton *typeSelectControl;
@property (nonatomic, retain, readwrite) MptVolumeControl *volumeControl;

@property (nonatomic, retain, readwrite) UIControl *airPlayControlContainer;
@property (nonatomic, retain, readwrite) MPVolumeView *airPlayControl;
@property (nonatomic, retain, readwrite) UIButton *dismissControl;
@property (nonatomic, retain, readwrite) UILabel *videoTitle;
@property (nonatomic, retain, readwrite) UIButton *zoomControl;
@end


@implementation MptAVPlayerLayout

@synthesize moviePlayer = _moviePlayer;
@synthesize controlsView = _controlsView;
@synthesize controlStyle = _controlStyle;
@synthesize playingLivestream;
@synthesize airPlayControlVisible;
@synthesize width;
@synthesize height;
@synthesize scrubberControl,currentTimeLabel,totalTimeLabel;
@synthesize topControlsView,bottomControlsView,topControlsContainerView,buttomControlsContainerView,playPauseControl,rewindControl,forwardControl,typeSelectControl,airPlayControlContainer,airPlayControl,dismissControl,videoTitle,zoomControl;
@synthesize screenType;


- (void)dealloc
{
    _moviePlayer = nil;
    MptSafeRelease(_controlsView);
    self.topControlsView = nil;
    self.bottomControlsView = nil;
    self.topControlsContainerView = nil;
    self.buttomControlsContainerView = nil;
    self.scrubberControl = nil;
    self.currentTimeLabel = nil;
    self.totalTimeLabel = nil;
    self.playPauseControl = nil;
    self.rewindControl = nil;
    self.forwardControl = nil;
    self.typeSelectControl = nil;
    self.volumeControl = nil;
    self.airPlayControlContainer = nil;
    self.airPlayControl = nil;
    self.dismissControl = nil;
    self.videoTitle = nil;
    self.zoomControl = nil;
    [super dealloc];
}

- (id)init{
    self  = [super init];
    if (self) {
        
        self.screenType= UIDeviceResolution_Unknown;
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            if (scale == 2.0f) {
                if (pixelHeight == 960.0f)
                    self.screenType = UIDeviceResolution_iPhoneRetina35;
                else if (pixelHeight == 1136.0f)
                    self.screenType = UIDeviceResolution_iPhoneRetina4;
                
            } else if (scale == 1.0f && pixelHeight == 480.0f)
                self.screenType = UIDeviceResolution_iPhoneStandard;
            
        } else {
            if (scale == 2.0f && pixelHeight == 2048.0f) {
                self.screenType = UIDeviceResolution_iPadRetina;
                
            } else if (scale == 1.0f && pixelHeight == 1024.0f) {
                self.screenType = UIDeviceResolution_iPadStandard;
            }
        }
        
    }
    return self;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayerLayout
////////////////////////////////////////////////////////////////////////

- (void)setMoviePlayer:(MptAVPlayer *)moviePlayer {
    if (moviePlayer != _moviePlayer) {
        _moviePlayer = moviePlayer;
        
        // update control references
            
        self.topControlsView = _moviePlayer.view.controlsView.topControlsView;
        self.bottomControlsView = _moviePlayer.view.controlsView.bottomControlsView;
        self.topControlsContainerView = _moviePlayer.view.controlsView.topControlsContainerView;
        self.buttomControlsContainerView = _moviePlayer.view.controlsView.buttomControlsContainerView;
        
        self.scrubberControl = _moviePlayer.view.controlsView.scrubberControl;
        self.currentTimeLabel = _moviePlayer.view.controlsView.currentTimeLabel;
        self.totalTimeLabel = _moviePlayer.view.controlsView.totalTimeLabel;
        
        self.playPauseControl = _moviePlayer.view.controlsView.playPauseControl;
        self.rewindControl = _moviePlayer.view.controlsView.rewindControl;
        self.forwardControl = _moviePlayer.view.controlsView.forwardControl;
        
        self.typeSelectControl = _moviePlayer.view.controlsView.typeSelectControl;
        
        self.volumeControl = _moviePlayer.view.controlsView.volumeControl;
        
        self.airPlayControlContainer = _moviePlayer.view.controlsView.airPlayControlContainer;
        self.airPlayControl = _moviePlayer.view.controlsView.airPlayControl;
        
        self.dismissControl = _moviePlayer.view.controlsView.dismissControl;
        self.videoTitle = _moviePlayer.view.controlsView.videoTitle;
        self.zoomControl = _moviePlayer.view.controlsView.zoomControl;
    }
}

- (MptAVPlayerControlView *)controlsView {
    return self.moviePlayer.view.controlsView;
}

- (MptAVPlayerControlStyle)controlStyle {
    return self.moviePlayer.view.controlStyle;
}

- (BOOL)isPlayingLivestream {
    return self.moviePlayer.playingLivestream;
}

- (CGFloat)width {
    return self.moviePlayer.view.controlsView.bounds.size.width;
}

- (CGFloat)height {
    return self.moviePlayer.view.controlsView.bounds.size.height;
}

- (BOOL)isAirPlayControlVisible {
    if (self.airPlayControl == nil) {
        return NO;
    }
    
    for (UIView *subview in self.airPlayControl.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            if (subview.alpha == 0.f || subview.hidden) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)updateControlStyle:(MptAVPlayerControlStyle)controlStyle {
    [self customizeTopControlsViewWithControlStyle:controlStyle];
    [self customizeBottomControlsViewWithControlStyle:controlStyle];
    [self customizeControlsWithControlStyle:controlStyle];
    
    [self invalidateLayout];
}

- (void)invalidateLayout {
    [self.controlsView setNeedsLayout];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayerLayout Protocol
////////////////////////////////////////////////////////////////////////

- (void)customizeTopControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    // Subclasses must implement
}

- (void)customizeBottomControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    // Subclasses must implement
}

- (void)customizeControlsWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    // Sublasses must implement
}

- (void)layoutTopControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    // Subclasses must implement
}

- (void)layoutBottomControlsViewWithControlStyle:(MptAVPlayerControlStyle)controlStyle {
    // Subclasses must implement
}

- (void)layoutControlsWithControlStyle:(MptAVPlayerControlStyle)controlStyle AirplayAvailable:(BOOL)airPlayAvailable; {
    // Subclasses must implement
}




@end
