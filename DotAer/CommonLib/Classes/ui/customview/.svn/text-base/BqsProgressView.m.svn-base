//
//  BqsProgressView.m
//  iMobeeBook
//
//  Created by ellison on 11-7-11.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsProgressView.h"


@implementation BqsProgressView
@synthesize fPercent=_fPercent;
@synthesize bContinuous;
@synthesize imgFg;
@synthesize imgBg;
@synthesize dotGap; // for non continual

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)dealloc
{
    self.imgFg = nil;
    self.imgBg = nil;
    [super dealloc];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGContextRef ctx = UIGraphicsGetCurrentContext();

    if(nil == self.imgFg) return;
    
    float prgW = CGRectGetWidth(rect) * self.fPercent;

    if(self.bContinuous) {
        if(nil != self.imgBg) {
            [self.imgBg drawInRect:rect];
        }
        if(nil != self.imgFg) {
            CGRect rcPrg = rect;
            rcPrg.size.width = prgW;
            [self.imgFg drawInRect:rcPrg];
        }
    } else {
        CGPoint pt = CGPointMake(0, 0);
        float imgW = self.imgFg.size.width;
        float imgH = self.imgFg.size.height;
        
        if(rect.size.height > imgH) pt.y += (rect.size.height - imgH)/2;
        
        float w = rect.size.width;
        while(pt.x + imgW < w) {
            if(pt.x + imgW <= prgW) [self.imgFg drawAtPoint:pt];
            else if(nil != self.imgBg) [self.imgBg drawAtPoint:pt];
            pt.x += imgW + self.dotGap;
        }
    }
}

-(void)setFPercent:(float)afPercent {
    _fPercent = afPercent;
    [self setNeedsDisplay];
}

@end
