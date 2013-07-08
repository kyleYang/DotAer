/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "airADViewDelegate.h"

@interface AdViewAdapterAirAD : AdViewAdNetworkAdapter <airADViewDelegate> {
	
}

+ (AdViewAdNetworkType)networkType;

@end
