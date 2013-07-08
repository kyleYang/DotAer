/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "CaseeAdDelegate.h"

@class CaseeAdView;

/*架势无线*/

@interface AdViewAdapterCaseeAd : AdViewAdNetworkAdapter <CaseeAdDelegate> {

}

+ (AdViewAdNetworkType)networkType;

@end
