//
//  Log.h
//  iMobee
//
//  Created by ellison on 10-10-24.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Enable debug (NSLog) wrapper code?
//#define DEBUG 1
#define DEBUG_SHOW_FULLPATH 0

#if defined DEBUG
#define BqsLog(format,...) [CBqsLog output:__FILE__ lineNumber:__LINE__ input:(format), ##__VA_ARGS__]
#else
#define BqsLog(format,...)
#endif

@interface CBqsLog : NSObject {
}
//+ (CBqsLog *) sharedLogger;
+(void)output:(char*)fileName lineNumber:(int)lineNumber input:(NSString*)input, ...;
@end
