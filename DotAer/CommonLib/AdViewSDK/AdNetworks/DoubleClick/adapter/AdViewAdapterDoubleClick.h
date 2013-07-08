//
//  AdViewAdapterDoubleClick.h
//  AdViewSDK
//
//  Created by Ma ming on 12-12-12.
//
//

#import "AdViewAdNetworkAdapter.h"
#import "GADAppEventDelegate.h"

/*DoubleClick*/

@interface AdViewAdapterDoubleClick : AdViewAdNetworkAdapter<GADAppEventDelegate>{
}

+ (AdViewAdNetworkType)networkType;

@end
