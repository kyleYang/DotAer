/*
 *  AdViewViewImpl.h
 *  AdViewSDK_Sample
 *
 *  Created by laizhiwen on 10-12-24.
 *  Copyright 2010 www.adview.cn. All rights reserved.
 *
 */

#import "AdViewView.h"
#import "AWNetworkReachabilityWrapper.h"
#import "AdViewConfig.h"
#import "AdViewDeviceCollector.h"

@class AdViewViewConst;

#define ALL_ORG_DELEGATE_METHODS		0	/*some original delegate methods is not present*/

#define USER_TEST_SERVER			0
#define DEBUG_INFO					0

#define ADVIEW_NAME                 [AdViewViewConst sdkName]
#define ADVIEW_VERSION_STR          [AdViewViewConst sdkVersion]

#define ADVIEW_WQ_TAG               [AdViewViewConst wqTag]

#if USER_TEST_SERVER		//test server, ip server

#define kAdViewDefaultConfigURL				@"http://124.207.233.119/agent/agent1.php"
                                          //@"http://124.207.233.119/agent/agent1.php"
#define kAdViewDefaultImpMetricURL			@"http://124.207.233.119/agent/agent2.php"
#define kAdViewDefaultClickMetricURL		@"http://124.207.233.119/agent/agent3.php"
#define kAdViewDefaultCustomAdURL			@"http://124.207.233.119/agent/custom.php"
#define CONFIG_REACH_CHECK		0			//现在的check针对ip:124.207.233.116不可行，域名估计没问题, laizhiwen

#else

#define kAdViewDefaultConfigURL				@"http://config.adview.cn/agent/agent1.php"
#define kAdViewDefaultImpMetricURL			@"http://www.adview.cn/agent/agent2.php"
#define kAdViewDefaultClickMetricURL		@"http://www.adview.cn/agent/agent3.php"
#define kAdViewDefaultCustomAdURL			@"http://www.adview.cn/agent/custom.php"
#define CONFIG_REACH_CHECK		1			//现在的check针对ip:adview，域名估计没问题, laizhiwen

#endif

#define kAdViewImpMetricURLFmt			@"http://%@/agent/agent2.php"
#define kAdViewClickMetricURLFmt		@"http://%@/agent/agent3.php"

//adview:www.adview.cn
//test:124.207.233.116

//#define kAdViewDefaultConfigURL @"http://mob.adview.com/getInfo.php"
//#define kAdViewDefaultImpMetricURL			@"http://met.adview.com/exmet.php"
//#define kAdViewDefaultClickMetricURL		@"http://met.adview.com/exclick.php"
//#define kAdViewDefaultCustomAdURL			@"http://mob.adview.com/custom.php"


#define kAWMinimumTimeBetweenFreshAdRequests 4.9f
#define kAdViewAdRequestTimeout				10

/*
 usr: threadxyz@gmail.com
 pwd: adviewlocust
 */

#define FAIL_TO_ROLLOVER	1	//original will rollover

@class AdViewAdNetworkConfig;
@class AdViewAdNetworkAdapter;
@class AdViewConfigStore;
@class AWNetworkReachabilityWrapper;

@interface AdViewViewConst : NSObject

+ (NSString*)sdkName;
+ (NSString*)sdkVersion;

+ (NSString*)wqTag;

@end

@interface AdViewView ()

- (void)setInShowingModalView:(BOOL)bModal;

#pragma mark For ad network adapters use only


/**
 * Starts pre-fetching ad network configurations from an AdView server. If the
 * configuration has been fetched when you are ready to request an ad, you save
 * a round-trip to the network and hence your ad may show up faster. You
 * typically call this in the applicationDidFinishLaunching: method of your
 * app delegate. The request is non-blocking. You only need to call this
 * at most once per run of your application. Subsequent calls to this function
 * will be ignored.
 */
+ (void)startPreFetchingConfigurationDataWithDelegate:(id<AdViewDelegate>)d;

/**
 * Call this method to request a new configuration from the AdView servers.
 * This can be useful to support iOS 4.0 backgrounding.
 */
+ (void)updateAdViewConfigWithDelegate:(id<AdViewDelegate>)delegate;

/**
 * Called by Adapters when there's a new ad view.
 */
- (void)adapter:(AdViewAdNetworkAdapter *)adapter
didReceiveAdView:(UIView *)view;

- (void)adapter:(AdViewAdNetworkAdapter *)adapter
shouldAddAdView:(UIView *)view;

- (void)adapter:(AdViewAdNetworkAdapter *)adapter
   shouldReport:(UIView *)view DisplayOrClick:(BOOL)bDisplay;

/**
 * Called by Adapters when ad view failed.
 */
- (void)adapter:(AdViewAdNetworkAdapter *)adapter didFailAd:(NSError *)error;

/**
 * Called by Adapters when the ad request is finished, but the ad view is
 * furnished elsewhere. e.g. Generic Notification
 */
- (void)adapterDidFinishAdRequest:(AdViewAdNetworkAdapter *)adapter;

@end

@class AdViewReachability;

@interface AdViewViewImpl : AdViewView<AdViewConfigDelegate,
							AWNetworkReachabilityDelegate, AdViewDeviceCollectorDelegate> {
	AdViewConfig *config;
	AdViewConfig *config_noblocking;	//config fetch in backgroud
	
	NSMutableArray *prioritizedAdNetCfgs;
	double totalPercent;
	
	BOOL ignoreAutoRefreshTimer;
	BOOL ignoreNewAdRequests;
	BOOL appInactive;
	BOOL showingModalView;                  
	
	BOOL requesting;
	AdViewAdNetworkAdapter *currAdapter;
	AdViewAdNetworkAdapter *lastAdapter;
	NSDate *lastRequestTime;
	NSMutableDictionary *pendingAdapters;
	
	NSTimer *refreshTimer;
	NSTimer *configTimer;
	
	// remember which adapter we last sent click stats for so we don't send twice
	id lastNotifyAdapter;
								
	id lastNotifyGotAdapter;
	id lastNotifyGotAdView;	//the adNetworkView
	NSTimeInterval lastNotifyGotTime;
	
	AdViewConfigStore *configStore;
	
	AWNetworkReachabilityWrapper *rollOverReachability;
	
	NSUInteger configFetchAttempts;
                                
    AdViewReachability* internetReach;
    BOOL                bNetReachable;
}

/**
 * Call this method to request a new configuration from the AdView servers.
 */
- (void)updateAdViewConfig;

/**
 * Call this method to get another ad to display. You can also specify under
 * "app settings" on adview.com to automatically get new ads periodically.
 */
- (void)requestFreshAd;

/**
 * Call this method if you prefer a rollover instead of a getNextAd call.  This
 * is offered primarily for developers who want to use generic notifications and
 * then execute a rollover when an ad network fails to serve an ad.
 */
- (void)rollOver;

/**
 * The delegate is informed asynchronously whether an ad succeeds or fails to
 * load. If you prefer to poll for this information, you can do so using this
 * method.
 *
 */
- (BOOL)adExists;

/**
 * Different ad networks may return different ad sizes. You may adjust the size
 * of the AdViewView and your UI to avoid unsightly borders or chopping off
 * pixels from ads. Call this method when you receive the adViewDidReceiveAd
 * delegate method to get the size of the underlying ad network ad.
 */
- (CGSize)actualAdSize;

/**
 * Some ad networks may offer different banner sizes for different orientations.
 * Call this function when the orientation of your UI changes so the underlying
 * ad may handle the orientation change properly. You may also want to
 * call the actualAdSize method right after calling this to get the size of
 * the ad after the orientation change.
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

/**
 * Call this method to get the name of the most recent ad network that an ad
 * request was made to.
 */
- (NSString *)mostRecentNetworkName;

/**
 * Call this method to ignore automatic refreshes AND manual refreshes entirely.
 *
 * This is provided for developers who asked to disable refreshing entirely,
 * whether automatic or manual.
 * If you call ignoreNewAdRequests, the AdView will:
 * 1) Ignore any Automatic refresh events (via the refresh timer) AND
 * 2) Ignore any manual refresh calls (via requestFreshAd and rollOver)
 */
- (void)ignoreNewAdRequests;
- (void)doNotIgnoreNewAdRequests;
- (BOOL)isIgnoringNewAdRequests;

/**
 * Call this to replace the content of this AdViewView with the view.
 */
- (void)replaceBannerViewWith:(UIView*)bannerView;


#pragma mark For ad network adapters use only

/**
 * Called by Adapters when there's a new ad view.
 */
- (void)adapter:(AdViewAdNetworkAdapter *)adapter
didReceiveAdView:(UIView *)view;

/**
 * Called by Adapters when ad view failed.
 */
- (void)adapter:(AdViewAdNetworkAdapter *)adapter didFailAd:(NSError *)error;

/**
 * Called by Adapters when the ad request is finished, but the ad view is
 * furnished elsewhere. e.g. Generic Notification
 */
- (void)adapterDidFinishAdRequest:(AdViewAdNetworkAdapter *)adapter;

- (NSString *)adViewImpMetricBaseURLString;
- (NSString *)adViewClickMetricBaseURLString;

@end
