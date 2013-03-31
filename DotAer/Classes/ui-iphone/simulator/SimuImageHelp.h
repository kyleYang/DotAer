//
//  SimuImageHelp.h
//  DotAer
//
//  Created by Kyle on 13-3-27.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimuImageHelp : NSObject

+(UIImage*)imageWithFileName:(NSString *)name;

+(UIImage*)imageForHeroSN:(NSNumber *)heroSn WithFileName:(NSString *)name;

+(UIImage*)imageForEquipWithFileName:(NSString *)name;


@end
