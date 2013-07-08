/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#ifdef __IPHONE_4_0
#import <iAd/ADBannerView.h>
#else
#import "IAD_sim.h"
#endif

@interface AdViewAdapterIAd : AdViewAdNetworkAdapter <ADBannerViewDelegate> {
	
}

+ (AdViewAdNetworkType)networkType;

@end
