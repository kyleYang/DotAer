//
//  CaseeAdView.h
//  CaseeAdLib
//
//  Copyright 2009 CASEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CaseeAdDelegate;

typedef enum {
    CaseeAdSizeIdentifier_320x50  = 0,
    CaseeAdSizeIdentifier_48x256  = 1,
    CaseeAdSizeIdentifier_300x250 = 2,
    CaseeAdSizeIdentifier_728x90  = 3,
    CaseeAdSizeIdentifier_364x60  = 4,
    CaseeAdSizeIdentifier_90x708  = 5,
    CaseeAdSizeIdentifier_60x354  = 6,
} CaseeAdSizeIdentifier;

@interface CaseeAdView : UIView {

}

/**
 * method to create object for banner ad view.
 * 创建广告条view
 * @prama delegate:代理类
 */
+(CaseeAdView *)adViewWithDelegate:(id <CaseeAdDelegate>)delegate caseeRectStyle:(CaseeAdSizeIdentifier) adSize;

- (void)refreshAd;

/**
 * start rotation timer.
 */
-(void)startAdRotation;

/**
 * Start rotation with a delay.
 */
-(void)startAdRotationWithDelay;

/**
 * If display mode is rotation, stop the timer.
 */
- (void)stopAdRotation;
/**
 * get param assigned by developer.
 * this methods is to request, you should to implement the method "didReceiveParam" define in CaseeAdDelegate get response
 */
- (void)getParam:(NSString*) param;
/**
 * method to create object for full screen and rich media ad view.
 *
 */
+(CaseeAdView *)fullScreenViewWithDelegate:(id<CaseeAdDelegate>)delegate;

/**
 * request a full screen ad
 * this ad will auto display once it was received.
 */
- (void)requestFullScreenAdView;

@end
