/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterWooboo.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "CommonADView.h"
#import "SingletonAdapterBase.h"

@interface AdViewAdapterWooboo (PRIVATE)
- (void)didReceivedAD;
- (void)onFailedToReceiveAD:(NSString*)error;
- (NSString*)appID;
@end

@interface AdapterImp : SingletonAdapterBase<ADCommonListenerDelegate>

@end

@implementation AdapterImp

- (UIView*)makeAdView {
    Class woobooViewClass = NSClassFromString (@"CommonADView");
    if (nil == woobooViewClass) return nil;
    
    CommonADView *commonADView = [[woobooViewClass alloc]
								  initWithPID:[mAdapter performSelector:@selector(appID)]
								  locationX:0
								  locationY:0
                                  displayType:CommonBannerScreen
                                  screenOrientation:0];
    
    if (nil == commonADView)
        return nil;
    
    [commonADView performSelector:@selector(setListenerDelegate:) withObject:self];
    commonADView.requestADTimeIntervel = 20;		//
    [commonADView startADRequest];
    return [commonADView autorelease];
}

- (void)didReceivedAD
{
	[mAdapter performSelector:@selector(didReceivedAD)];
}

- (void) onFailedToReceiveAD:(NSString *)error
{
	[mAdapter performSelector:@selector(onFailedToReceiveAD:)
                       withObject:error];
}

@end


AdapterImp *gAdapterImp = nil;

@implementation AdViewAdapterWooboo

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeWOOBOO;
}

+ (void)load {
	if(NSClassFromString(@"CommonADView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

//sample @"afc507fbcab54cd2b56beacaba74efdc".
- (NSString*)appID {
    NSString *appID;
    if ([adViewDelegate respondsToSelector:@selector(woobooApIDString)]) {
        appID = [adViewDelegate woobooApIDString];
    }
    else {
        appID = networkConfig.pubId;
    }
    return appID;
}

- (void)getAd {	
	Class woobooViewClass = NSClassFromString (@"CommonADView");
	
	if (nil == woobooViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no wooboo lib, can not create.");
		return;
	}
	
	if (nil == gAdapterImp) gAdapterImp = [[AdapterImp alloc] init];
	[gAdapterImp setAdapterValue:YES ByAdapter:self];
	CommonADView *commonADView = (CommonADView*)[[gAdapterImp getIdelAdView] retain];
	if (nil == commonADView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	self.adNetworkView = commonADView;
	[commonADView release];
}

- (void)stopBeingDelegate {
    CommonADView *adView = (CommonADView *)self.adNetworkView;
	if (adView != nil) {
		[gAdapterImp addIdelAdView:adView];
        [gAdapterImp setAdapterValue:NO ByAdapter:self];
		self.adNetworkView = nil;
    }
}

- (BOOL)canMultiBeingDelegate {
    return NO;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {0,0,
        0,0,
        0,0};
    
    [self setSizeParameter:flagArr size:nil];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Woooboo methods

/* 收到广告时调用 */
- (void)didReceivedAD
{
	[adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

/* 获取广告失败的时候调用 */
- (void)onFailedToReceiveAD:(NSString*)error
{
	AWLogInfo(@"Failed from Wooboo, Error:%@", error);
    [adViewView adapter:self didFailAd:[NSError errorWithDomain:error code:-1 userInfo:nil]];
}

@end
