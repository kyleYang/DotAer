//
//  AdViewAdapterGuomob.h
//  AdViewSDK
//
//  Created by Ma ming on 13-5-24.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "GuomobAdSDK.h"

@interface AdViewAdapterGuomob : AdViewAdNetworkAdapter <GuomobAdSDKDelegate> 

@property (retain, nonatomic) GuomobAdSDK *guomobAdView;

+ (AdViewAdNetworkType)networkType;

@end
