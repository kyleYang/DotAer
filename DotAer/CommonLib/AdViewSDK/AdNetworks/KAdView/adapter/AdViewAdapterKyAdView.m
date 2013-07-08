/*
 adview app recommend
*/

#import "AdViewViewImpl.h"
#import "AdViewConfig.h"
#import "AdViewAdNetworkConfig.h"
#import "AdViewDelegateProtocol.h"
#import "AdViewLog.h"
#import "AdViewAdNetworkAdapter+Helpers.h"
#import "AdViewAdNetworkRegistry.h"
#import "AdViewAdapterKyAdView.h"
#import "KOpenAPIAdView.h"
#import "AdViewExtraManager.h"

@interface AdViewAdapterKyAdView ()
@end


@implementation AdViewAdapterKyAdView

+ (AdViewAdNetworkType)networkType {
  return AdViewAdNetworkTypeAdviewApp;
}

+ (void)load {
	if(NSClassFromString(@"KOpenAPIAdView") != nil) {
		[[AdViewAdNetworkRegistry sharedRegistry] registerClass:self];	
	}
}

- (NSString *) appId {
	NSString *apID;

	apID = [adViewDelegate adViewApplicationKey];

	return apID;
}

- (NSString*) kAdViewHost {
	return self.networkConfig.pubId2;
}

@end
