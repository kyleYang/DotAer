/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter.h"
#import "MobiSageSDK.h"

/**/

@interface AdViewAdapterMobiSage : AdViewAdNetworkAdapter<MobiSageAdViewDelegate> {
@private
    UIView* adViewInternal;
    UIView* mobiSageAdView;
    
    NSThread *adThread_;
}

+ (AdViewAdNetworkType)networkType;
@property (nonatomic, retain) UIView* adViewInternal;
@property (nonatomic, retain) UIView* mobiSageAdView;

@end
