//
//  AdViewAdapterPingcoo.h
//  AdViewSDK
//
//  Created by Ma ming on 13-6-13.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "pingcooSDK.h"

@interface AdViewAdapterPingcoo : AdViewAdNetworkAdapter <pingcooSDKDelegate> {

}

@property (retain, nonatomic) pingcooSDK *pingcoo;

+ (AdViewAdNetworkType)networkType;

@end
