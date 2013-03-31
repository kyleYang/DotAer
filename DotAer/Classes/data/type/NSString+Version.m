//
//  NSString+Version.m
//  DotAer
//
//  Created by Kyle on 13-3-31.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "NSString+Version.h"

@implementation NSString(Version)


- (NSComparisonResult)compareVersion:(NSString *)version
{
    return [self compare:version options:NSNumericSearch];
}

- (NSComparisonResult)compareVersionDescending:(NSString *)version
{
    switch ([self compareVersion:version])
    {
        case NSOrderedAscending:
        {
            return NSOrderedDescending;
        }
        case NSOrderedDescending:
        {
            return NSOrderedAscending;
        }
        default:
        {
            return NSOrderedSame;
        }
    }
}

@end
