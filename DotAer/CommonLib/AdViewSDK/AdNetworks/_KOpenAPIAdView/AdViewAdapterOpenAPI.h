/*

Adview .
 
*/

#import "AdViewAdNetworkAdapter.h"
#import "KOpenAPIAdView.h"


/*Adview openapi ad -- OpenAPI.*/

@interface AdViewAdapterOpenAPI : AdViewAdNetworkAdapter <KOpenAPIAdViewDelegate> {

}

+ (AdViewAdNetworkType)networkType;

- (int)OpenAPIAdType;
- (NSString *)appId;

@end
