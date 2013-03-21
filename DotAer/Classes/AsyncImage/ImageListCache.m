//
//  ImageListCache.m
//  bitauto2
//

//  Copyright 2011 BitAuto. All rights reserved.
//

#import "ImageListCache.h"


@implementation ImageListCache
@synthesize imageCacheDirectory;

SYNTHESIZE_SINGLETON_FOR_CLASS(ImageListCache);
- (BOOL) cacheImage:(UIImage *) theImage forString:(NSString*) urlString
{
	
	NSData * _data = UIImageJPEGRepresentation(theImage,0);
	if (! _data)
	{
		return NO;
	}
	
	NSString *_string = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	_string = [_string stringByReplacingOccurrencesOfString:@":" withString:@"+"];	
	NSString * _name = _string;
	
	BOOL _res = [_data writeToFile: [self.imageCacheDirectory stringByAppendingPathComponent: _name]  atomically:YES];
	return _res;
	
}
- (UIImage *)  getCachedImageForString:(NSString*) urlString
{
	NSString *_string = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	_string = [_string stringByReplacingOccurrencesOfString:@":" withString:@"+"];	
	NSString * _name = _string;
	NSData * _imageData = [NSData dataWithContentsOfFile: [self.imageCacheDirectory stringByAppendingPathComponent: _name]];
	UIImage * _image = [UIImage imageWithData: _imageData ];
	return _image;
}



#pragma mark  private methods
-(NSString * ) imageCacheDirectory
{
	if ( imageCacheDirectory)
	{
		return imageCacheDirectory;
	}
	NSString *documentsDirectory;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0) 
	{
		documentsDirectory = [paths objectAtIndex:0];
		self.imageCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"ImageCache"];
		NSError * _error = nil;
		[[NSFileManager defaultManager] createDirectoryAtPath: imageCacheDirectory withIntermediateDirectories: YES attributes:nil error: &_error];
		
	}
    NSLog(@"dddddddddd=%@",self.imageCacheDirectory);
    
	return imageCacheDirectory;
}

@end
