//
//  AdViewAdapterDoubleClick.m
//  AdViewSDK
//
//  Created by Ma ming on 12-12-12.
//
//

#import "AdViewAdapterDoubleClick.h"
#import "adViewAdNetworkConfig.h"
#import "AdViewViewImpl.h"
#import "DFPBannerView.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterDoubleClick (PRIVATE)

- (NSArray *)testDevices;

@end

@implementation AdViewAdapterDoubleClick

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeDoubleClick;
}

+ (void)load {
	if(NSClassFromString(@"DFPBannerView") != nil && NSClassFromString(@"GADRequest") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class DoubleClickViewClass = NSClassFromString (@"DFPBannerView");
	
	if (nil == DoubleClickViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no DoubleClick lib, can not create.");
		return;
	}
    Class GADRequestClass = NSClassFromString(@"GADRequest");
    if (GADRequestClass == nil) {
        [adViewView adapter:self didFailAd:nil];
        AWLogInfo(@"no DoubleClick lib, can't create");
        return;
    }
	
	[self updateSizeParameter];
    
    DFPBannerView *DoubleClickView = [[DoubleClickViewClass alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.sSizeAd.width, self.sSizeAd.height)];
    if (nil == DoubleClickView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
    [DoubleClickView performSelector:@selector(setAdUnitID:) withObject:networkConfig.pubId];
    AWLogInfo(@"AdMob ID:%@", DoubleClickView.adUnitID);
    [DoubleClickView performSelector:@selector(setDelegate:) withObject:self];
    [DoubleClickView performSelector:@selector(setRootViewController:) withObject:[adViewDelegate viewControllerForPresentingModalView]];
    //[adMobView loadRequest:[GADRequestClass performSelector: @selector(request)]];
	GADRequest *request = [GADRequestClass request];
	//request.testDevices = [self testDevices];
	request.testing = [self isTestMode];
	if ([self helperUseGpsMode] && nil != [AdViewExtraManager sharedManager]) {
		CLLocation *loc = [[AdViewExtraManager sharedManager] getLocation];
		if (nil != loc)
			[request setLocationWithLatitude:loc.coordinate.latitude
								   longitude:loc.coordinate.longitude
									accuracy:loc.horizontalAccuracy];
	}
    [DoubleClickView loadRequest:request];
    self.adNetworkView = DoubleClickView;
    [DoubleClickView release];
}

- (void)stopBeingDelegate {
    DFPBannerView *DoubleClickView = (DFPBannerView *)self.adNetworkView;
    if (DoubleClickView != nil) {
        [DoubleClickView performSelector:@selector(setDelegate:) withObject:nil];
        [DoubleClickView performSelector:@selector(setRootViewController:) withObject:nil];
        self.adNetworkView = nil;
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    BOOL isLandscape = [self helperIsLandscape];
    CGSize size1 = isLandscape?CGSizeMake(480, 32):CGSizeMake(320, 50);
    CGSize size2 = isLandscape?CGSizeMake(1024, 90):CGSizeMake(768, 50);
    CGSize sizeArr[] = {size1,size2,
        size1,CGSizeMake(300, 250),
        CGSizeMake(468, 60),size2};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    [adViewView adapter:self didReceiveAdView:view];
}

- (void)adView:(DFPBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
	AWLogInfo(@"AdView fail from DoubleClick.Error:%@", [error localizedDescription]);
    [adViewView adapter:self didFailAd:error];
}

- (void)adViewWillPresentScreen:(DFPBannerView *)adView
{
    //[self helperNotifyDelegateOfFullScreenModal];
    [self helperNotifyDelegateOfFullScreenModal];
}
- (void)adViewDidDismissScreen:(DFPBannerView *)adView
{
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (NSArray *)testDevices {
    if ([adViewDelegate respondsToSelector:@selector(adViewTestMode)]
        && [adViewDelegate adViewTestMode]) {
        return [NSArray arrayWithObjects:
                GAD_SIMULATOR_ID,                             // Simulator
                nil];
    }
    return nil;
}

@end

