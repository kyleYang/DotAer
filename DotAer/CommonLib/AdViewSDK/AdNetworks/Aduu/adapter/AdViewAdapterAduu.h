/*

Adview .
 
*/

#import "YYAdDelegateProtocol.h"
#import "YYAdView.h"

/*Adview openapi ad -- Aduu.*/

@interface AdViewAdapterAduu : AdViewAdNetworkAdapter <YYAdDelegate> {

}

@property (retain, nonatomic) YYAdView *aduuView;

+ (AdViewAdNetworkType)networkType;

@end
