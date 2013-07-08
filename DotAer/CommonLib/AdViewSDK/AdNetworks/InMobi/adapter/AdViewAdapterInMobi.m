/*
 adview openapi ad-InMobi.
 */

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterInMobi.h"
#import "AdViewExtraManager.h"
#import "IMCommonUtil.h"

@interface AdViewAdapterInMobi ()
@end


@implementation AdViewAdapterInMobi

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeInMobi;
}

+ (void)load {
	if(NSClassFromString(@"IMAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class IMAdViewClass = NSClassFromString (@"IMAdView");
	
	if (nil == IMAdViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no inmobi lib, can not create.");
		return;
	}
    Class IMAdRequestClass = NSClassFromString(@"IMAdRequest");
    if (IMAdRequestClass == nil) {
        [adViewView adapter:self didFailAd:nil];
        AWLogInfo(@"no inmobi lib, can't create");
        return;
    }
    
    Class IMCommonUtilClass = NSClassFromString(@"IMCommonUtil");
    [IMCommonUtilClass setDeviceIdMask:(IMDevice_ExcludeUDID)];
    
	[self updateSizeParameter];
        
	IMAdView *inmobiAdView = [[IMAdViewClass alloc]
                              initWithFrame:self.rSizeAd
                              imAppId:[self appId]
                              imAdSize:self.nSizeAd
                              rootViewController:[adViewDelegate viewControllerForPresentingModalView]];
    inmobiAdView.delegate = self;
	if (nil == inmobiAdView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
    IMAdRequest *request = [IMAdRequestClass request];
    /**
     * additional targeting parameters. these are optional
     */
    //request.gender = kIMGenderMale;
    //request.education = kIMEducationBachelorsDegree;
    // etc ..
    
    /**
     * Make sure to set testMode to NO before submitting to App Store.
     */
    request.testMode = [self isTestMode];
    inmobiAdView.imAdRequest = request;
    [inmobiAdView setRefTag:@"adsAdview" forKey:@"ref-tag"];
    [inmobiAdView loadIMAdRequest];
    self.adNetworkView = inmobiAdView;
    [inmobiAdView release];
}

- (void)stopBeingDelegate {
    IMAdView *inmobiAdView = (IMAdView *)self.adNetworkView;
    if (inmobiAdView != nil) {
        [inmobiAdView performSelector:@selector(setDelegate:) withObject:nil];
        [inmobiAdView performSelector:@selector(setRootViewController:) withObject:nil];
        self.adNetworkView = nil;
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {IM_UNIT_320x50,IM_UNIT_728x90,
        IM_UNIT_320x50,IM_UNIT_300x250,
        IM_UNIT_468x60,IM_UNIT_728x90};
    CGSize sizeArr[] = {CGSizeMake(320, 50),CGSizeMake(728, 90),
        CGSizeMake(320, 50),CGSizeMake(300, 250),
        CGSizeMake(468, 60),CGSizeMake(728, 90)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (NSString *) appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(inmobiApIDString)]) {
		apID = [adViewDelegate inmobiApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	return apID;
	
#if 0
	return @"4f0acf110cf2f1e96d8eb7ea";		//4f0acf110cf2f1e96d8eb7ea
#endif
}

#pragma mark delegate 

- (void)adViewDidFinishRequest:(IMAdView *)adView {
     [adViewView adapter:self didReceiveAdView:adView];
}

- (void)adView:(IMAdView *)view didFailRequestWithError:(IMAdError *)error {
    [adViewView adapter:self didFailAd:error];
}

- (void)adViewDidDismissScreen:(IMAdView *)adView {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)adViewWillDismissScreen:(IMAdView *)adView {
}

- (void)adViewWillPresentScreen:(IMAdView *)adView {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adViewWillLeaveApplication:(IMAdView *)adView {
}

@end
