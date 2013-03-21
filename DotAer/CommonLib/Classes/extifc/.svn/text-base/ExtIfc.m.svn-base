//
//  ExtIfc.m
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import "ExtIfc.h"
#import "ExtIfcCommand.h"
#import "WebviewController.h"
#import "Log.h"

@interface ExtIfc()

-(id) getIfcInstance:(NSString*)objName;

@end

@implementation ExtIfc
@synthesize ifcObjects = _ifcObjects;


-(id) init {
	self = [super init];
	
	if(nil == self) return self;
	
	self.ifcObjects = [NSMutableDictionary dictionaryWithCapacity:10];
	
	return self;
}

-(void)dealloc {
	self.ifcObjects = nil;
	
	[super dealloc];
}

-(BOOL)procURLRequest:(NSURLRequest*)request webViewController:(WebviewController*)webviewCtl {
	
	NSURL *url = [request URL];
	
	if (![[url scheme] isEqualToString:kExtIfcScheme]) {
		// not extifc command url
		return NO;
	}
	
	ExtIfcCommand *cmd = [ExtIfcCommand fromUrl:url];
	if(nil != cmd) {
		if(nil != webviewCtl) {
			NSString* rcvCB = (NSString*)[cmd.arguments objectForKey:kCmdArg_ReceivedCallback];
			if(nil != rcvCB && [rcvCB length] > 0) {
				[webviewCtl.webView stringByEvaluatingJavaScriptFromString:rcvCB];
			}
		}
		
		// Check to see if we are provided a class:method style command.
		[self execute:cmd webViewController: webviewCtl];
	}

	return YES;
}

/**
 Returns an instance of a PhoneGapCommand object, based on its name.  If one exists already, it is returned.
 */
-(id) getIfcInstance:(NSString*)objName
{
    id obj = [_ifcObjects objectForKey:objName];
    if (nil == obj) {
		NSString* className = [@"extifc_" stringByAppendingString: objName];
		//NSBqsLog(@"className=%@", className);
		obj = [[NSClassFromString(className) alloc] init];
        
        [_ifcObjects setObject:obj forKey: objName];
		//NSBqsLog(@"count: %d", [_ifcObjects count]);
		[obj release];
    }
    return obj;
}

-(BOOL)execute:(ExtIfcCommand*)command webViewController:(WebviewController*)webviewCtl {
	
	BOOL ret = NO;
	
	if (nil == command || nil == command.objName || nil == command.methodName) {
		return ret;
	}
	
	// Fetch an instance of this class
	id obj = [self getIfcInstance:command.objName];
	if(nil == obj) {
		BqsLog(@"Can't find obj for %@", command.objName);
		return ret;
	}
	
	// construct the fill method name to ammend the second argument.
	NSString* fullMethodName = [[NSString alloc] initWithFormat:@"%@:webViewController:", command.methodName];
	SEL s = NSSelectorFromString(fullMethodName);
	BqsLog(@"obj=%@ methodName=%@ s=%d", [[obj class] description], fullMethodName, s);
	if ([obj respondsToSelector:s]) {
		@try {
			[obj performSelector:s withObject:command.arguments withObject:webviewCtl];
		} 
		@catch (NSException * e) {
			BqsLog(@"Exception %@", e);
			ret = NO;
		}
		@finally {
			
		}
		
		ret = YES;
	}
	else {
		// There's no method to call, so throw an error.
		BqsLog(@"Class method '%@' not defined in class 'extifc_%@'", fullMethodName, command.objName);
	}
	[fullMethodName release];
	
	return ret;
	
}

@end
