//
//  Utils.m
//  iMobee
//
//  Created by ellison on 10-9-13.
//  Copyright 2010 borqs. All rights reserved.
//

#import "BqsUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSON.h"
#import "Env.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <net/if.h>
#include <net/if_dl.h>

// Assumes unsigned int is a 32-bit integer.  Change as needed
static unsigned int s_GameRand_High = 1;
static unsigned int s_GameRand_Low = 1 ^ 0x49616E42;
static int g_seeded = 0;

// implements the Microsoft-like interface for rand with new function names
void sgamerand(unsigned int seed)
{
	s_GameRand_High = seed;
	s_GameRand_Low = seed ^ 0x49616E42;
}

int gamerand(unsigned int seed)
{
	if(!g_seeded) {
		sgamerand(seed);
		g_seeded = 1;
	}
    s_GameRand_High = (s_GameRand_High << 16) + (s_GameRand_High >> 16);
    s_GameRand_High += s_GameRand_Low;
    s_GameRand_Low += s_GameRand_High;
    return s_GameRand_High;
}

@interface BqsUtils()

+(void)doClearTrashPath:(NSString*)path;

@end


@implementation BqsUtils

+ (NSString *)urlEncodedString:(NSString*)str {
    if(nil == str || [str length] < 1) return str;
    
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)str,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

+ (NSString *)urlDecodedString:(NSString*)str {
    if(nil == str || [str length] < 1) return str;
    
    return [[str stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
//																						   (CFStringRef)str,
//																						   CFSTR(""),
//																						   kCFStringEncodingUTF8);
//    [result autorelease];
//	return result;	

}

+ (NSString*)setURL: (NSString*)sUrl ParameterName: (NSString*)sName Value: (NSString*)sValue {
	if(nil == sUrl || [sUrl length] < 1 ||
	   nil == sName || [sName length] < 1) {
		BqsLog(@"Utils.setURL: %@ ParameterName: %@ Value: %@", sUrl, sName, sValue);
		return sUrl;
	}
    
    NSString *theValue = @"";
    if(nil != sValue) {
        theValue = sValue;
    }
	
	NSRange qPos = [sUrl rangeOfString: @"?"];
	if(NSNotFound == qPos.location) {
		return [sUrl stringByAppendingFormat:@"?%@=%@", sName, [BqsUtils urlEncodedString:theValue]];
	} else if(qPos.location >= [sUrl length]-1) {
		return [sUrl stringByAppendingFormat:@"%@=%@", sName, [BqsUtils urlEncodedString:theValue]];
	}
	
	// has "?"
	NSString *key = [sName stringByAppendingString:@"="];
	NSRange oldPos = [sUrl rangeOfString: key];
	
    while(NSNotFound != oldPos.location && oldPos.location > 0) {
        unichar ch = [sUrl characterAtIndex:oldPos.location - 1];
        if('?' != ch && '&' != ch) {
            NSRange left = NSMakeRange(oldPos.location + oldPos.length, [sUrl length] - oldPos.location - oldPos.length);
            if(left.length < [key length]) {
                oldPos.location = NSNotFound;
                break;
            } else {
//                BqsLog(@"len: %d, op.p: %d, op.l: %d, l.p: %d, l.l: %d", [sUrl length], oldPos.location, oldPos.)
                oldPos = [sUrl rangeOfString:key options:NSLiteralSearch range:left];
            }
        } else {
            break;
        }
    }
    
	if(NSNotFound == oldPos.location) {
		if([sUrl characterAtIndex: [sUrl length] - 1] == '&') {
			return [sUrl stringByAppendingFormat:@"%@=%@", sName, [BqsUtils urlEncodedString:theValue]];
		} else {
			return [sUrl stringByAppendingFormat:@"&%@=%@", sName, [BqsUtils urlEncodedString:theValue]];
		}
	} else {
        
		NSString* subE = [sUrl substringFromIndex:oldPos.location + oldPos.length];

		NSRange endPos = [subE rangeOfString:@"&"];
		if(NSNotFound == endPos.location) {
			subE = @"";
		} else {
			subE = [subE substringFromIndex:endPos.location];
		}

		return [NSString stringWithFormat:@"%@%@=%@%@",
				[sUrl substringToIndex: oldPos.location],
				sName,
				[BqsUtils urlEncodedString:theValue],
				subE];
	}

	return sUrl;
}

+(NSString*)getParameter:(NSString *)sName FromUrl:(NSString *)url {
    if(url.length < 1 || sName.length < 1) {
        BqsLog(@"Invalid url: %@, sName: %@", url, sName);
        return nil;
    }
    
    NSRange rng = [url rangeOfString:@"?"];
    if(NSNotFound == rng.location) {
        return nil;
    }
    NSString *queryString = [url substringFromIndex:rng.location + rng.length];
    if(queryString.length < 1) return nil;
    
    // pos
    rng = [queryString rangeOfString:[NSString stringWithFormat:@"%@=",sName]];
    if(NSNotFound == rng.location) return nil;
    
    NSString *valueString = [queryString substringFromIndex:rng.location + rng.length];
    rng = [valueString rangeOfString:@"&"];
    if(NSNotFound == rng.location) return valueString;
    
    return [queryString substringToIndex:rng.location];
}

+ (NSDictionary*)getAllParameterFromUrl:(NSString*)url {
    if(url.length < 1) {
        BqsLog(@"Invalid url");
        return nil;
    }
    
    NSRange rng = [url rangeOfString:@"?"];
    if(NSNotFound == rng.location) {
        return nil;
    }
    
    NSString *queryString = [url substringFromIndex:rng.location + rng.length];
    if(queryString.length < 1) return nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            value = [BqsUtils urlDecodedString:value];
            if(key && value)
                [dict setObject:value forKey:key];
        }
    }
    return dict;
}

+ (NSString*)fixURLHost: (NSString*)sUrl {
	if(nil == sUrl || [sUrl length] < 1) return sUrl;
	
	if([sUrl hasPrefix:@"/"]) {
		return [NSString stringWithFormat:@"http://%@%@", [Env sharedEnv].host, sUrl];
	}
	
	return sUrl;
}
+ (NSString*)getURLHost: (NSString*)sUrl {
    if(sUrl.length < 1) return @"";
    
    NSURL *theUrl = [[NSURL alloc] initWithString:sUrl];//[NSURL URLWithString:sUrl];
    NSString *urlHost = [[[theUrl host] copy] autorelease];
    [theUrl release];
    
    return urlHost;
}

+ (NSString*)replaceURL:(NSString*)sUrl LastFileName:(NSString*)sFileName {
    if([sUrl length] < 1) return nil;
    if([sFileName length] < 1) return nil;
    
    int length = [sUrl length];
    int i = 0;
    for( i = length - 1; i >= 0; i --) {
        unichar c = [sUrl characterAtIndex:i];
        if('/' == c) {
            break;
        }
    }
    
    if(i < 0) {
        return nil;
    }
    
    NSString *s = [sUrl substringToIndex:i];
    NSString *sRet = @"";
    if(![sFileName hasPrefix:@"/"]) {
        sRet = [NSString stringWithFormat:@"%@/%@", s, sFileName];
    } else {
        sRet = [NSString stringWithFormat:@"%@%@", s, sFileName];
    }
    
    return sRet;
}


+ (NSString *)SHA1Hash:(NSString *)clearText
{
	const char *cStr = [clearText UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X"
			@"%02X%02X%02X%02X%02X"
			@"%02X%02X%02X%02X%02X"
			@"%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4],
			result[5], result[6], result[7], result[8], result[9], 
			result[10],result[11],result[12],result[13],result[14],
			result[15],result[16], result[17], result[18], result[19]
			];
}

//+ (NSString*)bqsCM:(NSString*)udid Salt: (NSString*)salt {
//    if(nil == salt || [salt length] < 1 ||
//       nil == udid || [udid length] < 1) {
//        BqsLog(@"invalid param: %@,%@", udid, salt);
//        return udid;
//    }
//
//	NSString *sA = [udid stringByAppendingString:salt];
//	NSString *sB = [BqsUtils SHA1Hash:sA];
//	
//	//NSMutableString *sC = [[NSMutableString alloc] initWithCapacity:10];
//	int len = [sB length];
//	len = len / 4;
//	char data[CC_SHA1_DIGEST_LENGTH];
//	
//	int i;
//	for(i = 0; i < len; i ++) {
//		data[i] = [sB characterAtIndex: i * 4];
//	}
//	data[i] = 0;
//
//	return [NSString stringWithUTF8String: data];
//
//}

+ (NSString*)bqsPasswordEnc:(NSString*)password {
    if(nil == password || password.length < 1) return nil;
    
    const char *putf8 = [password UTF8String];
    NSString *sbase64 = [BqsUtils base64StringFromData:[NSData dataWithBytes:putf8 length:strlen(putf8)]];
    
    putf8 = [sbase64 UTF8String];
    int len = strlen(putf8);
    
    NSMutableData *obuf = [NSMutableData dataWithLength:len];
    char *pout = (char*)[obuf mutableBytes];
    
    int codeMin = (len % 64) / 2;
    int codeMax = codeMin * 2;
    
    int curCode = codeMax;
    
    for(int i = 0; i < len ; i++) {
        int b = putf8[i];
        
        b += curCode;
        
        b %= 128;
        
        pout[i] = (char)b;
        
        curCode --;
        if(curCode < codeMin) {
            curCode = codeMax;
        }
    }
    
    return [BqsUtils base64StringFromData:obuf];
}

+ (NSString*)bqsPasswordDec:(NSString*)encPwd {
    if(nil == encPwd || encPwd.length < 1) return nil;
    
    NSData *dat = [BqsUtils base64DecodeString:encPwd];
    if(nil == dat || dat.length < 1) return nil;
    
    char *pb = (char*)[dat bytes];
    
    int len = [dat length];
    NSMutableData *obuf = [NSMutableData dataWithLength:len + 1];
    char *pout = (char*)[obuf mutableBytes];
    
    int codeMin = (len % 64) / 2;
    int codeMax = codeMin * 2;
    
    int curCode = codeMax;
    
    for(int i = 0; i < len ; i++) {
        int b = pb[i];
        
        b -= curCode;
        
        if(b < 0) b += 128;
        
        pout[i] = (char)b;
        
        curCode --;
        if(curCode < codeMin) {
            curCode = codeMax;
        }
    }
    
    pout[len] = '\0';
    
    NSString *sbase64 = [NSString stringWithUTF8String:pout];
    
    dat = [BqsUtils base64DecodeString:sbase64];
    
    if(nil == dat || dat.length < 1) return nil;
    
    obuf = [NSMutableData dataWithLength:dat.length + 1];
    pb = (char*)[dat bytes];
    pout = (char*)[obuf mutableBytes];
    memcpy(pout, pb, dat.length);
    pout[dat.length] = '\0';
    
    return [NSString stringWithUTF8String:pout];
}


// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
+ (NSString*)readDevMACAddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

//get left size
+ (NSString *) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"%qi" ,freespace/1024/1024/1024];
}

+ (NSString *) calcMD5forString:(NSString*)str {
    
    if(str == nil || [str length] < 1) return nil;
    
    const char *value = [str UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

+(void) clearCookiesForUrl:(NSString *)url {
    if(nil == url || [url length] < 1) return;
    
    NSHTTPCookieStorage *cs = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *arr = [cs cookiesForURL:[NSURL URLWithString:url]];
    if(nil != arr && [arr count] > 0) {
        for(NSHTTPCookie *ck in arr) {
            [cs deleteCookie:ck];
        }
    }
}

+ (NSInteger)randLimit:(NSInteger)max {
	double now = [NSDate timeIntervalSinceReferenceDate];
	NSString *sNow = [NSString stringWithFormat:@"%f", now];
	int random = gamerand([sNow hash]);
	
	if(random < 0) random = - random;
	return (random % max);
}

+ (int)fileSize:(NSString*)path {
    if(nil == path || [path length] < 1) {
        BqsLog(@"path is nil");
        return 0;
    }

	// Get file size
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError* err = nil;
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&err];
	if(nil == err && fileAttributes != nil) {
		NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
		
		if(nil != fileSize) {
			return [fileSize intValue];
		}
	}
	return 0;
}

+ (void)deletePath:(NSString*)path {
    if(nil == path || [path length] < 1) {
        BqsLog(@"path is nil");
        return;
    }
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	BOOL bIsDir = NO;
	BOOL bExist = [fileManager fileExistsAtPath:path isDirectory: &bIsDir];
	if(!bExist){
		[fileManager release];
		return;
	}
	
	NSError* err = nil;
	if(![fileManager removeItemAtPath:path error:&err]) {
		BqsLog(@"Failed to removePath:%@, err:%@", path, err);
	}
	BqsLog(@"deleted: %@", path);
	[fileManager release];
}

+ (void)trashPath:(NSString*)path {
    if(nil == path || [path length] < 1) {
        BqsLog(@"path is nil");
        return;
    }
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//NSError* err = nil;
	BOOL bIsDir = NO;
	BOOL bExist = [fileManager fileExistsAtPath:path isDirectory: &bIsDir];
	if(!bExist) return;
	
	double now = [NSDate timeIntervalSinceReferenceDate];
	NSString *sNow = [NSString stringWithFormat:@"%f", now];
	int random = gamerand([sNow hash]);
	
	NSString *fileName = [[Env sharedEnv].dirTmp stringByAppendingPathComponent:
						  [NSString stringWithFormat:@"%@_%x", sNow, random]];
	BqsLog(@"trash: %@ -> %@", path, fileName);
	
	[BqsUtils moveFile:path To:fileName];
	[BqsUtils clearTrashPathBackground:fileName];
}

+ (void)clearTrashPathBackground:(NSString*)path {
    if(nil == path || [path length] < 1) {
        BqsLog(@"path is nil");
        return;
    }

	[BqsUtils performSelectorInBackground:@selector(doClearTrashPath:) withObject: path];
}

+(void)doClearTrashPath:(NSString*)sPath {
    if(nil == sPath || [sPath length] < 1) {
        BqsLog(@"sPath is nil");
        return;
    }
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *path = [NSString stringWithString:sPath];
	
	[BqsUtils deletePath:path];
	
	[pool release];
}

+ (void)checkCreateDir:(NSString*)path {
    if(nil == path || [path length] < 1) {
        BqsLog(@"path is nil");
        return;
    }

	// Get file size
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError* err = nil;
	BOOL bIsDir = NO;
	BOOL bExist = [fileManager fileExistsAtPath:path isDirectory: &bIsDir];
	if(bExist && bIsDir) return;
	
	if(bExist) {
		if(![fileManager removeItemAtPath:path error:&err]) {
			BqsLog(@"Failed to removePath:%@, err:%@", path, err);
		}
	}
	
	if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes: nil error:&err]) {
		BqsLog(@"Failed to createPath:%@, err:%@", path, err);
	}
	
	
}

+ (BOOL)copyFile:(NSString*)path1 To:(NSString*)path2 {
    if(nil == path1 || [path1 length] < 1 ||
       nil == path2 || [path2 length] < 1) {
        BqsLog(@"invalid param. %@, %@", path1, path2);
        return NO;
    }

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError* err = nil;
	if(![fileManager copyItemAtPath:path1 toPath:path2 error:&err]) {
		BqsLog(@"Failed to copy:%@->%@, err:%@", path1, path2, err);
		return NO;
	}
	return YES;
}
+ (BOOL)moveFile:(NSString*)path1 To:(NSString*)path2 {
    if(nil == path1 || [path1 length] < 1 ||
       nil == path2 || [path2 length] < 1) {
        BqsLog(@"invalid param. %@, %@", path1, path2);
        return NO;
    }

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError* err = nil;
	if(![fileManager moveItemAtPath:path1 toPath:path2 error:&err]) {
		BqsLog(@"Failed to move:%@->%@, err:%@", path1, path2, err);
		return NO;
	}
	return YES;
	
}

+ (NSString*)stringFromFileSize:(int)theSize {
	float floatSize = theSize;
	if (theSize<1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1fKB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1fMB",floatSize]);
	floatSize = floatSize / 1024;
	
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

+ (NSString*)stringFromUIColor:(UIColor*)color {
	if(nil == color) return @"";
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	return [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
}

+ (NSString*)stringFromData:(NSData*)data Encoding:(NSString*)enoding {
    if(nil == data || [data length] < 1) return @"";
    
    // parse string
    NSStringEncoding se = NSUTF8StringEncoding;
    if(nil != enoding && [enoding length] > 0) {
        CFStringEncoding cfse = CFStringConvertIANACharSetNameToEncoding((CFStringRef)enoding);
        if(kCFStringEncodingInvalidId == cfse) {
            BqsLog(@"Invalid charset name=%@", enoding);
        } else {
            se = CFStringConvertEncodingToNSStringEncoding(cfse);
        }
    }
    
    NSString *sRet = [[[NSString alloc] initWithData:data encoding:se] autorelease];
//    BqsLog(@"charset=%@, %d", enoding, se);
    if(nil == sRet && se != NSUTF8StringEncoding) {
        BqsLog(@"Try utf-8");
        se = NSUTF8StringEncoding;
        sRet = [[[NSString alloc] initWithData:data encoding:se] autorelease];
    }
    if(nil == sRet) {
        // try gbk
        CFStringEncoding cfse = CFStringConvertIANACharSetNameToEncoding((CFStringRef)@"gbk");
        if(kCFStringEncodingInvalidId == cfse) {
            BqsLog(@"Invalid charset gbk");
        } else {
            se = CFStringConvertEncodingToNSStringEncoding(cfse);
            sRet = [[[NSString alloc] initWithData:data encoding:se] autorelease];
        }
    }
    
    if(nil == sRet) {
        BqsLog(@"Failed to parse data into string");
        return @"";
    }

    return sRet;
}

+ (NSString*)base64StringFromData:(NSData*)theData {
    if(nil == theData || [theData length] < 1) return nil;
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

+ (NSData*)base64DecodeString:(NSString*)str {
    if(nil == str) {
        return nil;
    }
    
    int iLen = [str length];
    if(iLen % 4 != 0) {
        return nil;
    }
    
    const char *pIn = [str UTF8String];
    while(iLen > 0 && '=' == pIn[iLen-1]) {
        iLen --;
    }
    
    if(iLen < 1) return nil;
    
    int oLen = (iLen * 3) / 4;
    NSMutableData *outData = [[[NSMutableData alloc] initWithLength:oLen] autorelease];
    
    int ip = 0;
    int op = 0;
    char *pOut = (char*)[outData mutableBytes];
    
    
    NSMutableData *map1 = [[[NSMutableData alloc] initWithLength:64] autorelease];
    NSMutableData *map2 = [[[NSMutableData alloc] initWithLength:128] autorelease];
    char* pMap1 = (char*)[map1 mutableBytes];
    char* pMap2 = (char*)[map2 mutableBytes];
    {
        int i = 0;
        char c;
        for(c = 'A'; c <= 'Z'; c++) {
            pMap1[i++] = c;
        }
        for(c = 'a'; c <= 'z'; c++) {
            pMap1[i++] = c;
        }
        for(c = '0'; c <= '9'; c++) {
            pMap1[i++] = c;
        }
        pMap1[i++] = '+';
        pMap1[i++] = '/';
        
        int len = [map2 length];
        for(i = 0; i < len; i ++) {
            pMap2[i] = -1;
        }
        for(i = 0; i < 64; i ++) {
            pMap2[pMap1[i]] = (char)i;
        }
    }
    
    while(ip < iLen) {
        int i0 = pIn[ip ++];
        int i1 = pIn[ip ++];
        int i2 = ip < iLen ? pIn[ip++] : 'A';
        int i3 = ip < iLen ? pIn[ip++] : 'A';
        
        if(i0 > 127 || i1 > 127 || i2 > 127 || i3 > 127) {
            return nil;
        }
        
        int b0 = pMap2[i0];
        int b1 = pMap2[i1];
        int b2 = pMap2[i2];
        int b3 = pMap2[i3];
        if(b0 < 0 || b1 < 0 || b2 < 0 || b3 < 0) {
            return nil;
        }
        
        int o0 = (b0 << 2) | (b1 >> 4);
        int o1 = ((b1 & 0xf) << 4) | (b2 >> 2);
        int o2 = ((b2 & 3) << 6) | b3;
        pOut[op++] = (char)o0;
        
        if(op < oLen) {
            pOut[op++] = (char)o1;
        }
        if(op < oLen) {
            pOut[op++] = (char)o2;
        }   
    }
    
    return outData;

}

+ (BOOL)parseBoolean:(NSString*)str Def:(BOOL)defValue {
    if(nil == str || [str length] < 1) return defValue;
    
    NSString *lwS = [str lowercaseString];
    
    if([@"yes" isEqualToString:lwS] ||
       [@"true" isEqualToString:lwS] ||
       [@"1" isEqualToString:lwS]) {
        return YES;
    } else if([@"no" isEqualToString:lwS] ||
              [@"false" isEqualToString:lwS] || 
              [@"0" isEqualToString:lwS]) {
        return NO;
    }
    return defValue;
}

+ (UIColor*)colorFromNSString:(NSString*)str {
	if(nil == str || [str length] < 1) return nil;
	NSArray *components = [str componentsSeparatedByString:@","];
	if([components count] < 4) {
		BqsLog(@"Invalid color string: %@", str);
		return nil;
	}
	
	CGFloat r = [[components objectAtIndex:0] floatValue];
	CGFloat g = [[components objectAtIndex:1] floatValue];
	CGFloat b = [[components objectAtIndex:2] floatValue];
	CGFloat a = [[components objectAtIndex:3] floatValue];
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (NSString*)commaStringFromStringArray:(NSArray*)arr {
	NSMutableString *ret = [[[NSMutableString alloc] initWithCapacity:128] autorelease];
	
	BOOL bFirst = YES;
	for(NSString *s in arr) {
		if(!bFirst) {
			[ret appendString:@","];
		}
		[ret appendString: s];
		bFirst = NO;
	}
	
	return ret;
}
+ (NSMutableArray*)parseCommaString:(NSString*)commaStr {
    if(nil == commaStr || commaStr.length < 1) return nil;
    
    NSArray *components = [commaStr componentsSeparatedByString:@","];
    if([components count] > 0) {
        
        NSCharacterSet *csEmpty = [NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"];
        
        NSMutableArray *ms = [NSMutableArray arrayWithCapacity:[components count]];
        for(NSString *chid in components) {
            if(nil == chid || chid.length < 1) continue;
            
            NSString *channelId = [chid stringByTrimmingCharactersInSet:csEmpty];
            if(nil != channelId && channelId.length > 0) {
                [ms addObject:channelId];
            }
        }
        
        if([ms count] > 0) {
            return ms;
        }
    }

    return nil;
}

+ (NSString*)localizedWeekDayStr:(NSString*)code {
	if(nil == code || [code length] < 1) return @"";
	
	NSString *lc = [code lowercaseString];
	
	/*
	 "day_sun"="周日";
	 "day_mon"="周一";
	 "day_tue"="周二";
	 "day_wed"="周三";
	 "day_thu"="周四";
	 "day_fri"="周五";
	 "day_sat"="周六";
	 */
	if([lc hasPrefix:@"sun"]) return NSLocalizedStringFromTable(@"day.sun", @"commonlib", nil);
	else if([lc hasPrefix:@"mon"]) return NSLocalizedStringFromTable(@"day.mon", @"commonlib", nil);
	else if([lc hasPrefix:@"tue"]) return NSLocalizedStringFromTable(@"day.tue", @"commonlib", nil);
	else if([lc hasPrefix:@"teu"]) return NSLocalizedStringFromTable(@"day.tue", @"commonlib", nil);
	else if([lc hasPrefix:@"wed"]) return NSLocalizedStringFromTable(@"day.wed", @"commonlib", nil);
	else if([lc hasPrefix:@"thu"]) return NSLocalizedStringFromTable(@"day.thu", @"commonlib", nil);
	else if([lc hasPrefix:@"fri"]) return NSLocalizedStringFromTable(@"day.fri", @"commonlib", nil);
	else if([lc hasPrefix:@"sat"]) return NSLocalizedStringFromTable(@"day.sat", @"commonlib", nil);
	else return code;
	
	/*day.long.sun
	 */
}

+ (NSString*)localizedWeekDayLongStr:(NSString*)code {
	if(nil == code || [code length] < 1) return @"";
	
	NSString *lc = [code lowercaseString];
	

	if([lc hasPrefix:@"sun"]) return NSLocalizedStringFromTable(@"day.long.sun", @"commonlib", nil);
	else if([lc hasPrefix:@"mon"]) return NSLocalizedStringFromTable(@"day.long.mon", @"commonlib", nil);
	else if([lc hasPrefix:@"tue"]) return NSLocalizedStringFromTable(@"day.long.tue", @"commonlib", nil);
	else if([lc hasPrefix:@"teu"]) return NSLocalizedStringFromTable(@"day.long.tue", @"commonlib", nil);
	else if([lc hasPrefix:@"wed"]) return NSLocalizedStringFromTable(@"day.long.wed", @"commonlib", nil);
	else if([lc hasPrefix:@"thu"]) return NSLocalizedStringFromTable(@"day.long.thu", @"commonlib", nil);
	else if([lc hasPrefix:@"fri"]) return NSLocalizedStringFromTable(@"day.long.fri", @"commonlib", nil);
	else if([lc hasPrefix:@"sat"]) return NSLocalizedStringFromTable(@"day.long.sat", @"commonlib", nil);
	else return code;
	
}

+ (NSString*)replaceString:(NSString*)str Characters:(NSCharacterSet*)cs WithString:(NSString*)s {
    if(nil == str || [str length] < 1 || nil == cs || nil == s) return str;
    
    int replaceLen = [s length];
    int cnt = [str length];
    int dstBufLen = cnt + 256;
    
    unichar *dstBuf = malloc(sizeof(unichar) * dstBufLen);
    unichar *orgBuf = malloc(sizeof(unichar) * cnt);
    unichar *replaceBuf = malloc(sizeof(unichar) * replaceLen);
    
    [str getCharacters:orgBuf range:NSMakeRange(0, cnt)];
    [s getCharacters:replaceBuf range:NSMakeRange(0, replaceLen)];
    
    unichar *porg = orgBuf;
    unichar *pdst = dstBuf;
    
    int i, dstcnt;
    
    dstcnt = 0;
    
    for(i = 0; i < cnt; i ++) {
        unichar c = *porg;
        porg ++;
        
        // check dst buf length
        {
            if(dstcnt + replaceLen > dstBufLen) {
                BqsLog(@"malloc new length");
                int newlen = dstBufLen + replaceLen + 1024;
                // realloc dst buf
                unichar *newbuf = malloc(sizeof(unichar) * newlen);
                memcpy(newbuf, dstBuf, (sizeof(unichar) * dstcnt));
                
                free(dstBuf);
                dstBuf = newbuf;
                dstBufLen = newlen;
                pdst = ((void*)dstBuf + sizeof(unichar)*dstcnt);
            }
        }
        
        if([cs characterIsMember:c]) {
            // is member, copy replace char to target
            unichar *preplace = replaceBuf;
            for(int rc = 0; rc < replaceLen; rc ++) {
                *pdst = *preplace;
                pdst ++;
                preplace ++;
                dstcnt ++;
            }
        } else {
            // not member, copy to target
            *pdst = c; 
            pdst ++;
            dstcnt ++;
        }
    }
    
    NSString *ret = [NSString stringWithCharacters:dstBuf length:dstcnt];
    
    free(dstBuf);
    free(orgBuf);
    free(replaceBuf);
    
    return ret;
}

+(NSString*)parseCharsetInContentType:(NSString*)contentType {
	//"text/html; charset=iso-8859-1"
	if(nil == contentType || [contentType length] < 1) return nil;
	
	NSString *lct = [contentType lowercaseString];
	NSRange rng = [lct rangeOfString:@"charset="];
	if(NSNotFound == rng.location) {
		BqsLog(@"No charset in %@", contentType);
		return nil;
	}
	
	NSString *cs = [contentType substringFromIndex:rng.location +rng.length];
    
    rng = [cs rangeOfString:@";"];
    if(NSNotFound != rng.location) {
        cs = [cs substringToIndex:rng.location];
    }
    
	return [cs stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" '\"\n\r\t"]];
}

NSInteger intSort(id num1, id num2, void *context)
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

// return NSArray(NSValue(NSRange))
+(NSArray*)genRangeFromIntArray:(NSArray*)arrIntNumbers {
    if(nil == arrIntNumbers || [arrIntNumbers count] < 1) return nil;
    
    NSArray *sortedArr = [arrIntNumbers sortedArrayUsingFunction:intSort context:NULL];
    
    NSMutableArray *arrRng = [NSMutableArray arrayWithCapacity:[sortedArr count]];
    
    int nStart = -1, nEnd = -1;
    for(NSNumber *n in sortedArr) {
        int nV = [n intValue];
        if(-1 == nStart) {
            nStart = nV;
            nEnd = nStart;
        } else {
            if(nV == nEnd + 1) {
                nEnd = nV;
                continue;
            }
            
            // new range 
            [arrRng addObject:[NSValue valueWithRange:NSMakeRange(nStart, nEnd - nStart + 1)]];
            
            nStart = nV;
            nEnd = nStart;
        }
    }
    
    if(nStart >= 0 && nEnd >= nStart) {
        [arrRng addObject:[NSValue valueWithRange:NSMakeRange(nStart, nEnd - nStart + 1)]];
    }

    return arrRng;
}

+(float)getOsVer {
	NSString *osVer = [UIDevice currentDevice].systemVersion;
	float fOsVer = [osVer floatValue];
	
//	BqsLog(@"osver: %@->%f", osVer, fOsVer);
	return fOsVer;
}
+(float)getScreenScale {
	
	float fOsVer = [BqsUtils getOsVer];
	
	if(fOsVer >= 4.0f) {
		// os 4
		float scale = [UIScreen mainScreen].scale;
        if(scale < 1.0) return 1.0;
        return scale;
	}
	
	return 1.0;
}

+(NSString*)todayTimeStr {
	NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
	[date_formater setDateFormat:@"yyyyMMdd"];
	NSString* sDate = [date_formater stringFromDate:[NSDate date]];
	[date_formater release];
	
	return sDate;
}

+(NSString*)todayCurHourTimeStr {
	NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
	[date_formater setDateFormat:@"yyyyMMddHH"];
	NSString* sDate = [date_formater stringFromDate:[NSDate date]];
	[date_formater release];
	
	return sDate;	
}

+(NSString*)timeDurationStrWithSecond:(NSInteger)seconds {
	NSInteger s = seconds % 60;
	NSInteger m = seconds / 60;
	NSInteger h = 0;
	
	if(m > 60) {
		h = m / 60;
		m = m % 60;
	}
	
	if(h > 0) {
		return [NSString stringWithFormat:@"%d:%02d:%02d", h, m, s];
	} else {
		return [NSString stringWithFormat:@"%d:%02d", m, s];
	}
}

+(BOOL) curDisplayChinese {
	if([NSLocalizedStringFromTable(@"sys.language", @"commonlib", nil) hasPrefix:@"zh"]) {
		return YES;
	}
	return NO;
}

+(BOOL) isIPad {
#ifdef __IPHONE_3_2
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        return YES;
    }
#endif
    return NO;
}



+(BOOL)isIpAddress:(NSString*)host {
    if(nil == host || [host length] < 1) return NO;
    
    const char* pHost = [host UTF8String];
    int len = strlen(pHost);
    int i;
    
    for(i = 0; i < len; i ++) {
        char c = pHost[i];
        
        if('.' == c ||
           ('0' <= c && '9' >= c)) {
            continue;
        } else {
            return NO;
        }
    }
    
    
    
    return YES;
}

+(BOOL)isMobilePhoneNumber:(NSString*)str {
    if(nil == str || str.length < 1) return NO;
    
    const char *ps = [str UTF8String];
    
    int len = strlen(ps);
    int i;
    for(i = 0; i < len; i ++) {
        char c = ps[i];
        
        if('0' <= c && '9' >= c) {
            continue;
        } else {
            return NO;
        }
    }
    
    return YES;
}

+(BOOL)isEmailAddress:(NSString*)str {
    if(nil == str || str.length < 1) return NO;
 
    NSRange loc = [str rangeOfString:@"@"];
    if(NSNotFound == loc.location) return NO;
    
    loc = [str rangeOfString:@"."];
    if(NSNotFound == loc.location) return NO;
    
    return YES;
}

+(NSString*)getHostDomain:(NSString*)host {
    if(nil == host || [host length] < 1) return host;
    
    if([BqsUtils isIpAddress:host]) return host;
    
    NSRange rDot1 = [host rangeOfString:@"."];
    if(NSNotFound == rDot1.location) return host;
    
    NSUInteger nIdx = rDot1.location + rDot1.length;
    NSRange rDot2 = [host rangeOfString:@"." options:NSLiteralSearch range:NSMakeRange(nIdx, [host length]-nIdx)];
    
    if(NSNotFound == rDot2.location) return host;
    
    return [host substringFromIndex:rDot1.location];
}


+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	if([BqsUtils getOsVer] >= 4.0f) {
		UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(rect.size);
	}

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIImage *)drawBorderAroundImage:(UIImage*)img Color:(UIColor *)color {
    if(nil == img) return img;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
	if([BqsUtils getOsVer] >= 4.0f) {
		UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(rect.size);
	}

    CGContextRef context = UIGraphicsGetCurrentContext();
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
	CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, rect, img.CGImage);
    
    rect.origin.x += .5;
    rect.origin.y += .5;
    rect.size.width -= 1;
    rect.size.height -= 1;

    // draw line
	CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGContextSetLineWidth(context, 1);
	//CGContextSetLineJoin(context, kCGLineJoinRound);
	
	CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)drawImageInBox:(UIImage*)img Border:(UIColor *)color Rc:(CGRect)rc {
    if(nil == img) return img;
    //BqsLog(@"drawImgInBox: %.1fx%.1f", rc.size.width, rc.size.height);
    
    CGRect rect = rc;
	if([BqsUtils getOsVer] >= 4.0f) {
		UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(rect.size);
	}

    CGContextRef context = UIGraphicsGetCurrentContext();
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
	CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rcImg = rect;
    {
        CGSize szImg = img.size;
        if(szImg.height > 0 && szImg.width > 0 &&
           rcImg.size.height > 0 && rcImg.size.width > 0) {
            CGSize szRc = rcImg.size;
            float ratioImg = szImg.width / szImg.height;
            float ratioRc = szRc.width / szRc.height;
            
            if(ratioImg > ratioRc) {
                szRc.height = floor(szRc.width * (szImg.height/szImg.width));
            } else if(ratioImg < ratioRc) {
                szRc.width = floor(szRc.height * ratioImg);
            }
            
            if(szRc.width < rcImg.size.width) {
                rcImg.origin.x = floor(rcImg.origin.x + (rcImg.size.width - szRc.width) / 2.0);
                rcImg.size.width = szRc.width;
            }
            if(szRc.height < rcImg.size.height) {
                rcImg.origin.y = floor(rcImg.origin.y + (rcImg.size.height - szRc.height) / 2.0);
                rcImg.size.height = szRc.height;
            }
        }
//        BqsLog(@"imgSize: %.1fx%.1f", rcImg.size.width, rcImg.size.height);
        CGContextDrawImage(context, rcImg, img.CGImage);
    }
    
    rcImg.origin.x += .5;
    rcImg.origin.y += .5;
    rcImg.size.width -= 1;
    rcImg.size.height -= 1;
    
    // draw line
	CGContextBeginPath(context);
    CGContextMoveToPoint(context, rcImg.origin.x, rcImg.origin.y);
    CGContextAddLineToPoint(context, rcImg.origin.x, rcImg.size.height + rcImg.origin.y);
    CGContextAddLineToPoint(context, rcImg.size.width + rcImg.origin.x, rcImg.size.height + rcImg.origin.y);
    CGContextAddLineToPoint(context, rcImg.size.width + rcImg.origin.x, rcImg.origin.y);
    CGContextAddLineToPoint(context, rcImg.origin.x, rcImg.origin.y);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGContextSetLineWidth(context, 1);
	//CGContextSetLineJoin(context, kCGLineJoinRound);
	
	CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

+(CGFloat)distancePoint1:(CGPoint)a Point2:(CGPoint)b {
	return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
}


+(float)getFontHeight:(UIFont *)fnt {
    if(nil == fnt) return 0;
    
    unichar c = 0x6211; // 我
	NSString *str = [NSString stringWithCharacters:&c length:1];
	CGSize sz = [str sizeWithFont:fnt];
    
    return sz.height;
}
+(CGSize)getFontChineseSize:(UIFont*)fnt {
    if(nil == fnt) return CGSizeZero;
    
    unichar c = 0x6211; // 我
	NSString *str = [NSString stringWithCharacters:&c length:1];
	CGSize sz = [str sizeWithFont:fnt];
    
    return sz;
}
+(CGSize)getFontAsciiSize:(UIFont*)fnt {
    if(nil == fnt) return CGSizeZero;
    
	NSString *str = @"W";
	CGSize sz = [str sizeWithFont:fnt];
    
    return sz;
}

+(CGRect) rect:(CGRect) rect Inset:(UIEdgeInsets) insets {
    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
                      rect.size.width - (insets.left + insets.right),
                      rect.size.height - (insets.top + insets.bottom));
}

+(CGRect)shrinkCenterSize:(CGSize)sz WithInRect:(CGRect)boxRc {
    if(sz.width <= 0 || sz.height <= 0 ||
       boxRc.size.width <= 0 || boxRc.size.height <= 0) {
        return CGRectZero;
    }
    
    if(sz.width < boxRc.size.width && sz.height < boxRc.size.height) {
        return CGRectMake(boxRc.origin.x + floor((boxRc.size.width-sz.width)/2.0), boxRc.origin.y + floor((boxRc.size.height-sz.height)/2.0), sz.width, sz.height);
    } else {
        // shrink
        CGRect szRc = boxRc;
        float ratioSz = sz.width / sz.height;
        float ratioRc = boxRc.size.width / boxRc.size.height;
        
        if(ratioSz > ratioRc) {
            szRc.size.height = floor(szRc.size.width * (sz.height/sz.width));
        } else if(ratioSz < ratioRc) {
            szRc.size.width = floor(szRc.size.height * ratioSz);
        }
        
        if(szRc.size.width < boxRc.size.width) {
            szRc.origin.x = floor(szRc.origin.x + (boxRc.size.width - szRc.size.width) / 2.0);
        }
        if(szRc.size.height < boxRc.size.height) {
            szRc.origin.y = floor(szRc.origin.y + (boxRc.size.height - szRc.size.height) / 2.0);
        }
        return szRc;
    }
}
+(CGRect)fitSize:(CGSize)sz WithInRect:(CGRect)boxRc {
    if(sz.width <= 0 || sz.height <= 0 ||
       boxRc.size.width <= 0 || boxRc.size.height <= 0) {
        return boxRc;
    }
    
    CGRect rcRet = boxRc;
    
    CGRect szRc = boxRc;
    float ratioSz = sz.width / sz.height;
    float ratioRc = boxRc.size.width / boxRc.size.height;
    
    if(ratioSz > ratioRc) {
        szRc.size.height = floor(szRc.size.width * (sz.height/sz.width));
        
        rcRet.origin.y += floor((boxRc.size.height - szRc.size.height)/2.0);
        rcRet.size.height = szRc.size.height;
    } else if(ratioSz < ratioRc) {
        szRc.size.width = floor(szRc.size.height * ratioSz);
        
        rcRet.origin.x += floor((boxRc.size.width - szRc.size.width)/2.0);
        rcRet.size.width = szRc.size.width;
    }

    return rcRet;
}

+(CGRect)fillSize:(CGSize)sz WithInRect:(CGRect)boxRc {
    if(sz.width <= 0 || sz.height <= 0 ||
       boxRc.size.width <= 0 || boxRc.size.height <= 0) {
        return boxRc;
    }
    
    CGRect rcRet = boxRc;
    
    CGRect szRc = boxRc;
    float ratioSz = sz.width / sz.height;
    float ratioRc = boxRc.size.width / boxRc.size.height;
    
    if(ratioSz > ratioRc) {
        szRc.size.width = floor(szRc.size.height * ratioSz);
        
        rcRet.origin.x += floor((boxRc.size.width - szRc.size.width)/2.0);
        rcRet.size.width = szRc.size.width;
    } else if(ratioSz < ratioRc) {
        szRc.size.height = floor(szRc.size.width * (sz.height/sz.width));
        
        rcRet.origin.y += floor((boxRc.size.height - szRc.size.height)/2.0);
        rcRet.size.height = szRc.size.height;
    }
    
    return rcRet;
}


+(CGAffineTransform)aspectFitFromRc:(CGRect)innerRect ToRc:(CGRect)outerRect {
	CGFloat scaleFactor = MIN(outerRect.size.width/MAX(innerRect.size.width, 1), outerRect.size.height/MAX(innerRect.size.height, 1));
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}

///*
// format int value to string:
// e.g: 
//    1000 -> 1K
//    1234567 -> 1,234K
// */
//+(NSString*) stringFromNumber:(int) count {
//    if (0 <= count) {
//        return @"0";
//    }
//    else {
//        int temp = count/1000;
//        NSMutableString *result = [[[NSMutableString alloc] initWithFormat:@"%dK",temp] autorelease];
//        int lenth = [result length] - 1;
//        int templenth = lenth;
//        while (0 == (templenth % 3)) {
//            //[result 
//             templenth -= 3;
//        }
//        NSString *s = [[NSString alloc] initWithFormat:@"%d", result];
//        return s;
//    }
//}
//
@end
