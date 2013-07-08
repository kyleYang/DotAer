/*
 adview openapi ad-suizong.
 */

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterMiidi.h"
#import "AdViewExtraManager.h"
#import "MiidiAdView.h"
#import "MiidiManager.h"
#import "SingletonAdapterBase.h"

@interface AdViewAdapterMiidi ()

@end

@interface AdViewAdapterMiidiImpl : SingletonAdapterBase<MiidiAdViewDelegate>
{
}

@end

static AdViewAdapterMiidiImpl *gAdViewAdapterMiidiImpl = nil;

@implementation AdViewAdapterMiidi

@synthesize bGotInGet;

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeUserDefined;
}

+ (void)load {
	if(NSClassFromString(@"MiidiAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];	
	}
}

- (void)getAd {
	Class MiidiAdViewClass = NSClassFromString (@"MiidiAdView");
	Class MiidiManagerClass = NSClassFromString (@"MiidiManager");
	
	if (nil == MiidiAdViewClass || nil == MiidiManagerClass) {
		[self.adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no Miidi lib, can not create.");
		return;
	}
	
	if (nil == gAdViewAdapterMiidiImpl) gAdViewAdapterMiidiImpl = [[AdViewAdapterMiidiImpl alloc] init];
	[gAdViewAdapterMiidiImpl setAdapterValue:YES ByAdapter:self];
	
	[MiidiManagerClass setAppPublisher:self.networkConfig.pubId 
					withAppSecret:self.networkConfig.pubId2
					 withTestMode:[self isTestMode]];
	
	[MiidiManagerClass setMarketChannelID:999];
	
	MiidiAdView *adView = (MiidiAdView*)[[gAdViewAdapterMiidiImpl getIdelAdView] retain];
	if (nil == adView) {
		[self.adViewView adapter:self didFailAd:nil];
		return;
	}
	self.adNetworkView = adView;
	
	if (self.bGotInGet)				//got in getIdelAdView, so added here.
		[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
	else {
		//[self.adViewView adapter:self shouldAddAdView:self.adNetworkView];
	}
	
	[adView release];
}

//can being delegate even more than one instances being delegate.
- (BOOL) canMultiBeingDelegate
{
    return NO;
}

- (void)stopBeingDelegate {
	MiidiAdView *adView = (MiidiAdView *)self.adNetworkView;
	AWLogInfo(@"--Miidi stopBeingDelegate--");
	[gAdViewAdapterMiidiImpl setAdapterValue:NO ByAdapter:self];
	if (adView != nil) {
		//[gAdViewAdapterMiidiImpl addIdelAdView:adView];
		
		[adView removeFromSuperview];
		adView.delegate = nil;
		AWLogInfo(@"MiidiAdView retain:%d", [adView retainCount]);		
		self.adNetworkView = nil;
	}
}

- (void)cleanupDummyRetain {
	[super cleanupDummyRetain];
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {MiidiAdSize320x50,MiidiAdSize768x72,
        MiidiAdSize320x50,MiidiAdSize200x200,
        MiidiAdSize460x72,MiidiAdSize768x72};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void)dealloc {	
	[super dealloc];
}

@end

@implementation AdViewAdapterMiidiImpl

- (UIView*)makeAdView {
	Class MiidiAdViewClass = NSClassFromString (@"MiidiAdView");
	
	if (nil == MiidiAdViewClass) {
		[mAdapter.adViewView adapter:mAdapter didFailAd:nil];
		AWLogInfo(@"no Miidi lib, can not create.");
		return nil;
	}
	
	[mAdapter updateSizeParameter];
	
	MiidiAdView *adView = [[MiidiAdViewClass alloc]
                           initMiidiAdViewWithContentSizeIdentifier:mAdapter.nSizeAd
																				  
                           delegate:self];
	
	return [adView autorelease];
}

#pragma mark Delegate


- (void)didReceiveAd:(MiidiAdView *)adView
{
	AWLogInfo(@"did receive an ad from Miidi:%@", mAdapter);
	if (nil != mAdapter) {
		if (nil != mAdapter.adNetworkView) {
			[mAdapter.adViewView adapter:mAdapter didReceiveAdView:mAdapter.adNetworkView];
		} else {
			((AdViewAdapterMiidi*)mAdapter).bGotInGet = YES;
		}
	}
}

// 请求广告条数据失败后调用
// 
// 详解:当接收服务器返回的广告数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveAd:(MiidiAdView *)adView  error:(NSError *)error
{
	AWLogInfo(@"adview failed from Miidi:%@", [error localizedDescription]);
	[mAdapter.adViewView adapter:mAdapter didFailAd:error];	
}

// 显示全屏广告成功后调用
//
// 详解:显示一次全屏广告内容后调用该函数
- (void)didShowAdWindow:(MiidiAdView *)adView
{
	AWLogInfo(@"didShowAdWindow from Miidi");
	[mAdapter helperNotifyDelegateOfFullScreenModal];
}

// 成功关闭全屏广告后调用
//
// 详解:全屏广告显示完成，关闭全屏广告后调用该函数
- (void)didDismissAdWindow:(MiidiAdView *)adView
{
	AWLogInfo(@"didDismissAdWindow from Miidi");
	[mAdapter helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
