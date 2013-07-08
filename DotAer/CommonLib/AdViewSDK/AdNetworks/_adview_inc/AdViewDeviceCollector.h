//
//  AdViewDeviceCollector.h
//  AdViewDeviceCollector
//
//  Created by Zhang Kerberos on 11-9-9.
//  Copyright 2011年 Access China. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdViewDeviceCollector;

@protocol AdViewDeviceCollectorDelegate <NSObject>
@required
- (NSString*) appKey;
@optional
- (NSString*) marketChannel;
@end

@interface AdViewDeviceCollector : NSObject
@property (nonatomic, assign) id<AdViewDeviceCollectorDelegate> delegate;
@property (nonatomic, retain) NSString *uuid;

+ (AdViewDeviceCollector*) sharedDeviceCollector;
- (NSString*) deviceId;
- (NSString*) deviceModel;
- (NSString*) systemVersion;
- (NSString*) systemName;
- (NSString*) screenResolution;
- (NSString*) serviceProviderCode;
- (NSString*) networkType;
- (void) postDeviceInformation;

+ (NSString *)myIdentifier;

@end