/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "MobWinBannerView.h"

@interface AdViewAdapterMobWin : AdViewAdNetworkAdapter <MobWinBannerViewDelegate> {
	
}

+ (AdViewAdNetworkType)networkType;

@end
