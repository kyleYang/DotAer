/*
 adview openapi ad-Aduu.
*/

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterAduu.h"
#import "AdViewExtraManager.h"

#import "YYAdJailbrokenHelper.h"

@interface AdViewAdapterAduu ()
@end


@implementation AdViewAdapterAduu

@synthesize aduuView;

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAduu;
}

+ (void)load {
	if(NSClassFromString(@"YYAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];	
	}
}

- (void)getAd {
    Class AduuAdViewClass = NSClassFromString (@"YYAdView");
	
	if (nil == AduuAdViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no adwo lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
    CGRect r = CGRectMake(0.0f, 0.0f, self.sSizeAd.width, self.sSizeAd.height);
    AWLogInfo(@"%d",self.nSizeAd);
    YYAdView* adView = [[AduuAdViewClass alloc] initWithContentSizeIdentifier:self.nSizeAd delegate:self];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
    adView.appID = [self appId];
    adView.appSecret = networkConfig.pubId2;
    adView.rootViewController = [self.adViewDelegate viewControllerForPresentingModalView];
    adView.frame = r;
    adView.updateTime = 30;
    
    [adView start];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:r];
	[dummyView addSubview:adView];
    
    self.adNetworkView = dummyView;
    self.aduuView = adView;
    [adView release];
	[dummyView release];
    AWLogInfo(@"%@",[AduuAdViewClass sdkVersion]);	
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
    int flagArr[] = {YYAdBannerContentSizeIdentifier320x50,
        YYAdBannerContentSizeIdentifier728x90,
        YYAdBannerContentSizeIdentifier320x50,
        YYAdBannerContentSizeIdentifier320x50,
        YYAdBannerContentSizeIdentifier320x50,
        YYAdBannerContentSizeIdentifier728x90};
    CGSize sizeArr[] = {CGSizeMake(320,50),CGSizeMake(720,110),
        CGSizeMake(320,50),CGSizeMake(320,50),
        CGSizeMake(320,50),CGSizeMake(720,110)};
    
    [self setSizeParameter:flagArr size:sizeArr];
}

- (void)cleanupDummyRetain {
    [super cleanupDummyRetain];
    
    if (self.aduuView) {
        [self.aduuView stop];
        self.aduuView.delegate = nil;
        self.aduuView = nil;
    }
    self.adNetworkView = nil;
}

#pragma mark -
#pragma mark delegate

- (NSString *) appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(aduuApIDString)]) {
		apID = [adViewDelegate aduuApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	return apID;
	
#if 0
	return @"4f0acf110cf2f1e96d8eb7ea";		//4f0acf110cf2f1e96d8eb7ea
#endif
}

//成功加载后调用
- (void)didReceiveAd:(YYAdView *)adView {
    AWLogInfo(@"Aduu success to load ad.");
	[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

// 请求广告条数据失败后调用
//
// 详解:
//      当接收服务器返回的广告数据失败后调用该方法

- (void)didFailToReceiveAd:(YYAdView *)adView  error:(NSError *)error {
    AWLogInfo(@"Aduu failed to load ad.");
	
	[self.adViewView adapter:self didFailAd:error];
}

//下载,安装app
//
// 详解:针对越狱环境
-(void)willDownloadAndInstal:(NSString *)appURL {
    [[YYAdJailbrokenHelper sharedInstance] downloadApp:appURL];
}

// 将要显示全屏广告前调用
//
// 详解:将要显示一次全屏广告内容前调用该函数
- (void)willPresentScreen:(YYAdView *)adView {
    AWLogInfo(@"Aduu will present modal view.");
	[self helperNotifyDelegateOfFullScreenModal];
}

// 显示全屏广告成功后调用
//
// 详解:显示一次全屏广告内容后调用该函数
- (void)didPresentScreen:(YYAdView *)adView {

}

// 将要关闭全屏广告前调用
//
// 详解:全屏广告将要关闭前调用该函数
- (void)willDismissScreen:(YYAdView *)adView {
    AWLogInfo(@"Aduu did dismiss modal view.");
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"--Aduu stopBeingDelegate--");
    [self.aduuView stop];
    self.aduuView.delegate = nil;
    self.aduuView = nil;
    self.adNetworkView = nil;
}

@end
