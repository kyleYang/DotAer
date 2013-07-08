/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterWQ.h"
#import "WQAdView.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewViewImpl.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

#import <QuartzCore/QuartzCore.h>

#define NEED_IN_REALVIEW 0

#define WQMOB_SIZE_320x50 CGSizeMake(320,50)
#define WQMOB_SIZE_IPAD_640x100 CGSizeMake(640,100)

@interface AdViewAdapterWQ (PRIVATE)

- (UIView *)makeAdView;
- (NSString *)appId;
- (NSString *)publisherId;

@end

@implementation AdViewAdapterWQ

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeWQ;
}

+ (void)load {
	if(NSClassFromString(@"WQAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class WQAdViewClass = NSClassFromString (@"WQAdView");
	
	if (nil == WQAdViewClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no WQMobile lib support, can not create.");
		return;
	}
	
	WQAdView *wqBanner = (WQAdView*)[[self makeAdView] retain];
	if (nil == wqBanner) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
    
    CGRect r = CGRectMake(0, 0, self.sSizeAd.width, self.sSizeAd.height);
    wqBanner.delegate = self;
    [wqBanner performSelector:@selector(setAdPlatform:AdPlatformVersion:)
                   withObject:ADVIEW_WQ_TAG
                   withObject:ADVIEW_VERSION_STR];
    [self addActAdViewInContain:wqBanner rect:r];
    
#if NEED_IN_REALVIEW
	if ([adViewDelegate respondsToSelector:@selector(viewControllerForPresentingModalView)])
	{
		UIViewController *controller = [adViewDelegate viewControllerForPresentingModalView];
		if (nil != controller && nil != controller.view)
		{
			[controller.view addSubview:self.adNetworkView];
			self.adNetworkView.hidden = YES;
		}
	}
#endif
    
    [wqBanner startWithAdSlotID:[self appId] AccountKey:[self publisherId] InViewController:
    [self.adViewDelegate viewControllerForPresentingModalView]];
    [wqBanner release];
    AWLogInfo(@"WQ getad");
}

- (void)stopBeingDelegate {
	WQAdView *wqBanner = (WQAdView *)self.actAdView;
    AWLogInfo(@"WQ stop being delegate");
	if (wqBanner != nil) {
        if (!self.bGotView) [self.adNetworkView removeFromSuperview];
        else [self getImageOfActAdViewForRemove];
        
		wqBanner.delegate = nil;
        self.actAdView = nil;
        self.adNetworkView = nil;
	}
}

//For wq's delegate is retain property, should release here.
- (void)cleanupDummyRetain {
    [super cleanupDummyRetain];
    
    AWLogInfo(@"WQ cleanupDummyRetain");
    WQAdView *wqBanner = (WQAdView *)self.actAdView;
    wqBanner.delegate = nil;
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {WQMOB_SIZE_320x50,WQMOB_SIZE_IPAD_640x100,
        WQMOB_SIZE_320x50,WQMOB_SIZE_320x50,
        WQMOB_SIZE_320x50,WQMOB_SIZE_IPAD_640x100};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (NSString *)appId {
	NSString *apID;
	if ([self.adViewDelegate respondsToSelector:@selector(WQAppIDString)]) {
		apID = [self.adViewDelegate WQAppIDString];
	}
	else {
		apID = self.networkConfig.pubId;
	}
    
	return apID;
	//return @"123456789";
}

- (NSString*)publisherId {
	NSString *idStr;
	if ([self.adViewDelegate respondsToSelector:@selector(WQPublisherIDString)]) {
		idStr = [self.adViewDelegate WQPublisherIDString];
	}
	else {
		idStr = self.networkConfig.pubId2;
	}
    
	return idStr;
}

//PublisherID

- (void)dealloc {
	[super dealloc];
}


#pragma mark util


- (UIView*)makeAdView {
	Class WQAdViewClass = NSClassFromString (@"WQAdView");
	
	if (nil == WQAdViewClass) {
		[self.adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no WQMobile lib support, can not create.");
		return nil;
	}
	[self updateSizeParameter];
	//CGRect rect = CGRectMake(0, 0, self.sSizeAd.width, self.sSizeAd.height);
	WQAdView *wqBanner = [[WQAdViewClass alloc] init];
	return [wqBanner autorelease];
}


#pragma mark WQDelegate methods

//广告视图将要关闭
- (void)onWQAdDismiss:(WQAdView *)adview {
	AWLogInfo(@"wqmobile onWQAdDismiss");
}

//点击的时候调用
//- (void)onWQAdClicked:(WQAdView *)adview {
//    [adViewView adapter:self shouldReport:self.adNetworkView DisplayOrClick:NO];
//}

//广告视图进入屏幕展示状态，请勿释放
-(void)onWQAdWillPresentScreen:(WQAdView *) adview
{ 
    AWLogInfo(@"wqmobile onWQAdWillPresentScreen");
    
	[self helperNotifyDelegateOfFullScreenModal];
}

//广告视图结束屏幕展示状态，可以释放
-(void)onWQAdDidDismissScreen:(WQAdView *) adview
{
	AWLogInfo(@"wqmobile onWQAdDidDismissScreen");
    
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

//广告视图获取缓慢提醒
- (void)onWQAdLoadTimeout:(WQAdView*) adview {
    AWLogInfo(@"wqmobile onWQAdLoadTimeout");
}

- (void)onWQAdReceived:(WQAdView *)adview {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(onWQAdReceived:)
                               withObject:adview
                            waitUntilDone:NO];
        return;
    }
#if NEED_IN_REALVIEW
	[self.adNetworkView setHidden:NO];
    if (!self.bGotView)
        [self.adNetworkView removeFromSuperview];
#endif
		
	//CGRect r = CGRectMake(0, 0, self.sSizeAd.width, self.sSizeAd.height);
	//adview.frame = r;

	[self.adViewView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)onWQAdFailed:(WQAdView *)adview {
	AWLogInfo(@"WQMobile didFailToReceiveAd");
	
	[self.adViewView adapter:self didFailAd:nil];
}

@end
