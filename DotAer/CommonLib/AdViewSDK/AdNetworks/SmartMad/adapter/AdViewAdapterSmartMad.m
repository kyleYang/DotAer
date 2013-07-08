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
#import "AdViewAdapterSmartMad.h"
#import "SMAdManager.h"

#define LOG_FILE_NAME  @"smartmad_log.txt"

@interface AdViewAdapterSmartMad ()
- (void)didReceiveAd:(UIView *)adView;
- (NSString *)appIdForAd:(UIView *)adView;

- (UIColor *)adBackgroundColor:(UIView *)adView;
- (UIColor *)adTextColor:(UIView *)adView;
@end

@implementation AdViewAdapterSmartMad

- (void)makeTheLogWith:(NSString*)logType{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *logPath = [documentsDirectory
                        stringByAppendingPathComponent:LOG_FILE_NAME];
    NSString *logInfo = [NSString stringWithFormat:@"%@:%@\n",
                         [[NSDate date] description], logType];
    
    FILE *fp = fopen([logPath UTF8String], "a+");
    if (NULL != fp) {
        NSData *data = [logInfo dataUsingEncoding:NSUTF8StringEncoding];
        fwrite([data bytes], [data length], 1, fp);
        fclose(fp);
    }
}

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeSMARTMAD;
}

+ (void)load {
	if(NSClassFromString(@"SMAdBannerView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class smartMadAdViewClass = NSClassFromString (@"SMAdBannerView");
	
	if (nil == smartMadAdViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no smartmad lib, can not create.");
		return;
	}
	
    Class smadManagerClass = NSClassFromString (@"SMAdManager");
    
	[smadManagerClass setApplicationId:[self appIdForAd:nil]];
    [smadManagerClass setDebugMode:[self isTestMode]];
    [smadManagerClass setAdRefreshInterval:600];
 
	//    [smartMadAdViewClass setUserAge:20];
	//    [smartMadAdViewClass setUserGender:UFemale];
	//    [smartMadAdViewClass setBirthDay:@"20110126"];
	//    [smartMadAdViewClass setFavorite:@"GAME"];
	//    [smartMadAdViewClass setCity:@"shanghia"];
	//    [smartMadAdViewClass setPostalCode:@"200336"];
	//    [smartMadAdViewClass setWork:@"it"];
	//    [smartMadAdViewClass setKeyWord:@"smartmad"];	
    [self makeTheLogWith:@"adrequest"];
	SMAdBannerView *smartView = [[smartMadAdViewClass alloc]
                                 initWithAdSpaceId:[self adPositionId]
                                 smAdSize:self.nSizeAd];

	if (nil == smartView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}	
    //[smartView setEventDelegate:self]; // set Ad Event Delegate
	smartView.delegate = self;
	
	self.adNetworkView = smartView;

	[smartView release];
}

- (void)stopBeingDelegate {
  SMAdBannerView *smartView = (SMAdBannerView*)self.adNetworkView;
	AWLogInfo(@"--SmartMad stopBeingDelegate--");
  if (smartView != nil) {
	  smartView.delegate = nil;
	  self.adNetworkView = nil;
  }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    int flagArr[] = {PHONE_AD_BANNER_MEASURE_AUTO,TABLET_AD_BANNER_MEASURE_728X90,
        PHONE_AD_BANNER_MEASURE_AUTO,TABLET_AD_BANNER_MEASURE_300X250,
        TABLET_AD_BANNER_MEASURE_468X60,TABLET_AD_BANNER_MEASURE_728X90};
    CGSize sizeArr[] = {CGSizeMake(320, 48),CGSizeMake(728, 90),
        CGSizeMake(320, 48),CGSizeMake(300, 250),
        CGSizeMake(468, 60),CGSizeMake(728, 90)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark self util methods

- (void)didReceiveAd:(UIView *)adView {
	[adViewView adapter:self didReceiveAdView:adView];
}

- (NSString *)appIdForAd:(UIView *)adView {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(SmartMadApIDString)]) {
		apID = [adViewDelegate SmartMadApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"03580729f4a07177";
}

- (NSString *)adPositionId {
	if ([adViewDelegate respondsToSelector:@selector(SmartMadBannerAdIDString)]) {
		return [adViewDelegate SmartMadBannerAdIDString];
	}
	else {
		return networkConfig.pubId2;
	}	
	return @"";
	
	//return @"90002436";
}

- (UIColor *)adBackgroundColor:(UIView *)adView {
	return [self helperBackgroundColorToUse];
}

- (UIColor *)adTextColor:(UIView *)adView {
	return [self helperTextColorToUse];
}

#pragma mark SmartMad delegate methods

- (void)adBannerViewDidReceiveAd:(SMAdBannerView*)adView
{
    [self makeTheLogWith:@"adreceive"];
    [self didReceiveAd:adView];
}

- (void)adBannerView:(SMAdBannerView*)adView didFailToReceiveAdWithError:(SMAdEventCode*)errorCode
{
    [self makeTheLogWith:@"adfail_to_receive"];
    [adViewView adapter:self didFailAd:errorCode];
}

- (void)adWillExpandAd:(SMAdBannerView *)adView
{
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adDidCloseExpand:(SMAdBannerView*)adView
{
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)adBannerViewWillPresentScreen:(SMAdBannerView*)adView impressionEventCode:(SMAdEventCode*)eventCode
{
    [self makeTheLogWith:@"adshow"];
    
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:YES];
}

- (void)adBannerViewDidDismissScreen:(SMAdBannerView*)adView
{
    AWLogInfo(@"--SmartMad adBannerViewDidDismissScreen--");
}

- (void)appWillSuspendForAd:(SMAdBannerView*)adView
{
    AWLogInfo(@"--SmartMad appWillSuspendForAd--");
}

- (void)appWillResumeFromAd:(SMAdBannerView*)adView
{
    AWLogInfo(@"--SmartMad appWillResumeFromAd--");
}

- (BOOL)shouldSendExMetric {
	return NO;
}

- (void)adDidClick {
    [self makeTheLogWith:@"adclick"];
    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
}

@end
