/*

Adview .
 
*/

#import "AdViewAdNetworkAdapter.h"
#import "MiidiAdViewDelegate.h"


/*Adview openapi ad -- suizong.*/

@interface AdViewAdapterMiidi : AdViewAdNetworkAdapter {

}

@property (nonatomic, assign) BOOL bGotInGet;

+ (AdViewAdNetworkType)networkType;

@end
