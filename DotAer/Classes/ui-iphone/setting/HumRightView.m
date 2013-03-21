//
//  HumRightView.m
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumRightView.h"

@implementation HumRightView


-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        text.font = [UIFont systemFontOfSize:20];
        text.text = @"XXXXXOOOOOOOO";
        [self addSubview:text];
        [text release];
        
        
        // guesture recognize
        
    }
    return self;
    
}


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

@end
