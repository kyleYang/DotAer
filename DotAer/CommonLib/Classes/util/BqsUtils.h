//
//  Utils.h
//  iMobee
//
//  Created by ellison on 10-9-13.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Log.h"
#include <math.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define radians(x) ((x)*M_PI/180.0)

@interface BqsUtils : NSObject {

}

+ (NSString *)urlEncodedString:(NSString*)str;
+ (NSString *)urlDecodedString:(NSString*)str;
+ (NSString*)setURL: (NSString*)sUrl ParameterName: (NSString*)sName Value: (NSString*)sValue;
+ (NSString*)getParameter:(NSString*)sName FromUrl:(NSString*)url;
+ (NSDictionary*)getAllParameterFromUrl:(NSString*)url;
+ (NSString*)fixURLHost: (NSString*)sUrl;
+ (NSString*)getURLHost: (NSString*)sUrl;
+ (NSString*)replaceURL:(NSString*)sUrl LastFileName:(NSString*)sFileName;
+ (NSString*)SHA1Hash:(NSString*)str;
+ (NSInteger)randLimit:(NSInteger)max;

//+ (NSString*)bqsCM:(NSString*)udid Salt: (NSString*)salt;
+ (NSString*)bqsPasswordEnc:(NSString*)password;
+ (NSString*)bqsPasswordDec:(NSString*)encPwd;

+ (NSString*)readDevMACAddress;
+ (NSString *) freeDiskSpaceInBytes;
+ (NSString *)calcMD5forString:(NSString*)str;
+ (void)clearCookiesForUrl:(NSString*)url;

+ (int)fileSize:(NSString*)path;
+ (void)deletePath:(NSString*)path;
+ (void)trashPath:(NSString*)path;
+ (void)clearTrashPathBackground:(NSString*)path;
+ (void)checkCreateDir:(NSString*)path;
+ (BOOL)copyFile:(NSString*)path1 To:(NSString*)path2;
+ (BOOL)moveFile:(NSString*)path1 To:(NSString*)path2;

+ (NSString*)stringFromFileSize:(int)size;
+ (NSString*)stringFromUIColor:(UIColor*)color;
+ (NSString*)stringFromData:(NSData*)data Encoding:(NSString*)enoding;
+ (BOOL)parseBoolean:(NSString*)str Def:(BOOL)defValue;
+ (UIColor*)colorFromNSString:(NSString*)str;
+ (NSString*)commaStringFromStringArray:(NSArray*)arr;
+ (NSMutableArray*)parseCommaString:(NSString*)commaStr;
+ (NSString*)localizedWeekDayStr:(NSString*)code;
+ (NSString*)localizedWeekDayLongStr:(NSString*)code;
+ (NSString*)replaceString:(NSString*)str Characters:(NSCharacterSet*)cs WithString:(NSString*)s;
+ (NSString*)base64StringFromData:(NSData*)theData;
+ (NSData*)base64DecodeString:(NSString*)str;

+(NSString*)parseCharsetInContentType:(NSString*)contentType;

+(NSArray*)genRangeFromIntArray:(NSArray*)arrIntNumbers; // return NSArray(NSValue(NSRange))
+(float)getOsVer;
+(float)getScreenScale;

+(NSString*)todayTimeStr;
+(NSString*)todayCurHourTimeStr;
+(NSString*)timeDurationStrWithSecond:(NSInteger)seconds;

+(BOOL) curDisplayChinese;
+(BOOL) isIPad;


+(BOOL)isIpAddress:(NSString*)host;
+(BOOL)isMobilePhoneNumber:(NSString*)str;
+(BOOL)isEmailAddress:(NSString*)str;
+(NSString*)getHostDomain:(NSString*)host;

+(UIImage *)imageWithColor:(UIColor *)color;
+(UIImage *)drawBorderAroundImage:(UIImage*)img Color:(UIColor *)color;
+(UIImage *)drawImageInBox:(UIImage*)img Border:(UIColor *)color Rc:(CGRect)rc;

+(CGFloat)distancePoint1:(CGPoint)a Point2:(CGPoint)b;

+(float)getFontHeight:(UIFont*)fnt;
+(CGSize)getFontChineseSize:(UIFont*)fnt;
+(CGSize)getFontAsciiSize:(UIFont*)fnt;

+(CGRect)rect:(CGRect) rect Inset:(UIEdgeInsets) insets;
+(CGRect)shrinkCenterSize:(CGSize)sz WithInRect:(CGRect)boxRc;
+(CGRect)fitSize:(CGSize)sz WithInRect:(CGRect)boxRc;
+(CGRect)fillSize:(CGSize)sz WithInRect:(CGRect)boxRc;
+(CGAffineTransform)aspectFitFromRc:(CGRect)innerRect ToRc:(CGRect)outerRect;

@end
