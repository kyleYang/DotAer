/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterMobiSage.h"
#import "AdviewObjCollector.h"

#define TestUserSpot @"all"

@interface NotificationReceiver : NSObject
{
	NSTimer *delayNotifyTimer;
}

@property (retain) NSTimer *delayNotifyTimer;
@property (retain) AdViewAdapterMobiSage *adatper;

@end

@implementation NotificationReceiver

@synthesize adatper;

@synthesize delayNotifyTimer;

- (id)init {
	self = [super init];
	if (nil != self) {
	}
	return self;
}

- (void)dealloc {
	if (nil != delayNotifyTimer) {
		[delayNotifyTimer invalidate];
		delayNotifyTimer = nil;
	}
	
	[super dealloc];
}

- (void) mobiSageCallback: (UIView*) view
{
	AWLogInfo(@"mobiSageCallback, need not do.");
}

- (void) delayMobiSageStartShowAd: (UIView*) view {
	AWLogInfo(@"delayMobiSageStartShowAd");
	if (nil != self.delayNotifyTimer) {
		[self.delayNotifyTimer invalidate];
		self.delayNotifyTimer = nil;
	}
	if (nil == self.adatper) return;
	
	self.delayNotifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self	
											 selector:@selector(mobiSageStartShowAd:)
											 userInfo:view
											  repeats:NO];
}

- (void) mobiSageStartShowAd: (UIView*) view
{
	if (nil != self.adatper) {
		[self.adatper performSelector:@selector(mobiSageStartShowAd:) withObject:view];
	}
}

- (void) mobiSageStopShowAd: (UIView*) view
{
	self.delayNotifyTimer = nil;
	if (nil != self.adatper) {
		[self.adatper performSelector:@selector(mobiSageStopShowAd:) withObject:view];
	}
}

- (void) mobiSageWillPopAd: (UIView*) view
{
	if (nil != self.adatper) {
		[self.adatper performSelector:@selector(mobiSageWillPopAd:) withObject:view];
	}
}

- (void) mobiSageHidePopAd: (UIView*) view
{
	if (nil != self.adatper) {
		[self.adatper performSelector:@selector(mobiSageHidePopAd:) withObject:view];
	}
}

@end

NotificationReceiver *gReceiver = nil;


@implementation AdViewAdapterMobiSage
@synthesize adViewInternal;
@synthesize mobiSageAdView;

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAdSage;
}

+ (void)load {
	if(NSClassFromString(@"MobiSageManager") != nil) {
        //AWLogInfo(@"AdView: Find MobiSage AdNetork");
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)actGetAd {
    NSString *apID = @"";
    NSTimeInterval tmStart = [[NSDate date] timeIntervalSince1970];
    
	Class mobiSageAdBannerClass = NSClassFromString (@"MobiSageAdBanner");
	if (nil == mobiSageAdBannerClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no mobisage lib, can not create.");
		return;
	}
    
	if ([adViewDelegate respondsToSelector:@selector(mobiSageApIDString)]) {
		apID = [adViewDelegate mobiSageApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	[self updateSizeParameter];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	
#if 0	//根据厂商建议，不调用此。
    Class mobiSageAdViewManagerClass = NSClassFromString (@"MobiSageManager");
	if (nil != mobiSageAdViewManagerClass)
		[[mobiSageAdViewManagerClass getInstance] setPublisherID:apID];
#endif
	
	UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sSizeAd.width, self.sSizeAd.height)];
    MobiSageAdBanner* adView = [[mobiSageAdBannerClass alloc] initWithAdSize:self.nSizeAd PublisherID:apID withDelegate:self];
	
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		[dummyView release];
		return;
	}
    adView.delegate = self;
    if (nil != gReceiver) {
		[nc addObserver:gReceiver selector:@selector(mobiSageStartShowAd:) name:MobiSageAdView_Start_Show_AD object:adView];
		[nc addObserver:gReceiver selector:@selector(mobiSageStopShowAd:) name:MobiSageAdView_Pause_Show_AD object:adView];
		[nc addObserver:gReceiver selector:@selector(mobiSageCallback:) name:MobiSageAdView_Refresh_AD object:adView];
		[nc addObserver:gReceiver selector:@selector(mobiSageWillPopAd:) name:MobiSageAdView_Pop_AD_Window object:adView];
		[nc addObserver:gReceiver selector:@selector(mobiSageHidePopAd:) name:MobiSageAdView_Hide_AD_Window object:adView];
        
        [nc addObserver:gReceiver selector:@selector(mobiSageActionError:) name:MobiSageAction_Error object:adView];
    }

    
	adView.frame = CGRectMake(0, 0, self.sSizeAd.width,self.sSizeAd.height);
	[adView setSwitchAnimeType:Random];
	[adView	setInterval:Ad_NO_Refresh];
    dummyView.backgroundColor = [UIColor clearColor];
    //[dummyView addSubview:adView];
    self.adNetworkView = dummyView;
	self.adViewInternal = dummyView;
    [self.adViewInternal addSubview:adView];
    self.mobiSageAdView = adView;
    [adView release];
    [dummyView release];
    
    NSTimeInterval tmEnd = [[NSDate date] timeIntervalSince1970];
    
    AWLogInfo(@"mobisage getad time:%f", tmEnd - tmStart);
}

//For first load mobisage will use 5-9 second, use background mode.
- (void)getAd {
    //[self performSelectorInBackground:@selector(actGetAd) withObject:nil];
    [self setupDefaultDummyHackTimer];
	if (nil == gReceiver) gReceiver = [[NotificationReceiver alloc] init];
	if (nil != gReceiver) {
		gReceiver.adatper = self;
	}
#if 0       //如果异步处理，未完成就释放，可能出错，因此屏蔽。
    if ([NSThread isMultiThreaded]) {
        adThread_ = [[NSThread alloc] initWithTarget:self selector:@selector(actGetAd) object:nil];
        [adThread_ setName:@"mobisage_getad"];
        [adThread_ setThreadPriority:0.1f];
        [adThread_ start];
    } else
#endif
    {
        [self performSelector:@selector(actGetAd)];
    }
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--MobiSage stopBeingDelegate");
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
	
    MobiSageAdBanner *banner = (MobiSageAdBanner*)self.mobiSageAdView;
    banner.delegate = nil;
    
	[self cleanupDummyHackTimer];
	gReceiver.adatper = nil;
}

- (void)cleanupDummyRetain {
	[super cleanupDummyRetain];
    
    gReceiver.adatper = nil;
    if ([adThread_ isExecuting]) {
        self.adViewView = nil;
        self.adViewDelegate = nil;
        [[AdviewObjCollector sharedCollector] addObj:self];
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {Ad_320X50,Ad_728X90,
        Ad_320X50,Ad_300X250,
        Ad_468X60,Ad_728X90};
    CGSize sizeArr[] = {CGSizeMake(320, 50), CGSizeMake(728, 90),
        CGSizeMake(320, 50), CGSizeMake(300, 250),
        CGSizeMake(468, 60), CGSizeMake(728, 90)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void) mobiSageStartShowAd: (UIView*) view
{
	AWLogInfo(@"mobiSageStartShowAd");
    [self cleanupDummyHackTimer];
    
    [self.adViewInternal addSubview:self.mobiSageAdView];
	[self.adViewView adapter:self didReceiveAdView:self.adViewInternal];
}

- (void) mobiSageStopShowAd: (UIView*) view
{
    AWLogInfo(@"mobiSageStartStopAd");
}

- (void) mobiSageWillPopAd: (UIView*) view
{
	AWLogInfo(@"mobiSageWillPopAd");
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void) mobiSageRefreshAd: (UIView*) view
{
	AWLogInfo(@"mobiSageRefreshAd");
}

- (void) mobiSageHidePopAd: (UIView*) view
{
	AWLogInfo(@"mobiSageHidePopAd");
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void) mobiSageActionError: (UIView*) view
{
	AWLogInfo(@"mobiSageActionError");
}

- (void)dealloc {
	AWLogInfo(@"adapter mobisage dealloc");
    if ([adThread_ isExecuting]) [adThread_ cancel];
    [adThread_ release];
    adThread_ = nil;
	
    [self.mobiSageAdView removeFromSuperview];
	self.mobiSageAdView = nil;
	
    [self cleanupDummyHackTimer];
	
	[self.adViewInternal removeFromSuperview];
    self.adViewInternal = nil;
    self.adNetworkView = nil;
	
	[super dealloc];
}

#pragma mark delegate methods.

- (UIViewController *)viewControllerToPresent {
    return [adViewDelegate viewControllerForPresentingModalView];
}

@end
