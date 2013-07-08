//
//  extifc_sys.m
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "extifc_sys.h"
#import "Downloader.h"
#import "BqsUtils.h"
#import "Env.h"

@interface extifc_sys()
@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) MPMoviePlayerViewController *moviePlayer;

-(void)onDownloaderCallback:(DownloaderCallbackObj*)obj;
-(void)onSaveImageToPhotoAlbumDownloadCallback:(DownloaderCallbackObj*)obj;
@end


@implementation extifc_sys

@synthesize downloader = _downloader;
@synthesize moviePlayer;

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	if(nil != _downloader) {
		[_downloader cancelAll];
	}
	[_downloader release];
	[_downloadTasks release];
	moviePlayer = nil;
	[super dealloc];
}


// using app's openUrl
- (void)performSystemRequest:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *url = (NSString*)[args objectForKey: @"url"];
	
	[super callbackToWebview:webviewCtl Argument:args Data:nil];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

// get sys info
- (void)getInfo:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	
	NSArray *supportNames = [NSArray arrayWithObjects:
							 @"sw",@"version",@"udid",@"ScrRes",@"ScrScale",@"osName",@"osVer",@"phoneType",@"lang",
							 @"market",@"uiAdStatus",nil
							 ];
	NSString *ns = (NSString*)[args objectForKey: @"names"];
	NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:[supportNames count]];;
	if(nil != ns && [ns length] > 0) {
		NSArray *ar = [ns componentsSeparatedByString:@","];
		for(NSString *a in ar) {
			if(nil != a && [a length] > 0) {
				[names addObject:a];
			}
		}
	}
	
	if([names count] < 1) {
		[names addObjectsFromArray:supportNames];
	}
	
	Env *env = [Env sharedEnv];
	UIDevice *myDevice = [UIDevice currentDevice];
	
	NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithCapacity:[names count]];
	
	for(NSString *n in names) {
		NSString *v = @"";
		
		if([@"sw" isEqualToString:n]) {
			v = env.swType;
		} else if([@"version" isEqualToString:n]) {
			v = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		} else if([@"udid" isEqualToString:n]) {
			v = env.macUdid;
		} else if([@"ScrRes" isEqualToString:n]) {
			v = [NSString stringWithFormat:@"%dx%d", (int)env.screenSize.width, (int)env.screenSize.height];
		} else if([@"ScrScale" isEqualToString:n]) {
			v = [NSString stringWithFormat:@"%.1f", [BqsUtils getScreenScale]];
		} else if([@"osName" isEqualToString:n]) {
			v = [myDevice.systemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		} else if([@"osVer" isEqualToString:n]) {
			v = myDevice.systemVersion;
		} else if([@"phoneType" isEqualToString:n]) {
			v = [myDevice.model stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		} else if([@"lang" isEqualToString:n]) {
			v = NSLocalizedStringFromTable(@"sys.language", @"commonlib", nil);
		} else if([@"market" isEqualToString:n]) {
			v = env.market;
		} else if([@"uiAdStatus" isEqualToString:n]) {
			v = [NSString stringWithFormat:@"%d", [webviewCtl adStatus]];
		} else {
			BqsLog(@"Not support name: %@", n);
		}
		
		[dicInfo setObject:v forKey:n];
	}
	[names release];
	
	NSMutableDictionary *ret = [[[NSMutableDictionary alloc] init] autorelease];
	[ret setObject: dicInfo forKey: @"info"];
	
	[dicInfo release];
	
	[super callbackToWebview:webviewCtl Argument:args Data:ret];
}

// download a page
- (void)requestUrlData:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *url = (NSString*)[args objectForKey: @"url"];
	//NSString *charset = (NSString*)[args objectForKey:@"charset"];
	
	NSMutableDictionary *ret = [[[NSMutableDictionary alloc] init] autorelease];
	[ret setObject: [NSNumber numberWithInt:-1]  forKey: @"httpStatus"];
	
	if(nil == url || [url length] < 1) {
		BqsLog(@"Invalid url: %@", url);
		[super callbackToWebview:webviewCtl Argument:args Data:ret];
		return;
	}
	
	if(nil == _downloader) {
		_downloader = [[Downloader alloc] init];
	}
	if(nil == _downloadTasks) {
		_downloadTasks = [[NSMutableArray alloc] initWithCapacity:10];
	}
	
	NSDictionary *tsk = [NSDictionary dictionaryWithObjectsAndKeys:
						 webviewCtl, @"webview",
						 args, @"args",
						 nil, nil];
	[_downloadTasks addObject:tsk];
	[_downloader addTask:url Target:self Callback:@selector(onDownloaderCallback:) Attached:tsk];
}

-(void)onDownloaderCallback:(DownloaderCallbackObj*)obj {
	BqsLog(@"onDownloaderCallback: %@", obj);
	if(nil == obj) {
		BqsLog(@"obj is nil");
		return;
	}
	if(nil == obj.attached || ![_downloadTasks containsObject:obj.attached]) {
		BqsLog(@"Not contains the task: %@", obj.attached);
		return;
	}
	
	@try {
		NSDictionary *tsk = (NSDictionary*)obj.attached;
		WebviewController *webViewCtl = [tsk objectForKey:@"webview"];
		NSDictionary *args = [tsk objectForKey:@"args"];
		
		BqsLog(@"http return: %d: %@ %@", obj.httpStatus, obj.httpContentType, args);
		
		NSString *charset = [args objectForKey:@"charset"];
		if(nil == charset || [charset length] < 1) {
			charset = [BqsUtils parseCharsetInContentType:obj.httpContentType];
		}
		NSStringEncoding se = NSUTF8StringEncoding;
		if(nil != charset && [charset length] > 0) {
			CFStringEncoding cfse = CFStringConvertIANACharSetNameToEncoding((CFStringRef)charset);
			if(kCFStringEncodingInvalidId == cfse) {
				BqsLog(@"Invalid charset name=%@", charset);
			} else {
				se = CFStringConvertEncodingToNSStringEncoding(cfse);
			}
		}
		BqsLog(@"charset=%@, %d", charset, se);
		
		NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:10];
		[ret setObject:[NSNumber numberWithInt:obj.httpStatus] forKey:@"httpStatus"];
		if(nil != obj.httpContentType) {
			[ret setObject:obj.httpContentType forKey:@"contentType"];
		}
		
		NSString *content = [[NSString alloc] initWithData:obj.rspData encoding:se];
		if(nil != content) {
			[ret setObject:content forKey:@"content"];
		} else {
			BqsLog(@"rspData is nil");
		}
		[content release];
		
		[super callbackToWebview:webViewCtl Argument:args Data:ret];
		
		[ret release];
	}
	@catch (NSException * e) {
		BqsLog(@"Exception %@", e);
	}
	@finally {
		[_downloadTasks removeObject:obj.attached];
	}
}

// download an image and save to system's photo album
- (void)saveImageToPhotoAlbum:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *url = (NSString*)[args objectForKey: @"url"];
	
	NSMutableDictionary *ret = [[[NSMutableDictionary alloc] init] autorelease];
	[ret setObject: [NSNumber numberWithInt:-1]  forKey: @"httpStatus"];
	
	if(nil == url || [url length] < 1) {
		BqsLog(@"Invalid url: %@", url);
		[super callbackToWebview:webviewCtl Argument:args Data:ret];
		return;
	}
	
	if(nil == _downloader) {
		_downloader = [[Downloader alloc] init];
	}
	if(nil == _downloadTasks) {
		_downloadTasks = [[NSMutableArray alloc] initWithCapacity:10];
	}
	
	NSDictionary *tsk = [NSDictionary dictionaryWithObjectsAndKeys:
						 webviewCtl, @"webview",
						 args, @"args",
						 nil, nil];
	[_downloadTasks addObject:tsk];
	[_downloader addTask:url Target:self Callback:@selector(onSaveImageToPhotoAlbumDownloadCallback:) Attached:tsk];
}

-(void)onSaveImageToPhotoAlbumDownloadCallback:(DownloaderCallbackObj*)obj {
	BqsLog(@"onSaveImageToPhotoAlbumDownloadCallback: %@", obj);
	if(nil == obj) {
		BqsLog(@"obj is nil");
		return;
	}
	if(nil == obj.attached || ![_downloadTasks containsObject:obj.attached]) {
		BqsLog(@"Not contains the task: %@", obj.attached);
		return;
	}
	
	@try {
		NSDictionary *tsk = (NSDictionary*)obj.attached;
		WebviewController *webViewCtl = [tsk objectForKey:@"webview"];
		NSDictionary *args = [tsk objectForKey:@"args"];
		
		BqsLog(@"http return: %d: %@ %@", obj.httpStatus, obj.httpContentType, args);
		
		NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:10];
		[ret setObject:[NSNumber numberWithInt:obj.httpStatus] forKey:@"httpStatus"];
		if(nil != obj.httpContentType) {
			[ret setObject:obj.httpContentType forKey:@"contentType"];
		}
		
		if(200 == obj.httpStatus && nil != obj.rspData && [obj.rspData length] > 1) {
			UIImage *img = [UIImage imageWithData:obj.rspData];
			if(nil == img) {
				BqsLog(@"Can't create image from response data");
			} else {
				UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
			}
		} else {
			BqsLog(@"Invalid response data: %d, %@", obj.httpStatus, obj.rspData);
		}
		[super callbackToWebview:webViewCtl Argument:args Data:ret];
		
		[ret release];
	}
	@catch (NSException * e) {
		BqsLog(@"Exception %@", e);
	}
	@finally {
		[_downloadTasks removeObject:obj.attached];
	}
}

// open media player to play a url
- (void)openMediaPlayer:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl {
	NSString *url = (NSString*)[args objectForKey: @"url"];
	
	[super callbackToWebview:webviewCtl Argument:args Data:nil];
	
	if(nil == url || [url length] < 1) {
		BqsLog(@"Invalid url: %@", url);
		return;
	}
	
	if(![webviewCtl respondsToSelector:@selector(presentMoviePlayerViewControllerAnimated:)]) {
		[webviewCtl loadUrl:url];
		return;
	}
	
	[moviePlayer dismissMoviePlayerViewControllerAnimated];
	moviePlayer = nil;
	moviePlayer  = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL URLWithString:[BqsUtils fixURLHost: url]]];
	[[NSNotificationCenter defaultCenter]addObserver: self selector: @selector(playFinishedCallback:) 
												name: MPMoviePlayerPlaybackDidFinishNotification object: nil];
	
	// Movie playback is asynchronous, so this method returns immediately. 
	[webviewCtl presentMoviePlayerViewControllerAnimated:moviePlayer]; 
	[moviePlayer.moviePlayer play];
}

-(void) playFinishedCallback: (NSNotification*) aNotification {
	BqsLog(@"playFinishedCallback:");
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMoviePlayerPlaybackDidFinishNotification object: nil];
	moviePlayer = nil;
}


@end
