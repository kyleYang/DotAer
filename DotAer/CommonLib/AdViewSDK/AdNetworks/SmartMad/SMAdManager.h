/*!
 @header SMAdManager.h
 @abstract base bannerView
 @author madhouse
 @version 3.0.0 2013/01/14 Creation
 */

#import <Foundation/Foundation.h>
#import "SMAdEventCode.h"


/*!
 @protocol
 @abstract SMAdPrecacheDelegate
 @discussion 预缓存代理
 */
@protocol SMAdPrecacheDelegate <NSObject>

@optional

/*!
 @method
 @abstract 开始预缓存
 @discussion
 @result nil
 */
- (void)adPrecacheStarted;

/*!
 @method
 @abstract 预缓存结束
 @discussion
 @result nil
 */
- (void)adPrecacheCompleted;

/*!
 @method
 @abstract 预缓存错误
 @discussion
 @result nil
 */
- (void)adPrecacheError:(SMAdEventCode*)errorCode;
@end


typedef enum {
    BannerAnimation_None = 0,
    BannerAnimation_Random = 1,
    BannerAnimation_FadeInOut = 2,
    BannerAnimation_FlipFromLeft = 3,
    BannerAnimation_FlipFromRight = 4,
    BannerAnimation_PageUp = 5,
    BannerAnimation_PageDown = 6,
    BannerAnimation_SliderFromLeft = 7,
    BannerAnimation_SliderFromRight = 8,
} BannerAnimationType;

typedef enum {
    InterstitialAnimation_None = 0,
    InterstitialAnimation_FadeInOut = 1,
    InterstitialAnimation_Popup = 2,
}InterstitialAnimationType;

typedef enum {
    PHONE_AD_BANNER_MEASURE_AUTO = 0,
    TABLET_AD_BANNER_MEASURE_300X250 = 7,
    TABLET_AD_BANNER_MEASURE_468X60 = 8,
    TABLET_AD_BANNER_MEASURE_728X90 = 9,
}SMAdBannerSizeType;

typedef enum {
    AD_INTERSTITIAL_MEASURE_AUTO = 0,
    AD_INTERSTITIAL_MEASURE_UMAP = 1,
}SMAdInterstitialSizeType;
               
typedef enum {
    AdSpaceTypeBanner = 1,
    AdSpaceTypeIntersitial = 2,
}AdSpaceType;



/*!
 @class
 @abstract SMAdManager
 */

@interface SMAdManager : NSObject


/*!
 @method
 @abstract 设置应用程序id
 @discussion
 @param applicationId
 @result nil
 */
+ (void)setApplicationId:(NSString*)applicationId;

/*!
 @method
 @abstract 设置调试模式
 @discussion
 @param isDebug
 @result nil
 */

+ (void)setDebugMode:(BOOL)isDebug;

/*!
 @method
 @abstract 设置广告刷新时间
 @discussion
 @param intervalTime
 @result nil
 */

+ (void)setAdRefreshInterval:(NSInteger)intervalTime;

/*!
 @method
 @abstract 设置关键字
 @discussion
 @param keywords
 @result nil
 */

+ (void)setKeywords:(NSString*)keywords;

/*!
 @method
 @abstract 设置用户信息
 @discussion
 @param jsonUserInfo
 @result nil
 */

+ (void)setUserInformation:(NSString*)jsonUserInfo;

/*!
 @method
 @abstract 设置channel id
 @discussion
 @param channelId
 @result nil
 */
+ (void)setChannelId:(NSString*)channelId;

/*!
 @method
 @abstract 设置启用预缓存
 @discussion
 @param adSpaceId
 @param adSpaceType
 @result nil
 */
+ (void)enableAdPrecache:(NSString*)adSpaceId adSpaceType:(AdSpaceType)adSpaceType;

/*!
 @method
 @abstract 设置预缓存监听代理
 @discussion
 @param delegate
 @result nil
 */
+ (void)setPrecacheDelegate:(id<SMAdPrecacheDelegate>)delegate;

@end
