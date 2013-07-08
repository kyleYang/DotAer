/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "FtadStatusDelegate.h"

@class FtadManager;
@class FtadBannerView;

@interface AdViewAdapterAdFracta: AdViewAdNetworkAdapter <FtadStatusDelegate> {
}

@property (nonatomic, retain) FtadManager *ftAdManager;
@property (nonatomic, retain) FtadBannerView *ftAdBanner;

@end
