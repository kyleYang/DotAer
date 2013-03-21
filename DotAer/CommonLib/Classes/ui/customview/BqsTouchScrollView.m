//
//  BqsTouchScrollView.m
//  iMobeeNews
//
//  Created by ellison on 11-6-21.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsTouchScrollView.h"
#import "BqsUtils.h"


@implementation BqsTouchScrollView
@synthesize callback;
@synthesize attached;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
	UITouch *touch = [event.allTouches anyObject];
	touchBeganPoint = [touch locationInView:self];
    _touch = touch;
}	
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	
    for (UITouch* touch in touches) {
        if (touch == _touch) {
            _touch = nil;
            CGPoint touchPoint = [touch locationInView:self];
            float dist = [BqsUtils distancePoint1:touchPoint Point2:touchBeganPoint];
            if(dist < 20.0 && CGRectContainsPoint(self.bounds, touchPoint)) {
                
                if(touch.tapCount == 2) {
                    // 
                    if(nil != self.callback && [self.callback respondsToSelector:@selector(scrollView:didDoubleTapped:)]) {
                        [self.callback scrollView:self didDoubleTapped:touchPoint];
                    }
                } else {
                    if(nil != self.callback && [self.callback respondsToSelector:@selector(scrollView:didTapped:)]) {
                        [self.callback scrollView:self didTapped:touchPoint];
                    }
                }
            } else {
                BqsLog(@"dist: %.1f", dist);
            }
            break;
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
    for (UITouch* touch in touches) {
        if (touch == _touch) {
            _touch = nil;
            break;
        }
    }
}

@end
