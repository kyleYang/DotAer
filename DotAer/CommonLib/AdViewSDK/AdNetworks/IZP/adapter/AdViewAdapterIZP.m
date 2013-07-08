/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdapterIZP.h"
#import "AdViewView.h"
#import "AdViewViewImpl.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkConfig.h"
#import "AdviewObjCollector.h"
#import "adViewLog.h"

@implementation AdViewAdapterIZP

+ (AdViewAdNetworkType)networkType {
	return AdViewAdNetworkTypeIZPTec;
}

+ (void)load {
    if (NSClassFromString(@"IZPView") != nil) {
        [[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];        
    }
}

- (void)getAd{
    NSString* apID = @"";
    Class izpViewClass = NSClassFromString(@"IZPView");
    if (izpViewClass == nil) {
        return;
    }

    if ([adViewDelegate respondsToSelector:@selector(izpApIDString)]) {
		apID = [adViewDelegate izpApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}

    Model md1 = [adViewDelegate adViewTestMode]?MODEL_TEST:MODEL_RELEASE;
    [izpViewClass setPID:apID adType:AD_TYPE_BANNER model:md1];
	
	[self updateSizeParameter];

    IZPView *adView = [[izpViewClass alloc] initWithFrame:self.rSizeAd];
	if (nil == adView) {
		[adViewView adapter:self didFailAd:nil];
		return;
	}

    adView.delegate = self;
    
    self.bWaitAd = YES;
    [adView start];
    
    self.adNetworkView = adView;
    [adView release];
    [self setupDummyHackTimer:14];
}

- (void)stopBeingDelegate {
    AWLogInfo(@"IZP stopBeingDelegate %@", self);
    IZPView *adView = (IZPView *)self.adNetworkView;
    [adView pause];
    adView.delegate = nil;
    self.adNetworkView = nil;
}

- (void)cleanupDummyRetain {
    AWLogInfo(@"IZP cleanupDummyRetain %@", self);
    [super cleanupDummyRetain];
    
    IZPView *adView = (IZPView *)self.adNetworkView;
    [adView pause];
	if (self.bWaitAd) {
        self.adViewView = nil;
		[[AdviewObjCollector sharedCollector] addObj:self wait:180];
    }
}

- (void)updateSizeParameter {
    /*
     * auto for iphone, auto for ipad,
     * 320x50, 300x250,
     * 480x60, 728x90
     */
    CGSize sizeArr[] = {CGSizeMake(320, 48), CGSizeMake(768, 90),
        CGSizeMake(320, 48), CGSizeMake(320, 48),
        CGSizeMake(320, 48), CGSizeMake(768, 90)};
    
    [self setSizeParameter:nil size:sizeArr];
}

- (void)dealloc {
	[super dealloc];
}

/*
 *错误报告
 * 
 *详解:code 是错误代码  info是对错误的说明
 * 1：系统错误 2：参数错误 3：接口不存在 4：应用被冻结 5：无合适广告 6：应用用户不存在 7:请求广告时无法建立连接 8：请求广告时发生连接错误 9：解析广告出错  10 11 12 ：没能成功请求到广告资源  100：没有产品id  101:没有广告类型
 */
- (void) errorReport:(NSInteger)code erroInfo:(NSString*) info {
    AWLogInfo(@"IZP errorReport %@", self);
    self.bWaitAd = NO;
    [self cleanupDummyHackTimer];
    
    if (self.adNetworkView) {
        IZPView *adView = (IZPView *)self.adNetworkView;
        [adView pause];
    }
    [adViewView adapter:self didFailAd:[NSError errorWithDomain:info code:code userInfo:nil]];
}


/*
 *成功请求到一则广告
 *
 *详解:count代表请求到第几条广告，从1开始，累加计数
 */
- (void)didReceiveFreshAd:(IZPView*)view adCount:(NSInteger)count {
    self.bWaitAd = NO;
    [self cleanupDummyHackTimer];
    if (self.adNetworkView)
        [view pause];
    [adViewView adapter:self didReceiveAdView:view];
}

@end
