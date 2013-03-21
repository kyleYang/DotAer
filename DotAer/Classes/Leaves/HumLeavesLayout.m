//
//  HumLeavesLayout.m
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumLeavesLayout.h"

@interface HumLeavesLayout()

@property (nonatomic, readonly) UIImage *bottomControlFullscreenImage;
@property (nonatomic, readonly) UIImage *TopControlFullscreenImage;

@property (nonatomic, retain, readwrite) UIView *topControlsView;
@property (nonatomic, retain, readwrite) UIView *bottomControlsView;
@property (nonatomic, retain, readwrite) UIView *topControlsContainerView;

@property (nonatomic, retain, readwrite) UIButton *backControl;

@end


@implementation HumLeavesLayout
@synthesize controlsView = _controlsView;
@synthesize controlStyle = _controlStyle;

@synthesize topControlsView;
@synthesize bottomControlsView;
@synthesize topControlsContainerView;

@synthesize bottomControlFullscreenImage = _bottomControlFullscreenImage;
@synthesize TopControlFullscreenImage = _TopControlFullscreenImage;

@synthesize backControl = _backControl;


- (void)dealloc{
    _controlsView = nil;
    self.topControlsView = nil;
    self.bottomControlsView = nil;
    self.topControlsContainerView = nil;
    self.backControl = nil;
    
    [super dealloc];
    
}

- (id)init{
    self  = [super init];
    if (self) {
        
    }
    return self;
}



- (void)setControlsView:(HumLeavesControlView *)controlsView{
    if (controlsView != _controlsView) {
        _controlsView = controlsView;
        
        // update control references
        
        self.topControlsView = _controlsView.topControlsView;
        self.bottomControlsView = _controlsView.bottomControlsView;
        self.topControlsContainerView = _controlsView.topControlsContainerView;
        
        self.backControl = _controlsView.backControl;
        

    }
}

- (void)updateControlStyle:(HumLeavesControlStyle)controlStyle {
    [self customizeTopControlsViewWithControlStyle:controlStyle];
    [self customizeBottomControlsViewWithControlStyle:controlStyle];
    [self customizeControlsWithControlStyle:controlStyle];
    
    [self invalidateLayout];
}

- (void)invalidateLayout {
    [self.controlsView setNeedsLayout];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - HumLeavesTopButtomImage
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

- (UIImage *)bottomControlFullscreenImage {
    if (_bottomControlFullscreenImage == nil) {
        _bottomControlFullscreenImage = [[UIImage imageNamed:@"HMLeaves.bundle/HM_Leaves_nv_butom_bg"] stretchableImageWithLeftCapWidth:6 topCapHeight:20];
        
        // make it a resizable image
        if ([_bottomControlFullscreenImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            _bottomControlFullscreenImage = [_bottomControlFullscreenImage resizableImageWithCapInsets:UIEdgeInsetsMake(48.f, 15.f, 46.f, 15.f)];
        } else {
            _bottomControlFullscreenImage = [_bottomControlFullscreenImage stretchableImageWithLeftCapWidth:15 topCapHeight:47];
        }
    }
    
    return _bottomControlFullscreenImage;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - HumLeavesLayout
////////////////////////////////////////////////////////////////////////

- (void)customizeTopControlsViewWithControlStyle:(HumLeavesControlStyle)controlStyle {
    UIImageView *topControlsImageView = (UIImageView *)self.topControlsView;
    
    if (controlStyle == HumLeavesControlStyleFullscreen) {
        topControlsImageView.backgroundColor = [UIColor clearColor];
        topControlsImageView.image = self.TopControlFullscreenImage;
    } else if (controlStyle == HumLeavesControlStyleInline) {
        topControlsImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        topControlsImageView.image = nil;
    }

}

- (void)customizeBottomControlsViewWithControlStyle:(HumLeavesControlStyle)controlStyle {
    // update styling of bottom controls view
    UIImageView *bottomControlsImageView = (UIImageView *)self.bottomControlsView;
    
    if (controlStyle == HumLeavesControlStyleFullscreen) {
        bottomControlsImageView.backgroundColor = [UIColor clearColor];
        bottomControlsImageView.image = self.bottomControlFullscreenImage;
    } else if (controlStyle == HumLeavesControlStyleInline) {
        bottomControlsImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        bottomControlsImageView.image = nil;
    }
}

- (void)customizeControlsWithControlStyle:(HumLeavesControlStyle)controlStyle {
    
}



- (void)layoutTopControlsViewWithControlStyle:(HumLeavesControlStyle)controlStyle {
    self.topControlsView.frame = CGRectMake(0.f,
                                            20.f,
                                            CGRectGetWidth(_controlsView.bounds),
                                            [self topControlsViewHeightForControlStyle:controlStyle]);


}

- (void)layoutBottomControlsViewWithControlStyle:(HumLeavesControlStyle)controlStyle {
    CGFloat controlsViewHeight = [self bottomControlsViewHeightForControlStyle:controlStyle];
    CGFloat offset = (self.controlStyle == HumLeavesControlStyleFullscreen ? 0.f : 0.f);
    
    self.bottomControlsView.frame = CGRectMake(offset,
                                               CGRectGetHeight(_controlsView.bounds)-controlsViewHeight+20,
                                               CGRectGetWidth(_controlsView.bounds),
                                               controlsViewHeight-offset);
}





- (CGFloat)topControlsViewHeightForControlStyle:(HumLeavesControlStyle)controlStyle {
    if (controlStyle == HumLeavesControlStyleFullscreen) {
        return 40.f; //all state is fullScreen ,heigh for topView
    } else {
        return 40.f;
    }
    
}

- (CGFloat)bottomControlsViewHeightForControlStyle:(HumLeavesControlStyle)controlStyle {
    if (controlStyle == HumLeavesControlStyleFullscreen) {
        return 40.f; //all state is fullScreen
    } else {
        return 40.f;
    }
}


- (void)layoutControlsWithControlStyle:(HumLeavesControlStyle)controlStyle{
    if (controlStyle == HumLeavesControlStyleInline) {
        [self layoutSubviewsForControlStyleInline];
    } else {
        [self layoutSubviewsForControlStyleFullscreen];
    }
}







- (void)layoutSubviewsForControlStyleFullscreen{
    

}


- (void)layoutSubviewsForControlStyleInline{
    
    self.backControl.frame = CGRectMake(15, 0, 60, 40);
    
    
}


@end
