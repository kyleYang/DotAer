//
//  Env.h
//  iMobee
//
//  Created by ellison on 10-9-13.
//  Copyright 2010 borqs. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BqsUtils.h"
#import "BkSvc.h"

#define kDefaultHost @"www.mobeehome.com"

#define kSliderHeight 23
#define kNavigationBarHeight 44
#define kToolBarHeight 41

#define kNavDoneButtonBlue RGBA(0x26, 0x6e, 0xff, 1)
#define kNavDoneButtonBluePressed RGBA(0x16, 0x3f, 0x91, 1)

#define kToolbarButtonTintColorBlack RGBA(0x3b,0x3b,0x3b,1)
#define kToolbarButtonTintColorBlue RGBA(0x22, 0x60, 0xdd, 1)

typedef enum{
    MptDeviceResolution_Unknown          = 0,
    MptDeviceResolution_iPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    MptDeviceResolution_iPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    MptDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    MptDeviceResolution_iPadStandard     = 4,    // iPad 1,2,mini Standard Display       (1024x768px)
    MptDeviceResolution_iPadRetina       = 5     // iPad 3 Retina Display            (2048x1536px)
}MptDeviceScreenType;


@interface Env : NSObject {
	NSString *_udid;
	CGSize _screenSize;
    NSString *_sScreenSize;
    CGFloat _screenScale;
    NSString *_sScreenScale;
	
	NSString *_host;
    NSDictionary *_serverServiceEntry;
    NSString *_swVersion;
    NSString *_swType;
	NSString *_market;
    NSString *_umengId;
	
	NSString *_dirDocuments;
	NSString *_dirCache;
	NSString *_dirTmp;
	
	NSMutableDictionary *_runtimeData;
    NSMutableDictionary *_memImgCache;
		
	NSString *_hdrClientType;
    
    BkSvc *_bkSvc;
}

@property (nonatomic, copy, readonly) NSString *sPhoneType;
@property (nonatomic, copy, readonly) NSString *udid;
@property (nonatomic, copy, readonly) NSString *sDevId; // device id generated from udid
@property (nonatomic, readonly) CGSize screenSize;
@property (nonatomic, copy, readonly) NSString *sScreenSize;
@property (nonatomic, readonly) CGFloat screenScale;
@property (nonatomic, copy, readonly) NSString *sScreenScale;
@property (nonatomic, assign, readonly) MptDeviceScreenType deviceType;
@property (nonatomic, assign, readonly) BOOL bIsPad;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *sServiceEntryUrl; // /phone/tvguide.xml
@property (nonatomic, copy, readonly) NSString *swVersion; // 1.2.7
@property (nonatomic, copy, readonly) NSString *swVersionCode; // 127  // version with out any dot
@property (nonatomic, copy, readonly) NSString *sAppDownloadUrlForWeibo;
@property (nonatomic, copy, readonly) NSString *swType;
@property (nonatomic, copy, readonly) NSString *itunesAppId;
@property (nonatomic, copy, readonly) NSString *umengId;
@property (nonatomic, copy, readonly) NSString *market;
@property (nonatomic, copy, readonly) NSString *dirDocuments;
@property (nonatomic, copy, readonly) NSString *dirCache;
@property (nonatomic, copy, readonly) NSString *dirTmp;

@property (nonatomic, retain) NSMutableDictionary *runtimeData;

@property (nonatomic, copy, readonly) NSString *hdrClientType;

@property (nonatomic, retain, readonly) BkSvc *bkSvc;

@property (nonatomic, retain, readonly) NSDictionary *dicNetAppAppendHeader;

+ (Env*)sharedEnv;
+ (UIViewController*)getRootViewController;
- (id)init;
- (void)dealloc;
- (void)onReceiveMemoryWarning;

- (NSString*)getSEKey:(NSString*)key Def:(NSString*)defValue;
- (void)updateServerSE:(NSDictionary*)newServerSE;

- (UIImage*)cacheImage:(NSString*)fileName;
- (UIImage*)cacheScretchableImage:(NSString*)fileName X:(float)x Y:(float)y;

-(NSString*)getProperty:(NSString*)name;
@end


@protocol EnvProtocol <NSObject>

-(Env*)getEnv;
-(UIViewController*)getRootViewController;

@end
