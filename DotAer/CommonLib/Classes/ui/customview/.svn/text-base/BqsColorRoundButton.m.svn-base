//
//  BqsColorRoundButton.m
//  iMobeeBook
//
//  Created by ellison on 11-7-6.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsColorRoundButton.h"
#import "BqsUtils.h"

@implementation BqsColorRoundButton
@synthesize bShining;
@synthesize bShadow;
@synthesize bgColor;
@synthesize bgColorPress;
@synthesize text;
@synthesize textFont;
@synthesize textColor;
@synthesize textColorPress;
@synthesize img;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;

    self.bShining = YES;
    self.bShadow = YES;
    self.backgroundColor = [UIColor clearColor];
    self.textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    return self;
}


- (void)dealloc
{
    self.bgColor = nil;
    self.bgColorPress = nil;
    self.text = nil;
    self.textFont = nil;
    self.textColor = nil;
    self.textColorPress = nil;
    self.img = nil;
    
    [super dealloc];
}

- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations
                                 count:(int)count {
    CGFloat* components = malloc(sizeof(CGFloat)*4*count);
    for (int i = 0; i < count; ++i) {
        UIColor* color = colors[i];
        size_t n = CGColorGetNumberOfComponents(color.CGColor);
        const CGFloat* rgba = CGColorGetComponents(color.CGColor);
        if (n == 2) {
            components[i*4] = rgba[0];
            components[i*4+1] = rgba[0];
            components[i*4+2] = rgba[0];
            components[i*4+3] = rgba[1];
            
        } else if (n == 4) {
            components[i*4] = rgba[0];
            components[i*4+1] = rgba[1];
            components[i*4+2] = rgba[2];
            components[i*4+3] = rgba[3];
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
    free(components);
    
    return gradient;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
#define kCorner .15

    CGFloat radius = CGRectGetMaxY(rect)*kCorner;
    CGFloat puffer = 0;//CGRectGetMaxY(rect)*0.10;
    if(bShadow) {
        puffer = 3;//CGRectGetMaxY(rect)*0.10;
    }
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;

    // draw bg
    {
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
        UIColor *color = nil;
        if(_bPressed && nil != self.bgColorPress) color = self.bgColorPress;
        if(nil == color) color = self.bgColor;
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
        CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
        CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
        CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
        if(self.bShadow) {
            CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
        }
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
        
    }
    if(self.bShining) {
        CGContextSaveGState(context);
        
//        CGFloat radius = CGRectGetMaxY(rect)*kCorner;
//        CGFloat puffer = 0;//CGRectGetMaxY(rect)*0.10;
//        if(bShadow) puffer = 3;//CGRectGetMaxY(rect)*0.10;
//        CGFloat maxX = CGRectGetMaxX(rect) - puffer;
//        CGFloat maxY = CGRectGetMaxY(rect) - puffer;
//        CGFloat minX = CGRectGetMinX(rect) + puffer;
//        CGFloat minY = CGRectGetMinY(rect) + puffer;
        CGContextBeginPath(context);
        CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
        CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
        CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
        CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
        CGContextClosePath(context);
        CGContextClip(context);
        
       
        UIColor *topStartHL = [UIColor colorWithWhite:1.0 alpha:.6];
        //UIColor *topEndHL = [UIColor colorWithWhite:1.0 alpha:.13];
        UIColor *clearColor = [UIColor colorWithWhite:1.0 alpha:.0];
        
        UIColor *botEndHL = clearColor;
        
        UIColor *colors[] = {
            topStartHL, botEndHL};
        
        CGFloat locations[] = {0, 1.0};
        
        CGGradientRef gradient = [self newGradientWithColors:colors locations:locations count:2];
        CGContextDrawLinearGradient(context, gradient, rect.origin, CGPointMake(rect.origin.x, rect.origin.y+rect.size.height), 0);
        CGGradientRelease(gradient);

        
        CGContextRestoreGState(context);	

    }
    
    if(nil != self.img) {
        // draw img
        float dx = 2;
        if(self.bShadow) dx += 3;
        CGRect rcDrawArea = CGRectInset(rect, dx, dx);
        CGRect rcImg = rcDrawArea;
        CGSize szImg = self.img.size;
        
        if(CGRectGetWidth(rcDrawArea) < szImg.width || CGRectGetHeight(rcDrawArea) < szImg.height) {
            // shrink img
            if(szImg.height > 0 && szImg.width > 0 &&
               rcImg.size.height > 0 && rcImg.size.width > 0) {
                CGSize szRc = rcImg.size;
                float ratioImg = szImg.width / szImg.height;
                float ratioRc = szRc.width / szRc.height;
                
                if(ratioImg > ratioRc) {
                    szRc.height = szRc.width * (szImg.height/szImg.width);
                } else if(ratioImg < ratioRc) {
                    szRc.width = szRc.height * ratioImg;
                }
                
                if(szRc.width < rcImg.size.width) {
                    rcImg.origin.x = floor(rcImg.origin.x + (rcImg.size.width - szRc.width) / 2.0);
                    rcImg.size.width = floor(szRc.width);
                }
                if(szRc.height < rcImg.size.height) {
                    rcImg.origin.y = floor(rcImg.origin.y + (rcImg.size.height - szRc.height) / 2.0);
                    rcImg.size.height = floor(szRc.height);
                }
            }
        } else {
            // center img
            rcImg.origin.x = floor(rcImg.origin.x + (CGRectGetWidth(rcDrawArea) - szImg.width)/2.0);
            rcImg.origin.y = floor(rcImg.origin.y + (CGRectGetHeight(rcDrawArea) - szImg.height)/2.0);
            rcImg.size = szImg;
        }
//        BqsLog(@"rcDrawArea: %.1f, %.1f %.1fx%.1f", rcDrawArea.origin.x, rcDrawArea.origin.y, rcDrawArea.size.width, rcDrawArea.size.height);
//        BqsLog(@"imgRc: %.1f, %.1f %.1fx%.1f", rcImg.origin.x, rcImg.origin.y, rcImg.size.width, rcImg.size.height);
        [self.img drawInRect:rcImg];
        
    } else {
        // draw text
        if(nil != self.text && [self.text length] > 0) {
            UIFont *fnt = self.textFont;
            if(nil == fnt) fnt = [UIFont systemFontOfSize:17.0];
            UIColor *color = nil;
            if(_bPressed && nil != self.textColorPress) color = self.textColorPress;
            else color = self.textColor;
            if(nil == color) color = [UIColor blackColor];
            

            NSMutableString *txt = [[[NSMutableString alloc] initWithString:self.text] autorelease];
            {
                // calc text
                CGSize sz = [txt sizeWithFont:fnt];
                int cnt = [txt length];    
                BOOL bAppend = NO;
                while(sz.width > rect.size.width && cnt > 0) {
                    [txt deleteCharactersInRange:NSMakeRange(cnt-1, 1)];
                    cnt --;
                    
                    NSString *s = [NSString stringWithFormat:@"%@...", txt];
                    sz = [s sizeWithFont:fnt];
                    
                    bAppend = YES;
                }
                
                if(bAppend) [txt appendString:@"..."];
                
            }

            CGContextSetFillColorWithColor(context, color.CGColor);
            CGSize textSize = [txt sizeWithFont:textFont];
            [txt drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2)) withFont:fnt];
        }
    }
}

-(void)sizeToFit {
    CGRect rcFrm = self.frame;
    CGSize szContent = CGSizeZero;
    
    if(nil != img) {
        szContent = img.size;
        
    } else {
        UIFont *fnt = self.textFont;
        if(nil == fnt) fnt = [UIFont systemFontOfSize:17.0];
        
        CGSize textSize = CGSizeZero;
        if(nil != self.text && [self.text length] > 0) textSize = [self.text sizeWithFont:fnt];
        
        szContent = textSize;
        
    }
    int padding = 2;
    int shadow = 3;
    if(!self.bShadow) shadow = 0;
    
    rcFrm.size.width = szContent.width + 2*(padding + shadow); // shadow/padding
    rcFrm.size.height = szContent.height + 2*(padding + shadow);
    
    self.frame = rcFrm;

}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

//-(void)setCallbackTarget:(id)target Sel:(SEL)sel {
//    _cbTarget = target;
//    _cbSel = sel;
//}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
//	UITouch *touch = [event.allTouches anyObject];
    
    _bPressed = YES;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    _bPressed = NO;
    [self setNeedsDisplay];
    
//    UITouch *touch = [[event allTouches] anyObject];
//    if(nil == touch) return;
//    CGPoint pt = [touch locationInView:self];
//    
//    if(CGRectContainsPoint(self.bounds, pt)) {
//        if(nil != _cbTarget && [_cbTarget respondsToSelector:_cbSel]) {
//            [_cbTarget performSelector:_cbSel withObject:self afterDelay:.01];
//        }
//	}
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    _bPressed = NO;
    [self setNeedsLayout];
}

@end
