//
//  ExtIfcCommand.m
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import "ExtIfcCommand.h"
#import "Log.h"
#import "BqsUtils.h"

@implementation ExtIfcCommand

@synthesize arguments = _arguments;
@synthesize objName = _objName;
@synthesize methodName = _methodName;

- (void) dealloc
{
	[_arguments release];
	[_objName release];
	[_methodName release];
	
	[super dealloc];
}



+ (ExtIfcCommand*) fromUrl:(NSURL*)url
{
    /*
	 * Get Command and Options From URL
	 * We are looking for URLS that match yourscheme://<Obj>.<command>?[<arguments>]
	 *
	 */
	ExtIfcCommand* iuc = [[[ExtIfcCommand alloc] init] autorelease];
	
    NSString *command = [url host];
	NSArray* components = [command componentsSeparatedByString:@"."];
	if (components.count == 2) {
		iuc.objName = [components objectAtIndex:0];
		iuc.methodName = [components objectAtIndex:1];
	}
	
	if(nil == iuc.objName || [iuc.objName length] < 1 ||
	   nil == iuc.methodName || [iuc.methodName length] < 1) {
		BqsLog(@"Invalid extifc command url: %@", [url absoluteURL]);
		return nil;
	}
	
	// Dictionary of arguments
	NSMutableDictionary* args = [NSMutableDictionary dictionaryWithCapacity:5];
	NSArray * options_parts = [NSArray arrayWithArray:[[url query] componentsSeparatedByString:@"&"]];
	int options_count = [options_parts count];
	int i = 0;
	
    for (i = 0; i < options_count; i++) {
		NSArray *option_part = [[options_parts objectAtIndex:i] componentsSeparatedByString:@"="];
		if(nil != option_part && [option_part count] > 1) {
			NSString *name = [BqsUtils urlDecodedString:(NSString *)[option_part objectAtIndex:0]];
			NSString *value = [BqsUtils urlDecodedString:(NSString *)[option_part objectAtIndex:1]];
			[args setObject:value forKey:name];
		}
		
	}
	iuc.arguments = args;
	
	
	return iuc;
}




@end
