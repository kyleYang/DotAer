//
//  HumDotaUserCenterOps.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HumDotaUserCenterOps : NSObject



#define kReadFontSize @"dota.raad.font.size"

//net
#define kDftHaveNetWork @"dota.network.have"
#define kDftNetTypeWifi @"dota.network.type"//net type

//user
#define kDftUserReallyPassport @"user.really.passport"
#define kDftUserLogoinStatus @"user.logoin.status"
#define kDftUserName @"user.login.username"
#define kDftUserPassword @"user.login.password"
//
#define kSimulatorLastVersionKey  @"simulatorLastVersionChecked"
#define kSimulatorNowVersionName  @"simulatorLastVersionName"
#define kSimulatorIgnoreVersion  @"simulatorIgnoreVersion"
#define kSimulatorLastChecked  @"simulatorLastChecked"
#define kSimulatorLastReminded  @"simulatorLastReminded"

#define kFirstUseDota @"dota.first.use"
//screentype
#define kScreenPlayType @"screenplaytype"
#define kScreenDownType @"screendowntype"


#define kDftNewsCatSaveTime @"dft.news.xml.save.time"
#define kDftVideoCatSaveTimeForCat @"dft.video.xml.save.time.%@"
#define kDftImageCatSaveTimeForCat @"dft.image.xml.save.time.%@"
#define kDftStrategyCatSaveTimeForCat @"dft.strategy.xml.save.time.%@"

#define kRefreshNewsIntervalS (2*60*60.0)
#define kRefreshVideoInterVals (2*60*60)
#define kRefreshImageIntervalS (2*60*60.0)
#define kRefreshStrategyInterVals (2*60*60)


+(CGFloat)intValueReadForKey:(NSString *)key;
+(void)intVaule:(int)value saveForKey:(NSString *)key;

+(CGFloat)floatValueReadForKey:(NSString *)key;
+(void)floatVaule:(CGFloat)value saveForKey:(NSString *)key;


+(BOOL)BoolValueForKey:(NSString *)key;
+(void)saveBoolVaule:(BOOL)value forKye:(NSString *)key;

+(id)objectValueForKey:(NSString *)key;
+(void)setObjectValue:(id)value forKey:(NSString *)key;


@end
