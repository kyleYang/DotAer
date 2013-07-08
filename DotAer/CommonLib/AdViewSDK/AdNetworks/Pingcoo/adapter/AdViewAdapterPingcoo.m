//
//  AdViewAdapterPingcoo.m
//  AdViewSDK
//
//  Created by Ma ming on 13-6-13.
//
//

#import "AdViewAdapterPingcoo.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewViewImpl.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"

@interface AdViewAdapterPingcoo (PIRVATE)

- (NSString *)appId;

@end

@implementation AdViewAdapterPingcoo

@synthesize pingcoo;

+ (AdViewAdNetworkType)networkType {
    return AdViewAdNetworkTypePingcoo;
}

+ (void)load {
    if(NSClassFromString(@"pingcooSDK") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];
	}
}

- (void)getAd {
    Class PingcooSDKClass = NSClassFromString(@"pingcooSDK");
    if (PingcooSDKClass == nil) {
        [adViewView adapter:self didFailAd:nil];
		AWLogInfo(@"no pingcoo lib support, can not create.");
        return;
    }
    
    pingcoo = [PingcooSDKClass initWithKey:[self appId]];
    if (nil == pingcoo) {
        [adViewView adapter:self didFailAd:nil];
        return;
    }

    [self updateSizeParameter];
    
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sSizeAd.width, self.sSizeAd.height)];
    
    self.adNetworkView = dummyView;
    [dummyView release];
    pingcoo.delegate = self;
    [pingcoo bannerShow:self.adNetworkView];
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


#pragma mark util

- (NSString *)appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(pingcooAdIDString)]) {
		apID = [adViewDelegate pingcooAdIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
    
	return apID;
	//return @"123456789";
}

#pragma mark delete

-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result
{
    AWLogInfo(@"did receive an ad from pingcoo");
    [adViewView adapter:self didReceiveAdView:self.adNetworkView];
}
-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error
{
    AWLogInfo(@"adview failed from pingcoo:%@", [error localizedDescription]);
    [adViewView adapter:self didFailAd:error];
}

- (void)stopBeingDelegate {
	AWLogInfo(@"--Pingcoo stopBeingDelegate--");
    if (pingcoo != nil) {
        if (!self.bGotView)
            [self.adNetworkView removeFromSuperview];
        else {
            //here can get image for actAdView, and to remove actAdView.
            //[self getImageOfActAdViewForRemove];
        }
        if (self == pingcoo.delegate)
            pingcoo.delegate = nil;
        self.adNetworkView = nil;
    }
}

@end
