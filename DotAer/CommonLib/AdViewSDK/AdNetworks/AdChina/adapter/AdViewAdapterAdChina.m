/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterAdChina.h"
#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdChinaBannerView.h"
#import "SingletonAdapterBase.h"

#define KADCHINA_DETAULT_FRAME (CGRectMake(0,0,KADVIEW_WIDTH,64))
#define KADCHINA_LANDSCAPE_FRAME (CGRectMake(0,0,KLANDSCAPE_WIDTH,45))

#define ADCHINA_FRAME_AUTO		0

@interface AdViewAdapterAdChinaImpl : SingletonAdapterBase <AdChinaBannerViewDelegate> {
}
- (NSString *)adSpaceId;

@end

static AdViewAdapterAdChinaImpl *gAdChinaImpl = nil;

@implementation AdViewAdapterAdChina

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypeADCHINA;
}

+ (void)load {
	if(NSClassFromString(@"AdChinaBannerView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	if (nil == gAdChinaImpl)
		gAdChinaImpl = [[AdViewAdapterAdChinaImpl alloc] init];
	mDelegate = gAdChinaImpl;
	[mDelegate setAdapterValue:YES ByAdapter:self];
	
	AdChinaBannerView *adView = (AdChinaBannerView*)[[mDelegate getIdelAdView] retain];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	[adView setAnimationMask:AnimationMaskNone];
	[adView setRefreshInterval:DisableRefresh];
	
#if ADCHINA_FRAME_AUTO
	UIDeviceOrientation orientation;
	if ([self.adViewDelegate respondsToSelector:@selector(adViewCurrentOrientation)]) {
		orientation = [self.adViewDelegate adViewCurrentOrientation];
	}
	else {
		orientation = [UIDevice currentDevice].orientation;
	}
	
	if (UIDeviceOrientationIsLandscape(orientation)) {
		[adView setAdFrame:KADCHINA_LANDSCAPE_FRAME];
	} else {
		[adView setAdFrame:KADCHINA_DETAULT_FRAME];
	}
#else
    CGRect r = adView.frame;
    r.origin = CGPointMake(0, 0);
	r.size = self.sSizeAd;
    adView.frame = r;
#endif
	
	self.adNetworkView = adView;
    [adView release];
}


- (BOOL)canMultiBeingDelegate {
    return NO;
}

- (void)stopBeingDelegate {
    AdChinaBannerView *adView = (AdChinaBannerView *)self.adNetworkView;
	AWLogInfo(@"--AdChina stopBeingDelegate--");
    if (adView != nil) {
#if 0
        [mDelegate addIdelAdChinaView:adView];
#else
        //to test if adchina view can be alloced and released. if fail, should resue.
        self.adNetworkView = nil;
#endif
        [mDelegate setAdapterValue:NO ByAdapter:self];
        
        self.adNetworkView = nil;
    }
	mDelegate = nil;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {BannerSizeDefault,BannerSizeDefault,
        CGSizeMake(320, 48),BannerSizeSquare,
        BannerSizeVideo,BannerSizeDefault};
    
    [self setSizeParameter:nil size:sizeArr];
}

#if ADCHINA_FRAME_AUTO
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation {
	AdChinaView *adView = (AdChinaView *)self.adNetworkView;
	if (adView == nil) return;
	if (UIDeviceOrientationIsLandscape(orientation)) {
		[adView setAdFrame:KADCHINA_LANDSCAPE_FRAME];
	} else {
		[adView setAdFrame:KADCHINA_DETAULT_FRAME];
	}
}
#endif

- (void)dealloc {
    [super dealloc];
}

@end

@implementation AdViewAdapterAdChinaImpl

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (UIView*)makeAdView {
	AdChinaBannerView	*ret;
    
    Class adChinaViewClass = NSClassFromString (@"AdChinaBannerView");
    
    if (0 == adChinaViewClass) {
        AWLogInfo(@"no adchina lib, can not create.");
        return nil;
    }
    [mAdapter updateSizeParameter];
    ret = [adChinaViewClass requestAdWithAdSpaceId:[self adSpaceId] delegate:self
                                             adSize:mAdapter.sSizeAd];
    [ret setViewControllerForBrowser:[mAdapter.adViewDelegate viewControllerForPresentingModalView]];
	return ret;
}

- (void)dealloc {
	[mIdelViewArr release];
	[super dealloc];
}

#pragma mark AdChinaDelegate methods

/**
 *	Be sure to return the id you get from AdChina
 */
- (NSString *)adSpaceId {
	NSString *appID = @"";
	
	if ([mAdapter.adViewDelegate respondsToSelector:@selector(adChinaApIDString)]) {
		appID = [mAdapter.adViewDelegate adChinaApIDString];
	}
	else {
		appID = mAdapter.networkConfig.pubId;
	}
	return appID;
	//return @"69329";
}

- (void)didGetBanner:(AdChinaBannerView *)adView {
	if (nil != adView) {
		AWLogInfo(@"AdChina: Did receive ad:%@", NSStringFromCGSize(adView.frame.size));
    }
	
	if (![self isAdViewValid:adView]) return;
	
	[mAdapter.adViewView adapter:mAdapter didReceiveAdView:adView];
}

- (void)didFailToGetBanner:(AdChinaBannerView *)adView
{
	AWLogInfo(@"AdChina: Failed to receive ad");
	
	if (![self isAdViewValid:adView]) return;
	
	[mAdapter.adViewView adapter:mAdapter didFailAd:nil];
}

- (void)didEnterFullScreenMode
{
	[mAdapter helperNotifyDelegateOfFullScreenModal];
	AWLogInfo(@"AdChina: Did click on an ad");
}

- (void)didExitFullScreenMode
{
	[mAdapter helperNotifyDelegateOfFullScreenModalDismissal];
	AWLogInfo(@"AdChina: Did back from ad web");
}

- (NSString *)phoneNumber
{
	return @"";		// return user's phone number if possible
}

- (Sex)gender
{
	return SexUnknown;		// return user's gender if possible
}

- (NSString *)postalCode
{
	return @"";		// return user's postcode if possible
}

- (NSString *)dateOfBirth
{
	return @"";		// return user's birthday if possible
}

@end
