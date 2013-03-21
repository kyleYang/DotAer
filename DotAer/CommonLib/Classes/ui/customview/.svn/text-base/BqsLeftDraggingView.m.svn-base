//
//  BqsLeftDraggingView.m
//  iMobeeBook
//
//  Created by ellison on 11-7-5.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsLeftDraggingView.h"

#define kDragThreshDistance 10

@implementation BqsLeftDraggingView

@synthesize bClickTogglePop;
@synthesize dragMaxX;
@synthesize dragMinX;
@synthesize callback;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    self.bClickTogglePop = YES;
    
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

-(BOOL) isShrinked {
    float frmx = self.frame.origin.x;
    {
        float middlex = (self.dragMaxX + self.dragMinX) / 2;
        if(frmx < middlex) {
            return YES;
        } else {
            return NO;
        }
    }

}
-(void)pop:(BOOL)bAnim {
    if(_interactionLocked) return;
    
    float newx = self.dragMaxX;
    
    if(newx != self.frame.origin.x) {
        if(bAnim) {
            _interactionLocked = YES;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.2];
        }
        
        CGRect frm = self.frame;
        frm.origin.x = newx;
        self.frame = frm;
        
        if(bAnim) {
            [UIView commitAnimations];
        }
    }
    [self performSelector:@selector(onPopAnimEnd)
               withObject:nil 
               afterDelay:.3];
    return;
}

-(void)shrink:(BOOL)bAnim {
    if(_interactionLocked) return;
    
    float newx = self.dragMinX;
    
    if(newx != self.frame.origin.x) {
        if(bAnim) {
            _interactionLocked = YES;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.2];
        }
        
        CGRect frm = self.frame;
        frm.origin.x = newx;
        self.frame = frm;
        
        if(bAnim) {
            [UIView commitAnimations];
            
        }
    }
    [self performSelector:@selector(onShrinkAnimEnd)
               withObject:nil 
               afterDelay:.3];
    return;    
}

-(void)onShrinkAnimEnd {
    _interactionLocked = NO;
    
    if(nil != self.callback) {
        // did shirnk
        if([self.callback respondsToSelector:@selector(bqsLeftDraggingViewDidShrink:)]) {
            [self.callback performSelector:@selector(bqsLeftDraggingViewDidShrink:) withObject:self];
        }
    }
}

-(void)onPopAnimEnd {
    _interactionLocked = NO;
    
    if(nil != self.callback) {
        // did pop
        if([self.callback respondsToSelector:@selector(bqsLeftDraggingViewDidPop:)]) {
            [self.callback performSelector:@selector(bqsLeftDraggingViewDidPop:) withObject:self];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(_interactionLocked) return;
    
	UITouch *touch = [event.allTouches anyObject];
	_touchBeganPoint = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(_interactionLocked) return;
    
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self.superview];
	
	if (!_touchDragging) {
		
        float frmx = self.frame.origin.x;
        
		BOOL dragged = sqrtf(powf(touchPoint.x-_touchBeganPoint.x, 2)) > kDragThreshDistance;
		if(dragged) {
			if(touchPoint.x < _touchBeganPoint.x) {
                // drag to left
				if(frmx > self.dragMinX) {
					_touchDragging = YES;
                    _dragBeginX = frmx;
                    _dragTouch = touch;
				} else {
					return;
				}
			} else {
                // drag to right
				if(frmx < self.dragMaxX){
					_touchDragging = YES;
                    _dragBeginX = frmx;
                    _dragTouch = touch;
				} else {
					return;
				}
			}
		} else {
			return;
		}
        
        if(_touchDragging) {
            if(nil != self.callback) {
                // begin drag
                if([self.callback respondsToSelector:@selector(bqsLeftDraggingViewBeginDrag:)]) {
                    [self.callback performSelector:@selector(bqsLeftDraggingViewBeginDrag:) withObject:self];
                }
            }
        }
	}
    
    
    for (UITouch* touch in touches) {
        if (touch == _dragTouch) {
            touchPoint = [touch locationInView:self.superview];
            
            float distance = touchPoint.x - _touchBeganPoint.x;
            
            float newx = MIN(_dragBeginX + distance, self.dragMaxX);
            newx = MAX(newx, self.dragMinX);
            
            if(newx != self.frame.origin.x) {
                
                CGRect frm = self.frame;
                frm.origin.x = newx;
                self.frame = frm;
                
            }
            break;
        }
    }
    
	
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_interactionLocked) return;
    
	if (!_touchDragging) {
        
        if(!self.bClickTogglePop) return;
        
        if([self isShrinked]) {
            [self pop:YES];
        } else {
            [self shrink:YES];
        }
	} else {
        for (UITouch* touch in touches) {
            if (touch == _dragTouch) {
                // dragging end
                _touchDragging = NO;
                _dragTouch = nil;
                
                CGPoint touchPoint = [touch locationInView:self.superview];
                BOOL dragged = sqrtf(powf(touchPoint.x-_touchBeganPoint.x, 2)) > kDragThreshDistance;
                
                if(dragged) {
//                    float frmx = self.frame.origin.x;
//                    float middlex = (self.dragMaxX + self.dragMinX) / 2;
                    if(touchPoint.x > _touchBeganPoint.x) {
                        // pop
                        [self pop:YES];
                    } else {
                        // shrink
                        [self shrink:YES];
                    }                    
                }
                
                break;
            }
        }
	}
	
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    [self touchesEnded:touches withEvent:event];
}

@end
