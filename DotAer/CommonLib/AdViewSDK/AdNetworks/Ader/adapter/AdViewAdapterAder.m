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
#import "AderSDK.h"
#import "AdViewAdapterAder.h"

#define TestUserSpot @"all"

@interface AdViewAdapterAder ()
- (NSString *)appId;
@end


@implementation AdViewAdapterAder

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAder;
}

+ (void)load {
	if(NSClassFromString(@"AderSDK") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
	Class aderSDKClass = NSClassFromString (@"AderSDK");
	
	if (nil == aderSDKClass) {
		[adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no ader lib, can not create.");
		return;
	}
	
	[self updateSizeParameter];
	UIView *dummyView = [[UIView alloc] initWithFrame:self.rSizeAd];
	if (nil == dummyView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}
	
	[aderSDKClass startAdService:dummyView appID:[self appId]
											 adFrame:self.rSizeAd
						   model:([self isTestMode]?MODEL_TEST:MODEL_RELEASE)];
	[aderSDKClass setDelegate:self];
	self.adNetworkView = dummyView;
	[dummyView release];
}

//Can being delegate even more than one instances being delegate.
//Ader can not.
- (BOOL) canMultiBeingDelegate
{
    return NO;
}

- (void)stopBeingDelegate {
	AWLogInfo(@"--Ader stopBeingDelegate--");
	UIView *dummyView = self.adNetworkView;
    if (dummyView != nil) {
        Class aderSDKClass = NSClassFromString (@"AderSDK");
        [aderSDKClass setDelegate:nil];
        [aderSDKClass stopAdService];
    }
	self.adNetworkView = nil;
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

#pragma mark AderDelegate methods

- (NSString *)appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(aderApIDString)]) {
		apID = [adViewDelegate aderApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	return apID;
	
	//return @"18c4bae606274027805d1b9064189161";
}

//成功接收并显示新广告后调用，count表示当前广告是第几条广告，SDK启动后从1开始，累加计数
- (void)didSucceedToReceiveAd:(NSInteger)count
{
    AWLogInfo(@"did receive an ad from ader");
    [adViewView adapter:self didReceiveAdView:self.adNetworkView];	
}

/*
 接受SDK返回的错误报告
 code 1: 参数错误
 code 2: 服务端错误
 code 3: 应用被冻结
 code 4: 无合适广告
 code 5: 应用账户不存在
 code 6: 频繁请求
 */
- (void) didReceiveError:(NSError *)error
{
	AWLogInfo(@"adview failed from ader:%@", [error localizedDescription]);
	[adViewView adapter:self didFailAd:error];
}

@end
