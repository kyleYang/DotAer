//
//  YYInterstitialAdController.h
//  YYAdLib
//
//  Created by iosKin on 13-2-28.
//  Copyright (c) 2013年 www.aduu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAdView.h"

@protocol YYInterstitialAdControllerDelegate;

@interface YYInterstitialAdController : UIViewController

// 开发者应用ID
//
// 详解:前往优友主页:http://www.aduu.cn/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的ID
@property(nonatomic, retain)                      NSString    *appID;

// 开发者的安全密钥
//
// 详解:前往优友主页:http://www.aduu.cn/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的安全密钥
@property(nonatomic, retain)                      NSString    *appSecret;

@property (nonatomic, assign) id<YYInterstitialAdControllerDelegate> delegate;

// 初始化一个插屏广告控制器，使用开发者指定的尺寸
- (id)initWithRootViewController:(UIViewController *)rootViewController
                        delegate:(id<YYInterstitialAdControllerDelegate>)delegate;

//加载广告
-(void)loadAd;

//呈现广告
-(void)presentAd;

@end

@protocol YYInterstitialAdControllerDelegate <NSObject>

// 当插屏广告被成功加载后，回调该方法
- (void)interstitialSuccessToLoadAd:(YYInterstitialAdController *)interstitial;

// 当插屏广告加载失败后，回调该方法
- (void)interstitialFailToLoadAd:(YYInterstitialAdController *)interstitial withError:(NSError *)err;

// 当插屏广告要被呈现出来前，回调该方法
- (void)interstitialWillPresentScreen:(YYInterstitialAdController *)interstitial;

// 当插屏广告被关闭后，回调该方法
- (void)interstitialDidDismissScreen:(YYInterstitialAdController *)interstitial;


@end
