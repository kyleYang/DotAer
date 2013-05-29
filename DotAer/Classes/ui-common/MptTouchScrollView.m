//
//  MptTouchScrollView.m
//  TVGontrol
//
//  Created by Kyle on 13-5-10.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import "MptTouchScrollView.h"
#import "BqsUtils.h"

#define kScrollMoveLength 20

@implementation MptTouchScrollView
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




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	BqsLog(@"touchesEnded ");
    if (!self.dragging)
        [self.nextResponder touchesEnded: touches withEvent:event];
    else
        [super touchesEnded: touches withEvent: event];
}




@end
