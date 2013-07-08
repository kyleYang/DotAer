//
//  AdViewAdapterGuomob.m
//  AdViewSDK
//
//  Created by Ma ming on 13-5-24.
//
//

#import "AdViewAdapterGuomob.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

@interface AdViewAdapterGuomob ()
- (NSString *)guomobAppId;
@end

@implementation AdViewAdapterGuomob

@synthesize guomobAdView;

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeGuomob;
}

+ (void)load {
	if(NSClassFromString(@"GuomobAdSDK") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class guomobSDKClass = NSClassFromString (@"GuomobAdSDK");
	
	if (nil == guomobSDKClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no guomob lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
    
	UIView *dummyView = [[UIView alloc] initWithFrame:self.rSizeAd];
	if (nil == dummyView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}

    guomobAdView = [guomobSDKClass initWithAppId:[self guomobAppId] delegate:self];
    
	self.adNetworkView = dummyView;
	[dummyView release];
    
    [self.guomobAdView loadAd];
    [self.adNetworkView addSubview:self.guomobAdView];
    
    [self setupDefaultDummyHackTimer];
}

- (void)stopBeingDelegate {
	AWLogInfo(@"--Guomob stopBeingDelegate--");
    GuomobAdSDK *adView = (GuomobAdSDK *)self.guomobAdView;
    [self cleanupDummyHackTimer];
    
    if (adView != nil) {
        if (!self.adNetworkView)
            [self.adNetworkView removeFromSuperview];
        if (self == adView.delegate)
            adView.delegate = nil;
        adView = nil;
        self.adNetworkView = nil;
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(728,90),
        CGSizeMake(320,50),CGSizeMake(300,250),
        CGSizeMake(480,60),CGSizeMake(728,90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - 
#pragma mark delegate

- (NSString *)guomobAppId {
    NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(guomobApIDString)]) {
		apID = [adViewDelegate guomobApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
}

- (void)loadBannerAdSuccess:(BOOL)success {
    AWLogInfo(@"Guomob success to load ad.");
    [self cleanupDummyHackTimer];
	[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

@end
