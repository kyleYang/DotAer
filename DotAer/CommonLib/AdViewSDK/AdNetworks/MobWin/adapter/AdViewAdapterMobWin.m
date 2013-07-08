/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterMobWin.h"
#import "MobWinBannerView.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewViewImpl.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdviewObjCollector.h"

@interface AdViewAdapterMobWin()
- (UIView*)makeAdView;
@end


@implementation AdViewAdapterMobWin

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeMobWin;
}

+ (void)load {
	if(NSClassFromString(@"MobWinBannerView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	AWLogInfo(@"MobWin getAd");
	
	Class MobWinBannerViewClass = NSClassFromString (@"MobWinBannerView");
	
	if (nil == MobWinBannerViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no mobwin lib support, can not create.");
		return;
	}
	
	MobWinBannerView *adBanner = (MobWinBannerView*)[[self makeAdView] retain];
	if (nil == adBanner) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	self.adNetworkView = adBanner;
    self.bWaitAd = YES;
	[adBanner startRequest];
	//[adViewView adapter:self didReceiveAdView:adBanner];
	[adBanner release];
}

- (void)stopBeingDelegate {
	MobWinBannerView *adBanner = (MobWinBannerView *)self.adNetworkView;
	AWLogInfo(@"mobwin stop being delegate");
	if (adBanner != nil) {
		[adBanner stopRequest];
		self.adNetworkView = nil;
	}
}

- (void)cleanupDummyRetain {
    [super cleanupDummyRetain];
    
    self.adViewView = nil;
    
    if (self.bWaitAd)
        [[AdviewObjCollector sharedCollector] addObj:self];
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {MobWINBannerSizeIdentifierUnknow,MobWINBannerSizeIdentifier728x90,
        MobWINBannerSizeIdentifierUnknow,MobWINBannerSizeIdentifier300x250,
        MobWINBannerSizeIdentifier468x60,MobWINBannerSizeIdentifier728x90};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark util

- (NSString *)appId {
	NSString *apID;
	if ([self.adViewDelegate respondsToSelector:@selector(MobWinAppIDString)]) {
		apID = [self.adViewDelegate MobWinAppIDString];
	}
	else {
		apID = self.networkConfig.pubId;
	}
    
	return apID;
	//return @"A495798C12C030F28E7711F3613DFC1B";
}

- (UIView*)makeAdView {
	Class MobWinBannerViewClass = NSClassFromString (@"MobWinBannerView");
	
	if (nil == MobWinBannerViewClass) {
		[self.adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no mobwin lib support, can not create.");
		return nil;
	}
	
	[self updateSizeParameter];
	MobWinBannerView *adBanner = [MobWinBannerViewClass instance];
    adBanner.adSizeIdentifier = self.nSizeAd;
	adBanner.adIntegrateKey = @"ben1574leo";
	if (nil == adBanner)
		return nil;
	
	adBanner.delegate = self;
	adBanner.rootViewController = [self.adViewDelegate viewControllerForPresentingModalView];
	adBanner.adUnitID = [self appId];
	//
	// 腾讯MobWIN提示：开发者可选调用
	//
	adBanner.adGpsMode = [self helperUseGpsMode];
	
	//adBanner.adTextColor = [self helperTextColorToUse];
	//adBanner.adSubtextColor = [self helperSecondaryTextColorToUse];
	//adBanner.adBackgroundColor = [self helperBackgroundColorToUse];

	self.adNetworkView = adBanner;
	//[adBanner startRequest];
	return [adBanner autorelease];
}

#pragma mark MobWinDelegate methods

// 详解:请求插播广告成功时调用
- (void)bannerViewDidReceived {
	AWLogInfo(@"mobwin bannerViewDidReceived");
	[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
    self.bWaitAd = NO;
}
 
// 详解:请求插播广告失败时调用
- (void)bannerViewFailToReceived {
	AWLogInfo(@"mobwin bannerViewFailToReceived");
	[self.adViewView adapter:self didFailAd:nil];
    self.bWaitAd = NO;
}

// 详解:将要展示一次插播广告内容前调用
- (void)bannerViewDidPresentScreen {
	AWLogInfo(@"mobwin bannerViewDidPresentScreen");
	[self helperNotifyDelegateOfFullScreenModal];
}

// 详解:插播广告展示完成，结束插播广告后调用
- (void)bannerViewDidDismissScreen {
	AWLogInfo(@"mobwin bannerViewDidDismissScreen");
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
