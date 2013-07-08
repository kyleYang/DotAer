/*

 AdViewConfig.h

 Copyright 2010 www.adview.cn

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"

@class AdViewConfig;
@protocol AdViewConfigDelegate<NSObject>

@optional
- (void)adViewConfigDidReceiveConfig:(AdViewConfig *)config;
- (void)adViewConfigDidFail:(AdViewConfig *)config error:(NSError *)error;
- (NSURL *)adViewConfigURL;

@end

typedef enum {
  AWBannerAnimationTypeNone           = 0,
  AWBannerAnimationTypeFlipFromLeft   = 1,
  AWBannerAnimationTypeFlipFromRight  = 2,
  AWBannerAnimationTypeCurlUp         = 3,
  AWBannerAnimationTypeCurlDown       = 4,
  AWBannerAnimationTypeSlideFromLeft  = 5,
  AWBannerAnimationTypeSlideFromRight = 6,
  AWBannerAnimationTypeFadeIn         = 7,
  AWBannerAnimationTypeRandom         = 8,
} AWBannerAnimationType;

typedef enum {
	FetchTypeNetwork = 1,
	FetchTypeFile = 2,
	FetchTypeMemory = 4,
} FetchType;

@class AdViewAdNetworkConfig;
@class AdViewAdNetworkRegistry;

@interface AdViewConfig : NSObject {
  NSString *appKey;
  NSURL *configURL;
  BOOL legacy;

  BOOL adsAreOff;
  NSMutableArray *adNetworkConfigs;

	NSString *reportHost;
  UIColor *backgroundColor;
  UIColor *textColor;
  NSTimeInterval refreshInterval;
  BOOL locationOn;
  AWBannerAnimationType bannerAnimationType;
  NSInteger fullscreenWaitInterval;
  NSInteger fullscreenMaxAds;

  NSMutableArray *delegates;
  BOOL hasConfig;

	NSDate *getDataDate;

  AdViewAdNetworkRegistry *adNetworkRegistry;
	
	NSInteger langSet;
	BOOL	 fetchBlockMode;
	int	 fetchType;
    int     configVer;
}

- (id)initWithAppKey:(NSString *)ak delegate:(id<AdViewConfigDelegate>)delegate;
- (BOOL)parseConfig:(NSData *)data error:(NSError **)error;
- (BOOL)addDelegate:(id<AdViewConfigDelegate>)delegate;
- (BOOL)removeDelegate:(id<AdViewConfigDelegate>)delegate;
- (void)notifyDelegatesOfFailure:(NSError *)error;

@property (nonatomic,readonly) NSString *appKey;
@property (nonatomic,readonly) NSURL *configURL;

@property (nonatomic,readonly) BOOL hasConfig;

@property (nonatomic,readonly) NSDate *getDataDate;

@property (nonatomic,readonly) BOOL adsAreOff;
@property (nonatomic,readonly) NSArray *adNetworkConfigs;
@property (nonatomic,readonly) UIColor *backgroundColor;
@property (nonatomic,readonly) UIColor *textColor;
@property (nonatomic,readonly) NSTimeInterval refreshInterval;
@property (nonatomic,readonly) BOOL locationOn;
@property (nonatomic,readonly) AWBannerAnimationType bannerAnimationType;
@property (nonatomic,readonly) NSInteger fullscreenWaitInterval;
@property (nonatomic,readonly) NSInteger fullscreenMaxAds;

@property (nonatomic,readonly) NSString *reportHost;

@property (nonatomic,assign) AdViewAdNetworkRegistry *adNetworkRegistry;

@property (nonatomic, assign) NSInteger langSet;
@property (nonatomic, assign) BOOL fetchBlockMode;
@property (nonatomic, assign) int fetchType;

@property (nonatomic, assign) BOOL needParse;
@property (nonatomic, assign) int  configVer;

+ (BOOL)isDeviceForeign;

@end


// Convenience conversion functions, converts val into native types var.
// val can be NSNumber or NSString, all else will cause function to fail
// On failure, return NO.
BOOL advIntVal(NSInteger *var, id val);
BOOL advFloatVal(CGFloat *var, id val);
BOOL advDoubleVal(double *var, id val);
