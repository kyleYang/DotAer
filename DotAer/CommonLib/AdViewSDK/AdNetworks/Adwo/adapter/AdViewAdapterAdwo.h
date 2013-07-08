/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "AWAdView.h"

@class AWAdView;

/*架势无线*/

@interface AdViewAdapterAdwo : AdViewAdNetworkAdapter <AWAdViewDelegate> {
}

+ (AdViewAdNetworkType)networkType;

@end
