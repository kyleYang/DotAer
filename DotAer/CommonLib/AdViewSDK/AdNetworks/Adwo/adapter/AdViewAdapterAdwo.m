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
#import "AWAdView.h"
#import "AdViewAdapterAdwo.h"
#import "AdviewObjCollector.h"

@interface AdViewAdapterAdwo ()
- (NSString *)adwoPublisherIdForAd;
@end


@implementation AdViewAdapterAdwo

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeADWO;
}

+ (void)load {
	if(NSClassFromString(@"AWAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class awAdViewClass = NSClassFromString (@"AWAdView");
	
	if (nil == awAdViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no adwo lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
    AWAdView* adView = [[awAdViewClass alloc] initWithAdwoPid:[self adwoPublisherIdForAd]
                                                   adTestMode:![self isTestMode]];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
    AWLogInfo(@"Adwo view:%@", adView);
    
    adView.frame = self.rSizeAd;
    adView.delegate = self;
    
    [adView performSelector:@selector(setAGGChannel:) withObject:[NSNumber numberWithInteger:ADWOSDK_AGGREGATION_CHANNEL_ADVIEW]];    //
    
    adView.spreadChannel = ADWOSDK_AGGREGATION_CHANNEL_ADVIEW;
    
	adView.adRequestTimeIntervel = 16;//时间不要低于60s，以免影响用户体验
	adView.disableGPS = ![self helperUseGpsMode];//如果客户应用不支持定位
    
    [self addActAdViewInContain:adView rect:self.rSizeAd];
        
    AWLogInfo(@"Adwo adtype:%d", self.nSizeAd);
    [adView loadAd:self.nSizeAd];
	[adView release];
    
    [self setupDummyHackTimer:14.0f];
}

- (void)stopBeingDelegate {
    AWAdView *adView = (AWAdView *)self.actAdView;
	AWLogInfo(@"--Adwo stopBeingDelegate--");
    [self cleanupDummyHackTimer];
    
    if (adView != nil) {
        [adView pauseAd];
        if (!self.bGotView)
            [self.adNetworkView removeFromSuperview];
        else {
            //here can get image for actAdView, and to remove actAdView.
            //[self getImageOfActAdViewForRemove];
        }
        if (self == adView.delegate)
            adView.delegate = nil;
        self.adNetworkView = nil;
        self.actAdView = nil;
    }
}

- (void)cleanupDummyRetain {
    [self cleanupDummyHackTimer];
    [super cleanupDummyRetain];
    
    AWAdView *adView = (AWAdView *)self.actAdView;
    [adView pauseAd];
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110,
        ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50,
        ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110};
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(720,110),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(720,110)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark AwAdDelegate methods

- (UIViewController*)viewControllerForPresentingModalView {
    return [adViewDelegate viewControllerForPresentingModalView];
}

- (NSString *)adwoPublisherIdForAd {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(AdwoApIDString)]) {
		apID = [adViewDelegate AdwoApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"a2c491847b8e4be78b8aa223ae625e43";
}

- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)adView{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(adwoAdViewDidFailToLoadAd:)
                               withObject:adView waitUntilDone:NO];
        return;
    }
    AWLogInfo(@"adwoAdViewDidFailToLoadAd");
    [self cleanupDummyHackTimer];
    
    [adViewView adapter:self didFailAd:nil];
}

- (void)adwoAdViewDidLoadAd:(AWAdView*)adView {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(adwoAdViewDidLoadAd:)
                               withObject:adView waitUntilDone:NO];
        return;
    }
    AWLogInfo(@"adwoAdViewDidLoadAd, size: %@", NSStringFromCGRect(adView.frame));
    [self cleanupDummyHackTimer];
    
    adView.frame = self.rSizeAd;
    [adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)adwoDidPresentModalViewForAd:(AWAdView*)adView {
    AWLogInfo(@"adwoDidPresentModalViewForAd");
    AWAdView *adView1 = (AWAdView *)self.actAdView;
    [adView1 pauseAd];
    
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adwoDidDismissModalViewForAd:(AWAdView*)adView {
    AWLogInfo(@"adwoDidDismissModalViewForAd");
    AWAdView *adView1 = (AWAdView *)self.actAdView;
    [adView1 resumeAd];
    
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma Report

- (BOOL)shouldSendExMetric {
	return NO;
}

- (UIViewController*)adwoGetBaseViewController {
	if ([adViewDelegate respondsToSelector:@selector(viewControllerForPresentingModalView)])
	{
		return [adViewDelegate viewControllerForPresentingModalView];
    }
    return nil;
}

// 用于获取请求计数
- (void)adwoRequestAdAction:(AWAdView*)adView
{
    AWLogInfo(@"adwoRequestAdAction");
}

// 用于获取广告点击计数
- (void)adwoClickAdAction:(AWAdView*)adView
{
    AWLogInfo(@"adwoClickAdAction");
    
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}

// 用于获取广告展示计数
- (void)adwoShowAdAction:(AWAdView*)adView
{
    AWLogInfo(@"adwoShowAdAction");
    
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:YES];
}

@end
