//
//  PanguImgPopView.m
//  pangu
//
//  Created by yang zhiyun on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMImagePopManager.h"
#import "HMImagePopController.h"
#import "Env.h"


#define kButtonWidth 40
#define kButtonHeigh 40
#define kElemtGap 5

#define ZOOM_STEP 1.5
#define ZOOM_MIN 0.3


static CGFloat const kAnimateElasticSizeRatio = 0.03;
static CGFloat const kAnimateElasticDurationRatio = 0.6;
static CGFloat const kAnimationDuration = 1.0;

@interface  HMImagePopManager()<humWebImageDelegae>{
    BOOL _bAnimation;
    UIView *_viewZomm;
}

@property (nonatomic, retain) HMImagePopController *focusViewController;
@property (nonatomic, assign) UIViewController *parentController;

@end


@implementation HMImagePopManager

@synthesize imgRect;
@synthesize urlString;
@synthesize animationDuration;
// The background color. Defaults to transparent black.
@synthesize backgroundColor;
// Returns whether the animation has an elastic effect. Defaults to YES.
@synthesize elasticAnimation;
// Returns whether zoom is enabled on fullscreen image. Defaults to YES.
@synthesize zoomEnabled;
@synthesize dftImage;

@synthesize focusViewController = _focusViewController;

@synthesize parentController;

- (void)dealloc
{
   
    self.urlString = nil;
    self.backgroundColor = nil;
    self.dftImage = nil;
    self.focusViewController = nil;
    self.parentController = nil;
    
    [super dealloc];
}


- (UIImage *)decodedImageWithImage:(UIImage *)imageTmp
{
    CGImageRef imageRef = imageTmp.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpace, CGImageGetBitmapInfo(imageRef));
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return imageTmp;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}


- (id)init{
    return [self initWithParentConroller:nil DefaultImg:nil imageUrl:nil imageFrame:CGRectZero];
}

- (id)initWithParentConroller:(UIViewController *)controller DefaultImg:(UIImage *)popImage imageUrl:(NSString*)popImgUrl imageFrame:(CGRect)rect
{
    self = [super init];
    if (self) {
        
        self.imgRect = rect;
        self.urlString = popImgUrl;
        self.dftImage = popImage;
        self.parentController = controller;
    
        self.animationDuration = kAnimationDuration;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
        self.elasticAnimation = YES;
        self.zoomEnabled = YES;
        
        _bAnimation = NO;
    }
    return self;
}



- (HMImagePopController *)focusViewControllerForView:(UIView *)mediaView
{
    HMImagePopController *viewController;
    UITapGestureRecognizer *tapGesture;

    if(self.dftImage == nil)
        return nil;
    
    viewController = [[[HMImagePopController alloc] initWithNibName:nil bundle:nil]autorelease] ;
    tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDefocusGesture:)] autorelease];
    [viewController.view addGestureRecognizer:tapGesture];
    viewController.mainImageView.image = self.dftImage;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image;
        HumWebImageView *webImage = [[[HumWebImageView alloc] initWithFrame:CGRectZero] autorelease];
        webImage.imgDelegate = self;
        webImage.style = HUMWebImageStyleNO;
        webImage.imgUrl = self.urlString;
        image = webImage.downImage;
       
        if (image == nil) {
            image = self.dftImage;
        }
             
        image = [self decodedImageWithImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            viewController.mainImageView.image = image;
        });
    });
    
    return viewController;
}



- (void)handleFocusGesture:(UIGestureRecognizer *)gesture
{
    UIViewController *parentViewController;
    HMImagePopController *focusViewController;
  
    UIView *imageView;
    
   
    focusViewController = [self focusViewControllerForView:nil];
    if(focusViewController == nil)
        return;
    
    self.focusViewController = focusViewController;
    
    parentViewController = self.parentController;
    [parentViewController addChildViewController:focusViewController];
    [parentViewController.view addSubview:focusViewController.view];
    focusViewController.view.frame = parentViewController.view.bounds;
    
    
    imageView = focusViewController.mainImageView;
    imageView.frame = self.imgRect;
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame;
                         CGRect initialFrame;
                         CGAffineTransform initialTransform;
                         
                         frame = self.parentController.view.bounds;
//                         frame = (self.elasticAnimation?[self rectInsetsForRect:frame ratio:-kAnimateElasticSizeRatio]:frame);
                         
                         // Trick to keep the right animation on the image frame.
                         // The image frame shoud animate from its current frame to a final frame.
                         // The final frame is computed by taking care of a possible rotation regarding the current device orientation, done by calling updateOrientationAnimated.
                         // As this method changes the image frame, it also replaces the current animation on the image view, which is not wanted.
                         // Thus to recreate the right animation, the image frame is set back to its inital frame then to its final frame.
                         // This very last frame operation recreates the right frame animation.
                         initialTransform = imageView.transform;
                         imageView.transform = CGAffineTransformIdentity;
                         initialFrame = imageView.frame;
                         imageView.frame = frame;
                         [focusViewController updateOrientationAnimated:NO];
                         // This is the final image frame. No transform.
                         frame = imageView.frame;
                         // It must now be animated from its initial frame and transform.
                         imageView.frame = initialFrame;
                         imageView.transform = initialTransform;
                         imageView.transform = CGAffineTransformIdentity;
                         imageView.frame = frame;
                         
                         focusViewController.view.backgroundColor = self.backgroundColor;
                     }
                     completion:^(BOOL finished) {
                         if(self.elasticAnimation)
                         {
                             [UIView animateWithDuration:self.animationDuration*kAnimateElasticDurationRatio
                                              animations:^{
                                                  imageView.frame = focusViewController.contentView.bounds;
                                              }
                                              completion:^(BOOL finished) {
                                                  [self installZoomView];
                                              }];
                         }
                         else
                         {
                             [self installZoomView];
                         }
                     }];
    
}


- (void)installZoomView
{
    HumWebImageView *scrollView;
    
    if(!self.zoomEnabled)
        return;
    
    scrollView = [[HumWebImageView alloc] initWithFrame:self.focusViewController.contentView.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    scrollView.imgDelegate = self;
    self.focusViewController.scrollView = scrollView;
    [self.focusViewController.contentView addSubview:scrollView];
    [scrollView displayImage:self.focusViewController.mainImageView.image];
    self.focusViewController.mainImageView.hidden = YES;
    [scrollView release];
}

- (void)uninstallZoomView
{
    CGRect frame;
    
    if(!self.zoomEnabled)
        return;
    
    frame = [self.focusViewController.contentView convertRect:self.focusViewController.scrollView.imageView.frame fromView:self.focusViewController.scrollView];
    self.focusViewController.scrollView.hidden = YES;
    self.focusViewController.mainImageView.hidden = NO;
    self.focusViewController.mainImageView.frame = frame;
}


- (CGRect)rectInsetsForRect:(CGRect)frame ratio:(CGFloat)ratio
{
    CGFloat dx;
    CGFloat dy;
    
    dx = frame.size.width*ratio;
    dy = frame.size.height*ratio;
    
    return CGRectInset(frame, dx, dy);
}



- (void)handleDefocusGesture:(UIGestureRecognizer *)gesture
{
    _bAnimation = YES;
    UIImageView *contentView;
//    CGRect __block bounds;
    
    [self uninstallZoomView];
    contentView = self.focusViewController.mainImageView;
    contentView.image = self.dftImage;
    contentView.contentMode = UIViewContentModeScaleAspectFit;
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.focusViewController.contentView.transform = CGAffineTransformIdentity;
                         contentView.frame = self.imgRect;
//                         contentView.bounds = (self.elasticAnimation?[self rectInsetsForRect:bounds ratio:kAnimateElasticSizeRatio]:bounds);
                        
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:(self.elasticAnimation?self.animationDuration*kAnimateElasticDurationRatio:0)
                                          animations:^{
                                            self.focusViewController.view.backgroundColor = [UIColor clearColor];
                                              if(self.elasticAnimation)
                                              {
//                                                  contentView.bounds = bounds;
                                              }
                                          }
                                          completion:^(BOOL finished) {
                                              [self.focusViewController.view removeFromSuperview];
                                              [self.focusViewController removeFromParentViewController];
                                              self.focusViewController = nil;
                                              _bAnimation = FALSE;
                                          }];
                     }];
}









#define humWebImageDelegae

- (void)photoViewDidSingleTap:(HumWebImageView *)photoView{
    
    if (_bAnimation) {
        return;
    }
    [self handleDefocusGesture:nil];
}





@end
