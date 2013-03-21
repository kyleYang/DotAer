//
//  BqsPageControl.m
//  iMobeeBook
//
//  Created by ellison on 11-7-4.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsPageControl.h"
// Tweak these or make them dynamic.
#define kDotDiameter 8.0
#define kDotSpacer 8.0

@interface BqsPageControl()


@end

@implementation BqsPageControl
@synthesize imageNormal = mImageNormal;
@synthesize imageCurrent = mImageCurrent;
@synthesize dotColorCurrentPage;
@synthesize dotColorOtherPage;
@synthesize delegate;
@synthesize dotWidth;
@synthesize dotSpace;


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor blackColor];
        self.dotColorOtherPage = [UIColor lightGrayColor];
		self.dotWidth = kDotDiameter;
		self.dotSpace = kDotSpacer;
    }
    return self;
}

- (void) dealloc {
	[mImageNormal release], mImageNormal = nil;
	[mImageCurrent release], mImageCurrent = nil;
	self.dotColorOtherPage = nil;
	self.dotColorCurrentPage = nil;
	
	[super dealloc];
}


/** Override setImageNormal */
- (void) setImageNormal:(UIImage*)image {
	[mImageNormal release];
	mImageNormal = [image retain];
    	
	// update dot views
	[self setNeedsDisplay];
}

/** Override setImageCurrent */
- (void) setImageCurrent:(UIImage*)image
{
	[mImageCurrent release];
	mImageCurrent = [image retain];
	
	// update dot views
	[self setNeedsDisplay];
}


- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

-(void)layoutSubviews {
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
	// Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    //	CGContextTranslateCTM(context, 0.0, rect.size.height);
    //    CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect currentBounds = self.bounds;
	CGFloat dotsWidth = self.numberOfPages*self.dotWidth + MAX(0, self.numberOfPages-1)*self.dotSpace;
	CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
	CGFloat y = CGRectGetMidY(currentBounds)-self.dotWidth/2;
	for (int i=0; i<_numberOfPages; i++)
	{
		CGRect circleRect = CGRectMake(x, y, self.dotWidth, self.dotWidth);
		if (i == _currentPage)
		{
			if(nil != mImageCurrent) {
				//CGContextDrawTiledImage(context, circleRect, mImageCurrent.CGImage);
				[mImageCurrent drawInRect:circleRect];
			} else {
				CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
				CGContextFillEllipseInRect(context, circleRect);
			}
			
		}
		else
		{
			if(nil != mImageNormal) {
				//CGContextDrawTiledImage(context, circleRect, mImageNormal.CGImage);
				[mImageNormal drawInRect:circleRect];
			} else {
				CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
				CGContextFillEllipseInRect(context, circleRect);
			}
		}
		
		x += self.dotWidth + self.dotSpace;
	}
	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	
    CGFloat dotSpanX = self.numberOfPages*(self.dotWidth + self.dotSpace);
    CGFloat dotSpanY = self.dotWidth + self.dotSpace;
	
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
	
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
	
    
	self.currentPage = floor(x/(self.dotWidth + self.dotSpace));
	
    if ([self.delegate respondsToSelector:@selector(bqsPageControlDidChangePage:)])
    {
        [self.delegate performSelector:@selector(bqsPageControlDidChangePage:) withObject:self afterDelay:.1];
    }
}
@end
