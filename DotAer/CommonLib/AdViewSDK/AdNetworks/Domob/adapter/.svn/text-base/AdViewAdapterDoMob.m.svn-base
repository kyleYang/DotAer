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
#import "DMTools.h"
#import "AdViewAdapterDoMob.h"

#define TestUserSpot @"all"

@interface AdViewAdapterDoMob ()
- (NSString *)appIdForAd;
@end


@implementation AdViewAdapterDoMob

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeDOMOB;
}

+ (void)load {
	if(NSClassFromString(@"DMAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class dMAdViewClass = NSClassFromString (@"DMAdView");
	
	if (nil == dMAdViewClass) {
		AWLogInfo(@"no domob lib, can not create.");		
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	DMAdView* adView = (DMAdView*)[[self makeAdView] retain];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	self.adNetworkView = adView;
    [adView loadAd]; // 开始加载广告
    
    // 检查更新提
#if 0
	Class dmToolsClass = NSClassFromString (@"DMTools");
	if (nil != dmToolsClass) {
		DMTools *dmTools = [[DMTools alloc] initWithPublisherId:[self appIdForAd]];
		[dmTools checkRateInfo];
		[dmTools release];
	}
#endif
    [adView release];
    [self setupDefaultDummyHackTimer];
}

- (void)stopBeingDelegate {
  DMAdView *adView = (DMAdView *)self.adNetworkView;
  AWLogInfo(@"--Domob stopBeingDelegate--");
	
  if (adView != nil) {
	  adView.delegate = nil;
	  adView.rootViewController = nil;
  }
	self.adNetworkView = nil;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {DOMOB_AD_SIZE_320x50,DOMOB_AD_SIZE_728x90,
        DOMOB_AD_SIZE_320x50,DOMOB_AD_SIZE_300x250,
        DOMOB_AD_SIZE_488x80,DOMOB_AD_SIZE_728x90};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
  [super dealloc];
}

- (NSString *)appIdForAd {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(DoMobApIDString)]) {
		apID = [adViewDelegate DoMobApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"56OJycJIuMWsQqo0JM";
}

- (UIView*)makeAdView {
	Class dMAdViewClass = NSClassFromString (@"DMAdView");
	
	if (nil == dMAdViewClass) {
		AWLogInfo(@"no domob lib, can not create.");
		return nil;
	}
	
	if (nil == self) {
		AWLogInfo(@"have not set domob adapter.");
		return nil;
	}
	
	AdViewAdapterDoMob *adapter = (AdViewAdapterDoMob*)self;
	
	[adapter updateSizeParameter];
	DMAdView* adView = [[dMAdViewClass alloc] initWithPublisherId:[adapter appIdForAd]
                                                      placementId:networkConfig.pubId2
															 size:adapter.sSizeAd
													  autorefresh:NO];
	if (nil == adView) {
		AWLogInfo(@"did not alloc DMAdView");
		return nil;
	}
	
    adView.delegate = self; // 设置 Delegate
    adView.rootViewController = [self.adViewDelegate viewControllerForPresentingModalView];
	
	return [adView autorelease];
}

#pragma mark DoMobDelegate methods

// 成功加载广告后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    AWLogInfo(@"Domob success to load ad.");
	
    [self cleanupDummyHackTimer];
	[self.adViewView adapter:self didReceiveAdView:adView];
}

// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    AWLogInfo(@"Domob fail to load ad. %@", error);
	
    [self cleanupDummyHackTimer];
	[self.adViewView adapter:self didFailAd:error];
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    AWLogInfo(@"Domob will present modal view.");    
	[self helperNotifyDelegateOfFullScreenModal];
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    AWLogInfo(@"Domob did dismiss modal view.");
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
