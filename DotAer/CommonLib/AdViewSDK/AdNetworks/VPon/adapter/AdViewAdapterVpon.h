/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "VponAdOn.h"

@class AdOnView;

/*架势无线*/

@interface AdViewAdapterVpon : AdViewAdNetworkAdapter <VponAdOnDelegate> {

}

+ (AdViewAdNetworkType)networkType;

@end
