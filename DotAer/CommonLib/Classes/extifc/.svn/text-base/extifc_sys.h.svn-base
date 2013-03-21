//
//  extifc_sys.h
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmptyExtIfc.h"

@class Downloader;

@interface extifc_sys : EmptyExtIfc {
	NSMutableArray *_downloadTasks; // NSArray -> NSDictionary
	Downloader *_downloader;
}

// using app's openUrl
- (void)performSystemRequest:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;
// get sys info
- (void)getInfo:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;

// download a page
- (void)requestUrlData:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;
// download an image and save to system's photo album
- (void)saveImageToPhotoAlbum:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;

// open media player to play a url
- (void)openMediaPlayer:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;
@end
