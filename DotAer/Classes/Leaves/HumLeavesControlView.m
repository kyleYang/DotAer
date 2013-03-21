//
//  HumLeavesControlView.m
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumLeavesControlView.h"
#import "HumLeavesLayout.h"

#define kBarStrePosX 20
#define kBarStrePosY 13


@interface HumLeavesControlView()

@property (nonatomic, retain, readwrite) UIView *topControlsView;
@property (nonatomic, retain, readwrite) UIView *bottomControlsView;
@property (nonatomic, retain, readwrite) UIView *topControlsContainerView;
@property (nonatomic, retain, readwrite) UIButton *backControl;


@end


@implementation HumLeavesControlView
@synthesize delegate;
@synthesize topControlsView = _topControlsView;
@synthesize bottomControlsView = _bottomControlsView;
@synthesize topControlsContainerView = _topControlsContainerView;

@synthesize backControl = _backControl;


- (void)dealloc{
    self.delegate = nil;
    [_topControlsView release]; _topControlsView = nil;
    [_bottomControlsView release]; _bottomControlsView = nil;
    [_topControlsContainerView release]; _topControlsContainerView = nil;
    _backControl = nil;
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
        
        _topControlsContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _topControlsContainerView.backgroundColor = [UIColor clearColor];
        [_topControlsView addSubview:_topControlsContainerView];
        
        _bottomControlsView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomControlsView.alpha = 0.8f;
        _bottomControlsView.userInteractionEnabled = YES;
        _bottomControlsView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomControlsView];
        
        
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
#pragma mark - Button Method
////////////////////////////////////////////////////////////////////////
- (void)handleBackButtonPress:(id)sender{
    
    [self.delegate humLeavesControl:sender didPerformAction:HumLeavesControlActionBack];

}


@end
