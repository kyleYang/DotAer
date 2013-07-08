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
#import "CaseeAdView.h"
#import "AdViewAdapterCaseE.h"
#import "AdviewObjCollector.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterCaseeAd ()
- (void)adView:(CaseeAdView *)adView failedWithError:(NSError *)error;
@end


@implementation AdViewAdapterCaseeAd

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeCASEE;
}

+ (void)load {
	if(NSClassFromString(@"CaseeAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class caseeAdViewClass = NSClassFromString (@"CaseeAdView");
	
	if (nil == caseeAdViewClass) {
		[self adView:nil failedWithError:nil];
		AWLogInfo(@"no adchina lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
	CaseeAdView* caseeView = [[caseeAdViewClass adViewWithDelegate:self caseeRectStyle:self.nSizeAd] retain];
	
	self.adNetworkView = caseeView;
	[caseeView refreshAd];
	[caseeView release];
	
	self.bWaitAd = YES;
}

- (void)stopBeingDelegate {
	CaseeAdView *caseeView = (CaseeAdView *)adNetworkView;
	AWLogInfo(@"--Casee stopBeingDelegate--");
	if (caseeView != nil) {
		[caseeView stopAdRotation];
		self.adNetworkView = nil;
	}
}

- (void)cleanupDummyRetain {
	[super cleanupDummyRetain];
	
	if (self.bWaitAd) {	//added to collector
		self.adViewView = nil;
		[[AdviewObjCollector sharedCollector] addObj:self];
	}
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {CaseeAdSizeIdentifier_320x50,CaseeAdSizeIdentifier_728x90,
        CaseeAdSizeIdentifier_320x50,CaseeAdSizeIdentifier_300x250,
        CaseeAdSizeIdentifier_364x60,CaseeAdSizeIdentifier_728x90};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark MMAdDelegate methods

/**
 * app id assigned in casee.cn. This will be used in an ad request to identify this app.
 */
- (NSString *)appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(caseeApIDString)]) {
		apID = [adViewDelegate caseeApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"A20B4DA7124A102A13FBF20E72E6F5F4";
}

- (BOOL)allowShareLocation {
    return [self helperUseGpsMode];
}

// let the SDK get current location.
- (CLLocation *)location {
    return [[AdViewExtraManager sharedManager] getLocation];
}

// Other information may send with an ad request
- (NSString *)keywords {
    return @"";
}

/**
 * An ad view did recieve an ad. This is called from a background thread.
 */
- (void)didReceiveAdIn:(CaseeAdView *)adView
{
    AWLogInfo(@"adview did receive an ad from CASEE");
    [adViewView adapter:self didReceiveAdView:adView];
	
	self.bWaitAd = NO;
}

/**
 * An ad view failed to get ad.  This is called from a background thread.
 */
- (void)adView:(CaseeAdView *)adView failedWithError:(NSError *)error
{
    AWLogInfo(@"adview failed with error: %@", error);
	[adViewView adapter:self didFailAd:error];
	
	self.bWaitAd = NO;
}

/**
 * Will show landing page.  Normally it's a full screen view or a modal view.
 * It's time to stop animations or other time sensitive interactions.
 */
- (void)willShowFullScreenAd
{
	AWLogInfo(@"CaseeAdView will show full screen ad.");
	[self helperNotifyDelegateOfFullScreenModal];
}

/**
 * Close the landing page.  It's time to resume anything you stopped in -willShowLandingPage.
 */
- (void)didCloseFullScreenAd
{
	AWLogInfo(@"CaseeAdView did close full screen ad.");
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

//
// test settings
//

/**
 * Specify whether this is in test(development) mode or production mode. Default is NO.
 */ 
- (BOOL)isTestMode {
	return [super isTestMode];
}

/**
 * ad rotation interval. default is 30 seconds.
 * return 0 means never rotate. minimal is 12 seconds.
 */
- (NSTimeInterval)adInterval
{
	return 40;
}

@end
