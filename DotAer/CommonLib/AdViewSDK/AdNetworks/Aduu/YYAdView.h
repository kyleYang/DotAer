//
//  YYAdView.h
//  YYAdLib
//
//  Created by iosKin on 13-2-28.
//  Copyright (c) 2013年 www.aduu.cn. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YYAdDelegateProtocol.h"

typedef enum {
    YYAdBannerContentSizeIdentifierUnknow     = 0,
    YYAdBannerContentSizeIdentifier320x50     = 1, // iPhone and iPod Touch ad size
    YYAdBannerContentSizeIdentifier320x480    = 2, // Full Banner size for the iPhone
    YYAdBannerContentSizeIdentifier728x90     = 3, // iPad size
    YYAdBannerContentSizeIdentifier400x400    = 4,
    YYAdBannerContentSizeIdentifier300x250    = 5
} YYAdBannerContentSizeIdentifier;


@interface YYAdView : UIView
// 开发者应用ID
// 
// 详解:前往优友主页:http://www.aduu.cn/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的ID
@property(nonatomic, retain)                      NSString    *appID;

// 开发者的安全密钥
// 
// 详解:前往优友主页:http://www.aduu.cn/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的安全密钥
@property(nonatomic, retain)                      NSString    *appSecret;

//应用程序请求时间间隔
//
//详解:网络请求刷新数据时间间隔
@property(nonatomic, assign)                    NSInteger   updateTime;


//应用程序设置全屏显示的时间
//
//详解:全屏模式下，全屏广告在显示时间后消失。默认情况下该值为10秒
@property(nonatomic, assign)                    NSInteger   disappearTime;


//应用程序的渠道号
//
//详解:渠道号
@property(nonatomic, retain)                    NSString       *channelNo; 

//// 背景颜色
//// @{64/255.0, 118/255.0, 170/255.0, 1.0}
////
//// 详解：
//// 广告条的背景颜色
//@property(nonatomic, retain)                    UIColor *indicateBackgroundColor;
//
//// 主标题颜色
//// @{255/255.0, 255/255.0, 255/255.0, 1.0}
////
//// 详解：主要是文字广告的时候，主标题的颜色
//@property(nonatomic, retain)                    UIColor *textColor;
//
//// 副标题颜色
//// @{255/255.0, 255/255.0, 255/255.0, 1.0}
////
//// 详解：主要是文字广告的时候，副标题的颜色
//@property(nonatomic, retain)                    UIColor *subTextColor;
//// 广告条的尺寸 

// 委托
@property(nonatomic, assign)                                id<YYAdDelegate> delegate;


//根视图的控制器
@property (nonatomic, assign) UIViewController *rootViewController;

//设置banner切换效果

//默认是随机切换
@property(nonatomic,assign)                      YYAdViewBannerAnimationType bannerAnimationType;


//切换效果持续时间间隔
//默认0.6
@property(nonatomic,assign)                      CGFloat animationDuration;

//初始化AdView的唯一接口
- (id)initWithContentSizeIdentifier:(YYAdBannerContentSizeIdentifier)sizeIdentifier delegate:(id<YYAdDelegate>)delegate;

// iOS SDK Version
//
//详解:返回该库的版本信息
+ (NSString *)sdkVersion;

//说明 设置页面广告背景颜色,设置广告文字颜色
-(void)setColor:(UIColor*)indicateBackgroundColor textColor:(UIColor*)textColor subTextColor:(UIColor*)subTextColor;

// 开始请求广告
//
//详解:初始化YYAdView后,开始请求网络数据,按设置的时间间隔更新广告
- (void)start;

// 停止请求广告
//
//详解:停止更新请求广告
- (void)stop;


@end
