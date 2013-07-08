//
//  AdChinaFullScreenView.h
//  AdChinaSDK
//
//  AdChina Publisher Code
//

#import <UIKit/UIKit.h>
#import "AdChinaFullScreenViewDelegateProtocol.h"

@interface AdChinaFullScreenView : UIView

// returns newly created fullscreen ad
+ (AdChinaFullScreenView *)requestAdWithAdSpaceId:(NSString *)theAdSpaceId delegate:(id<AdChinaFullScreenViewDelegate>)theDelegate;

// Set view controller for browser, default view controller is delegate
- (void)setViewControllerForBrowser:(UIViewController *)controller;

// Set the loading view's background color, default RGBA is 0,0,0,0.3
- (void)setBackgroundColor:(UIColor *)backgroundColor;

// If your enable accelerometer, the [UIAccelerometer sharedAccelerometer].delegate may be changed by html5 ads.
// The default value is YES, which may cause conflict.
// You may use - accelerometer:detectedAcceleration: to avoid conflict
- (void)setAccelerometerEnabled:(BOOL)enable;

@end
