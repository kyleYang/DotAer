//
//  KGModal.m
//  KGModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "KGModal.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kFadeInAnimationDuration = 0.3;
CGFloat const kTransformPart1AnimationDuration = 0.2;
CGFloat const kTransformPart2AnimationDuration = 0.1;
NSString *const KGModalGradientViewTapped = @"KGModalGradientViewTapped";

#define kDefaultOffsetY 0

@interface KGModalGradientView : UIView
@end

@interface KGModalCloseButton : UIButton
@end



@interface KGModal()
@property (retain, nonatomic) KGModalGradientView *styleView;
@property (retain, nonatomic) KGModalCloseButton *closeButton;
@property (retain, nonatomic) UIView *contentView;
@end

@implementation KGModal
@synthesize styleView;
@synthesize closeButton;
@synthesize contentView;
@synthesize offsetY;
@synthesize timeInterval;
- (void)dealloc
{
    self.styleView = nil;
    self.closeButton = nil;
    [super dealloc];
}

+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }
    
    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 4;
    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
    styleLayer.shadowOffset = CGSizeMake(0, 0);
    styleLayer.shadowOpacity = 0.5;
    styleLayer.borderWidth = 1;
    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
    styleLayer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.55] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    self.offsetY = kDefaultOffsetY;
    self.timeInterval = kgDefalutTimer;
    [self.layer addSublayer:styleLayer];
    [styleLayer release];
    
    _superFrame = CGRectZero;
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    self.showCloseButton = NO;
    self.backgroundScreenMode = KGModalBackgrounFullScreenModel;
    return self;

}

- (id)init{
    if(!(self = [super init])){
        return nil;
    }
    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 4;
    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
    styleLayer.shadowOffset = CGSizeMake(0, 0);
    styleLayer.shadowOpacity = 0.5;
    styleLayer.borderWidth = 1;
    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
    styleLayer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.55] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    self.offsetY = kDefaultOffsetY;
    self.timeInterval = kgDefalutTimer;
    [self.layer addSublayer:styleLayer];
     [styleLayer release];
    _superFrame = CGRectZero;
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    self.showCloseButton = NO;
    self.backgroundScreenMode = KGModalBackgrounFullScreenModel;
    return self;
}

- (id)initWithSuperFrame:(CGRect)superFrame
{
    if(!(self = [super init])){
        return nil;
    }
    
    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 4;
    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
    styleLayer.shadowOffset = CGSizeMake(0, 0);
    styleLayer.shadowOpacity = 0.5;
    styleLayer.borderWidth = 1;
    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
    styleLayer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.55] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    [self.layer addSublayer:styleLayer];
    [styleLayer release];
    self.offsetY = kDefaultOffsetY;
    self.timeInterval = kgDefalutTimer;
    _superFrame = superFrame;
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    self.showCloseButton = NO;
    self.backgroundScreenMode = KGModalBackgrounFullScreenModel;
    return self;
}

- (void)setShowCloseButton:(BOOL)showCloseButton{
    if(_showCloseButton != showCloseButton){
        _showCloseButton = showCloseButton;
        [self.closeButton setHidden:!self.showCloseButton];
    }
}


- (void)showWithContentView:(UIView *)acontentView{
    [self showWithContentView:acontentView andAnimated:YES];
}

- (void)showWithContentView:(UIView *)acontentView andAnimated:(BOOL)animated{
    CGRect fullRect;
    if (self.backgroundScreenMode == KGModalBackgrounFullScreenModel) {
        fullRect =  [[UIScreen mainScreen] bounds];
    }else{
        fullRect =  _superFrame;
    }
   
    NSArray *viewAry = self.subviews;
    if (viewAry && viewAry.count!=0) {
        for (UIView *tempView in viewAry) {
            [tempView removeFromSuperview];
        }
    }

//    CGFloat padding = 17;
    UIWindow *window = nil ;//= [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];
//    for (UIView *subview in topView.subviews) {
//        if (subview == self) {
//            return;
//        }
//    }
//    [self removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
   
    [topView addSubview:self];
    
    CGRect containerViewRect = acontentView.bounds;
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(fullRect)-CGRectGetMidX(containerViewRect));
    containerViewRect.origin.y = round(CGRectGetMidY(fullRect)-CGRectGetMidY(containerViewRect))-self.offsetY;
    self.frame = containerViewRect;
    [self addSubview:acontentView];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
   
    self.closeButton = [[[KGModalCloseButton alloc] init] autorelease];
    [self.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setHidden:!self.showCloseButton];
    [self addSubview:self.closeButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];

    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        if(animated){
           
            self.alpha = 0;
            self.layer.shouldRasterize = YES;
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                self.alpha = 1;
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                    self.alpha = 1;
                    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    self.layer.shouldRasterize = NO;
                    [self performSelector:@selector(hide) withObject:nil afterDelay:self.timeInterval];
                }];
            }];
        }
    });
}

- (void)closeAction:(id)sender{
    [self hideAnimated:self.animateWhenDismissed];
}

- (void)tapCloseAction:(id)sender{
    if(self.tapOutsideToDismiss){
        [self hideAnimated:self.animateWhenDismissed];
    }
}

- (void)hide{
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated{
    if(!animated){
        [self cleanup];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{

        self.layer.shouldRasterize = YES;
        [UIView animateWithDuration:kTransformPart2AnimationDuration animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:kTransformPart1AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                self.alpha = 0;
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
            } completion:^(BOOL finished2){
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.layer.shouldRasterize = NO;
                self.timeInterval = kgDefalutTimer;
                [self cleanup];
            }];
        }];
    });
}

- (void)cleanup{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSArray *viewAry = self.subviews;
    if (viewAry && viewAry.count!=0) {
        for (UIView *tempView in viewAry) {
            [tempView removeFromSuperview];
        }
    }
    [self removeFromSuperview];
}

@end


@implementation KGModalGradientView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalGradientViewTapped object:nil];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if([[KGModal sharedInstance] backgroundDisplayStyle] == KGModalBackgroundDisplayStyleSolid){
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }else{
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

@end

@implementation KGModalCloseButton

- (id)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 32, 32}])){
        return nil;
    }
  
   
    UIImage  *closeButtonImage = [self closeButtonImage];
    
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];

    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
    (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);

    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;


    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);


    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);


    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
