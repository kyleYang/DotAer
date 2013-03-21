//
//  ExtIfcCommand.h
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCmdCallback_Place_Holder @"(rs)"

#define kCmdArg_ReceivedCallback @"cmdRcvCB"
#define kCmdArg_Callback @"cmdCB"


@interface ExtIfcCommand : NSObject {

	NSString* _objName;
	NSString* _methodName;
	NSMutableDictionary* _arguments;
	
}

@property(copy) NSString* objName;
@property(copy) NSString* methodName;
@property(retain) NSMutableDictionary* arguments;

+ (ExtIfcCommand*) fromUrl:(NSURL*)url;

- (void) dealloc;

@end
