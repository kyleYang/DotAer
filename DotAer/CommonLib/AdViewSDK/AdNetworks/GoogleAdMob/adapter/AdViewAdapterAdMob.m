/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterAdMob.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewViewImpl.h"
#import "GADBannerView.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterAdMob (PRIVATE)

- (NSArray *)testDevices;

@end



@implementation AdViewAdapterAdMob

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAdMob;
}

+ (void)load {
	if(NSClassFromString(@"GADBannerView") != nil && NSClassFromString(@"GADRequest") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class adMobViewClass = NSClassFromString (@"GADBannerView");
	
	if (nil == adMobViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no admob lib, can not create.");
		return;
	}
    Class GADRequestClass = NSClassFromString(@"GADRequest");
    if (GADRequestClass == nil) {
        [adViewView adapter:self didFailAd:nil];
        AWLogInfo(@"no admob lib, can't create");
        return;
    }
	
	[self updateSizeParameter];

    GADBannerView *adMobView = [[adMobViewClass alloc] initWithFrame:
								CGRectMake(0.0f, 0.0f, self.sSizeAd.width, self.sSizeAd.height)];
	if (nil == adMobView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}

    [adMobView performSelector:@selector(setAdUnitID:) withObject:networkConfig.pubId];
    AWLogInfo(@"AdMob ID:%@", adMobView.adUnitID);
    [adMobView performSelector:@selector(setDelegate:) withObject:self];
    [adMobView performSelector:@selector(setRootViewController:) withObject:[adViewDelegate viewControllerForPresentingModalView]];
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
    [adMobView loadRequest:request];
    self.adNetworkView = adMobView;
    [adMobView release];
}

- (void)stopBeingDelegate {
  GADBannerView *adMobView = (GADBannerView *)self.adNetworkView;
  if (adMobView != nil) {
      [adMobView performSelector:@selector(setDelegate:) withObject:nil];
      [adMobView performSelector:@selector(setRootViewController:) withObject:nil];
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
    CGSize size2 = isLandscape?CGSizeMake(1024, 90):CGSizeMake(768, 90);
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

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
	AWLogInfo(@"AdView fail from AdMob.Error:%@", [error localizedDescription]);
    [adViewView adapter:self didFailAd:error];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    //[self helperNotifyDelegateOfFullScreenModal];
    [self helperNotifyDelegateOfFullScreenModal];
}
- (void)adViewDidDismissScreen:(GADBannerView *)adView
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
