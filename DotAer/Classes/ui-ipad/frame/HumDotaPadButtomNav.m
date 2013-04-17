//
//  HumDotaButtomNav.m
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadButtomNav.h"
#import "HUmDotaMaco.h"
#import "Env.h"


#define kNameColor_Nor [UIColor colorWithRed:160.0f/255.0f green:160.0f/255.0f blue:160.0f/255.0f alpha:1.0]
#define kNameColor_Hight [UIColor colorWithRed:11.0f/255.0f green:244.0f/255.0f blue:194.0f/255.0f alpha:1.0]


#pragma mark - MptGuideFrameCatSelectView_PopButton
@interface HumDotaPadNavigation_Button : NSObject  //buttom navigation button
{
    BOOL _select;
}

@property (nonatomic, assign) BOOL select;
@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UIImage *imgNor;
@property (nonatomic, retain) UIImage *imgHot;
@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, assign) id callback;
-(void)onClickBtn:(id)sender;
@end

@protocol HumDotaNavigation_Button_Callback  <NSObject> 

@optional
-(void)HumDotaFrameCatSelectView_PopButton:(HumDotaPadNavigation_Button*)obj DidSelectCat:(NSString*)catId;

@end

@implementation HumDotaPadNavigation_Button

@synthesize name;
@synthesize select = _select;
@synthesize catId, catName, btn, callback;
@synthesize imgNor, imgHot;


- (void)dealloc{
    self.name = nil;
    _select = FALSE;
    self.catId = nil;
    self.catName = nil;
    self.btn = nil;
    self.catId = nil;
    self.imgNor = nil;
    self.imgHot = nil;
    [super dealloc];
    
}


-(id)initWithCatId:(NSString*)catid Name:(NSString*)catname NorImg:(NSString*)norImg HotImg:(NSString*)hotImg Callback:(id)cb {
    self = [super init];
    if(nil == self) return nil;
    
    Env *env = [Env sharedEnv];
    
    _select = FALSE;
    self.catId = catid;
    self.catName = catname;
    self.callback = cb;
    
    self.imgNor = [env cacheImage:norImg];
    self.imgHot = [env cacheImage:hotImg];
    if(nil == self.imgHot) self.imgHot = self.imgNor;
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.btn.showsTouchWhenHighlighted = YES;
    self.btn.frame = CGRectMake(0, 0, self.imgNor.size.width, self.imgNor.size.height);
    [self.btn setBackgroundImage:self.imgNor forState:UIControlStateNormal];
    [self.btn setBackgroundImage:self.imgNor forState:UIControlStateHighlighted];
    [self.btn setBackgroundImage:self.imgHot forState:UIControlStateSelected];
    [self.btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.name = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.btn.frame)-17, CGRectGetWidth(self.btn.frame), 15)] autorelease];
    self.name.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    self.name.text = self.catName;
    self.name.backgroundColor = [UIColor clearColor];
    self.name.textAlignment = UITextAlignmentCenter;
    self.name.textColor = kNameColor_Nor;
    self.name.font = [UIFont systemFontOfSize:13.0f];
    [self.btn addSubview:self.name];
    
    
    return self;
}


- (void)setSelect:(BOOL)select
{
    if (_select == select) {
        return;
    }
    _select = select;
    if (select) {
        self.name.textColor = kNameColor_Hight;
        
    }else{
        self.name.textColor = kNameColor_Nor;
    }
    
    self.btn.selected = _select;
}

-(void)touchDown:(id)sender{
    self.name.textColor = kNameColor_Hight;
}

-(void)touchCancel:(id)sender{
    self.name.textColor = kNameColor_Nor;
}


-(void)onClickBtn:(id)sender {
    self.select = TRUE;
    if(nil != self.callback && [self.callback respondsToSelector:@selector(HumDotaFrameCatSelectView_PopButton:DidSelectCat:)]) {
        [self.callback HumDotaFrameCatSelectView_PopButton:self DidSelectCat:self.catId];
    }
}




@end




@interface HumDotaPadButtomNav()


@property (nonatomic, retain) NSMutableArray *arrAllButtons; //MptGuideFrameCatSelectView_PopButton

@end



@implementation HumDotaPadButtomNav

@synthesize arrAllButtons;
@synthesize curCatId = _curCatId;
@synthesize delegate;


-(void)dealloc{
    
    self.arrAllButtons = nil;
    HUMSAFERELEASE(_curCatId);
    self.delegate = nil;
    
    [super dealloc];
}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        Env *env = [Env sharedEnv];
        
        // create subviews
        // background view
        UIImageView *bgv = [[[UIImageView alloc] initWithFrame: self.bounds] autorelease];
        bgv.image = [env cacheImage:@"dota_frame_buttom_bg.jpg"];
        bgv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:bgv];
        
        [self loadButtons];
    
        
    }
    return self;
}


-(void)loadButtons {
    // all buttons
    
    
    
    NSMutableArray *arrCatIds = [NSMutableArray arrayWithCapacity:5];
    
    [arrCatIds addObject:kDotaCat_News];
    [arrCatIds addObject:kDotaCat_Video];
    [arrCatIds addObject:kDotaCat_Photo];
    [arrCatIds addObject:kDotaCat_Strategy];
    [arrCatIds addObject:kDotaCat_Simulator];
    
    
    self.arrAllButtons = [NSMutableArray arrayWithCapacity:[arrCatIds count]];
    
   /* "dota.buttom.nav.news"="新闻";
    "dota.buttom.nav.video"="视频";
    "dota.buttom.nav.photo"="图片";
    "dota.buttom.nav.strategy"="攻略";
    "dota.buttom.nav.simulator"="模拟器";
    */

        
    for(NSString *sCatId in arrCatIds) {
        if([kDotaCat_News isEqualToString:sCatId]) {
            [self.arrAllButtons addObject:[[[HumDotaPadNavigation_Button alloc] initWithCatId:sCatId Name:NSLocalizedString(@"dota.buttom.nav.news",nil) NorImg:@"dota_frame_cat_news_nor.png" HotImg:@"dota_frame_cat_news_hilight.png" Callback:self]autorelease]];
        } else if([kDotaCat_Video isEqualToString:sCatId]) {
            [self.arrAllButtons addObject:[[[HumDotaPadNavigation_Button alloc] initWithCatId:sCatId Name:NSLocalizedString(@"dota.buttom.nav.video",nil) NorImg:@"dota_frame_cat_video_nor.png" HotImg:@"dota_frame_cat_video_hilight.png" Callback:self]autorelease]];
        } else if([kDotaCat_Photo isEqualToString:sCatId]) {
            [self.arrAllButtons addObject:[[[HumDotaPadNavigation_Button alloc] initWithCatId:sCatId Name:NSLocalizedString(@"dota.buttom.nav.photo",nil) NorImg:@"dota_frame_cat_photo_nor.png" HotImg:@"dota_frame_cat_photo_hilight.png" Callback:self]autorelease]];
        } else if([kDotaCat_Strategy isEqualToString:sCatId]) {
            [self.arrAllButtons addObject:[[[HumDotaPadNavigation_Button alloc] initWithCatId:sCatId Name:NSLocalizedString(@"dota.buttom.nav.strategy",nil) NorImg:@"dota_frame_cat_strategy_nor.png" HotImg:@"dota_frame_cat_strategy_hilight.png" Callback:self]autorelease]];
        } else if([kDotaCat_Simulator isEqualToString:sCatId]) {
            [self.arrAllButtons addObject:[[[HumDotaPadNavigation_Button alloc] initWithCatId:sCatId Name:NSLocalizedString(@"dota.buttom.nav.simulator",nil) NorImg:@"dota_frame_cat_simulator_nor.png" HotImg:@"dota_frame_cat_simulator_hilight.png" Callback:self]autorelease]];
        }
    }
    
    
    for (int i= 0; i<self.arrAllButtons.count;i++ ) {
        HumDotaPadNavigation_Button *obj = [self.arrAllButtons objectAtIndex:i];
        CGRect frame = obj.btn.frame;
        obj.btn.frame = CGRectMake(0, i*CGRectGetHeight(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:obj.btn];
    }
    
}


#pragma mark - ifc method
-(void)setCurCatId:(NSString*)curCatId {
    [_curCatId release];
    _curCatId = [curCatId copy];
    
    for (int i= 0; i<self.arrAllButtons.count;i++ ) {
        HumDotaPadNavigation_Button *obj = [self.arrAllButtons objectAtIndex:i];
        obj.select = FALSE;
        if ([obj.catId isEqualToString:curCatId]) {
            obj.select = TRUE;
        }
    }
    
    
}



#pragma mark - MptGuideFrameCatSelectView_PopButton_Callback
-(void)HumDotaFrameCatSelectView_PopButton:(HumDotaPadNavigation_Button*)obj DidSelectCat:(NSString*)catId {
    BqsLog(@"HumDotaFrameCatSelectView_PopButton DidSelectCat = %d", catId);
    
    [_curCatId release];
    _curCatId = [catId copy];
    
    for (HumDotaPadNavigation_Button *bg in self.arrAllButtons) {
        bg.select = FALSE;
    }
    obj.select = TRUE;
    
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(HumDotaButtomNav:DidSelect:)]) {
        [self.delegate HumDotaButtomNav:self DidSelect:_curCatId];
    }
}




@end
