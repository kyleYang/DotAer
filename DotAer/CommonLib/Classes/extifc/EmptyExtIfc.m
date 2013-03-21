//
//  EmptyExtIfc.m
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import "EmptyExtIfc.h"
#import "ExtIfcCommand.h"
#import "JSON.h"
#import "Log.h"

@implementation EmptyExtIfc


- (void) callbackToWebview: (WebviewController*)webviewCtl Argument: (NSDictionary*) args Data: (NSDictionary*)data {
	NSString* cbStr = (NSString*)[args objectForKey: kCmdArg_Callback];
	
	if(nil == cbStr || [cbStr length] < 1) {
		BqsLog(@"No callback argument: %@", kCmdArg_Callback);
		return;
	}
	NSString *jsonData = @"";
	if(nil != data) jsonData = [data JSONRepresentation];
	
	NSString *realCBStr = [cbStr stringByReplacingOccurrencesOfString: kCmdCallback_Place_Holder withString: jsonData];
	BqsLog(@"Callback: %@", realCBStr);
	
	[webviewCtl.webView stringByEvaluatingJavaScriptFromString: realCBStr];
}

@end
