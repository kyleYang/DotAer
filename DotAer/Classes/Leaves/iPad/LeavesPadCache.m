//
//  LeavesCache.m
//  Reader
//
//  Created by Tom Brow on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LeavesPadCache.h"
#import "LeavesPadView.h"

@implementation LeavesPadCache

@synthesize dataSource, pageSize;

- (id) initWithPageSize:(CGSize)aPageSize
{
	if (self = [super init]) {
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



- (CGImageRef) imageForPageIndex:(NSUInteger)pageIndex isLeft:(BOOL)left{ //得到pad屏幕一半的图画
    CGFloat scale = [UIScreen mainScreen].scale;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, 
												 pageSize.width/2*scale,
												 pageSize.height*scale,
												 8,						/* bits per component*/
												 pageSize.width/2 * 4*scale, 	/* bytes per row */
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width/2*scale, pageSize.height*scale));
    CGContextScaleCTM(context, scale, scale);
	[dataSource renderPageAtIndex:pageIndex inContext:context isleft:left];
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	[UIImage imageWithCGImage:image];
	CGImageRelease(image);
	
	return image;
}

- (CGImageRef)imageWithImageForPageIndex:(NSUInteger)pageIndex isLeft:(BOOL)left
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 pageSize.width/2*scale,
                                                 pageSize.height*scale,
                                                 8,						/* bits per component*/
                                                 pageSize.width/2*scale * 4, 	/* bytes per row */
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width/2*scale, pageSize.height*scale));
    CGContextScaleCTM(context, scale, scale);
    [dataSource asyRenderPageAtIndex:pageIndex inContext:context isLeft:left];
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return image;
}

- (CGImageRef) imageForLeftImage:(CGImageRef)leftRef rightImage:(CGImageRef)rightRef
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 pageSize.width*scale,
                                                 pageSize.height*scale,
                                                 8,						/* bits per component*/
                                                 pageSize.width*scale * 4, 	/* bytes per row */
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width*scale, pageSize.height*scale));
    CGContextScaleCTM(context, scale, scale);
    CGRect imgBounds = CGRectMake(0, 0, pageSize.width/2, pageSize.height);
    CGContextDrawImage(context, imgBounds, leftRef);
    imgBounds = CGRectMake(pageSize.width/2, 0, pageSize.width/2, pageSize.height);
    CGContextDrawImage(context, imgBounds, rightRef);
    
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    [UIImage imageWithCGImage:image];
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
		CGImageRef lefeCGImage = [self imageForPageIndex:pageIndex isLeft:YES];
        CGImageRef rightCGImage = [self imageForPageIndex:pageIndex isLeft:NO];
        CGImageRef pageCGImage = [self imageForLeftImage:lefeCGImage rightImage:rightCGImage];
        
        pageImage = [pageCache objectForKey:pageIndexNumber]; //在执行时候假如存在缓存会让reloadImageForPageIndex 执行，cache保存了最终的数据，如果不判断，会覆盖。
        if (!pageImage) {
            pageImage = [UIImage imageWithCGImage:pageCGImage];
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
	
    CGImageRef lefeCGImage = [self imageWithImageForPageIndex:pageIndex isLeft:YES];
    CGImageRef rightCGImage = [self imageWithImageForPageIndex:pageIndex isLeft:NO];
    CGImageRef pageCGImage = [self imageForLeftImage:lefeCGImage rightImage:rightCGImage];
	
    pageImage = [UIImage imageWithCGImage:pageCGImage];
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
