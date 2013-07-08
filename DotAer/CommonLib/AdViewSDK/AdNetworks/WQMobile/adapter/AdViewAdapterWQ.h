/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "WQAdView.h"

@interface AdViewAdapterWQ : AdViewAdNetworkAdapter<WQAdViewDelegate> {
}

+ (AdViewAdNetworkType)networkType;

@end
