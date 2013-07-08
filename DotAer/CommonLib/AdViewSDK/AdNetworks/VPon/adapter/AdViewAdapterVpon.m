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
#import "AdViewAdapterVpon.h"
#import "AdOnPlatform.h"

@interface AdViewAdapterVpon ()
- (NSString *) adonLicenseKey;
@end


@implementation AdViewAdapterVpon

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeVPON;
}

+ (void)load {
	if(NSClassFromString(@"VponAdOn") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];	
	}
}

- (void)getAd {
	Class vponAdOnClass = NSClassFromString (@"VponAdOn");
	
	if (nil == vponAdOnClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no vpon lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
	
	[vponAdOnClass initializationPlatform:CN];
	AWLogInfo(@"Vpon version:%@",[vponAdOnClass getVersionVpon]);	
	
	if ([self isTestMode]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"VPON_UDID" object:nil];
	}
    
    [[vponAdOnClass sharedInstance] setIsVponLogo:YES];
	[[vponAdOnClass sharedInstance] setLocationOnOff:[self helperUseGpsMode]];

    
    UIViewController *vpon = [[vponAdOnClass sharedInstance] adwhirlRequestDelegate:self 
																  licenseKey:[self adonLicenseKey] 
																		size:self.sSizeAd];
	if (nil == vpon) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	UIView *adView = vpon.view;
	
	adView.backgroundColor = [self helperBackgroundColorToUse];
	self.adNetworkView = adView;
}

- (void)stopBeingDelegate {
  UIView *adView = (UIView *)self.adNetworkView;
	AWLogInfo(@"--Vpon stopBeingDelegate--");
  if (adView != nil) {
	  self.adNetworkView = nil;
  }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {ADON_SIZE_320x48,ADON_SIZE_700x105,
        ADON_SIZE_320x48,ADON_SIZE_320X270,
        ADON_SIZE_480x72,ADON_SIZE_700x105};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
  [super dealloc];
}

//return your adon Licenese Key
- (NSString *) adonLicenseKey {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(VponAdOnApIDString)]) {
		apID = [adViewDelegate VponAdOnApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"f2d0d34b319804690131a50de5900099";//@"fixme";
	
}

#pragma mark Delegate

#pragma mark 回傳點擊點廣是否有效
- (void)onClickAd:(UIViewController *)bannerView withValid:(BOOL)isValid withLicenseKey:(NSString *)adLicenseKey
{
	AWLogInfo(@"vpon click:%d", isValid);
}

#pragma mark 回傳Vpon廣告抓取成功
- (void)onRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey
{
	AWLogInfo(@"did receive an ad from vpon, %@", bannerView);
    [bannerView.view setAutoresizingMask:UIViewAutoresizingNone];
    [adViewView adapter:self didReceiveAdView:bannerView.view];	
}

#pragma mark 回傳Vpon廣告抓取失敗
- (void)onFailedToRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey
{
	AWLogInfo(@"adview failed from vpon");
	[adViewView adapter:self didFailAd:nil];		
}

@end
