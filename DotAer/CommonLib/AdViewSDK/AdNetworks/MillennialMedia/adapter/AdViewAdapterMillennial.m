/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterMillennial.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

#import "AdViewExtraManager.h"
#import "AdviewObjCollector.h"

#define kMillennialAdFrame_Iphone (CGRectMake(0, 0, 320, 53))
#define kMillennialAdFrame_Ipad300x250 (CGRectMake(0, 0, 300, 250))     //not support now.
#define kMillennialAdFrame_Ipad480x60 (CGRectMake(0, 0, 480, 60))       //not support now.
#define kMillennialAdFrame_Ipad (CGRectMake(0, 0, 768, 90))

@interface AdViewAdapterMillennial ()

@end


@implementation AdViewAdapterMillennial

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeMillennial;
}

+ (void)load {
	if(NSClassFromString(@"MMAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
    NSString *apID;
    if ([adViewDelegate respondsToSelector:@selector(millennialMediaApIDString)]) {
        apID = [adViewDelegate millennialMediaApIDString];
    }
    else {
        apID = networkConfig.pubId;
    }
    
	Class mmAdViewClass = NSClassFromString (@"MMAdView");
    Class MMRequestClass = NSClassFromString (@"MMRequest");
    Class MMSDKClass = NSClassFromString(@"MMSDK");
    
    int logLevel = [self isTestMode]?MMLOG_LEVEL_DEBUG:MMLOG_LEVEL_OFF;
    [MMSDKClass setLogLevel:logLevel];
    
    MMRequest *request = nil;
	
	if (nil == mmAdViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no Millennial lib, can not create adviewview.");
		return;
	}
	if ([self helperUseGpsMode] && nil != [AdViewExtraManager sharedManager]) {
		CLLocation *loc = [[AdViewExtraManager sharedManager] getLocation];
		if (nil != loc) {
            request = [MMRequestClass requestWithLocation:loc];
        }
	}
    if (nil == request) request = [MMRequestClass request];
	
    [self updateSizeParameter];
    MMAdView *adView = [[mmAdViewClass alloc] initWithFrame:self.rSizeAd apid:apID rootViewController:[adViewDelegate viewControllerForPresentingModalView]];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
    // Notification will fire when an ad modal will appear.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalWillAppear:)
                                                 name:MillennialMediaAdModalWillAppear
                                               object:nil];
    
    // Notification will fire when an ad modal did dismiss.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidDismiss:)
                                                 name:MillennialMediaAdModalDidDismiss
                                               object:nil];
	
    self.adNetworkView = adView;
    self.bWaitAd = YES;
    [adView getAdWithRequest:request onCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [adViewView adapter:self didReceiveAdView:self.adNetworkView];
        }
        else {
            [adViewView adapter:self didFailAd:nil];
        }
        self.bWaitAd = NO;
    }];
    [adView release];
}

- (void)stopBeingDelegate {
    MMAdView *adView = (MMAdView *)self.adNetworkView;
    AWLogInfo(@"--MillennialMedia stopBeingDelegate--");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (adView != nil) {
        self.adNetworkView = nil;
    }
}

- (void)cleanupDummyRetain {
    [super cleanupDummyRetain];
    
	if (self.bWaitAd) {
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
    CGRect rectArr[] = {kMillennialAdFrame_Iphone,kMillennialAdFrame_Ipad,
        kMillennialAdFrame_Iphone,kMillennialAdFrame_Iphone,
        kMillennialAdFrame_Iphone,kMillennialAdFrame_Ipad};
    
    [self setSizeParameter:nil rect:rectArr];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark MMAdDelegate methods

- (void)adModalWillAppear:(NSNotification *)notification {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adModalDidDismiss:(NSNotification *)notification {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
