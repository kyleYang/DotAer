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



+(CGFloat)intValueReadForKey:(NSString *)key;
+(void)intVaule:(int)value saveForKey:(NSString *)key;

+(CGFloat)floatValueReadForKey:(NSString *)key;
+(void)floatVaule:(CGFloat)value saveForKey:(NSString *)key;



+(BOOL)BoolValueForKey:(NSString *)key;
+(void)saveBoolVaule:(BOOL)value forKye:(NSString *)key;


@end
