//
//  AsyncImageView.M
//  Musiline
//
//  Created by fuacici on 10-5-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b);

static const char *gDefaultImages[] = {"wxt.png"};

#define SPINNY_TAG 5555
#define DOUBLE_TAP_DELAY 0.35

@implementation AsyncImageView
@synthesize  urlString; 
@synthesize defaultImage;
@synthesize manager;
@synthesize selectedRow;
@synthesize selectedSection;
@synthesize isImage;
@synthesize autoImage;
@synthesize imageViewBorderWidth;
@synthesize imageViewBorderColor;
@synthesize imageViewCornerRadius;
@synthesize imageViewMasksToBounds;
@synthesize delegate;
@synthesize index;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) 
	{
		self.manager = [ImageManager sharedImageManager];
	}
    return self;
}
- (void)awakeFromNib
{
	[super awakeFromNib];
	self.manager = [ImageManager sharedImageManager];
}
- (void) setUrlString:(NSString *) theUrl
{
	if ([urlString isEqualToString: theUrl ]) 
	{
		return;
	}
	[manager removeTarget: self forUrl: urlString];
	[urlString release];
	urlString = nil;
	[self imageDidLoaded: nil animate: NO];
	if (nil == theUrl) 
	{
		
		return;
	}
	urlString = [theUrl retain];
	if (nil == theUrl) 
	{
		
		return;
	}
	// setup the spiner
	UIActivityIndicatorView *spinny = (UIActivityIndicatorView *) [self viewWithTag: SPINNY_TAG];
	
	if (nil == spinny) 
	{
		spinny = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
	}
	
	spinny.tag = SPINNY_TAG;
	spinny.center = CGPointMake(self.center.x -self.frame.origin.x, self.center.y- self.frame.origin.y);
	[spinny startAnimating];
	[self addSubview:spinny];
	[manager addTaskWithURLString: urlString withDelegate: self];
    
}

- (void)dealloc 
{
	[manager removeTarget: self forUrl: urlString];
	self.manager = nil;
	self.urlString = nil;
    self.delegate = nil;
    self.index = nil;
	[imageView release];
	imageView = nil;
	[super dealloc];
}

- (void)setImage:(UIImage*) _image animate: (BOOL) animate
{
	//remove the spinner first
	
	if (autoImage==YES) {
				
		
		if (_image.size.width<=250&&_image.size.height<300) {
			self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, _image.size.width, _image.size.height);
		}else if (_image.size.width>250) {
			self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, 250, 250*(_image.size.height/_image.size.width));
		}else if (_image.size.height>300) {
			self.bounds=CGRectMake(self.frame.origin.x, self.frame.origin.y, 300*(_image.size.width/_image.size.height), 300);
		}
		
		CGAffineTransform  affineTransform1=CGAffineTransformMakeScale(0.1, 0.1);
		CGAffineTransform  affineTransform2=CGAffineTransformMakeScale(1, 1);

		[self setTransform:affineTransform1];
		[UIView beginAnimations:@"zfAnimations" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self setTransform:affineTransform2];
		[UIView commitAnimations];
		
	}
	UIView * _spinny = [self viewWithTag:SPINNY_TAG];
	[_spinny removeFromSuperview];
	
	//set the image

	if (nil == imageView) 
	{
		imageView = [[UIImageView alloc] initWithImage: _image] ;
		//imageView.userInteractionEnabled=YES;
		[self insertSubview: imageView atIndex:0];
	}else 
	{
		imageView.image = _image;
	}
	CGRect imgSize = self.bounds;
    if (_image) {
        if (imgSize.size.width * _image.size.height > imgSize.size.height * _image.size.width) {
            imgSize.size.width = imgSize.size.height * _image.size.width/_image.size.height;
            imgSize.origin.x = (self.bounds.size.width - imgSize.size.width)/2;
        }else {
            imgSize.size.height = imgSize.size.width * _image.size.height / _image.size.width;
            imgSize.origin.y = (self.bounds.size.height - imgSize.size.height)/2;
        }
    }
    
	imageView.tag = 2;
	imageView.frame = imgSize;
	imageView.layer.borderColor = imageViewBorderColor.CGColor;
	imageView.layer.borderWidth = imageViewBorderWidth;
	imageView.layer.cornerRadius = imageViewCornerRadius;
	imageView.layer.masksToBounds = imageViewMasksToBounds;
	
	if (animate)
	{
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		animation.fromValue = [NSNumber numberWithFloat:0.0f];
		animation.toValue = [NSNumber numberWithFloat:1.0f];
		animation.duration = 0.5f;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		[self.layer addAnimation: animation forKey: @"FadeIn"];
	}
	
	[imageView setNeedsLayout];
	[self setNeedsLayout];
}
- (void)setImage:(UIImage*) _image
{
	[self setImage: _image animate: NO];
}



- (UIImage*) image
{
    UIImageView* iv = imageView;
    return [iv image];
}

//代理方法，调用urlString的set方法时会执行，完成图片的设置。。。。
-(void)imageDidLoaded:(UIImage*) _image animate:(BOOL) animate
{
	
	
	if (nil == _image)
	{
		[self setImage: [UIImage imageNamed:  [NSString stringWithCString:gDefaultImages[defaultImage] encoding:NSUTF8StringEncoding]]];
		return;
	}

	[self setImage: _image animate:  animate];
	
    if (self.delegate && [self.delegate respondsToSelector:@selector(imgDownload:img:)]) { //下载完成回调
        [self.delegate imgDownload:self img:_image];
    }
}
- (void)layoutSubviews
{
	[super layoutSubviews];
//	imageView.frame = self.bounds;
	UIActivityIndicatorView * spinny = (UIActivityIndicatorView *) [self viewWithTag: SPINNY_TAG];
	spinny.center = CGPointMake(self.center.x -self.frame.origin.x, self.center.y- self.frame.origin.y);
}



#pragma mark 手势

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // cancel any pending handleSingleTap messages 
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    }    
    
    // check for 2-finger tap if we've seen multiple touches and haven't yet ruled out that possibility
    else if (multipleTouches && twoFingerTapIsPossible) { 
        
        // case 1: this is the end of both touches at once 
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0; 
            int tapCounts[2]; CGPoint tapLocations[2];
            for (UITouch *touch in touches) {
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) { // it's a two-finger tap if they're both single taps
                tapLocation = midpointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];
            }
        }
        
        // case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if touch is a single tap, store its location so we can average it with the second touch location
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        }
        
        // case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = midpointBetweenPoints(tapLocation, [touch locationInView:self]);
                [self handleTwoFingerTap];
            }
        }
    }
    
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

#pragma mark Private

- (void)handleSingleTap {
    if ([self.delegate respondsToSelector:@selector(tapDetectingImageView:gotSingleTapAtPoint:)])
        [self.delegate tapDetectingImageView:self gotSingleTapAtPoint:tapLocation];
}

- (void)handleDoubleTap {
    if ([self.delegate respondsToSelector:@selector(tapDetectingImageView:gotDoubleTapAtPoint:)])
        [self.delegate tapDetectingImageView:self gotDoubleTapAtPoint:tapLocation];
}

- (void)handleTwoFingerTap {
    if ([self.delegate respondsToSelector:@selector(tapDetectingImageView:gotTwoFingerTapAtPoint:)])
        [self.delegate tapDetectingImageView:self gotTwoFingerTapAtPoint:tapLocation];
}


@end

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}
