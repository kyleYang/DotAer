//
//  CustomNavigationBar.m
//  CustomNavigationBar
//
//  Created by looyao teng on 12-5-29.
//  Copyright (c) 2012年 Looyao. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

@synthesize customBgImage = _customBgImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [_customBgImage release];
    _customBgImage = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    if (_customBgImage) {
        [_customBgImage drawInRect:rect];
    } else {
        [super drawRect:rect];
    }
}

- (void)setCustomBgImage:(UIImage *)customBgImage
{
    if (customBgImage) {
        [_customBgImage release];
        _customBgImage = [customBgImage retain];
    } else {
        [_customBgImage release];
        _customBgImage = nil;
    }
    
    [self setNeedsDisplay];
}

@end
