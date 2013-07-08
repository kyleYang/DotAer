/*

 AdViewDelegateProtocol.h

 Copyright 2010 www.adview.cn. All rights reserved.
*/

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class AdViewView;

typedef enum  {
    LangSetType_None = 0,		//do nothing
    LangSetType_Foreign = 1,	//if simple zh lang, don't change, other lang, only use foreign ad
	LangSetType_Separated = 2,	//if simple zh lang, only use chinese ad, other, only foreign
    
} LangSetType ;

typedef enum {
	AdviewBannerSize_Auto = 0,	//auto select size.
                                //0 -- auto select size (act match iphone)
                                //1 -- auto select size (act match ipad)
	AdviewBannerSize_320x50 = 2,
	AdviewBannerSize_300x250,
	AdviewBannerSize_480x60,
	AdviewBannerSize_728x90,
}AdviewBannerSize;

typedef enum {
	AdViewAppAd_BgGradient_None = -1,		//no gradient background.
	AdViewAppAd_BgGradient_Fix = 0,			//fix gradient background color.
	AdViewAppAd_BgGradient_Random,			//random gradient background color.	
}AdViewAppAd_BgGradientType;

typedef enum {
    AdViewRequestMethod_Default = 0,         //percentage
    AdViewRequestMethod_Priority,
}AdViewRequestMethod;

typedef enum {
	AdViewBannerAnimationTypeNone           = 0,
	AdViewBannerAnimationTypeFlipFromLeft   = 1,
	AdViewBannerAnimationTypeFlipFromRight  = 2,
	AdViewBannerAnimationTypeCurlUp         = 3,
	AdViewBannerAnimationTypeCurlDown       = 4,
	AdViewBannerAnimationTypeSlideFromLeft  = 5,
	AdViewBannerAnimationTypeSlideFromRight = 6,
	AdViewBannerAnimationTypeFadeIn         = 7,
	AdViewBannerAnimationTypeRandom         = 8,
} AdViewBannerAnimationType;

@protocol AdViewDelegate<NSObject>

@required

- (NSString *)adViewApplicationKey;

/**
 * 窗体控制对象
 * 最好返回根窗体控制对象(例如是UINavigationController, 也可以返回子控制对象UIViewController，
 * 但必须保证它的生存周期覆盖了AdViewView的生存周期)
 */
- (UIViewController *)viewControllerForPresentingModalView;

@optional
/**
 * 应用的发布渠道，比如AppStore, 91，等
 */
- (NSString *)adViewApplicationPublishChannel;

/**
 * 想要的广告条大小，adview会为对应广告平台选择最接近的大小。
 */
- (AdviewBannerSize)PreferBannerSize;

/**
 * 选取广告平台的方式，缺省是按比例，可设置为按优先级，则从优先级开始选择广告平台。
 */
- (AdViewRequestMethod)adViewRequestMethod;

/**
 * 因为广告平台尺寸不支持，希望Ipad不使用而iphone使用的平台。
 * 返回值必须是@"38,35"类似，其中38表示baidu的sdk id， 35表示WQ的sdk id。
 */
- (NSString*)adViewDisablePlatformsForIpad;

#pragma mark notifications

/**
 * 成功收到广告的回调方法。
 */
- (void)adViewDidReceiveAd:(AdViewView *)adViewView;

/**
 * 实际请求失败的回调方法，这个方法主要是为了传递错误信息。
 * 注意紧跟着这个方法可能会回调adViewStartGetAd:表示切换到下一家，
 * 如果无法切换，则可能回调adViewDidFailToReceiveAd:usingBackup:方法。
 */
- (void)adViewFailRequestAd:(AdViewView *)adViewView error:(NSError*)error;

/**
 * 失败并无法切换到有效平台的回调方法，不是实际的某次请求失败的回调。
 */
- (void)adViewDidFailToReceiveAd:(AdViewView *)adViewView usingBackup:(BOOL)yesOrNo;

// 用户点击广告的回调函数，一次展示仅会计入一次，即一次展示第一次点击时才会调用本方法。
- (void)adViewDidClickAd:(AdViewView *)adViewView;

- (void)adViewStartGetAd:(AdViewView *)adViewView;	//notify start to get next ad


/**
 * AdView收到网络状态改变通知。
 */
- (void)adViewDidReceiveInternet:(AdViewView*)adViewView reachability:(BOOL)bReachable;

/**
 * adView切换广告时会调用此函数。
 */
- (void)adViewDidAnimateToNewAdIn:(AdViewView *)adViewView;

/**
 * 用户收到这个消息时，可以自定义UIView显示在adView上。
 */
- (void)adViewReceivedGenericRequest:(AdViewView *)adViewView;

/**
 * 如果所有的广告都关闭了，用户将收到本通知
 */
- (void)adViewReceivedNotificationAdsAreOff:(AdViewView *)adViewView;

/**
 * 在用户点击广告后，广告切换为全屏幕，或者从全屏幕返回时会调用这两个函数通知用户。
 */
- (void)adViewWillPresentFullScreenModal;
- (void)adViewDidDismissFullScreenModal;

/**
 * adView成功接受到config数据时会调用这个函数。
 */
- (void)adViewDidReceiveConfig:(AdViewView *)adViewView;


#pragma mark 设置

/**
 * 用户是否在广告调试状态，还是已经成功发布应用，已经发布了请返回NO
 */
- (BOOL)adViewTestMode;

/**
 * 用户是否要求输出日志，以前是和adViewTestMode同步的，现在可单独启用
 */
- (BOOL)adViewLogMode;

/**
 * 获取广告时间太长，则判定为失败的超时长度，缺省15，单位s
 */
- (NSTimeInterval)adTimeOutInterval;

/**
 * 是否打开Gps获取地理位置信息
 */
- (BOOL)adGpsMode;

/**
 * Returns the device's current orientation for ad networks that relys on
 * it. If you don't implement this function, [UIDevice currentDevice].orientation
 * is used to get the current orientation.
 */
- (UIDeviceOrientation)adViewCurrentOrientation;

/**
 * Return the value should adview support landscape mode. Only iad and admob support landscape mode,
 * that is, show 480x32 size ad.
 * Default: YES
 * 返回是否支持横屏广告，目前只有iad和admob支持横屏尺寸，即480x32尺寸广告。
 */
- (BOOL)adViewLandscapeMode;

#pragma mark 附加设置
- (LangSetType)PreferLangSet;

#pragma mark 外观设置
- (UIColor *)adViewAdBackgroundColor;
- (UIColor *)adViewTextColor;
- (UIColor *)adViewSecondaryTextColor;
/**
 * Default:AdViewAppAd_BgGradient_Fix
 * 应用互推在文字和图标模式下的渐变背景类型，缺省为单一渐变，可选择关闭或基于背景颜色的随机变化
 */
- (AdViewAppAd_BgGradientType)adViewAppAdBackgroundGradientType;

/**
 * Default:AdViewBannerAnimationTypeNone
 * 广告切换时的动画效果。注意调试，以免和改变尺寸的动画效果冲突导致动画效果不佳。
 */
- (AdViewBannerAnimationType)adViewBannerAnimationType;


#pragma mark 广告ID
- (NSString *)kuaiYouApIDString; //application id for kuaiYou
- (NSString *)youMiApIDString; //application id for youmi
- (NSString *)woobooApIDString; //application id for wooboo
- (NSString *)admobPublisherID; // your Publisher ID from Admob.
- (NSString *)millennialMediaApIDString;  // your ApID string from Millennial Media.

- (NSString *)adChinaApIDString;  //application id for adChina

- (NSString *)aderApIDString;	//application id for ader

- (NSString *)caseeApIDString;  //application id for casee

- (NSString *)WiAdApIDString;	//application id for WiYun

- (NSString *)DoMobApIDString;  //application id for DoMob

- (NSString *)BaiDuApIDString;  //application id for baidu
- (NSString *)BaiDuApSpecString;  //spec string for baidu

- (NSString *)AirADAppIDString;	//application id for airAD

- (NSString *)WQAppIDString;		//application id for WQ
- (NSString *)WQPublisherIDString;	//publisher id for WQ

- (NSString *)MobWinAppIDString;	//application id for MobWin

- (NSString *)SmartMadApIDString;  //application id for SmartMad
- (NSString *)SmartMadBannerAdIDString; 

- (NSString *)VponAdOnApIDString;	//application id for vpon

- (NSString *)AdwoApIDString;		//application id for adwo

- (NSString*)mobiSageApIDString;
- (NSString*)greystripeApIDString;
- (NSString*)inmobiApIDString;
- (NSString*)izpApIDString;

- (NSString *)suiZongApIDString; //application id for suizong
- (NSString *)aduuApIDString;
- (NSString *)guomobApIDString; //application id for guomob

- (NSString *)pingcooAdIDString; //application id for pingcoo

#pragma mark 有米
- (NSString *)youMiApSecretString; //application secret for youmi

@end
