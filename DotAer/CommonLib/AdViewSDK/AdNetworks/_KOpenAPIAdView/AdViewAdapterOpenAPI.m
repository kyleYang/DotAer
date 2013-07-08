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
#import "AdViewAdapterOpenAPI.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterOpenAPI (PRIVATE)
@end


@implementation AdViewAdapterOpenAPI

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAdviewApp;
}

+ (void)load {
    //should implement in subclass.
}

- (int)OpenAPIAdType {
    return KOPENAPIADTYPE_DEFAULT;
}

- (void)getAd {
	Class OpenAPIAdOnClass = NSClassFromString (@"KOpenAPIAdView");
	
	if (nil == OpenAPIAdOnClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no OpenAPI lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
	
	KOpenAPIAdView *adView = [OpenAPIAdOnClass requestOfSize: self.sSizeAd withDelegate:self 
												  withAdType:[self OpenAPIAdType]];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	adView.location = [[AdViewExtraManager sharedManager] getLocation];
	self.adNetworkView = adView;
	[adView resumeRequestAd];
}

- (void)stopBeingDelegate {
  KOpenAPIAdView *adView = (KOpenAPIAdView *)self.adNetworkView;
	AWLogInfo(@"--OpenAPI stopBeingDelegate--");
  if (adView != nil) {
	  adView.delegate = nil;
	  [adView pauseRequestAd];
	  self.adNetworkView = nil;
  }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {KOPENAPIADVIEW_SIZE_320x50,KOPENAPIADVIEW_SIZE_728x90,
        KOPENAPIADVIEW_SIZE_320x50,KOPENAPIADVIEW_SIZE_300x250,
        KOPENAPIADVIEW_SIZE_480x60,KOPENAPIADVIEW_SIZE_728x90};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
  [super dealloc];
}

- (NSString *)appId {
	NSString *apID = networkConfig.pubId;
	
	return apID;
}

- (NSString*) kAdViewHost {
	return self.networkConfig.pubId2;
}

-(int)	autoRefreshInterval {
	return -1;
}

-(BOOL) testMode {
	return [self isTestMode];
}

-(BOOL) logMode {
	if (nil != adViewDelegate
		&& [adViewDelegate respondsToSelector:@selector(adViewLogMode)]) {
		return [adViewDelegate adViewLogMode];
	}
	return NO;
}

#pragma mark Delegate

-(UIColor*) adTextColor {
	return [self helperTextColorToUse];
}

-(UIColor*) adBackgroundColor {
	return [self helperBackgroundColorToUse];
}

-(int)gradientBgType {
	if (nil != adViewDelegate
		&& [adViewDelegate respondsToSelector:@selector(adViewAppAdBackgroundGradientType)]) {
		return [adViewDelegate adViewAppAdBackgroundGradientType];
	}
	return 0;
}

-(void) didReceivedAd: (KOpenAPIAdView*) adView {
	AWLogInfo(@"did receive an ad from OpenAPI");
    [adViewView adapter:self didReceiveAdView:adView];	
}

-(void)didFailToReceiveAd:(KOpenAPIAdView*)adView Error:(NSError*)error {
	AWLogInfo(@"adview failed from OpenAPI:%@", [error localizedDescription]);
	[adViewView adapter:self didFailAd:error];
}

-(UIViewController*)viewControllerForShowModal {
	return [adViewDelegate viewControllerForPresentingModalView];
}

- (void)adViewWillPresentScreen:(KOpenAPIAdView *)adView {
	[self helperNotifyDelegateOfFullScreenModal];	
}

- (void)adViewDidDismissScreen:(KOpenAPIAdView *)adView {
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
