//
//  SimuImageHelp.m
//  DotAer
//
//  Created by Kyle on 13-3-27.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "SimuImageHelp.h"
#import "HumDotaDataMgr.h"
#import "Env.h"
#import "BqsUtils.h"


@implementation SimuImageHelp


+(UIImage*)imageWithFileName:(NSString *)name{
    return [UIImage imageNamed:name];
}

+(UIImage*)imageForHeroSN:(NSNumber *)heroSn WithFileName:(NSString *)name{
    NSString *file = [[HumDotaDataMgr instance] pathOfHeroImageDir];
    file = [file stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",[heroSn intValue]]];
    file = [file stringByAppendingPathComponent:name];
    BqsLog(@"HeroImageFile for herosn : %@ = %@",heroSn,file);
    return [UIImage imageWithContentsOfFile:file];
    
}

+(UIImage*)imageForEquipWithFileName:(NSString *)name{
    NSString *file = [[HumDotaDataMgr instance] pathOfEquipImageDir];
    file = [file stringByAppendingPathComponent:name];
    BqsLog(@"EquipmentImageFile  = %@",file);
    return [UIImage imageWithContentsOfFile:file];
}

@end
