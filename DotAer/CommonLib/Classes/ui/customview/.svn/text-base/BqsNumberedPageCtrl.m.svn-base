//
//  BqsNumberedPageCtrl.m
//  iMobeeNews
//
//  Created by ellison on 11-9-4.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsNumberedPageCtrl.h"

@interface BqsNumberedPageCtrl()
@property (nonatomic, retain) UILabel *lblTxt;
@property (nonatomic, retain) UIImageView *imgvLeft;
@property (nonatomic, retain) UIImageView *imgvRight;
@property (nonatomic, retain) UIButton *btnLeft;
@property (nonatomic, retain) UIButton *btnRight;

-(void)onClickLeft:(id)sender;
-(void)onClickRight:(id)sender;

-(void)updateTxt;
@end

@implementation BqsNumberedPageCtrl
@synthesize callback;

@synthesize currentPage = _curPage;
@synthesize numberOfPages = _numOfPages;
@synthesize txtFont;
@synthesize txtColor;

@synthesize lblTxt;
@synthesize imgvLeft;
@synthesize imgvRight;
@synthesize btnLeft;
@synthesize btnRight;

- (id)initWithFrame:(CGRect)frame LeftArrowImg:(UIImage*)imgLeft RightArrowImg:(UIImage*)imgRight
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    // create sub view
    {
        self.lblTxt = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.lblTxt.textAlignment = UITextAlignmentCenter;
        self.lblTxt.backgroundColor = [UIColor clearColor];
        self.lblTxt.font = [UIFont boldSystemFontOfSize:16];
        self.lblTxt.adjustsFontSizeToFitWidth = NO;
        self.lblTxt.textColor = [UIColor blackColor];
        self.lblTxt.numberOfLines = 1;
        [self addSubview:self.lblTxt];
    }
    {
        self.imgvLeft = [[[UIImageView alloc] initWithImage:imgLeft] autorelease];
        [self addSubview:self.imgvLeft];
        
        self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnLeft.showsTouchWhenHighlighted = YES;
        [self addSubview:self.btnLeft];
        [self.btnLeft addTarget:self action:@selector(onClickLeft:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        self.imgvRight = [[[UIImageView alloc] initWithImage:imgRight] autorelease];
        [self addSubview:self.imgvRight];
        
        self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnRight.showsTouchWhenHighlighted = YES;
        [self addSubview:self.btnRight];
        [self.btnRight addTarget:self action:@selector(onClickRight:) forControlEvents:UIControlEventTouchUpInside];
    }
        
    return self;
}

- (void)dealloc
{
    self.callback = nil;
        
    self.lblTxt = nil;
    self.imgvLeft = nil;
    self.imgvRight = nil;
    self.btnLeft = nil;
    self.btnRight = nil;

    [super dealloc];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rcBounds = self.bounds;
    
    self.imgvLeft.center = CGPointMake(CGRectGetMidX(self.imgvLeft.bounds), CGRectGetMidY(rcBounds));
    self.imgvRight.center = CGPointMake(CGRectGetMaxX(rcBounds) - CGRectGetMidX(self.imgvRight.bounds), CGRectGetMidY(rcBounds));
    self.btnLeft.frame = CGRectMake(0, 0, CGRectGetWidth(self.imgvLeft.frame), CGRectGetHeight(rcBounds));
    self.btnRight.frame = CGRectMake(CGRectGetMaxX(rcBounds) - CGRectGetWidth(self.imgvRight.frame), 0, CGRectGetWidth(self.imgvRight.frame), CGRectGetHeight(rcBounds));
    self.lblTxt.frame = CGRectMake(CGRectGetMaxX(self.imgvLeft.frame), 0, MAX(0.0, CGRectGetMinX(self.imgvRight.frame)-CGRectGetMaxX(self.imgvLeft.frame)), CGRectGetHeight(rcBounds));
}

-(void)sizeToFit {
    CGRect frm = self.frame;
    
    CGSize txtSize = [@"9999/9999" sizeWithFont:self.lblTxt.font];
    
    frm.size.width = CGRectGetWidth(self.imgvLeft.frame) + txtSize.width + CGRectGetWidth(self.imgvRight.frame);
    frm.size.height = MAX(txtSize.height, MAX(CGRectGetHeight(self.imgvLeft.frame), CGRectGetHeight(self.imgvRight.frame)));
    
    self.frame = frm;
}

-(void)setTxtFont:(UIFont *)aTxtFont {
    self.lblTxt.font = aTxtFont;
}
-(UIFont*)txtFont {
    return self.lblTxt.font;
}
-(void)setTxtColor:(UIColor *)aTxtColor {
    self.lblTxt.textColor = aTxtColor;
}
-(UIColor*)txtColor {
    return self.lblTxt.textColor;
}

-(void)setCurrentPage:(NSInteger)aCurrentPage {
    _curPage = aCurrentPage;
    [self updateTxt];
}
-(void)setNumberOfPages:(NSInteger)aNumberOfPages {
    _numOfPages = aNumberOfPages;
    [self updateTxt];
}

-(void)onClickLeft:(id)sender {
    if(_curPage > 0) {
        _curPage --;
        [self updateTxt];
        
        if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNumberedPageCtrl:DidTurnToPage:)]) {
            [self.callback bqsNumberedPageCtrl:self DidTurnToPage:_curPage];
        }
    }
}

-(void)onClickRight:(id)sender {
    if(_curPage < _numOfPages - 1) {
        _curPage ++;
        [self updateTxt];
        
        if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNumberedPageCtrl:DidTurnToPage:)]) {
            [self.callback bqsNumberedPageCtrl:self DidTurnToPage:_curPage];
        }

    }
}

-(void)updateTxt {
    self.lblTxt.text = [NSString stringWithFormat:@"%d/%d", MAX(MIN(_curPage+1, _numOfPages), 0), _numOfPages];
    
    self.btnLeft.showsTouchWhenHighlighted = (_curPage > 0);
    self.btnRight.showsTouchWhenHighlighted = (_curPage < _numOfPages - 1);
}

@end
