//
//  BqsTabBar.m
//  iMobeeBook
//
//  Created by ellison on 11-7-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsTabBar.h"
#import "BqsUtils.h"

#define kItemWidth 77.0
#define kItemHeight 47.0

#define kItemPadding 2

#define kItemImgW 34.0
#define kItemImgH 25.0


@interface BqsTabBar()
@property (nonatomic, retain) NSArray *arrItems;

-(NSInteger)getClickIdx:(CGPoint)pt;

@end

@implementation BqsTabBar
@synthesize backgroundImage;
@synthesize itemFontColor;
@synthesize itemSelectedFontColor;
@synthesize itemSelectedBgImg;
@synthesize selectedIdx = _selectedIdx;
@synthesize arrItems;
@synthesize callback;
@synthesize bFillWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.userInteractionEnabled = YES;
    self.itemFontColor = [UIColor blackColor];
    
    self.bFillWidth = NO;
    _clickEffectIdx = -1;
    
    return self;
}

- (void)dealloc
{
    self.backgroundImage = nil;
    self.itemFontColor = nil;
    self.itemSelectedFontColor = nil;
    self.itemSelectedBgImg = nil;
    self.arrItems = nil;
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    // draw bg
    if(nil != backgroundImage) {
        [backgroundImage drawInRect:rect];
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
    }
    
    
    // draw items
    int cnt = [self.arrItems count];
    if(cnt < 1) return;
    
    int itemWidth = kItemWidth;
    
    // calc item pos
    float totalW = cnt * kItemWidth;
    float x = 0.0;
    float y = rect.size.height - kItemHeight;
    if(totalW < rect.size.width) {
        if(self.bFillWidth) {
            itemWidth = CGRectGetWidth(rect) / cnt;
        } else {
            x += (rect.size.width - totalW) / 2;
        }
    } else if(totalW > rect.size.width) {
        itemWidth = floor(rect.size.width / cnt);
    }
    
    if(kItemHeight < rect.size.height) {
        y -= (rect.size.height - kItemHeight) / 2;
    }
    
    CGRect rcImg = CGRectMake(x + (itemWidth-kItemImgW)/2 + kItemPadding, y + kItemPadding, kItemImgW, kItemImgH);
    CGRect rcTxt = CGRectMake(x + kItemPadding, y+kItemImgH + kItemPadding, itemWidth - 2*kItemPadding, kItemHeight - kItemImgH - kItemPadding);
    UIFont *txtFont = [UIFont systemFontOfSize:14];
    
//    BqsLog(@"_selectIdx: %d, _clickEffectIdx: %d", _selectedIdx, _clickEffectIdx);
    
    for(int i = 0; i < cnt; i ++) {
        UIBarItem *bi = [self.arrItems objectAtIndex:i];
        
        CGContextSetFillColorWithColor(ctx, self.itemFontColor.CGColor);

        // draw click effetct item bg
        // draw selected item bg
        if(self.selectedIdx == i || _clickEffectIdx == i) {
            [self.itemSelectedBgImg drawInRect:CGRectMake(x, y, itemWidth, kItemHeight)];
            if(nil != self.itemSelectedFontColor) {
                CGContextSetFillColorWithColor(ctx, self.itemSelectedFontColor.CGColor);
            }
        }
        
        if(nil != bi.image) {
            CGRect imgRc = rcImg;
            CGSize szImg = bi.image.size;
            if(szImg.height > 0 && szImg.width > 0 &&
               imgRc.size.height > 0 && imgRc.size.width > 0) {
                CGSize szRc = imgRc.size;
                float ratioImg = szImg.width / szImg.height;
                float ratioRc = szRc.width / szRc.height;
                
                if(ratioImg > ratioRc) {
                    szRc.height = szRc.width * (szImg.height/szImg.width);
                } else if(ratioImg < ratioRc) {
                    szRc.width = szRc.height * ratioImg;
                }
                
                if(szRc.width < imgRc.size.width) {
                    imgRc.origin.x += (imgRc.size.width - szRc.width) / 2;
                    imgRc.size.width = szRc.width;
                }
                if(szRc.height < imgRc.size.height) {
                    imgRc.origin.y += (imgRc.size.height - szRc.height) / 2;
                    imgRc.size.height = szRc.height;
                }
            }
            [bi.image drawInRect:imgRc];
        }
        
        if(nil != bi.title && [bi.title length] > 0) {
            CGSize szTxt = [bi.title sizeWithFont:txtFont minFontSize:6 actualFontSize:nil forWidth:rcTxt.size.width lineBreakMode:UILineBreakModeClip];
            
            CGPoint pt = rcTxt.origin;
            float w = MIN(rcTxt.size.width, szTxt.width);
            if(szTxt.width < rcTxt.size.width) {
                pt.x += (rcTxt.size.width - szTxt.width) / 2;
            }
            if(szTxt.height < rcTxt.size.height) {
                pt.y += (rcTxt.size.height - szTxt.height) / 2;
            }
            [bi.title drawAtPoint:pt forWidth:w withFont:txtFont minFontSize:6 actualFontSize:nil lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentNone];
        }
        
        x += itemWidth;
        rcTxt.origin.x += itemWidth;
        rcImg.origin.x += itemWidth;
    }
    
}

-(void) layoutSubviews {
    [self setNeedsDisplay];
}


-(void)setSelectedIdx:(NSInteger)aSelectedIdx {
    int oldSelectId = _selectedIdx;
    
    _selectedIdx = aSelectedIdx;
    [self setNeedsDisplay];
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsTabBar:DidSelect:PrevSelect:)]) {
        [self.callback bqsTabBar:self DidSelect:_selectedIdx PrevSelect:oldSelectId];
    }

}

-(void)setItems:(NSArray*)arr {
    self.arrItems = arr;
    
    int cnt = [arr count];
    _selectedIdx = MIN(_selectedIdx, cnt-1);
    _selectedIdx = MAX(_selectedIdx, 0);
    
//    BqsLog(@"itemCnt: %d", [arr count]);
    [self setNeedsDisplay];
    
}
-(UITabBarItem*)getItem:(int)idx {
    if(idx >= 0 && idx < [self.arrItems count]) {
        return [self.arrItems objectAtIndex:idx];
    }
    
    return nil;
}
-(int)selectItemByTag:(int)tag {
    int cnt = [self.arrItems count];
    for(int i = 0; i < cnt; i ++) {
        UITabBarItem *it = (UITabBarItem*)[self.arrItems objectAtIndex:i];
        if(tag == it.tag) {
            [self setSelectedIdx:i];
            return i;
        }
    }
    return -1;
}

-(NSInteger)getClickIdx:(CGPoint)pt {
    // calc item pos
    
    int cnt = [self.arrItems count];
    if(cnt < 1) return -1;

    CGRect rect = self.bounds;
    
    if(pt.y < 0 || pt.y > rect.size.height) return -1;
    
    int itemWidth = kItemWidth;
    
    float totalW = cnt * kItemWidth;
    float x = 0.0;
    if(totalW < rect.size.width) {
        if(self.bFillWidth) {
            itemWidth = CGRectGetWidth(rect) / cnt;
        } else {
            x += (rect.size.width - totalW) / 2;
        }
    } else if(totalW > rect.size.width) {
        itemWidth = floor(rect.size.width / cnt);
    }
    
    for(int i = 0; i < cnt; i ++) {
        if(pt.x > x && pt.x <= x + itemWidth) {
            return i;
        }
        x += itemWidth;
    }

    return -1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	UITouch *touch = [event.allTouches anyObject];
	_touchBeganPoint = [touch locationInView:self];
    _touch = touch;
    _clickEffectIdx = [self getClickIdx:_touchBeganPoint];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	
    _clickEffectIdx = -1;
    [self setNeedsDisplay];
	
    for (UITouch* touch in touches) {
        if (touch == _touch) {
            _touch = nil;
            CGPoint touchPoint = [touch locationInView:self];
            float dist = [BqsUtils distancePoint1:touchPoint Point2:_touchBeganPoint];
            if(dist < 20.0) {
                
                // calc select idx
                int idx = [self getClickIdx:touchPoint];
                if(idx >= 0) {
                    self.selectedIdx = idx;
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
    
    _touchBeganPoint = CGPointZero;
    _touch = nil;
    _clickEffectIdx = -1;
    [self setNeedsDisplay];
}


@end
