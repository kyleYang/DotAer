//
//  AdChinaLocationManager.h
//  AdChinaSDK
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface AdChinaLocationManager : NSObject

// You may disable location service here, default value is YES
+ (void)setLocationServiceEnabled:(BOOL)enable;
+ (BOOL)getLocationServiceEnabled;

@end
