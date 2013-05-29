//
//  HumDotaCatTwoSelView.m
//  DotAer
//
//  Created by Kyle on 13-1-24.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCatTwoSelView.h"
#import "BqsTouchScrollView.h"
#import "Env.h"
#import "HumDotaMaco.h"
#import "HMCateOnePopView.h"
#import "MptCatScrollView.h"

#define kIndicateWidth 10
#define kCatOneBtnWidth 80

#define NUMBER_OF_NO_HIDDEN_VISIBLE_ITEMS 3
#define NUMBER_OF_HIDDEN_VISIBLE_ITEMS 3


#define ITEM_SPACING 90.0f
#define INCLUDE_PLACEHOLDERS YES

@interface HumDotaCatTwoItem : UIView

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *itemTxt;
@property (nonatomic, assign) BOOL seleted;


@end


@implementation HumDotaCatTwoItem
@synthesize bgImg;
@synthesize itemTxt;
@synthesize seleted = _seleted;


- (void)dealloc{
    self.bgImg = nil;
    self.itemTxt = nil;
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _seleted = FALSE;
        
        Env *env = [Env sharedEnv];
        
        self.bgImg = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        self.bgImg.image = [env cacheImage:@""];
        self.bgImg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.bgImg];
        
        self.itemTxt = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
        self.itemTxt.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.itemTxt.backgroundColor = [UIColor clearColor];
        self.itemTxt.font = [UIFont systemFontOfSize:12.0f];
        self.itemTxt.textAlignment = UITextAlignmentCenter;
        self.itemTxt.shadowColor = RGBA(0, 0, 0, .6);
        self.itemTxt.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [self addSubview:self.itemTxt];

    }

    return self;
    
}

- (void)setSeleted:(BOOL)value{
    if (_seleted == value) {
        return;
    }
    
    _seleted = value;
    
    if (_seleted) {
        self.bgImg.image = [[Env sharedEnv] cacheImage:@""];
    }else{
        self.bgImg.image = [[Env sharedEnv] cacheImage:@""];
    }
    
}



@end



@interface HumDotaCatTwoSelView() <MptCatScrollViewDelegate,HMCateOnePopViewDelegate>{
    int _onViewNum;
}


@property (nonatomic, retain) MptCatScrollView *viewScroll;
@property (nonatomic, retain) NSMutableArray *arrItemLabels; // UILabel

@property (nonatomic, retain) NSArray *arrItems;// category under big category
@property (nonatomic, retain) NSArray *arrCategory;//big category
@property (nonatomic, retain) NSArray *arrAll;//all category under category

@property (nonatomic, retain) UIButton *cateOneBtn; //category one button
@property (nonatomic, retain) UILabel *cateOneLab;
@property (nonatomic, retain) UIImageView *cateOneImg;

@end


@implementation HumDotaCatTwoSelView
@synthesize delegate;
@synthesize arrItems = _arrItems;
@synthesize arrCategory = _arrCategory;
@synthesize arrAll = _arrAll;
@synthesize itemSelectedId = _itemSelectedId;
@synthesize catSelectedId = _catSelectedId;
@synthesize viewScroll;
@synthesize arrItemLabels;
@synthesize cateOneBtn,cateOneLab,cateOneImg;


- (void)dealloc{
    self.delegate = nil;
    self.viewScroll = nil;
    HUMSAFERELEASE(_arrItems);
    HUMSAFERELEASE(_arrCategory);
    HUMSAFERELEASE(_arrAll);
    self.cateOneBtn = nil;
    self.cateOneLab = nil;
    self.cateOneImg = nil;
    
    self.arrItemLabels = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = [UIColor clearColor];
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.image = [[Env sharedEnv] cacheImage:@"dota_title_scr_bg.png"];
        [self addSubview:bg];
        [bg release];

        //category one button
        self.cateOneBtn = [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-kCatOneBtnWidth-3, 7, kCatOneBtnWidth, CGRectGetHeight(self.bounds)-13)] autorelease];
        [self.cateOneBtn addTarget:self action:@selector(cateOneSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.cateOneBtn setBackgroundImage:[[Env sharedEnv] cacheImage:@"dota_title_cat_one.png"] forState:UIControlStateNormal];
//        [self.cateOneBtn setBackgroundImage:[[Env sharedEnv] cacheImage:@"dota_title_cat_one.png"] forState:UIControlStateNormal];
        self.cateOneBtn.backgroundColor = [UIColor yellowColor];
//        self.cateOneBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.cateOneBtn.hidden = YES; //default is hidden,have no category one view
        [self addSubview:self.cateOneBtn];
        
        self.cateOneLab = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, CGRectGetHeight(self.cateOneBtn.bounds))] autorelease];
//        self.cateOneLab.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.cateOneLab.backgroundColor = [UIColor clearColor];
        self.cateOneLab.textAlignment = UITextAlignmentLeft;
        self.cateOneLab.textColor = [UIColor whiteColor];
        self.cateOneLab.font = [UIFont systemFontOfSize:13.0f];
        [self.cateOneBtn addSubview:self.cateOneLab];
        
            
        self.viewScroll = [[[MptCatScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))] autorelease];
        self.viewScroll.backgroundColor = [UIColor clearColor];
        self.viewScroll.normalColor = [UIColor grayColor];
        self.viewScroll.hilightColor = [UIColor whiteColor];
        self.viewScroll.delegate = self;
        [self addSubview:self.viewScroll];
        
    }
    return self;
}



#pragma mark
#pragma mark property setting

- (void)setCateTwoCurSelectIndex:(NSUInteger)index{
    [self.viewScroll setSelectedIndex:index];
}

- (void)humDotaCateTwoSetCatArr:(NSArray *)arrCat{
    self.viewScroll.arrItems = arrCat;
}

-(void)humDotaCateOneSetCatArr:(NSArray *)arrCat{
   
    
    [_arrCategory release]; _arrCategory= nil;
    _arrCategory = [arrCat retain];
    
     _catSelectedId = 0;
    
    if (!arrCat || [arrCat count] ==0 || [arrCat count] == 1) {
        BqsLog(@"_arrCategory nil or _arrCategory count :0");
        
        self.cateOneBtn.hidden = YES;
       
        CGRect frame = self.viewScroll.frame;
        frame.size.width = CGRectGetWidth(self.bounds);
        self.viewScroll.frame = frame;
        
              
    }else{
        
        self.cateOneBtn.hidden = NO;
        
        
        CGRect frame = self.viewScroll.frame;
        frame.size.width = CGRectGetWidth(self.frame)-CGRectGetWidth(self.cateOneBtn.frame);
        self.viewScroll.frame = frame;
        
        
        self.cateOneLab.text = [_arrCategory objectAtIndex:_catSelectedId];
        
    }
 
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(humDotaCatTwoSelectView:DidSelectCatOne:)]) {
        BqsLog(@"scrollView didTapped catone : %d,cattwo:%d ",_catSelectedId,_itemSelectedId);
        [self.delegate humDotaCatTwoSelectView:self DidSelectCatOne:_catSelectedId];
    }
    
}

#pragma mark 
#pragma mark private method
- (void)cateOneSelect:(id)sender{
    
    UIWindow *window = nil ;//= [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];
    
    CGPoint popPoint = CGPointMake(CGRectGetMidX(self.cateOneBtn.frame), CGRectGetMaxY(self.cateOneBtn.frame)+20);

    HMCateOnePopView *popView = [[HMCateOnePopView alloc] initWithFrame:topView.bounds withArray:_arrCategory popAt:popPoint];
    [popView popViewAnimation];
    popView.delegate = self;
    [topView addSubview:popView];
    [popView release];
    
}






#pragma mark -
#pragma mark MptCatScrollViewDelegate

- (void)catScrollView:(MptCatScrollView *)scrollView didSelect:(NSInteger)index{
    
    _oldItemSelectedid = _itemSelectedId;
    _itemSelectedId = index;

    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(humDotaCatTwoSelectView:DidSelectCatTwo:)]) {
        BqsLog(@"scrollView didTapped catone : %d,cattwo:%d ",_catSelectedId,_itemSelectedId);
        [self.delegate humDotaCatTwoSelectView:self DidSelectCatTwo:_itemSelectedId];
    }
    
}


#pragma mark
#pragma mark HMCateOnePopViewDelegate
- (void)hmCateOnePopView:(HMCateOnePopView *)popView didSelectAt:(NSIndexPath *)index{
    if (_catSelectedId == index.row) {
        BqsLog(@"hmCateOneSelect _catSelectedId == index.row :%d",_catSelectedId);
    }
    _catSelectedId = index.row;
    
    self.cateOneLab.text = [_arrCategory objectAtIndex:_catSelectedId];
    
       
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(humDotaCatTwoSelectView:DidSelectCatOne:)]) {
        BqsLog(@"scrollView didTapped catone : %d,cattwo:%d ",_catSelectedId,_itemSelectedId);
        [self.delegate humDotaCatTwoSelectView:self DidSelectCatOne:_catSelectedId];
    }
    
}


@end
