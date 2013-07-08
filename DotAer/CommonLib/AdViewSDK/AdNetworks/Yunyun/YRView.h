//
//  YRView.h
//  SuizongAdsSdk
//
//  Created by yunrang on 13-3-8.
//  Copyright (c) 2013年 yunrang. All rights reserved.
//

//#import "Contants.h"
#import <UIKit/UIKit.h>

typedef enum{
    // For iPhone&iPod Touch
    YRViewFormat_iPhone_320_48_mb,
    
    // For iPad
    YRViewFormat_iPad_300_250_pad,
    YRViewFormat_iPad_468_60_pad,
    YRViewFormat_iPad_728_90_pad,
    
    // 插播广告
    interstitial_mb DEPRECATED_ATTRIBUTE, 
} YRViewFormat;

@protocol   YRViewDelegate;

@interface YRView : UIView <UIWebViewDelegate>

/********************
 * 用户信息 必填字段 *
 ********************/

// 必填属性: 用户id
+ (void)setUserAppId:(NSString *)userAppId;
// 必填属性: 是否是测试模式
+ (void)setIsTestMode:(BOOL)isTestMode;

/******************
 *用户信息,可选字段   *
 ******************/

// 自定义属性: 关键字
+ (void)setKw:(NSString *)kw;

// 自定义属性: 用户性别 1=男,2=女
+ (void)setCustGender:(NSInteger)cg;

// 自定义属性: 用户年龄
+ (void)setCustAge:(NSInteger)age;

// 自定义属性: 用户工作
+ (void)setCustWork:(NSString *)work;

// 自定义属性: 用户生日（格式 19850414）
+ (void)setCustBd:(NSString *)bd;

// 自定义属性: 用户喜好
+ (void)setCustFav:(NSString *)fav;

// 自定义属性: 扩展字段
+ (void)setCustExtr:(NSDictionary *)extr;

// 自定义属性: 设置刷新时间
+ (void) setRefreshTime:(NSInteger)refreshTime;


/*******************************************************************
 * 初始化SDK,返回广告视图对象                                           *
 * sizeofAd：显示广告区域的CGSize大小。                                 *
 * delegate：YRViewDelegate对象，广告视图将执行YRViewDelegate中定义的方法。*
 * 返回值：广告视图对象。                                               *
 *******************************************************************/
+ (YRView *)requestYRViewWithYRDelegate:(id<YRViewDelegate>) delegate withFormat:(YRViewFormat)yrViewFormat withRootTarget:(UIViewController *)rootViewController;

+ (YRView *)requestYRViewWithYRDelegate:(id<YRViewDelegate>)delegate withRootTarget:(UIViewController *)rootViewController;

//funcion:  arbitrary size of the Banner by sacle
+ (YRView *)requestYRViewWithYRDelegate:(id<YRViewDelegate>) delegate withFormat:(YRViewFormat)yrViewFormat withRootTarget:(UIViewController *)rootViewController scale:(float)scale;


// 调用插播广告操作保存广告数据
+ (void)requestActiveAdWithDelegate:(id<YRViewDelegate>)delegate;
+ (void)requestActiveAdWithDelegate:(id<YRViewDelegate>) delegate withFormat:(YRViewFormat)yrViewFormat;

// 显示广告数据
+ (void)showActiveAd;
// 销毁广告条
-(void)destroy;

@end

