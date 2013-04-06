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

#define kDftHaveNetWork @"dota.network.have"
#define kDftNetTypeWifi @"dota.network.type"//net type

#define kSimulatorLastVersionKey  @"simulatorLastVersionChecked"
#define kSimulatorNowVersionName  @"simulatorLastVersionName"
#define kSimulatorIgnoreVersion  @"simulatorIgnoreVersion"
#define kSimulatorLastChecked  @"simulatorLastChecked"
#define kSimulatorLastReminded  @"simulatorLastReminded"


#define kDftNewsCatSaveTime @"dft.news.xml.save.time"
#define kDftVideoCatSaveTimeForCat @"dft.video.xml.save.time.%@"
#define kDftImageCatSaveTimeForCat @"dft.image.xml.save.time.%@"
#define kDftStrategyCatSaveTimeForCat @"dft.strategy.xml.save.time.%@"

#define kRefreshNewsIntervalS (0.5*60*60.0)
#define kRefreshVideoInterVals (0.5*60*60)
#define kRefreshImageIntervalS (0.5*60*60.0)
#define kRefreshStrategyInterVals (0.5*60*60)


+(CGFloat)intValueReadForKey:(NSString *)key;
+(void)intVaule:(int)value saveForKey:(NSString *)key;

+(CGFloat)floatValueReadForKey:(NSString *)key;
+(void)floatVaule:(CGFloat)value saveForKey:(NSString *)key;


+(BOOL)BoolValueForKey:(NSString *)key;
+(void)saveBoolVaule:(BOOL)value forKye:(NSString *)key;

+(id)objectValueForKey:(NSString *)key;
+(void)setObjectValue:(id)value forKey:(NSString *)key;


@end
