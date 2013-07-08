/*
 
 Adview .
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "IMAdView.h"
#import "IMAdDelegate.h"
#import "IMAdRequest.h"
#import "IMAdError.h"


@interface AdViewAdapterInMobi : AdViewAdNetworkAdapter<IMAdDelegate> {
    
}

+ (AdViewAdNetworkType)networkType;

@end
