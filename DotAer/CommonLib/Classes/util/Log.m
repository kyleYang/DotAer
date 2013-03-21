//
//  Log.m
//  iMobee
//
//  Created by ellison on 10-10-24.
//  Copyright 2010 borqs. All rights reserved.
//

#import "Log.h"
#import "Env.h"

//static CBqsLog *sharedLogInstance = nil;


@implementation CBqsLog

//+ (CBqsLog *) sharedLogger
//{
//	@synchronized(self)
//	{
//		if (sharedLogInstance == nil)
//		{
//			[[self alloc] init];
//		}
////		NSString *key = [[CBqsLog class] description];
////		
////		NSMutableDictionary *dict = [Env sharedEnv].runtimeData;
////		
////		CBqsLog *lg = (CBqsLog*)[dict objectForKey: key];
////		if(nil == lg) {
////			lg = [[CBqsLog alloc] init];
////			[dict setObject:lg forKey: key];
////			[lg release];
////		}
////		
////		return lg;
//		
//	}
//	return sharedLogInstance;
//}
//
//+ (id) allocWithZone:(NSZone *) zone
//{
//	@synchronized(self)
//	{
//		if (sharedLogInstance == nil)
//		{
//			sharedLogInstance = [super allocWithZone:zone];
//			return sharedLogInstance;
//		}
//	}
//	return nil;
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//	return self;
//}
//
//- (id)retain
//{
//	return self;
//}
//
//- (void)release
//{
//	// No action required...
//}
//
//- (unsigned)retainCount
//{
//	return UINT_MAX;  // An object that cannot be released
//}
//
//- (id)autorelease
//{
//	return self;
//}

+(void)output:(char*)fileName lineNumber:(int)lineNumber input:(NSString*)input, ...
{
	va_list argList;
	NSString *filePath, *formatStr;
	
    @synchronized(self) {
        // Build the path string
        filePath = [[NSString alloc] initWithBytes:fileName length:strlen(fileName)
                                          encoding:NSUTF8StringEncoding];
        
        // Process arguments, resulting in a format string
        va_start(argList, input);
        formatStr = [[NSString alloc] initWithFormat:input arguments:argList];
        va_end(argList);
        
        // Call NSLog, prepending the filename and line number
        NSLog(@"%s[%d] %@",[((DEBUG_SHOW_FULLPATH) ? filePath :
                                      [filePath lastPathComponent]) UTF8String], lineNumber, formatStr);
        
        [filePath release];
        [formatStr release];
    }
}
@end
