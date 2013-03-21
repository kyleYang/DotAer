//
//  extifc_store.m
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import "extifc_store.h"
#import "Log.h"

#define kStoreDataPrefix @"jsStore."

@implementation extifc_store

-(void)test:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	BqsLog(@"read");
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	[ret setObject: @"a" forKey:@"ka"];
	[ret setObject: [NSNumber numberWithInt:11]  forKey: @"n"];
	[super callbackToWebview:webviewCtl Argument: args Data:ret];
	
	[ret release];
}

-(void)put:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *name = (NSString*)[args objectForKey: @"name"];
	NSString *value = (NSString*)[args objectForKey: @"value"];
	
	[super callbackToWebview:webviewCtl Argument:args Data:nil];
	
	if(nil == name || [name length] < 1) {
		BqsLog(@"name is nil!");
		return;
	}
	if(nil == value) value = @"";
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	[defs setObject:value forKey:[kStoreDataPrefix stringByAppendingString:name]];
}

-(void)get:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *name = (NSString*)[args objectForKey: @"name"];
	NSString *value = @"";
	
	if(nil != name || [name length] > 0) {
		
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		
		value = [defs objectForKey:[kStoreDataPrefix stringByAppendingString:name]];
		if(nil == value) {
			value = @"";
		}

	} else {
		BqsLog(@"name is nil!");
	}
	
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	[ret setObject:name forKey:@"name"];
	[ret setObject:value forKey:@"value"];
	[super callbackToWebview:webviewCtl Argument: args Data:ret];
	[ret release];
	
}

@end
