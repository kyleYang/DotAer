//
//  AdViewExtraManager.h
//  AdViewSDK
//
//  Created by zhiwen on 12-7-25.
//  Copyright 2012 www.adview.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>

#define LAST_NET_CONFIG_TIME	@"lastGetNetConfigTime"


@interface AdViewExtraManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation		  *myLocation;
	NSTimeInterval	   myLocationTime;
	
	NSMutableDictionary		*objDict;
}

@property (nonatomic, retain) NSString *macAddr;

+ (AdViewExtraManager*)createManager;	//create and return.
+ (AdViewExtraManager*)sharedManager;	//won't create.

- (void)findLocation;
- (CLLocation*)getLocation;

- (NSString*)getMacAddress;

- (void)storeObject:(NSObject*)obj forKey:(NSString*)keyStr;
- (NSObject*)objectStoredForKey:(NSString*)keyStr;

@end
