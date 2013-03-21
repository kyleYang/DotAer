//
//  ImageListCache.h
//  bitauto2
//

//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
#import "SynthesizeSingleton.h"

@interface ImageListCache : NSObject<ImageCache>
{
	NSString * imageCacheDirectory;
}
+ (ImageListCache *)sharedImageListCache;
@property (nonatomic,retain) NSString * imageCacheDirectory;

@end
