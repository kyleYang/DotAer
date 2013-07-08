//
//  YYAdDelegateProtocol.h
//  YYAdLib
//
//  Created by iosKin on 13-2-28.
//  Copyright (c) 2013年 www.aduu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYAdView;

typedef enum {
	YYAdViewBannerAnimationTypeNone           = 0,
    YYAdViewBannerAnimationTypeSlideFromLeft  = 1,
	YYAdViewBannerAnimationTypeSlideFromRight = 2,
	YYAdViewBannerAnimationTypeFadeIn         = 3,
    YYAdViewBannerAnimationTypeCurlUp         = 4,
	YYAdViewBannerAnimationTypeCurlDown       = 5,
	YYAdViewBannerAnimationTypeFlipFromLeft   = 6,
	YYAdViewBannerAnimationTypeFlipFromRight  = 7,
	YYAdViewBannerAnimationTypeRandom         = 8,
} YYAdViewBannerAnimationType;


@protocol YYAdDelegate<NSObject>

@optional

// 请求广告数据成功后调用
//
// 详解:
//     当接收服务器返回的广告数据成功后调用该方法

//
- (void)didReceiveAd:(YYAdView *)adView;

// 请求广告条数据失败后调用
//
// 详解:
//      当接收服务器返回的广告数据失败后调用该方法

- (void)didFailToReceiveAd:(YYAdView *)adView  error:(NSError *)error;

//下载,安装app
//
// 详解:针对越狱环境
-(void)willDownloadAndInstal:(NSString *)appURL;


// 将要显示全屏广告前调用
// 
// 详解:将要显示一次全屏广告内容前调用该函数
- (void)willPresentScreen:(YYAdView *)adView;

// 显示全屏广告成功后调用
//
// 详解:显示一次全屏广告内容后调用该函数
- (void)didPresentScreen:(YYAdView *)adView;

// 将要关闭全屏广告前调用
//
// 详解:全屏广告将要关闭前调用该函数
- (void)willDismissScreen:(YYAdView *)adView;

@end
