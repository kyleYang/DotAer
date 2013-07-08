/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "AdChinaBannerViewDelegateProtocol.h"

@class AdChinaView;
@class AdViewAdapterAdChinaImpl;

/*易传媒*/

@interface AdViewAdapterAdChina : AdViewAdNetworkAdapter {
	AdViewAdapterAdChinaImpl	*mDelegate;
}

+ (AdViewAdNetworkType)networkType;

@end