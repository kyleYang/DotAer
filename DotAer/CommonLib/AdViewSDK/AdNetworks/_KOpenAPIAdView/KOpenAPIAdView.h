#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>

@class KOpenAPIAdView;

@protocol KOpenAPIAdViewDelegate <NSObject>

@optional
- (NSString*)appPwd;

- (UIColor*)adTextColor;
- (UIColor*)adBackgroundColor;
- (void)didReceivedAd:(KOpenAPIAdView*)adView;
- (void)didFailToReceiveAd:(KOpenAPIAdView*)adView Error:(NSError*)error;

- (NSString*) KOpenAPIAdViewHost;
- (int)autoRefreshInterval;	//<=0 - none, <15 - 15, unit: seconds
- (int)gradientBgType;		//-1 - none, 0 - fix, 1 - random

- (UIViewController*)viewControllerForShowModal;

- (void)adViewWillPresentScreen:(KOpenAPIAdView *)adView;
- (void)adViewDidDismissScreen:(KOpenAPIAdView *)adView;

- (BOOL)testMode;
- (BOOL)logMode;

@required

- (NSString*)appId;

@end

@interface KOpenAPIAdView : UIView

#define KOPENAPIADVIEW_SIZE_320x50		CGSizeMake(320, 50)
#define KOPENAPIADVIEW_SIZE_480x44		CGSizeMake(480, 44)
#define KOPENAPIADVIEW_SIZE_300x250		CGSizeMake(300, 250)
#define KOPENAPIADVIEW_SIZE_480x60		CGSizeMake(480, 60)
#define KOPENAPIADVIEW_SIZE_728x90		CGSizeMake(728, 90)

#define KOPENAPIADTYPE_DEFAULT		0			//adview app ad
#define KOPENAPIADTYPE_SUIZONG		1			//suizong
#define KOPENAPIADTYPE_IMMOB		2			//Immob, server response limit
#define KOPENAPIADTYPE_INMOBI		3           //inmobi
#define KOPENAPIADTYPE_ADUU			4           //Aduu
#define KOPENAPIADTYPE_WQMOBILE		5           //wq

@property (nonatomic, assign) id<KOpenAPIAdViewDelegate> delegate;
@property (nonatomic, retain) CLLocation*				location;

+(KOpenAPIAdView*) requestOfSize:(CGSize)size withDelegate:(id<KOpenAPIAdViewDelegate>)delegate 
					  withAdType:(int)adType;
+(KOpenAPIAdView*) requestWithDelegate:(id<KOpenAPIAdViewDelegate>)delegate
							withAdType:(int)adType;
+(NSString*) sdkVersion;

-(void) pauseRequestAd;
-(void) resumeRequestAd;

@end
