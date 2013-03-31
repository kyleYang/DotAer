//
//  NSString+Version.h
//  DotAer
//
//  Created by Kyle on 13-3-31.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Version)

- (NSComparisonResult)compareVersion:(NSString *)version;
- (NSComparisonResult)compareVersionDescending:(NSString *)version;

@end
