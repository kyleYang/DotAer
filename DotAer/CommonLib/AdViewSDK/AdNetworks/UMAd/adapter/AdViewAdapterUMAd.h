/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "UMAdBannerView.h"
#import "UMAdManager.h"

@interface AdViewAdapterUMAd : AdViewAdNetworkAdapter <UMADAppDelegate, UMAdADBannerViewDelegate, UMWebViewDelegate> {
}

@property (nonatomic, copy) NSString* umadClientIdString;
@property (nonatomic, copy) NSString* umadSlotIdString;

@end
