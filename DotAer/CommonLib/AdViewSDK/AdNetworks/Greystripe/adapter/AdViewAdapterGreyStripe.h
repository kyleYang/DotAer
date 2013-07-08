/*

Adview .
 
*/

#import "AdViewAdNetworkAdapter.h"
#import "GSAdDelegate.h"


@interface AdViewAdapterGreyStripe : AdViewAdNetworkAdapter <GSAdDelegate> {

}

@property (nonatomic, retain) NSString *bannerName;

+ (AdViewAdNetworkType)networkType;

@end
