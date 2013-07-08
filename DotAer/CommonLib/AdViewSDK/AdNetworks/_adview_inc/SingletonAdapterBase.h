//
//  SingletonAdapterBase.h
//  AdViewSDK
//
//  Created by zhiwen on 12-1-13.
//  Copyright 2012 www.adview.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdViewAdNetworkAdapter.h"


@interface SingletonAdapterBase : NSObject {
	AdViewAdNetworkAdapter	*mAdapter;
	NSMutableArray			*mIdelViewArr;
	NSObject				*mLockObj;
}

@property (nonatomic, assign) AdViewAdNetworkAdapter	*mAdapter;
@property (nonatomic, retain) NSMutableArray			*mIdelViewArr;
@property (nonatomic, retain) NSObject					*mLockObj;

- (void)setAdapterValue:(BOOL)bSetOrClean ByAdapter:(AdViewAdNetworkAdapter*)adapter;

/*
 * For use of analyze of xcode, return one with +0 retain
 */
- (UIView*)getIdelAdView;
- (void)addIdelAdView:(UIView*)view;
- (BOOL)isTestMode;

/*
 * For use of analyze of xcode, return one with +0 retain
 */
- (UIView*)makeAdView;


- (void)updateAdFrame:(UIView*)view;
- (BOOL)isAdViewValid:(UIView*)adView;

@end
