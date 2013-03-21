//
//  extifc_ui.m
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import "extifc_ui.h"
#import "PopupWebviewController.h"
#import "BqsUtils.h"
#import "Env.h"

@protocol MainTabControllerExtIfc // only for makeWebViewFullScreen and ensureWebViewNotFullScreen
@optional
-(UIViewController*)viewController;
-(UIView*)tabBar;
@end

@implementation extifc_ui

// popup a webview ui
- (void)popupWebView:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
//	NSString *title = (NSString*)[args objectForKey: @"title"];
//	NSString *url = (NSString*)[args objectForKey: @"url"];
		
	[super callbackToWebview:webviewCtl Argument:args Data:nil];
	
//	[PopupWebviewController presentPopWebviewParent:webviewCtl Title:title Url:url PopType:kTagPopWebView];
	
}

// hide a pupupwebview ui
- (void)hidePopupWebView:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	[super callbackToWebview:webviewCtl Argument:args Data:nil];
	
	if([webviewCtl isKindOfClass:[PopupWebviewController class]]) {
//		PopupWebviewController *pwc = (PopupWebviewController*)webviewCtl;
//		if(kTagPopWebView == pwc.popType) {
//			[pwc doActionNavigationBack];
//			return;
//		}
	}
	BqsLog(@"Not a popup webview controller");
}


// show error view
- (void)showError:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *sCode = [args objectForKey:@"code"];
	NSString *sDesc = [args objectForKey:@"desc"];
	
	BqsLog(@"showError: %@,%@", sCode, sDesc);
	
	[super callbackToWebview:webviewCtl Argument:args Data:nil];
	
	NSDictionary *dict = nil;
	if(nil != sDesc && [sDesc length] > 0) {
		dict = [NSDictionary dictionaryWithObject:sDesc forKey:NSLocalizedDescriptionKey];
	}
	NSError *err = [NSError errorWithDomain:@"HTTP" code:[sCode intValue] userInfo:dict];
	[webviewCtl jsShowError:err];
}	
@end
