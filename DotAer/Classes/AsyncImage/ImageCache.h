//
//  ImageCache.h
//  bitauto2
//
//  Created by fuacici on 10-11-22.
//  Copyright 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImageCache

@required
- (BOOL) cacheImage:(UIImage *) theImage forString:(NSString*) urlString;
- (UIImage *)  getCachedImageForString:(NSString*) urlString;

@end
