//
//  ImageManager.h
//  bitauto2
//
//  Created by fuacici on 10-11-22.
//  Copyright 2010 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
#import "ASIHTTPRequest.h"
#import "MulticastDelegate.h"

@protocol ImageLoaderDelegate
@required
-(void)imageDidLoaded:(UIImage*) _image animate:(BOOL) animate;


@end


@interface ImageManager:NSObject<ASIHTTPRequestDelegate>
{
	NSMutableDictionary * targetDict;
	id _cacheDelegate;
	NSOperationQueue * requestQueue;
}


@property (assign) id<ImageCache> cacheDelegate;

- (BOOL) addTaskWithURLString:(NSString *) urlString withDelegate:(id) target;
- (void) removeTarget:(id)target forUrl:(NSString *) urlString;
+ (ImageManager *) sharedImageManager;
@end
