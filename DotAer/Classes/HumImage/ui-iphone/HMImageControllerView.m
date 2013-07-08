//
//  ImageViewController.m
//  CoreTextDemo
//
//  Created by xuejun cai on 12-7-24.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "HMImageControllerView.h"
#import "Env.h"

#define kBarStrePosX 20
#define kBarStrePosY 13

@interface HMImageControllerView ()

@property (nonatomic, retain, readwrite) UIView *topControlsView;
@property (nonatomic, retain, readwrite) UIButton *backControl;
@property (nonatomic, retain, readwrite) UIButton *downloadImage;

@property (nonatomic, readonly) UIImage *TopControlFullscreenImage;

@end

@implementation HMImageControllerView

@synthesize delegate;

@synthesize topControlsView = _topControlsView;


@synthesize backControl = _backControl;
@synthesize downloadImage = _downloadImage;

@synthesize TopControlFullscreenImage = _TopControlFullscreenImage;


- (void)dealloc
{
    [_topControlsView release]; _topControlsView = nil;
    _backControl = nil;
    _backControl = nil;
    self.delegate = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _topControlsView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topControlsView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        _topControlsView.alpha = 0.8f;
        _topControlsView.userInteractionEnabled = YES;
        _topControlsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_topControlsView];
        
        
        
        _backControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _backControl.showsTouchWhenHighlighted = YES;
        _backControl.frame = (CGRect) { .size = CGSizeMake(60.f, 40.f) };
        _backControl.contentMode = UIViewContentModeCenter;
        [_backControl setImage:[[UIImage imageNamed:@"HMLeaves.bundle/HM_Leaves_bar_back"] stretchableImageWithLeftCapWidth:kBarStrePosX topCapHeight:kBarStrePosY] forState:UIControlStateNormal];
        [_backControl setImage:[[UIImage imageNamed:@"HMLeaves.bundle/HM_Leaves_backdown"] stretchableImageWithLeftCapWidth:kBarStrePosX topCapHeight:kBarStrePosY] forState:UIControlEventTouchDown];
        [_backControl addTarget:self action:@selector(handleBackButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_topControlsView addSubview:_backControl];
        
        _downloadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadImage.frame = (CGRect) { .size = CGSizeMake(60.f, 36.f) };
        _downloadImage.contentMode = UIViewContentModeCenter;
        [_downloadImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadImage setTitleColor:[UIColor whiteColor] forState:UIControlEventTouchDown];
        [_downloadImage setTitle:NSLocalizedString(@"dota.image.save.title", nil) forState:UIControlStateNormal];
         [_downloadImage setTitle:NSLocalizedString(@"dota.image.save.title", nil) forState:UIControlEventTouchDown];
        [_downloadImage setBackgroundImage:[[Env sharedEnv] cacheScretchableImage:@"pg_bar_done.png" X:kBarStrePosX Y:kBarStrePosY] forState:UIControlStateNormal];
        [_downloadImage setBackgroundImage:[[Env sharedEnv] cacheScretchableImage:@"pg_bar_donedown.png" X:kBarStrePosX Y:kBarStrePosY] forState:UIControlEventTouchDown];
        [_downloadImage addTarget:self action:@selector(handleImageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_topControlsView addSubview:_downloadImage];
        


        
        
        
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

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////
#pragma mark - layout
////////////////////////////////////////////////////////////////////////

- (UIImage *)TopControlFullscreenImage{
    if (_TopControlFullscreenImage == nil) {
        _TopControlFullscreenImage = [[Env sharedEnv] cacheImage:@"dota_frame_title_bg.png"];
        
        // make it a resizable image
        if ([_TopControlFullscreenImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            _TopControlFullscreenImage = [_TopControlFullscreenImage resizableImageWithCapInsets:UIEdgeInsetsMake(48.f, 15.f, 46.f, 15.f)];
        } else {
            _TopControlFullscreenImage = [_TopControlFullscreenImage stretchableImageWithLeftCapWidth:15 topCapHeight:47];
        }
        
    }
    return _TopControlFullscreenImage;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - HumLeavesLayout
////////////////////////////////////////////////////////////////////////

- (void)customizeTopControlsViewWithControlStyle {
    UIImageView *topControlsImageView = (UIImageView *)self.topControlsView;
    
    
    topControlsImageView.backgroundColor = [UIColor clearColor];
    topControlsImageView.image = self.TopControlFullscreenImage;
       
}





- (void)layoutTopControlsViewWithControlStyle{
    self.topControlsView.frame = CGRectMake(0.f,
                                            20.f,
                                            CGRectGetWidth(self.bounds),
                                            [self topControlsViewHeightForControlStyle]);
    
    
}





- (CGFloat)topControlsViewHeightForControlStyle{
    return 44;
}

- (CGFloat)bottomControlsViewHeightForControlStyle{
    return 40;
}


- (void)customizeControlsWithControlStyle {
    [self layoutTopControlsViewWithControlStyle];
    [self layoutSubviewsForControlStyleInline];
}



- (void)layoutSubviews{
    
    [self customizeTopControlsViewWithControlStyle];
    [self customizeControlsWithControlStyle];
    
//    [self setNeedsLayout];

}





- (void)layoutSubviewsForControlStyleInline{
    CGRect frame = self.backControl.frame;
    frame.origin = CGPointMake(15, 0);
    self.backControl.frame = frame;
    
    frame = self.downloadImage.frame;
    frame.origin = CGPointMake(CGRectGetWidth(self.bounds)-72, 4);
    self.downloadImage.frame = frame;
    
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Button Method
////////////////////////////////////////////////////////////////////////
- (void)handleBackButtonPress:(id)sender{
    
  [self.delegate humLeavesControl:sender didPerformAction:HMImageControlActionBack];
    
}


- (void)handleImageButtonPress:(id)sender{
    [self.delegate humLeavesControl:sender didPerformAction:HMImageControlActionImageDownload];
}



@end
