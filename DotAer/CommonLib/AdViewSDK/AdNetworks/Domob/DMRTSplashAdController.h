//
//  DMRTSplashAdController.h
//  DomobAdSDK
//
//  Created by Johnny on 13-5-14.
//  Copyright (c) 2013年 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DMAdView.h"

#ifndef DOMOB_AD_SIZE_320x240
// For iPhone
#define DOMOB_AD_SIZE_320x240   CGSizeMake(320, 240)
#define DOMOB_AD_SIZE_320x400   CGSizeMake(320, 400)

// For iPad
#define DOMOB_AD_SIZE_768x576   CGSizeMake(768, 576)
#define DOMOB_AD_SIZE_768x960   CGSizeMake(768, 960)
#endif

// Real time splash
@interface DMRTSplashAdController : DMSplashAdController

@property (nonatomic, assign) BOOL isReady; // 可以通过该属性获知开屏广告是否可以展现
@property (nonatomic, assign) NSObject<DMSplashAdControllerDelegate> *delegate; // 指定开屏广告的委派
@property (nonatomic, assign) UIViewController *rootViewController; // 指定开屏广告的RootViewController

// 初始化开屏广告控制器
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                   window:(UIWindow *)window;       // 用于呈现开屏广告的Key Window

// 初始化开屏广告控制器
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                   window:(UIWindow *)window        // 用于呈现开屏广告的Key Window
               background:(UIColor *)background;    // 开屏广告出现前的背景颜色、图片（默认为黑色）

// 初始化开屏广告控制器
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                   window:(UIWindow *)keyWindow     // 用于呈现开屏广告的Key Window
               background:(UIColor *)background     // 开屏广告出现前的背景颜色、图片（默认为黑色）
                animation:(BOOL)animation;          // 开屏广告关闭时，是否使用渐变动画（默认有关闭动画）

// 初始化开屏广告控制器。
// 可以指定广告的尺寸，以及显示的位置。从而使广告与开机画片结合的更好
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                     size:(CGSize)adSize            // 广告尺寸，只在竖屏时有效，横屏时均会显示全屏广告。
                   offset:(CGFloat)offset           // 广告视图在Y轴的偏移量，只在竖屏时有效，横屏时偏移量总是为0。
                   window:(UIWindow *)keyWindow     // 用于呈现开屏广告的Key Window
               background:(UIColor *)background     // 开屏广告出现前的背景颜色、图片（默认为黑色），建议设置为与“Launch Images”相同的图片。
                animation:(BOOL)animation;          // 开屏广告关闭时，是否使用渐变动画（默认有关闭动画）

// 呈现广告
- (void)present;

// 设置地理位置信息
- (void)setLocation:(CLLocation *)location;

// 设置邮编
- (void)setPostcode:(NSString *)postcode;

// 设置关键字
- (void)setKeywords:(NSString *)keywords;

// 设置用户年龄
- (void)setUserBirthday:(NSString *)userBirthday;

// 设置用户性别
- (void)setUserGender:(DMUserGenderType)userGender;

@end