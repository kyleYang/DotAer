/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterAirAD.h"
#import "airADView.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewViewImpl.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

@interface AdViewAdapterAirAD (PIRVATE)

- (NSString *)appId;

@end


@implementation AdViewAdapterAirAD

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeAirAD;
}

+ (void)load {
	if(NSClassFromString(@"airADView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class airADViewClass = NSClassFromString (@"airADView");
	
	if (nil == airADViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no airAd lib support, can not create.");
		return;
	}
	
	//设置AppID
	[airADViewClass setAppID:[self appId]];
	//设置是否显示提示信息。方便开发调试。
//	[airADViewClass setDebugMode:[self isTestMode]?DEBUG_ON:DEBUG_OFF];
	//设置是否需要取得GPS信息，为得到高质量的广告，建议打开。
	[airADViewClass setGPSOn:[self helperUseGpsMode]];
	
	airADView *airBanner = [[airADViewClass alloc] init];
	if (nil == airBanner) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	[self updateSizeParameter];
	
	CGRect r = CGRectMake(0, 0, AD_SIZE_320x54.width, AD_SIZE_320x54.height);
	
	[airBanner setFrame:r];
	[airBanner setDelegate:self];
//	[airBanner setBannerBGMode:BannerBG_ON];
	//设置刷新时必须大于15。单位秒。
	[airBanner setIntervalTime:30];
	//设置刷新模式，自动或者手动。设置为手动，则刷新时间的设置无效,并且需要每次主动调用refreshAd。
	[airBanner setRefreshMode:REFRESH_MODE_AUTO];

	self.adNetworkView = airBanner;
    [airBanner requestAd];
	[airBanner release];
    [self setupDefaultDummyHackTimer];
}

- (void)stopBeingDelegate {
	airADView *airBanner = (airADView *)self.adNetworkView;
	AWLogInfo(@"airAd stop being delegate");
	[self cleanupDummyHackTimer];
	if (airBanner != nil) {
		airBanner.delegate = nil;
	}
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {0,0,
        0,0,
        0,0};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void)dealloc {    
	[super dealloc];
}

#pragma mark util

- (NSString *)appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(AirADAppIDString)]) {
		apID = [adViewDelegate AirADAppIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
    
	return apID;
	//return @"123456789";
}

#pragma mark AirADDelegate methods

- (void)airADDidReceiveAD:(airADView*)view {
    [self cleanupDummyHackTimer];
    
	[adViewView adapter:self didReceiveAdView:view];
}

- (void)airADView:(airADView *)view didFailToReceiveAdWithError:(NSError *)error {
	[self cleanupDummyHackTimer];
	
	[adViewView adapter:self didFailAd:error];
}

- (void)airADWillShowContent:(airADView *)adView {
	[self helperNotifyDelegateOfFullScreenModal];
}

- (void)airADDidHideContent:(airADView *)adView {
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
