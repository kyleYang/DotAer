//
//  ImageViewController.m
//  CoreTextDemo
//
//  Created by xuejun cai on 12-7-24.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "HMImageControllerView.h"

#define kBarStrePosX 20
#define kBarStrePosY 13

@interface HMImageControllerView ()

@property (nonatomic, retain, readwrite) UIView *topControlsView;
@property (nonatomic, retain, readwrite) UIButton *backControl;

@property (nonatomic, readonly) UIImage *TopControlFullscreenImage;

@end

@implementation HMImageControllerView

@synthesize delegate;

@synthesize topControlsView = _topControlsView;


@synthesize backControl = _backControl;

@synthesize TopControlFullscreenImage = _TopControlFullscreenImage;


- (void)dealloc
{
    [_topControlsView release]; _topControlsView = nil;
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
        _TopControlFullscreenImage = [[UIImage imageNamed:@"HMLeaves.bundle/HM_Leaves_nv_top_bg"] stretchableImageWithLeftCapWidth:6 topCapHeight:20];
        
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
    return 40;
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
    
    self.backControl.frame = CGRectMake(15, 0, 60, 40);
    
    
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Button Method
////////////////////////////////////////////////////////////////////////
- (void)handleBackButtonPress:(id)sender{
    
  [self.delegate humLeavesControl:sender didPerformAction:HMImageControlActionBack];
    
}




@end
