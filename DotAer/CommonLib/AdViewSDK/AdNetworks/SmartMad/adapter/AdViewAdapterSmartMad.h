/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "SMAdBannerView.h"

/*架势无线*/

@interface AdViewAdapterSmartMad : AdViewAdNetworkAdapter <SMAdBannerViewDelegate> {
}

+ (AdViewAdNetworkType)networkType;

@end
