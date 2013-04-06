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



+(BOOL)BoolValueForKey:(NSString *)key{
     return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(void)saveBoolVaule:(BOOL)value forKye:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

//obj
+(id)objectValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setObjectValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}





@end
