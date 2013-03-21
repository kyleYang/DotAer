//
//  LeavesCache.m
//  Reader
//
//  Created by Tom Brow on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LeavesCache.h"
#import "LeavesView.h"

@implementation LeavesCache

@synthesize dataSource, pageSize;

- (id) initWithPageSize:(CGSize)aPageSize
{
	if (self = [super init]) {
//        screenScale = [UIScreen mainScreen].scale;
//        CGSize scaleSize = CGSizeMake(aPageSize.width*screenScale, aPageSize.height*screenScale);
		pageSize = aPageSize;
		pageCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[pageCache release];
	[super dealloc];
}



- (CGImageRef) imageForPageIndex:(NSUInteger)pageIndex {
    
    CGFloat scale = [[UIScreen mainScreen] scale];  // we need to size the graphics context according to the device scale
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, 
												 pageSize.width*scale,
												 pageSize.height*scale, 
												 8,						/* bits per component*/
												 pageSize.width * 4*scale, 	/* bytes per row */
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width*scale, pageSize.height*scale));
	
    CGContextScaleCTM(context, scale, scale);
    
	[dataSource renderPageAtIndex:pageIndex inContext:context];
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	[UIImage imageWithCGImage:image];
//    [UIImage imageWithCGImage:image scale:screenScale orientation:[UIDevice currentDevice].orientation];
	CGImageRelease(image);
	
	return image;
}


- (CGImageRef)imageWithImageForPageIndex:(NSUInteger)pageIndex
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 pageSize.width*scale,
                                                 pageSize.height*scale,
                                                 8,						/* bits per component*/
                                                 pageSize.width * 4*scale, 	/* bytes per row */
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width*scale, pageSize.height*scale));
    
    CGContextScaleCTM(context, scale, scale);
    [dataSource asyRenderPageAtIndex:pageIndex inContext:context];
   
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    [UIImage imageWithCGImage:image];
//    [UIImage imageWithCGImage:image scale:screenScale orientation:[UIDevice currentDevice].orientation];
    CGImageRelease(image);
    
    return image;
}


- (CGImageRef) cachedImageForPageIndex:(NSUInteger)pageIndex {
	NSNumber *pageIndexNumber = [NSNumber numberWithInt:pageIndex];
	UIImage *pageImage;
	@synchronized (pageCache) {
		pageImage = [pageCache objectForKey:pageIndexNumber];
	}
	if (!pageImage) {
		CGImageRef pageCGImage = [self imageForPageIndex:pageIndex];
        pageImage = [pageCache objectForKey:pageIndexNumber]; //在执行时候假如存在缓存会让reloadImageForPageIndex 执行，cache保存了最终的数据，如果不判断，会覆盖。
        if (!pageImage) {
            pageImage = [UIImage imageWithCGImage:pageCGImage];
//            pageImage = [UIImage imageWithCGImage:pageCGImage scale:screenScale orientation:[UIDevice currentDevice].orientation];
            @synchronized (pageCache) {
                [pageCache setObject:pageImage forKey:pageIndexNumber];
            }

        }
    }
	return pageImage.CGImage;
}

- (CGImageRef) reloadImageForPageIndex:(NSUInteger)pageIndex{//reload image when image downlaoded addedby Kyle Yang
    NSNumber *pageIndexNumber = [NSNumber numberWithInt:pageIndex];
	UIImage *pageImage;
	
	
    CGImageRef pageCGImage = [self imageWithImageForPageIndex:pageIndex];
    pageImage = [UIImage imageWithCGImage:pageCGImage];
//    pageImage = [UIImage imageWithCGImage:pageCGImage scale:screenScale orientation:[UIDevice currentDevice].orientation];
    if (pageImage) {
        @synchronized (pageCache) {
            [pageCache setObject:pageImage forKey:pageIndexNumber];
        }
        
    }else{
        @synchronized (pageCache) {
            pageImage = [pageCache objectForKey:pageIndexNumber];
        }
        
    }
    return pageImage.CGImage;
    
}

- (void) precacheImageForPageIndexNumber:(NSNumber *)pageIndexNumber {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self cachedImageForPageIndex:[pageIndexNumber intValue]];
	[pool release];
}

- (void) precacheImageForPageIndex:(NSUInteger)pageIndex {
	[self performSelectorInBackground:@selector(precacheImageForPageIndexNumber:)
						   withObject:[NSNumber numberWithInt:pageIndex]];
}

- (void) minimizeToPageIndex:(NSUInteger)pageIndex {
	/* Uncache all pages except previous, current, and next. */
	@synchronized (pageCache) {
		for (NSNumber *key in [pageCache allKeys])
			if (ABS([key intValue] - (int)pageIndex) > 2)
				[pageCache removeObjectForKey:key];
	}
}

- (void) flush {
	@synchronized (pageCache) {
		[pageCache removeAllObjects];
	}
}

#pragma mark accessors

- (void) setPageSize:(CGSize)value {
	pageSize = value;
	[self flush];
}



@end
