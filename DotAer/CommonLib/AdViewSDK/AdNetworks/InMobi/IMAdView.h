//
//  IMAdView.h
//  InMobi AdNetwork SDK
//
//  Copyright 2013 InMobi Technology Services Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAdDelegate.h"
#import "IMAdRequest.h"
#import "IMAdError.h"

#pragma mark Refresh Intervals.

// To switch off the adview refresh, use:
// adView.refreshInterval = REFRESH_INTERVAL_OFF;
#define REFRESH_INTERVAL_OFF  (-1)

// To use the default refresh interval for sdk, use:
// adView.refreshInterval = REFRESH_INTERVAL_DEFAULT_VALUE;
#define REFRESH_INTERVAL_DEFAULT_VALUE  (0)

// To use the minimum refresh interval supported by sdk, use:
// adView.refreshInterval = REFRESH_INTERVAL_MIN_SUPPORTED_VALUE;
#define REFRESH_INTERVAL_MIN_SUPPORTED_VALUE  (INT_MIN)

#pragma mark Ad Units
/**
 * The ad size equivalent to CGSizeMake(320, 48).
 * @deprecated Will be removed in a future release. Use IM_UNIT_320x50 instead.
 */
#define IM_UNIT_320x48        9
/**
 * Medium Rectangle size for the iPad (especially in a UISplitView's left pane).
 * The ad size equivalent to CGSizeMake(300, 250).
 */
#define IM_UNIT_300x250       10
/**
 * Leaderboard size for the iPad.
 * The ad size equivalent to CGSizeMake(728,90).
 */
#define IM_UNIT_728x90        11
/**
 * Full Banner size for the iPad (especially in a UIPopoverController or in
 * UIModalPresentationFormSheet).
 * The ad size equivalent to CGSizeMake(468x60).
 */
#define IM_UNIT_468x60        12
/**
 * Skyscraper size, designed for iPad's screen size.
 * The ad size equivalent to CGSizeMake(120x600).
 */
#define IM_UNIT_120x600       13
/**
 * Default ad size for iPhone and iPod Touch.
 * The ad size equivalent to CGSizeMake(320, 48).
 */
#define IM_UNIT_320x50        15

/**
 This is a UIView class that displays banner ads. A minimum implementation to
 get an ad from within a UIViewController class is:

   - Create and set up the ad view with proper app id and ad size.
   - Make your UIViewController adhere to the IMAdDelegate protocol to
     receive state change callbacks.
   - Place the adview on to the screen.

 Below is the sample example to use an IMAdView:
    IMAdView *adView = [[IMAdView alloc] initWithFrame:CGRectMake(0,0,320,50)
                                               imAppId:@"YOUR_APP_ID"
                                              imAdSize:IM_UNIT_320x50];
    adView.delegate = self;
    [self.view addSubview:adView];
    [adView release];

 When the IMAdView is added to its superview, it starts refreshing the ad
 automatically after some refresh interval set (default is 60). But If the
 refresh interval is set to REFRESH_INTERVAL_OFF, you may explicitely make
 the ad request or refresh the ad using:
    // without any targetting information:
    [adView loadIMAdRequest:nil];

    // or, with targetting information:
    IMAdRequest *request = [IMAdRequest request];
    request.gender = kIMGenderMale;
    // ... etc.
    [adView loadIMAdRequest:request];

 @warning When releasing the adView in the dealloc method of your
 UIViewController, make sure you set its delegate to nil and remove it from its
 superview to prevent any chance of your application crashing.
    - (void)dealloc {
        adView.delegate = nil;
        [adView removeFromSuperview];
        [adView release]; adView = nil;
        [super dealloc];
    }
 */
@interface IMAdView : UIView {

}

#pragma mark Required Properties

/**
 * Delegate object that receives state change notifications from this view.
 * Typically, this is a UIViewController instance.
 * @note When releasing the adView in the dealloc method of your
 * UIViewController, make sure you set its delegate to nil and remove it from
 * its superview to prevent any chance of your application crashing.
 */
@property (nonatomic, assign) IBOutlet id<IMAdDelegate> delegate;

/**
 * App ID can be obtained in the Publisher section by logging in to
 * InMobi's website. http://www.inmobi.com
 */
@property (nonatomic, copy) NSString *imAppId;

/**
 * Slot ID is an unique identifier that identifies one slot in your app. It can
 * be obtained in the Publisher section by logging in to InMobi's website.
 */
@property (nonatomic, assign) long long imSlotId;

/**
 * The ad size enum value to request for the specific banner size.
 * Default is IM_UNIT_320x50. Please see above for supported banner sizes.
 */
@property (nonatomic, assign) int imAdSize;

#pragma mark Optional properties

/**
 * Starts or stops the auto refresh of ads.
 * The refresh interval is measured between the completion(success or failure)
 * of the previous ad request and start of the next ad request. By default,
 * the refresh interval is set to 60 seconds. Setting a new valid refresh
 * interval value will start the auto refresh of ads if it is not already
 * started. Use REFRESH_INTERVAL_OFF as the parameter to switch off auto
 * refresh. When auto refresh is turned off, use the loadIMAdRequest method to
 * manually load new ads. The SDK will not refresh ads if the screen is in the
 * background or if the phone is locked.
 */
@property (nonatomic, assign) int refreshInterval;

/**
 * Specify animation type to be performed when this view refreshes.
 * Default value is UIViewAnimationTransitionCurlUp.
 */
@property (nonatomic, assign) UIViewAnimationTransition refreshAnimation;

/**
 * Specify additional parameters for targeted advertising.
 * You may call loadIMAdRequest: method for this view to load the request.
 *
 * @note See the IMAdRequest class for more details.
 */
@property (nonatomic, retain) IMAdRequest *imAdRequest;

/**
 * Use this constructor to obtain an instance of IMAdView.
 *
 * @param frame CGRect bounds for this view, typically according to the
 *              ad size requested.
 * @param appId Publisher's App ID obtained from InMobi website.
 * @param adSize Ad size to request the specific banner size.
 */
- (id)initWithFrame:(CGRect)frame
            imAppId:(NSString *)appId
           imAdSize:(int)adSize;
/**
 * Use this constructor to obtain an instance of IMAdView.
 *
 * @param frame CGRect bounds for this view, typically according to the
 *              ad size requested.
 * @param appId Publisher's App ID obtained from InMobi website.
 * @param slotId Slot Id to uniquely identify an ad slot in an app.
 * @param adSize Ad size to request the specific banner size.
 */
- (id)initWithFrame:(CGRect)frame
            imAppId:(NSString *)appId
           imAdSize:(int)adSize
           imSlotId:(long long)slotId;
/**
 * Call this method to refresh this view.
 * This method will call loadIMAdRequest: with the imAdRequest object specified
 */
- (void)loadIMAdRequest;

/**
 * Call this method to refresh this view.
 *
 * @param request The IMAdRequest object for requesting additional parameters.
 */
- (void)loadIMAdRequest:(IMAdRequest *)request;

/**
 * Call this method to stop loading the current ad request.
 */
- (void)stopLoading;
/**
 * Use this method to assign a custom reference tag at the time of making an
 * Ad Request to the InMobi Ad Server.
 *   [adView setRefTag:@"top ad on navigation bar" forKey:@"ref-tag"];
 *
 * @param value The value for this ref-tag. Max char limit is 50.
 * @param key The key for this ref-tag. Max char limit is 50.
 */
- (void)setRefTag:(NSString *)value forKey:(NSString *)key;

#pragma mark -- Deprecated methods
/**
 * @note This property is deprecated.
 */
@property (nonatomic, assign) UIViewController *rootViewController;

/**
 * Use this constructor to obtain an instance of IMAdView.
 *
 * @param frame CGRect bounds for this view, typically according to the
 *              ad size requested.
 * @param appId Publisher's App ID obtained from InMobi website.
 * @param adSize Ad size to request the specific banner size.
 * @param viewController RootViewController for this view.
 * @note This method is deprecated, please see above for the list of available constructors.
 */
- (id)initWithFrame:(CGRect)frame
            imAppId:(NSString *)appId
           imAdSize:(int)adSize
 rootViewController:(UIViewController *)viewController;

/**
 * @note This method is deprecated, calling this method will have no effect.
 */
- (void)setAdTextColor:(NSString *)color;

/**
 * @note This method is deprecated, calling this method will have no effect.
 */
- (void)setAdBackgroundColor:(NSString *)bgcolor;

/**
 * @note This method is deprecated, calling this method will have no effect.
 */
- (void)setAdBackgroundGradientWithTopColor:(NSString *)topcolor
                                bottomColor:(NSString *)bottomcolor;
/**
 * @note This method is deprecated, calling this method will always return TRUE;
 */
- (BOOL)shouldRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
