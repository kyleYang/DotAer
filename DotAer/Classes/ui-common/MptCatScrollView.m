//
//  MptCatScrollView.m
//  TVGontrol
//
//  Created by Kyle on 13-5-23.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import "MptCatScrollView.h"
#import "BqsTouchScrollView.h"
#import "Env.h"
#import "BqsUtils.h"

#define kSelectedBgExtandHori 0 

#define kFontSizeNor 14.0f
#define kFontSizeHot 16

#define kPaddingVer 5
#define kItemGapHori 15
#define kPaddingHori 0

#define kGapTextLine -2

#define kNameColor_Hight [UIColor colorWithRed:178.0f/255.0f green:224.0f/255.0f blue:83.0f/255.0f alpha:1.0]

@interface MptCatScrollView()<UIScrollViewDelegate,BqsTouchScrollViewCallback>{
    BqsTouchScrollView *_viewScroll;
    NSMutableArray *_arrItemLabels;
    
}

@property (nonatomic, strong) UIImageView *indicateImage;
@property (nonatomic, strong) BqsTouchScrollView *viewScroll;
@property (nonatomic, strong) NSMutableArray *arrItemLabels;

@end


@implementation MptCatScrollView
@synthesize viewScroll = _viewScroll;
@synthesize arrItems = _arrItems;
@synthesize delegate = _delegate;
@synthesize normalColor = _normalColor;
@synthesize hilightColor = _hilightColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        Env *env = [Env sharedEnv];
        
        _indicaHidden = NO;
        _normalColor = [UIColor blackColor];
        _hilightColor = [UIColor colorWithRed:23.0f/255.0f green:129.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
        
        self.viewScroll = [[BqsTouchScrollView alloc] initWithFrame:self.bounds];
        //    self.viewScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.viewScroll.showsVerticalScrollIndicator = NO;
        self.viewScroll.showsHorizontalScrollIndicator = NO;
        self.viewScroll.callback = self;
        self.viewScroll.delegate = self;
        self.viewScroll.scrollsToTop = FALSE;
        self.viewScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.viewScroll.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addSubview:self.viewScroll];
        
        self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, CGRectGetHeight(self.bounds))];
        self.indicateImage.image = [env cacheScretchableImage:@"scroll_indica.png" X:40 Y:15];
        [self.viewScroll addSubview:self.indicateImage];
        self.viewScroll.hidden = _indicaHidden;


    }
    return self;
}


#pragma mark
#pragma mark property

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    
    for (int i = 0; i< self.arrItemLabels.count; i++) {
        if (i == _selectedId) continue;
        
         UILabel *lbl = [self.arrItemLabels objectAtIndex:i];
         lbl.textColor = _normalColor;
    }

}

- (void)setHilightColor:(UIColor *)hilightColor{
    _hilightColor = hilightColor;
    
    if (_selectedId>=0 && _selectedId < [self.arrItemLabels count]) {
        UILabel *lbl = [self.arrItemLabels objectAtIndex:_selectedId];
        lbl.textColor = _hilightColor;
    }
    
}

- (void)setIndicaHidden:(BOOL)indicaHidden{
    if (_indicaHidden == indicaHidden) return;
    _indicaHidden = indicaHidden;
    
    self.indicateImage.hidden = indicaHidden;
    
    
}


-(void)setLabelColors {
    int cnt = [self.arrItemLabels count];
    for(int i = 0; i < cnt; i ++) {
        UILabel *lbl = [self.arrItemLabels objectAtIndex:i];
        if(i == _selectedId) {
//            lbl.font = [UIFont boldSystemFontOfSize:kFontSizeHot];
            lbl.textColor = _hilightColor;
            lbl.alpha = 1;
        } else {
//            lbl.font = [UIFont systemFontOfSize:kFontSizeNor];
            lbl.textColor = _normalColor;
            lbl.alpha = .5;
        }
    }
}


- (void)setSelectedIndex:(NSInteger)index{
    
    if (index<0 || index >= [self.arrItemLabels count]) return;
    
    int oldSelectedid = _selectedId;
    _selectedId = index;
    
    UILabel *lbl = [self.arrItemLabels objectAtIndex:_selectedId];
    
    CGRect frm = self.indicateImage.frame;
    frm.origin.x = lbl.frame.origin.x;
    frm.size.width = lbl.frame.size.width;
    //    frm.origin.x -= kSelectedBgExtandHori;
    //    frm.size.width += 2*kSelectedBgExtandHori;
    //    frm.origin.y -= kGapTextLine;
    //    frm.size.height += 2*kGapTextLine;
    //
    //    frm.origin.x = CGRectGetWidth(self.viewScroll.frame) / 2.0 - CGRectGetWidth(frm)/2.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    self.indicateImage.frame = frm;
    [self setLabelColors];
    [UIView commitAnimations];
    
    [self scrollsRectFullVisible:lbl.frame];
}


-(void)setArrItems:(NSArray *)arr {
    if (!arr) {
        BqsLog(@"setArrItems = nil");
        return;
    }
    
    _arrItems = arr;
    
    _selectedId = 0;
    
    self.viewScroll.contentOffset = CGPointMake(0, 0);
      
    int cnt = [_arrItems count];
    
    // create labels
    if(nil == self.arrItemLabels) self.arrItemLabels = [NSMutableArray arrayWithCapacity:cnt];
    
    while([self.arrItemLabels count] > cnt && [self.arrItemLabels count] > 0) {
        UILabel *lbl = [self.arrItemLabels lastObject];
        [lbl removeFromSuperview];
        [self.arrItemLabels removeObject:lbl];
    }
    
    while([self.arrItemLabels count] < cnt) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:kFontSizeNor];
        lbl.textColor = _normalColor;
        lbl.adjustsFontSizeToFitWidth = NO;
        lbl.textAlignment = UITextAlignmentCenter;
        //        lbl.backgroundColor = RGBA(0xff, 0, 0, .5);
        
        lbl.shadowColor = RGBA(0, 0, 0, .6);
        lbl.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [self.viewScroll addSubview:lbl];
        
        [self.arrItemLabels addObject:lbl];
    }
    
    // set view values
    for(int i = 0;i  < cnt; i ++) {
        UILabel *lbl = [self.arrItemLabels objectAtIndex:i];
        lbl.text = [_arrItems objectAtIndex:i];
    }
    
    [self layoutItems];
    
    _selectedId = MAX(0, MIN(_selectedId, cnt-1));
    
    if(_selectedId >= 0 && _selectedId < cnt) {
        UILabel *lbl = [self.arrItemLabels objectAtIndex:_selectedId];
        CGRect frm = self.indicateImage.frame;
        frm.origin.x = lbl.frame.origin.x;
        frm.size.width = lbl.frame.size.width;
        self.indicateImage.frame = frm;
        [self setLabelColors];
        [self setLabelColors];
    } else {
        [self.viewScroll scrollRectToVisible:CGRectZero animated:YES];
    }
}


-(void)layoutItems {
   
    
    float x = kPaddingHori;
    float y = kPaddingVer;
    float h = kGuideCatTwoViewH - 2 * kPaddingVer - 4;
    float fLblExpendW = 0.0;
    float fMinWidth = 50;//floor(MAX((CGRectGetWidth(self.bounds) - kPaddingHori * 2) / 4.5 , 20));
    
    int cnt = [self.arrItemLabels count];
    
    for(int i = 0;i  < cnt; i ++) {
        UILabel *lbl = [self.arrItemLabels objectAtIndex:i];
        
        CGSize sz = [lbl.text sizeWithFont:lbl.font];
        
        if(0 != i) x += kItemGapHori;
        
        x += MAX(sz.width,fMinWidth) + 2 * kSelectedBgExtandHori;
    }
    
    //    BqsLog(@"x: %.1f, w: %.1f, h: %.1f, sh: %.1f", x, CGRectGetWidth(self.viewScroll.bounds), h, CGRectGetHeight(self.viewScroll.bounds));
    
    if(x + kPaddingHori < CGRectGetWidth(self.viewScroll.bounds)) {
        fLblExpendW = floor((CGRectGetWidth(self.viewScroll.bounds) - x - kPaddingHori) / cnt);
    }
    
    x = kPaddingHori;
    
    UIFont *fnt = [UIFont boldSystemFontOfSize:kFontSizeHot];
    for(int i = 0;i  < cnt; i ++) {
        UILabel *lbl = [self.arrItemLabels objectAtIndex:i];
        lbl.text = [_arrItems objectAtIndex:i];
        
        CGSize sz = [lbl.text sizeWithFont:fnt];
        sz.width += fLblExpendW;
        
        if(0 != i) x += kItemGapHori;
        
        float w= MAX(sz.width,fMinWidth);
        lbl.frame = CGRectMake(x + kSelectedBgExtandHori, y, w, h);
        
        x += w + 2 * kSelectedBgExtandHori;
    }
    
    self.viewScroll.contentSize = CGSizeMake(x+ kPaddingHori, CGRectGetHeight(self.viewScroll.bounds));
    
}


-(void)scrollsRectFullVisible:(CGRect)frm {
    
    float offsetX = CGRectGetMinX(frm);
    BqsLog(@"setCotentOffset:%.1f",offsetX);
    [self.viewScroll scrollRectToVisible:frm animated:YES];
}




#pragma mark - BqsTouchScrollViewCallback
-(void)scrollView:(BqsTouchScrollView*)iv didTapped:(CGPoint)pt {
    BqsLog(@"tap:%.1f,%.1f", pt.x, pt.y);
    
    int i = -1;
    int cnt = [self.arrItemLabels count];
    for(i = 0; i < cnt; i ++) {
        float minx = 0, maxx = self.viewScroll.contentSize.width;
        
        UILabel *lbl = [self.arrItemLabels objectAtIndex:i];
        if(i > 0) {
            UILabel *lblPrev = [self.arrItemLabels objectAtIndex:i-1];
            if(CGRectGetMaxX(lblPrev.frame) < CGRectGetMinX(lbl.frame)) {
                minx = CGRectGetMinX(lbl.frame) - ((CGRectGetMinX(lbl.frame) - CGRectGetMaxX(lblPrev.frame))/2.0);
            } else {
                minx = CGRectGetMinX(lbl.frame);
            }
        }
        
        if(i < cnt - 1) {
            UILabel *lblNext = [self.arrItemLabels objectAtIndex:i+1];
            if(CGRectGetMinX(lblNext.frame) > CGRectGetMaxX(lbl.frame)) {
                maxx = CGRectGetMaxX(lbl.frame) + ((CGRectGetMinX(lblNext.frame) - CGRectGetMaxX(lbl.frame))/2.0);
            } else {
                maxx = CGRectGetMaxX(lbl.frame);
            }
        }
        
        BqsLog(@"i: %d, minx: %.1f, maxx: %.1f", i, minx, maxx);
        
        if(pt.x >= minx && pt.x <= maxx) {
            // found click
            break;
        }
    }
    
    if(i < 0 || i >= cnt) return;
    
    int oldSelectedid = _selectedId;
    _selectedId = i;
    
    UILabel *lbl = [self.arrItemLabels objectAtIndex:_selectedId];
    
    CGRect frm = self.indicateImage.frame;
    frm.origin.x = lbl.frame.origin.x;
    frm.size.width = lbl.frame.size.width;
//    frm.origin.x -= kSelectedBgExtandHori;
//    frm.size.width += 2*kSelectedBgExtandHori;
//    frm.origin.y -= kGapTextLine;
//    frm.size.height += 2*kGapTextLine;
//    
//    frm.origin.x = CGRectGetWidth(self.viewScroll.frame) / 2.0 - CGRectGetWidth(frm)/2.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    self.indicateImage.frame = frm;
    [self setLabelColors];
    [UIView commitAnimations];
    
    [self scrollsRectFullVisible:lbl.frame];
    
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(catScrollView:didSelect:)]) {
        [self.delegate catScrollView:self didSelect:_selectedId];
    }
    
}

-(void)scrollView:(BqsTouchScrollView*)sv didDoubleTapped:(CGPoint)pt {
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
//    BqsLog(@"scrollViewDidEndDecelerating:");
//    CGPoint pt = CGPointMake(0, CGRectGetMidY(self.viewScroll.bounds));
//    
//    pt.x = self.viewScroll.contentOffset.x + CGRectGetWidth(self.viewScroll.frame)/2.0;
//    if([self.arrItemLabels count] > 0) {
//        UILabel *lbl = [self.arrItemLabels lastObject];
//        if(pt.x > CGRectGetMaxX(lbl.frame)) {
//            pt.x = CGRectGetMidX(lbl.frame);
//        }
//        
//        lbl = [self.arrItemLabels objectAtIndex:0];
//        if(pt.x < CGRectGetMinX(lbl.frame)) {
//            pt.x = CGRectGetMidX(lbl.frame);
//        }
//    }
//    [self scrollView:self.viewScroll didTapped:pt];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate {
//    BqsLog(@"scrollViewDidEndDragging:willDecelerate:%d",decelerate);
//    if(decelerate) return;
//    
//    [self scrollViewDidEndDecelerating:sv];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)sv {
    BqsLog(@"scrollViewDidEndScrollingAnimation:");
}




@end
