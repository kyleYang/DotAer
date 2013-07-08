/*!
 @header SMAdBannerView.h
 @abstract base bannerView
 @author madhouse
 @version 3.0.0 2013/01/14 Creation 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SMAdManager.h"



@class SMAdBannerView;
@class SMAdEventCode;


/*!
 @protocol
 @abstract SMAdBannerViewDelegate
 @discussion SMAdBannerView's delegate
 */

@protocol SMAdBannerViewDelegate <NSObject>

@optional

/*!
 @method
 @abstract adBannerViewDidReceiveAd取到广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidReceiveAd:(SMAdBannerView*)adView;

/*!
 @method
 @abstract adBannerView取广告失败
 @discussion
 @param adView
 @param errorCode
 @result nil
 */
- (void)adBannerView:(SMAdBannerView*)adView didFailToReceiveAdWithError:(SMAdEventCode*)errorCode;

/*!
 @method
 @abstract 即将展示banner广告
 @discussion
 @param adView
 @param eventCode
 @result nil
 */
- (void)adBannerViewWillPresentScreen:(SMAdBannerView*)adView impressionEventCode:(SMAdEventCode*)eventCode;

/*!
 @method
 @abstract 即将移出banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillDismissScreen:(SMAdBannerView*)adView;

/*!
 @method
 @abstract 已经移出banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidDismissScreen:(SMAdBannerView*)adView;

/*!
 @method
 @abstract 应用程序被切换到后台
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillLeaveApplication:(SMAdBannerView*)adView;

/*!
 @method
 @abstract 广告被点击
 @discussion
 @result nil
 */
- (void)adDidClick;

/*!
 @method
 @abstract banner将被expand
 @discussion
 @param adView
 @result nil
 */
- (void)adWillExpandAd:(SMAdBannerView *)adView;

/*!
 @method
 @abstract expand已经被关闭
 @discussion
 @param adView
 @result nil
 */
- (void)adDidCloseExpand:(SMAdBannerView*)adView;

/*!
 @method
 @abstract 应用程序即将被挂起
 @discussion
 @param adView
 @result nil
 */
- (void)appWillSuspendForAd:(SMAdBannerView*)adView;

/*!
 @method
 @abstract 应用程序即将被唤醒
 @discussion
 @param adView
 @result nil
 */
- (void)appWillResumeFromAd:(SMAdBannerView*)adView;

@end


/*!
 @class
 @abstract SMAdBannerView
 */

@interface SMAdBannerView : UIView

/*!
 @property
 @abstract SMAdBannerViewDelegate's object
 */
@property (nonatomic, assign) id<SMAdBannerViewDelegate> delegate;

/*!
 @property
 @abstract adSpaceId
 */

@property (nonatomic, copy) NSString* adSpaceId;

/*!
 @property
 @abstract adSize
 */
@property (nonatomic, assign) SMAdBannerSizeType adSize;

/*!
 @property
 @abstract rootViewController
 */
@property (nonatomic, assign) UIViewController *rootViewController;

/*!
 @property
 @abstract adBannerAnimationType
 */
@property (nonatomic, assign) BannerAnimationType adBannerAnimationType;

/*!
 @method
 @abstract SMAdBannerView初始化方法
 @discussion 
 @param adSpaceId 

 @result SMAdBannerView's object
 */

- (id)initWithAdSpaceId:(NSString*)adSpaceId;


/*!
 @method
 @abstract SMAdBannerView初始化方法
 @discussion 
 @param adSpaceId
 @param adSize
 @result SMAdBannerView's object
 */
- (id)initWithAdSpaceId:(NSString *)adSpaceId smAdSize:(SMAdBannerSizeType)adSize;

@end
