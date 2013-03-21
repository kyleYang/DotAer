//
//  BqsTouchImageView.m
//  iMobeeNews
//
//  Created by ellison on 11-6-9.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsTouchImageView.h"
#import "BqsUtils.h"


@implementation BqsTouchImageView
@synthesize callback;
@synthesize attached;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
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
                
                if(nil != self.callback && [self.callback respondsToSelector:@selector(imageView:didTapped:)]) {
                    [self.callback imageView:self didTapped:touchPoint];
                }
            } else {
                BqsLog(@"dist: %.1f", dist);
            }
            break;
        }
    }

}

@end
