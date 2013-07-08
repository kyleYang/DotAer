/*

 AdViewView.h

 Copyright 2010 www.adview.cn. All rights reserved.

*/

#import <UIKit/UIKit.h>

@interface AdViewUtils : NSObject
{
}

/**
 * 返回配置平台情况，如果当前没有该配置缓存，返回nil
 * 未集成SDK的平台会被去掉。被setAdPlatformStatus方法disable的平台可能被去掉。
 * NSString-NSNumber, number is type, string is "name,percent,priority,key1,key2,key3", 
 * like "AdMob,50,1,a14dbf5efb5dd19,,"
 */
+ (NSDictionary*)getPlatformsForKey:(NSString*)adViewKey;

/**
 * 返回的是当前应用集成了SDK库的平台，和网站端配置结果无关。
 * NSString-NSNumber, number is type, string is "name,enable", like "AdMob,1"
 */
+ (NSDictionary*)getAdPlatforms;

/**
 * 设置当前集成平台可用与否，用于单平台测试。
 * NSNumber-NSNumber, key is type, value is 1--enable, 0--disable.
 */
+ (void)setAdPlatformStatus:(NSDictionary*)dict;		

@end