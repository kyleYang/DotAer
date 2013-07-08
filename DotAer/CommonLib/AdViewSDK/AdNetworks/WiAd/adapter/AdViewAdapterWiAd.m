/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterWiAd.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "WiAdView.h"

@interface AdViewAdapterWiAd ()
-(void) WiAdDidFailLoad:(WiAdView*)adView;
-(NSString *)appId:(WiAdView *)adView;
@end

@implementation AdViewAdapterWiAd

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeWIYUN;
}

+ (void)load {
	if(NSClassFromString(@"WiAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class WiAdViewClass = NSClassFromString (@"WiAdView");
	
	if (nil == WiAdViewClass) {
		[self WiAdDidFailLoad:nil];
		AWLogInfo(@"no WiAd lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
	//WiAdView* adView = [WiAdViewClass adViewWithResId:[self appId:nil]];//@"填入广告位id"
	WiAdView* adView = [WiAdViewClass adViewWithResId:[self appId:nil] style: self.nSizeAd];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}

	//adView.frame = self.rSizeAd;

    //设置Delegate对象
    adView.delegate = self;
    //设置广告背景色
    adView.adBgColor = [self helperBackgroundColorToUse];
	adView.adTextColor = [self helperTextColorToUse];
	
	[adView requestAd];
	
	self.adNetworkView = adView;
}

- (void)stopBeingDelegate {
  WiAdView *adView = (WiAdView *)self.adNetworkView;
	AWLogInfo(@"--WiAd stopBeingDelegate--");
  if (adView != nil) {
	  adView.delegate = nil;
  }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {kWiAdViewStyleBanner320_50,kWiAdViewStyleBanner768_110,
        kWiAdViewStyleBanner320_50,kWiAdViewStyleBanner320_270,
        kWiAdViewStyleBanner508_80,kWiAdViewStyleBanner768_110};
    CGRect rectArr[] = {CGRectMake(0, 0, 320, 50), CGRectMake(0, 0, 768, 110),
         CGRectMake(0, 0, 320, 50), CGRectMake(0, 0, 320, 270),
         CGRectMake(0, 0, 508, 80), CGRectMake(0, 0, 768, 110)};
    
    [self setSizeParameter:flagArr rect:rectArr];
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark MMAdDelegate methods

/**
 *	Be sure to return the id you get from WiAd
 */
- (NSString *)appId:(WiAdView *)adView {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(WiAdApIDString)]) {
		apID = [adViewDelegate WiAdApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
}

- (void)WiAdDidLoad:(WiAdView*)adView{
    //广告加载成功    
	AWLogInfo(@"loaded WiYun Ad!");
	[adView setHidden:NO];
    [adViewView adapter:self didReceiveAdView:adView];
}

- (void)WiAdDidFailLoad:(WiAdView*)adView{
    //广告加载失败
	AWLogInfo(@"WiYun ad fail to load!");
	[adView setHidden:YES];
    [adViewView adapter:self didFailAd:nil];
}

#pragma mark requestData optional methods

// The follow is kept for gathering requestData

- (BOOL)respondsToSelector:(SEL)selector {
  return [super respondsToSelector:selector];
}

@end
