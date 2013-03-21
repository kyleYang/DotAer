//
//  ImageManager.m
//  bitauto2
//
//  Created by fuacici on 10-11-22.
//  Copyright 2010 . All rights reserved.
//

#import "ImageManager.h"
#import "SynthesizeSingleton.h"
#import "ASIHTTPRequest.h"


@implementation ImageManager
@synthesize cacheDelegate = _cacheDelegate;
static ImageManager * sharedImageManager= nil;
+ (ImageManager *)sharedImageManager
{ 
	@synchronized(self) 
	{ 
		if (sharedImageManager == nil) 
		{ 
			sharedImageManager = [[self alloc] init]; 
			
		} 
	} 
	
	return sharedImageManager; 
} 
- (id) init
{
	if (self = [super init])
	{
		targetDict = [[NSMutableDictionary alloc] initWithCapacity: 100];
		requestQueue = [[NSOperationQueue alloc] init];
		requestQueue.maxConcurrentOperationCount = 3;
	}
	return self;
}
#pragma mark ASIHTTPRequestDelegate
- (void) request:(ASIHTTPRequest*) request doneForString:(NSString *) url
{
	NSData * _data = [request responseData];
	UIImage * _image = [UIImage imageWithData: _data];
	if (_image!=nil) {
		NSString * realPath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, //NSDocumentDirectory or NSCachesDirectory
																  NSUserDomainMask, //NSUserDomainMask
																  YES)	// YES
							  objectAtIndex: 0];
		NSString *imageCachePath = [url stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
		NSString * filePath=[realPath stringByAppendingPathComponent:imageCachePath];
		[_data writeToFile:filePath atomically:YES];
		NSLog(@"图片存储成功%@",filePath);
	}
	
	MulticastDelegate<ImageLoaderDelegate> * _delegates = [targetDict objectForKey: url];
	if (_delegates && [_delegates doesRecognizeSelector:@selector(imageDidLoaded:animate:)])
	{
		[_delegates imageDidLoaded: _image animate: YES];
	}
	if (_cacheDelegate && [_cacheDelegate respondsToSelector: @selector(cacheImage:forString:)]) 
	{
		[_cacheDelegate cacheImage: _image forString: url];
		//DebugLog(@"%@", _res? @"Success":@"Failed" );
	}
	
	[targetDict removeObjectForKey:  url];
}

- (void)requestForString: (NSString *)url failedWithError:(NSError*) error
{
	MulticastDelegate<ImageLoaderDelegate> * _delegates = [targetDict objectForKey: url];
	if (_delegates && [_delegates doesRecognizeSelector:@selector(imageDidLoaded:animate:)])
	{
		[_delegates imageDidLoaded: nil animate: NO];
		[targetDict removeObjectForKey:  url];
	}
	
}

- (BOOL) addTaskWithURLString:(NSString *) urlString withDelegate:(id) target
{
	
	/// get cached
	if (_cacheDelegate && [_cacheDelegate respondsToSelector: @selector(getCachedImageForString:)]) 
	{
		UIImage * _image = [_cacheDelegate getCachedImageForString: urlString];
		if (nil != _image) 
		{
			[target imageDidLoaded: _image animate: NO];
			//DebugLog(@"use cache for %@",urlString);
			return YES;
		}
	}
	//NSLog(@"loading %@",urlString);
	//no cache, request from the web
	MulticastDelegate<ImageLoaderDelegate> * _delegates = [targetDict objectForKey: urlString];
	if (nil != _delegates )
	{
		[_delegates addDelegate: target];
		return YES;
	}
	_delegates = (MulticastDelegate<ImageLoaderDelegate> *)[[[MulticastDelegate alloc] init]autorelease];
	[_delegates addDelegate: target];
	
	[targetDict setObject: _delegates forKey: urlString];
	
	//如果已有相同名字的图片 则不在下载图片
	NSString * realPath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, //NSDocumentDirectory or NSCachesDirectory
															  NSUserDomainMask, //NSUserDomainMask
															  YES)	// YES
						  objectAtIndex: 0];	
	NSString *imageCachePath = [urlString stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
	NSString * filePath=[realPath stringByAppendingPathComponent:imageCachePath];
	if([[NSFileManager defaultManager] fileExistsAtPath: filePath]){
		UIImage * image= [UIImage imageWithContentsOfFile:filePath];
		MulticastDelegate<ImageLoaderDelegate> * _delegates = [targetDict objectForKey: urlString];
		[_delegates imageDidLoaded: image animate: YES];
		[targetDict removeObjectForKey:  urlString];
		return YES;
	}
	
	// make the request
	NSURL *url = [NSURL URLWithString: urlString];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
	[request setDelegate:self];
	[request setCompletionBlock:^
	{
		[self request: request doneForString: urlString];
	}];
	
	[request setFailedBlock:^
	{
		NSError *error = [request error];
		[self requestForString: urlString failedWithError: error];
	}];
	[requestQueue addOperation: request];
	return YES;
}

- (void) removeTarget:(id)target forUrl:(NSString *) urlString
{
	MulticastDelegate<ImageLoaderDelegate> * _delegates = [targetDict objectForKey: urlString];
	if (nil != _delegates) 
	{
		@synchronized(_delegates)
		{
			[_delegates removeDelegate: target];
			if (0 == [_delegates count]) 
			{
				[targetDict removeObjectForKey: urlString];
			}
		}
        
//        NSLog(@"2222222222");
		return;
	}
	
}

- (void)dealloc
{
	[targetDict release];
	[requestQueue release];
	[super dealloc];
}

#pragma mark -- 


@end
