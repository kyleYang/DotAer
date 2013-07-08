/*
 adview openapi ad-suizong.
*/

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterSuiZong.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterSuiZong ()
@end

@implementation AdViewAdapterSuiZong

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeSuiZong;
}

+ (void)load {
	if(NSClassFromString(@"KOpenAPIAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];	
	}
}

- (int)OpenAPIAdType {
    return KOPENAPIADTYPE_SUIZONG;
}

- (NSString *) appId {
	NSString *apID;
	if ([adViewDelegate respondsToSelector:@selector(suiZongApIDString)]) {
		apID = [adViewDelegate suiZongApIDString];
	}
	else {
		apID = networkConfig.pubId;
	}
	
	return apID;
	
#if 0
	return @"4f0acf110cf2f1e96d8eb7ea";		//4f0acf110cf2f1e96d8eb7ea
#endif
}

@end
