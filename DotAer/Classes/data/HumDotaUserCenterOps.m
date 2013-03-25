//
//  HumDotaUserCenterOps.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaUserCenterOps.h"

@implementation HumDotaUserCenterOps



+(CGFloat)intValueReadForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(void)intVaule:(int)value saveForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(CGFloat)floatValueReadForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+(void)floatVaule:(CGFloat)value saveForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
