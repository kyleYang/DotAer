//
//  AWAdView.h
//  Adwo SDK 4.2
//
//  Created by zenny_chen on 12-8-17.
//  Copyright (c) 2012年Adwo. All rights reserved.
//
/////////////////////// NOTES /////////////////////////////

/**
 * !!IMPORTANT!!
 * 本次SDK将仅支持XCode4.5或更高版本，支持iOS 6.0，并且最低支持iOS 4.3系统。
 * 注意！本SDK以及附属的Demo属于本公司机密，未经许可不得擅自发布！
 * Release Notes：
 * 添加了Social.framework框架，此框架必须设置为可选的（Optional），否则如果以默认的Required加入会导致iOS6.0以下系统运行崩溃。
 * 在AWAdViewDelegate中增加了必须实现的adwoGetBaseViewController接口。
 
 * 必须添加的框架：
 * AddressBook.framework
 * AdSupport.framework
 * AudioToolbox.framework
 * AVFoundation.framework
 * CoreMedia.framework
 * CoreTelephony.framework
 * EventKit.framework
 * PassKit.framework
 * QuartzCore.framework
 * StoreKit.framework
 * SystemConfiguration.framework
 * Social.framework（将required变为optional）
*/

#import <UIKit/UIKit.h>

@class AWAdViewAttributes;
@class AWAdView;


// 如果你的程序工程中没有包含CoreLocation.frameowrk，
// 那么把下面这个宏写到你的AppDelegate.m或ViewController.m中类实现的上面空白处。
// 如果已经包含了CoreLocation.framework，那么请不要在其它地方写这个宏。
// 注意：这个宏不能写在类中，也不能写在函数或方法中。详细用法请参考AdwoSDKBasic这个Demo～
#define ADWO_SDK_WITHOUT_CORE_LOCATION_FRAMEWORK(...)    \
@interface CLLocationManager : NSObject             \
                                                    \
@end                                                \
                                                    \
@implementation CLLocationManager                   \
                                                    \
@end                                                \
                                                    \
double kCLLocationAccuracyBest = 0.0;

// 如果你不想添加PassKit.framework，那么需要在你的ViewController.m或AppDelegate.m中加入这个宏
// 详细用法请参考AdwoSDKBasic这个Demo～
#define ADWO_SDK_WITHOUT_PASSKIT_FRAMEWORK(...)     \
@interface PKAddPassesViewController : NSObject     \
@end                                                \
                                                    \
@implementation PKAddPassesViewController           \
@end                                                \
                                                    \
@interface PKPass : NSObject                        \
                                                    \
@end                                                \
                                                    \
@implementation PKPass                              \
                                                    \
@end


enum ADWO_ADSDK_AD_TYPE
{
    /** Banner types */
    // For normal banner(320x50)
    ADWO_ADSDK_AD_TYPE_NORMAL_BANNER = 1,
    
    // For banner on iPad
    ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50 = 10,
    ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110,
    
    /** Full-screen types */
    ADWO_ADSDK_AD_TYPE_FULL_SCREEN = 100
};

enum ADWOSDK_SPREAD_CHANNEL
{
    ADWOSDK_SPREAD_CHANNEL_APP_STORE,
    ADWOSDK_SPREAD_CHANNEL_91_STORE
};

enum ADWOSDK_AGGREGATION_CHANNEL
{
    ADWOSDK_AGGREGATION_CHANNEL_NONE,
    ADWOSDK_AGGREGATION_CHANNEL_GUOHEAD,
    ADWOSDK_AGGREGATION_CHANNEL_ADVIEW,
    ADWOSDK_AGGREGATION_CHANNEL_MOGO,
    ADWOSDK_AGGREGATION_CHANNEL_ADWHIRL,
    ADWOSDK_AGGREGATION_CHANNEL_ADSAGE
};

// 全屏广告展示形式ID
enum ADWOSDK_FSAD_SHOW_FORM
{
    ADWOSDK_FSAD_SHOW_FORM_NORMAL,          // 一般插页式全屏广告
    ADWOSDK_FSAD_SHOW_FORM_LAUNCHING,       // 应用启动后立即展示全屏广告
    ADWOSDK_FSAD_SHOW_FORM_GROUND_SWITCH    // 后台切换到前台后立即显示全屏广告
};

// 广告请求加载错误码
enum ADWOSDK_REQUEST_ERROR_CODE
{
    // Ad request
    ADWOSDK_REQUEST_ERROR_CODE_SERVER_BUSY = 0xe0,  // 服务器繁忙：e0
    ADWOSDK_REQUEST_ERROR_CODE_NO_AD,               // 当前没有广告：e1
    ADWOSDK_REQUEST_ERROR_CODE_UNKNOWN_ERROR,       // 未知错误，或意料之外的错误：e2
    ADWOSDK_REQUEST_ERROR_CODE_INEXIST_PID,         // PID不存在：e3
    ADWOSDK_REQUEST_ERROR_CODE_INACTIVE_PID,        // PID未被激活：e4
    ADWOSDK_REQUEST_ERROR_CODE_REQUEST_DATA,        // 请求有错：e5
    ADWOSDK_REQUEST_ERROR_CODE_RECEIVED_DATA,       // 数据接收有错：e6
    ADWOSDK_REQUEST_ERROR_CODE_NO_AD_IP,            // 当前IP下广告已经投放完：e7
    ADWOSDK_REQUEST_ERROR_CODE_NO_AD_POOL,          // 当前广告都已经投放完：e8
    ADWOSDK_REQUEST_ERROR_CODE_NO_AD_LOW_RANK,      // 没有低优先级广告：e9
    ADWOSDK_REQUEST_ERROR_CODE_BUNDLE_ID,           // 开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致：ea
    
    ADWOSDK_REQUEST_ERROR_CODE_RESPONSE_ERROR,      // 服务器响应出错：eb
    ADWOSDK_REQUEST_ERROR_CODE_NETWORK_CONNECT,     // 设备当前没连网络，或网络信号不好：ec
    ADWOSDK_REQUEST_ERROR_CODE_INVALID_REQUEST_URL, // 请求URL出错：ed
    
    // Ad Load
    ADWOSDK_REQUEST_ERROR_CODE_AD_LOAD_ERROR,       // 用于广告展示的web view没加载成功：ee
    ADWOSDK_REQUEST_ERROR_CODE_AD_RESOURCE_DAMAGED  // 这个错误码用于应用启动全屏。如果全屏资源没加载好，或者仅仅下载了部分资源，那么SDK将会给出此错误码信息：ef
};

// 调用loadAd方法后的参数值
enum ADWOSDK_LOAD_AD_STATUS
{
    ADWOSDK_LOAD_AD_STATUS_LOAD_AD_FAILED,          // 广告加载失败，可能由于广告已请求或PID、广告类型不正确，或当前网络连接不成功
    ADWOSDK_LOAD_AD_STATUS_LOAD_AD_SUCCESSFUL,      // 广告加载成功
    ADWOSDK_LOAD_AD_STATUS_REQUEST_LAUNCHING_FSAD   // 准备请求开屏全屏广告资源
};

// Banner动画类型
enum ADWO_ANIMATION_TYPE
{
    // Animation moving
    ADWO_ANIMATION_TYPE_AUTO,                   // 由Adwo服务器来控制动画类型
    ADWO_ANIMATION_TYPE_NONE,                   // 无动画，直接切换
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_LEFT,   // 从左到右的推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_RIGHT,  // 从右到左推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_BOTTOM, // 从下到上推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_TOP,    // 从上到下推移
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_LEFT,  // 新广告从左到右移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_RIGHT, // 新广告从右到左移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_BOTTOM,// 新广告从下到上移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_TOP,   // 新广告从上到下移动，并覆盖在老广告条上
    
    ADWO_ANIMATION_TYPE_CROSS_DISSOLVE,         // 淡入淡出
    
    // Animation transition
    ADWO_ANIMATION_TYPE_CURL_UP,                // 向上翻页
    ADWO_ANIMATION_TYPE_CURL_DOWN,              // 向下翻页
    ADWO_ANIMATION_TYPE_FLIP_FROMLEFT,          // 从左到右翻页
    ADWO_ANIMATION_TYPE_FLIP_FROMRIGHT          // 从右到左翻页
};

// 全屏广告动画类型
enum ADWO_SDK_FULLSCREEN_ANIMATION_TYPE
{
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_AUTO,    // 由Adwo服务器来控制动画类型
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE,    // 无动画，直接出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_LEFT_TO_RIGHT, // 从左到右出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_RIGHT_TO_LEFT, // 从右到左出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_BOTTOM_TO_TOP, // 从底到顶出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_TOP_TO_BOTTOM, // 从顶到底出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_LEFT_RIGHT,        // 水平方向伸缩出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_TOP_BOTTOM,        // 垂直方向伸缩出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_CROSS_DISSOLVE,          // 淡入淡出
};


@protocol AWAdViewDelegate <NSObject>

@required

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
*/
- (UIViewController*)adwoGetBaseViewController;

@optional

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
*/
- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)adView;

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
*/
- (void)adwoAdViewDidLoadAd:(AWAdView*)adView;

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
*/
- (void)adwoFullScreenAdDismissed:(AWAdView*)adView;

/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
*/
- (void)adwoDidPresentModalViewForAd:(AWAdView*)adView;

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
*/
- (void)adwoDidDismissModalViewForAd:(AWAdView*)adView;

@end


@interface AWAdView : UIView
{
@private
    
    NSInteger adRequestTimeIntervel;
    NSInteger adSlotID;
    NSInteger errorCode;
    NSObject<AWAdViewDelegate> *delegate;
    enum ADWOSDK_SPREAD_CHANNEL spreadChannel;
    enum ADWOSDK_FSAD_SHOW_FORM fsAdShowForm;
    BOOL disableGPS;
    NSInteger animationType;
    NSString *keywords;
    NSDictionary *keywordsDictionary;
    
@public
    
    AWAdViewAttributes *attrs;
}

// 广告请求时间间隔
@property(assign, nonatomic) NSInteger adRequestTimeIntervel;

// 广告位ID
@property(assign, nonatomic) NSInteger adSlotID;

// 全屏广告展示形式，对于Banner广告无需设置
@property(assign, nonatomic) enum ADWOSDK_FSAD_SHOW_FORM fsAdShowForm;

// 主要推广渠道
@property(assign, nonatomic) enum ADWOSDK_SPREAD_CHANNEL spreadChannel;

// AWAdView代理，这个属性必须被设置，并且要实现AWAdViewDelegate中的adwoGetBaseViewController方法
@property(assign, nonatomic) NSObject<AWAdViewDelegate> *delegate;

// 请求失败错误码
@property(assign, nonatomic, readonly) NSInteger errorCode;

// 是否禁用GPS
@property(assign, nonatomic) BOOL disableGPS;

// 广告切换动画类型
@property(assign, nonatomic) NSInteger animationType;

// 关键字
@property(assign, nonatomic) NSString *keywords;

// 关键字字典
@property(retain, nonatomic) NSDictionary *keywordsDictionary;


/**
 * 描述：AWAdView提供了唯一的一个初始化实例对象的方法。
 * 参数pid：申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * 参数isToShowFormalAd：是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * 返回：如果返回为空，表示广告初始化创建失败，否则会返回一个有效的AWAdView类的对象。
 * 初始化后，可以对AWAdView对象设置适当的属性。如果要展示的是横幅广告，必须将此对象加到你当前视图控制器的视图中。
 * 另外，如果要创建两条广告，那么这两条广告的测试模式值必须相同，即要么都是测试模式，要么都是发布模式。当然，本SDK并不推荐同时创建两个Banner，不过开发者可以创建一个Banner，一个全屏。
*/
- (id)initWithAdwoPid:(NSString*)pid adTestMode:(BOOL)isToShowFormalAd;

/**
 * 描述：当完成初始化和相关设置之后，调用此方法加载广告。如果当前要展示的是横幅广告，必须在调用此方法前先将AWAdView对象添加到一个视图中，作为其子视图。如果要展示的是全屏广告，那么AWAdView对象的尺寸都不用设置，也不需要事先添加到任何父视图中。
 * 参数adType：指定当前的广告类型。对于横幅广告，如果是用于iPhone、iPod Touch，那么使用ADWO_ADSDK_AD_TYPE_NORMAL_BANNER即可，该尺寸为320x50；如果是用于iPad，那么可以指定ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50和ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110两种尺寸。
   如果你的广告要展示的是全屏广告，那么使用ADWO_ADSDK_AD_TYPE_FULL_SCREEN。
 * 这里要注意的是，AWAdView对象应该被加到一个控制器的根视图中，即其大小撑满整个屏幕，否则某些广告展示形式可能会影响父视图的尺寸。
*/
- (enum ADWOSDK_LOAD_AD_STATUS)loadAd:(enum ADWO_ADSDK_AD_TYPE)adType;

/**
 * 描述：这个方法用于展示全屏广告。可参考全屏展示Demo。
 * 参数baseView：将全屏展示的AWAdView对象所要添加到的父视图对象。baseView的尺寸应该是撑满整个屏幕的尺寸。
 * 参数currOrientation：当前视图控制器的方向。全屏视图将会根据这个方向作适当的展示调整。
 * 返回：如果当前全屏广告已经加载好，可以准备展示，那么返回YES，否则返回NO。可以通过
   - (void)adwoAdViewDidLoadAd:(AWAdView*)adView;这个代理接口来获得全屏广告加载好的通知。
 * 这边另外要注意的是，当你调用这个接口后，相应的AWAdView对象将会被添加到baseView上，因此当你要释放此AWAdView时仅需调用其removeFromSuperView即可。若当前的AWAdView对象还没有调用此方法就要被释放，那么只需调用release即可。
*/
- (BOOL)showFullScreenAd:(UIView*)baseView orientation:(UIInterfaceOrientation)currOrientation;

/**
 * 描述：这个接口仅用于全屏广告展示。当你的设备旋转时并且你所嵌入的AWAdView对象的视图控制器也支持这个方向，那么在屏幕旋转的代理中调用此方法，全屏视图将会作相应调整。可参考全屏广告展示Demo。
 * 参数orientation：当前设备已经旋转到的方向。
*/
- (void)orientationChanged:(UIInterfaceOrientation)orientation;

/**
 * 描述：暂停当前AWAdView的广告请求。此接口仅对横幅广告有效。
*/
- (void)pauseAd;

/**
 * 描述：若当前的AWAdView对象处于暂停请求状态，那么将恢复请求。否则，无效果。此接口仅对横幅广告有效。
*/
- (void)resumeAd;

@end


