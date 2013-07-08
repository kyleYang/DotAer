/*
 adview openapi ad-OpenAPI.
*/

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterYunyun.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterYunyun (PRIVATE)
@end


@implementation AdViewAdapterYunyun

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeYunyun;
}

+ (void)load {
    if (nil != NSClassFromString (@"YRView")) {
        [[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
    }
}

- (void)getAd {
	Class YRViewClass = NSClassFromString (@"YRView");
	
	if (nil == YRViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no Yunyun lib, can not create.");
		return;
	}
    
    [YRViewClass setUserAppId:networkConfig.pubId];//networkConfig.pubId
    [YRViewClass setIsTestMode:[self isTestMode]];
    [YRViewClass setRefreshTime:90];
    [YRViewClass setCustExtr:[NSDictionary dictionaryWithObject:@"FRADVIEW_1.7.2" forKey:@"channel"]];
	[self updateSizeParameter];
    
    UIViewController *rootController = [adViewDelegate viewControllerForPresentingModalView];
    
	YRView *adView = [YRViewClass requestYRViewWithYRDelegate:self withFormat:self.nSizeAd withRootTarget:rootController scale:1.0f];
    adView.frame = self.rSizeAd;
    adView.backgroundColor = [self helperBackgroundColorToUse];
    self.adNetworkView = adView;
}

- (void)stopBeingDelegate {
    YRView *adView = (YRView *)self.adNetworkView;
	AWLogInfo(@"--Yunyun stopBeingDelegate--");
    if (adView != nil) {
        //self.adNetworkView = nil;
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {YRViewFormat_iPhone_320_48_mb,YRViewFormat_iPad_728_90_pad,
        YRViewFormat_iPhone_320_48_mb,YRViewFormat_iPad_300_250_pad,
        YRViewFormat_iPad_468_60_pad,YRViewFormat_iPad_728_90_pad};
    
    CGSize sizeArr[] = {CGSizeMake(320, 48), CGSizeMake(728, 90),
        CGSizeMake(320, 48), CGSizeMake(300, 250),
        CGSizeMake(468, 60), CGSizeMake(728, 90),
    };
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void)dealloc {
    YRView *adView = (YRView *)self.adNetworkView;
    [adView removeFromSuperview];
    [adView destroy];
    self.adNetworkView = nil;
    
    [super dealloc];
}

#pragma mark Delegate

-(void)yrViewDidReceiveAdRequest:(YRView *)yrView {
    [adViewView adapter:self didReceiveAdView:yrView];
}

- (void)yrViewDidFailedToReceiveAd:(YRView *)yrView {
    [adViewView adapter:self didFailAd:nil];
}

- (void)actionViewWillAppear:(YRView *)yrView {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)actionViewDidAppear:(YRView *)yrView {
    
}

- (void)actionViewWillDisappear:(YRView *)yrView {
    
}

- (void)actionViewDidDisappear:(YRView *)yrView {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
