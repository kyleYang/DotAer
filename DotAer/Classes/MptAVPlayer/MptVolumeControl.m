//
//  MptVolumeControl.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-11.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptVolumeControl.h"

#define MptSystemVolumeDidChangeNotification         @"AVSystemController_SystemVolumeDidChangeNotification"
#define kMptSliderHeigh                              48.f
#define kMptSliderWidth                            170.f
#define kMptMinimumSlideDistance                     10.f
#define kMptShadowRadius                             10.f
#define kMptSlideDuration                             0.2
#define kMptMinimumTapSize                           44.f



@interface MptVolumeControl ()
{
    CGFloat _beforeVolume;
  
}

@property (nonatomic, retain) UIButton *volumeBtn;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, assign) float systemVolume;
@property (nonatomic, readonly) BOOL sliderVisible;

@property (nonatomic, assign) CGPoint touchStartPoint;
@property (nonatomic, assign) BOOL touchesMoved;



@end


@implementation MptVolumeControl
@synthesize sliderWidth = _sliderWidth;
@synthesize volume = _volume;

@synthesize minimumTrackImage = _minimumTrackImage;
@synthesize maximumTrackImage = _maximumTrackImage;
@synthesize thumbTrckImage = _thumbTrckImage;

@synthesize touchesMoved = _touchesMoved;
@synthesize touchStartPoint = _touchStartPoint;
@synthesize sliderVisible = _sliderVisible;
@synthesize systemVolume = _systemVolume;
@synthesize slider = _slider;
@synthesize volumeBtn = _volumeBtn;
@synthesize delegate;

- (void)dealloc {
    self.delegate = nil;
    [_minimumTrackImage release]; _minimumTrackImage = nil;
    [_maximumTrackImage release]; _maximumTrackImage = nil;
    [_thumbTrckImage release]; _thumbTrckImage = nil;
    [_volumeBtn release]; _volumeBtn = nil;
    [_slider release]; _slider = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MptSystemVolumeDidChangeNotification object:nil];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _sliderWidth = kMptSliderWidth;
//        _expandDirection = NGVolumeControlExpandDirectionUp;

       
        _minimumTrackImage = [[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_now"] retain];
        _maximumTrackImage = [[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_more"] retain];
        _thumbTrckImage = [[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_thumb"] retain];
        
        _touchesMoved = NO;
        _touchStartPoint = CGPointZero;
        
        _volumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
        _volumeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_volumeBtn addTarget:self action:@selector(volumeOpenShut:) forControlEvents:UIControlEventTouchUpInside];
        _volumeBtn.contentMode = UIViewContentModeCenter;
        _volumeBtn.showsTouchWhenHighlighted = YES;
        [self addSubview:_volumeBtn];
        
        
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_volumeBtn.frame)+10, (CGRectGetHeight(self.frame) - kMptSliderHeigh)/2, CGRectGetWidth(self.frame) - CGRectGetMaxX(_volumeBtn.frame)-10, kMptSliderHeigh)];
        _slider.minimumValue = 0.f;
        _slider.maximumValue = 1.f;
        _slider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [_slider addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
        [self customizeSlider:_slider];
        [self setSliderWidth:_sliderWidth];
        [self addSubview:_slider];
        
        self.slider.value = self.systemVolume;
        [self updateUI];
        _beforeVolume = self.slider.value;
        // set properties of glow Laye
        
        // observe changes to system volume (volume buttons)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(systemVolumeChanged:)
                                                     name:MptSystemVolumeDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}



////////////////////////////////////////////////////////////////////////
#pragma mark - UIControl
////////////////////////////////////////////////////////////////////////
- (void)volumeChange:(id)sender
{
    self.volume = self.slider.value;
}

- (void)volumeOpenShut:(id)sender
{
    if (self.volume > 0.001) {
        _beforeVolume = self.volume;
        self.volume = 0.000;
        self.slider.value = self.volume;
    }else{
        self.volume = _beforeVolume;
        self.slider.value = _beforeVolume;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGVolumeControl
////////////////////////////////////////////////////////////////////////

- (void)setVolume:(float)volume {
    float maxBound = MIN(volume, 1.f);
    float boundedVolume = MAX(maxBound, 0.f);
    
    // update the system volume
    self.systemVolume = boundedVolume;
    if([self.delegate respondsToSelector:@selector(mptVolume:Option:)]){
        [self.delegate mptVolume:self Option:MptVolumChange];
    }
    
    // system volume doesn't work on the simulator, so for testing purposes we
    // set the slider/image directly instead of using system volume as in updateUI

}

- (float)volume {
    return self.systemVolume;
}


- (void) setMinimumTrackImage:(UIImage *)minimumTrackImage
{
    if(_minimumTrackImage != minimumTrackImage)
    {
        [_minimumTrackImage release]; _minimumTrackImage = nil;
        _minimumTrackImage = [minimumTrackImage retain];
        [self customizeSlider:self.slider];
        
        
    }
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage
{
    if(_maximumTrackImage != maximumTrackImage)
    {
        [_maximumTrackImage release]; _maximumTrackImage = nil;
        _maximumTrackImage = [maximumTrackImage retain];
        [self customizeSlider:self.slider];
    }
        
}


////////////////////////////////////////////////////////////////////////
#pragma mark - NGVolumeControl+NGSubclass
////////////////////////////////////////////////////////////////////////

- (UIImage *)imageForVolume:(float)volume {
    // Returns an image that represents the current volume
    if (volume < 0.001f) {
        return [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_no"];
    } else if (volume < 0.33f) {
        return [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_have"];
    } else if (volume < 0.66f) {
        return [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_have"];
    } else {
        return [UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_volume_have"];
    }
}

- (void)customizeSlider:(UISlider *)slider {
    [self.slider setMinimumTrackImage:_minimumTrackImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:_maximumTrackImage forState:UIControlStateNormal];
    [self.slider setThumbImage:_thumbTrckImage forState:UIControlStateNormal];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setSystemVolume:(float)systemVolume {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.volume = systemVolume;
}

- (float)systemVolume {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    return musicPlayer.volume;
}



- (void)updateUI {
    // update the UI to reflect the current volume
    UIImage *image = [self imageForVolume:self.volume];
    [self.volumeBtn setImage:image forState:UIControlStateNormal];
    self.slider.value = self.volume;
}

- (void)systemVolumeChanged:(NSNotification *)notification {
    // we update the UI when the system volume changed (volume buttons)
    [self updateUI];
}

- (void)handleSliderValueChanged:(id)sender {
    self.volume = self.slider.value;
}


@end
