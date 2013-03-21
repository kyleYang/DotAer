//
//  PanguImgPopView.m
//  pangu
//
//  Created by yang zhiyun on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMImagePopView.h"
#import "Env.h"


#define kButtonWidth 40
#define kButtonHeigh 40
#define kElemtGap 5

#define ZOOM_STEP 1.5
#define ZOOM_MIN 0.3

@interface  HMImagePopView()<humWebImageDelegae,UIScrollViewDelegate>{
    BOOL _bZooming;
    UIView *_viewZomm;
}

@property (nonatomic, retain) HumWebImageView *image;
@property (nonatomic, retain) UIScrollView *scroll;

@end


@implementation HMImagePopView
@synthesize image;
@synthesize scroll;
@synthesize imgRect;
@synthesize urlString;

- (void)dealloc
{
    self.image = nil;
    self.scroll = nil;
    self.urlString = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
   return [self initWithFrame:frame image:nil imageFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)popImage imageFrame:(CGRect)rect
{
    self = [super initWithFrame:frame];
    if (self) {
        

        
        self.imgRect = rect;
        self.scroll = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        
        self.scroll.delegate = self;
        self.scroll.BackgroundColor = [UIColor blackColor];
        self.scroll.bouncesZoom = YES;
        //        self.imgScorll.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.scroll setMaximumZoomScale:2];
        [self.scroll setMinimumZoomScale:.5];
        [self.scroll setZoomScale:1];
        [self.scroll setContentOffset:CGPointZero];
        [self.scroll setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        
        [self addSubview:self.scroll];
        
        self.image = [[[HumWebImageView alloc] initWithFrame:rect] autorelease];
        self.image.style = HUMWebImageStyleTopCentre;
        self.image.delegate = self;
        self.image.image = popImage;
        self.image.progressStyle = HMProgressCircle;
        [self.scroll addSubview:self.image];
        
        _viewZomm = nil;
        _bZooming = FALSE;
    }
    return self;
}


- (void)layoutSubviews
{

}



- (void)popViewAnimation
{
    
    self.image.style = HUMWebImageStyleScale;
    self.image.logoUrl = self.urlString;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.image.center = self.scroll.center;
            self.image.frame = self.scroll.bounds;
//            self.image.contentMode = UIViewContentModeScaleAspectFit;
         
        } completion:^(BOOL finished){
            

        }];
    });

}


- (void)popDisappear{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.image.frame = self.imgRect;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    });

}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (!_viewZomm) {
        _viewZomm = self.image;
    }
    
    _bZooming = YES;
    return _viewZomm;
    
    
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if(self.scroll != scrollView) return;
    
    if(scale < 1.1) {
        
               
        _bZooming = FALSE;
        _viewZomm.frame = self.scroll.bounds;
        _viewZomm = nil;

    }
    
}




- (void)tapDetectingImageView:(HumWebImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // Single tap shows or hides drawer of thumbnails.
    [self popDisappear];
}



- (void)tapDetectingImageView:(HumWebImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in
    float newScale = [self.scroll zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self.scroll zoomToRect:zoomRect animated:YES];
    
}

- (void)tapDetectingImageView:(HumWebImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
    float newScale = [self.scroll zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self.scroll zoomToRect:zoomRect animated:YES];
}


#pragma mark
#pragma mark ZOOM
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scroll frame].size.height / scale;
    zoomRect.size.width  = [self.scroll frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}




#define humWebImageDelegae

- (void)humWebImageDidDownloader:(HumWebImageView *)view image:(UIImage *)image{
//    view.frame = self.scroll.frame;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1) {
        CGPoint p = [aTouch locationInView:self];
    }
}


@end
