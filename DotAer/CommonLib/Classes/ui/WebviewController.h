//
//  WebviewController.h
//  iMobee
//
//  Created by ellison on 10-9-7.
//  Copyright 2010 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarItem;
@class ExtIfc;

#define kNtfWebViewFrameChanged @"WebviewController.frame.changed"

@interface WebviewController : UIViewController <UIWebViewDelegate> {
	UIWebView *_webView;
	UIActivityIndicatorView *_activityView;
	UIViewController *_errViewCtl;
	TabBarItem *_myTabBarItem;
	
	
	NSString *_homeUrl;
	ExtIfc *_extIfc;
	NSString *_curUrl;
	BOOL _webViewError;
	//BOOL _webViewErrHideAdOldState;
	BOOL _webViewErrorCallFromExtIfc;
	
	BOOL _bIsPopWebView;
	//BOOL _bActivityHidden;
	
	NSString *_orientationJsCallback;
	NSInteger _devOrientation;
    
    BOOL _bViewVisible;
}

//-(id)initWithHomeUrl:(NSString*)url;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) TabBarItem *myTabBarItem;
@property (nonatomic, retain) ExtIfc *extIfc;
@property (nonatomic, readonly) BOOL webViewError;
@property (nonatomic, copy, readonly) NSString *curUrl;
@property (nonatomic, copy) NSString *homeUrl;
@property (nonatomic, assign) BOOL isPopWebView;
@property (nonatomic, copy) NSString *orientationJsCallback;
@property (nonatomic, assign, readonly) NSInteger curOrientation;


- (void)loadUrl:(NSString*) url;
- (void)jsShowAd:(BOOL)bShow;

-(int)adStatus;
-(void)jsShowError:(NSError*)error;
@end
