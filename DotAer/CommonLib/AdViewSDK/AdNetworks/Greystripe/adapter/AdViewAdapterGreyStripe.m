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
#import "AdViewAdapterGreyStripe.h"
#import "AdViewExtraManager.h"
#import "GSBannerAdView.h"

@interface AdViewAdapterGreyStripe ()
- (NSString *) appId;
@end


@implementation AdViewAdapterGreyStripe

@synthesize bannerName = _bannerName;

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeGreyStripe;
}

+ (void)load {
	if(NSClassFromString(@"GSMobileBannerAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];	
	}
}

- (void)getAd {
	Class GreyStripeClass = NSClassFromString (@"GSMobileBannerAdView");
	
	if (nil == GreyStripeClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no GreyStripe lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
    GreyStripeClass = NSClassFromString (self.bannerName);
    if (nil == GreyStripeClass){
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no GreyStripe lib, can not create.");
		return;
	}
	
	GSBannerAdView *adView = [[GreyStripeClass alloc] initWithDelegate:self  GUID:[self appId] autoload:NO];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	self.adNetworkView = adView;
	[adView fetch];
    [adView release];
}


//Can being delegate even more than one instances being delegate.
- (BOOL) canMultiBeingDelegate
{
    return NO;
}

- (void)stopBeingDelegate {
  GSBannerAdView *adView = (GSBannerAdView *)self.adNetworkView;
  AWLogInfo(@"--GreyStripe stopBeingDelegate--");
  if (adView != nil) {
	  adView.delegate = nil;
	  self.adNetworkView = nil;
  }
}

//For BannerAdView's delegate is Retain Property, should clear.
- (void)cleanupDummyRetain {
    [super cleanupDummyRetain];
    
    GSBannerAdView *adView = (GSBannerAdView *)self.adNetworkView;
    adView.delegate = nil;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    NSString *nameArr[] = {@"GSMobileBannerAdView",@"GSLeaderboardAdView",
        @"GSMobileBannerAdView",@"GSMediumRectangleAdView",
        @"GSMobileBannerAdView",@"GSLeaderboardAdView"};
    
    int nIndex = [self getSizeIndex];
    self.bannerName = nameArr[nIndex];
}

- (void)dealloc {
  [super dealloc];
}

- (NSString *) appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(greystripeApIDString)]) {
		apID = [adViewDelegate greystripeApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	return apID;
}

- (UIViewController *)greystripeBannerDisplayViewController {
	return [adViewDelegate viewControllerForPresentingModalView];
}

-(BOOL) logMode {
	if (nil != adViewDelegate
		&& [adViewDelegate respondsToSelector:@selector(adViewLogMode)]) {
		return [adViewDelegate adViewLogMode];
	}
	return NO;
}

#pragma mark Delegate

- (void)greystripeAdFetchSucceeded:(id<GSAd>)a_ad {
	AWLogInfo(@"did receive an ad from GreyStripe");
    [adViewView adapter:self didReceiveAdView:(UIView*)a_ad];
}

- (void)greystripeAdFetchFailed:(id<GSAd>)a_ad withError:(GSAdError)a_error {
	AWLogInfo(@"adview failed from GreyStripe:%d", a_error);
	[adViewView adapter:self didFailAd:[NSError errorWithDomain:@"error code" code:a_error userInfo:nil]];
}

- (void)greystripeWillPresentModalViewController {
	[self helperNotifyDelegateOfFullScreenModal];
}

- (void)greystripeDidDismissModalViewController {
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)greystripeBannerAdWillExpand {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)greystripeBannerAdDidCollapse {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
