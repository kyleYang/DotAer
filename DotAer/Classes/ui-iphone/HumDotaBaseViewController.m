//
//  HumDotaBaseViewController.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaBaseViewController.h"
#import "HumDotaTopNav.h"
#import "HumDotaButtomNav.h"
#import "BqsUtils.h"
#import "HumDotaBaseFrame.h"
#import "HumDotaCatOneBaseView.h"
#import "HumDotaNewsCateOneView.h"
#import "HumDotaVideoCateOneView.h"
#import "HumDotaImageCateOneView.h"
#import "HumDotaStrategyCateOneView.h"
#import "HumDotaSimuCateOneView.h"
#import "HumLeftBaseView.h"
#import "HumRightBaseView.h"
#import "HumSettingView.h"
#import "HumRightView.h"
#import <QuartzCore/QuartzCore.h>

#import "HumDotaMaco.h"

#define kPanGuestureDistance 60

#define kCatOneMoveGuestureDistance 40

#define kTimeInterval 0.6


@interface HumDotaBaseViewController ()<HumDotaTopNavDelegate,HumDotaButtomNavDelgate,HumLeftBaseViewDelegate,HumRightBaseViewDelegate,DSDetailDelegate,HumBaseFrameDelegate>{
    CGPoint _swipeBeg;
    CGPoint _swipeEnd;
    BOOL _swiped;
    BOOL _animated;
}

@property (nonatomic, retain) HumDotaBaseFrame *frameView;
@property (nonatomic, retain) HumDotaCatOneBaseView *vieCatOne;
@property (nonatomic, retain) HumLeftBaseView *leftView;
@property (nonatomic, retain) HumRightView *rightView;

@property (nonatomic, copy) NSString *curCatId;


@end

@implementation HumDotaBaseViewController


@synthesize frameView;
@synthesize vieCatOne;
@synthesize curCatId;
@synthesize leftView;
@synthesize rightView;
@synthesize managedObjectContext = _managedObjectContext;

- (void)dealloc{
    self.frameView = nil;
    self.curCatId = nil;
    self.vieCatOne = nil;
    self.leftView = nil;
    self.rightView = nil;
    [_managedObjectContext release]; _managedObjectContext = nil;
    [super dealloc];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    
    self.frameView = [[[HumDotaBaseFrame alloc] initWithFrame: self.view.bounds] autorelease];
    self.frameView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.frameView.viewCatSel.delegate = self;
    self.frameView.delegate = self;
    
    [self.view addSubview:self.frameView];
    
    
    
    self.frameView.viewCatSel.curCatId = kDotaCat_News;
    [self HumDotaButtomNav:self.frameView.viewCatSel DidSelect:kDotaCat_News];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma -
#pragma mark HumDotaButtomNavDelgate
-(void)HumDotaButtomNav:(HumDotaButtomNav *)view DidSelect:(NSString *)catId {
     BqsLog(@"HumDotaButtomNav DidSelect category = %@",catId);
    
    if([catId isEqualToString:self.curCatId]) {
        BqsLog(@"Already select idx: %@", catId);
        return;
    }
    self.curCatId = catId;
    
    [self.vieCatOne viewWillDisappear];
    
    
    HumDotaCatOneBaseView *av = nil;
    CGRect frm = self.frameView.viewContent.bounds;
    
    if([kDotaCat_News isEqualToString:self.curCatId]) {
        av = [[[HumDotaNewsCateOneView alloc] initWithDotaCatFrameViewCtl:self Frame:frm] autorelease];
    }else if([kDotaCat_Video isEqualToString:self.curCatId]){
        av = [[[HumDotaVideoCateOneView alloc] initWithDotaCatFrameViewCtl:self Frame:frm] autorelease];
    }else if([kDotaCat_Photo isEqualToString:self.curCatId]){
        av = [[[HumDotaImageCateOneView alloc] initWithDotaCatFrameViewCtl:self Frame:frm] autorelease];
    }else if([kDotaCat_Strategy isEqualToString:self.curCatId]){
        av = [[[HumDotaStrategyCateOneView alloc] initWithDotaCatFrameViewCtl:self Frame:frm] autorelease];
    }else if([kDotaCat_Simulator isEqualToString:self.curCatId]){
        av = [[[HumDotaSimuCateOneView alloc] initWithDotaCatFrameViewCtl:self Frame:frm managedObjectContext:self.managedObjectContext] autorelease];
    }else{
        BqsLog(@"Unknow category one name");
    }
    av.topNav.delegate = self;
    av.frame = frm;
    av.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.frameView.viewContent addSubview:av];
    
    [av viewWillAppear];
    
    [av viewDidAppear];
    
    [self.vieCatOne viewDidDisappear];
    [self.vieCatOne removeFromSuperview];
    
    self.vieCatOne = av;
    
    [self.frameView.viewContent setNeedsLayout];
}




#pragma -
#pragma mark HumDotaTopNavDelegate

- (void)HumDotaTopNav:(HumDotaTopNav *)topNav didClickLeft:(id)sender{
    BqsLog(@"HumDotaTopNav didClickLeft");
    
    if(nil == self.leftView) {
        self.leftView = [[[HumSettingView alloc] initWithDotaCatFrameViewCtl:self Frame:self.view.bounds] autorelease];
        self.leftView.delegate = self;
        [self.view insertSubview:self.leftView belowSubview:self.frameView];
    }
    
    CGFloat time = (CGRectGetWidth(self.frameView.bounds)- kMainLeftViewRightGap-CGRectGetMinX(self.frameView.frame))*kTimeInterval/(CGRectGetMaxX(self.frameView.bounds) - kMainLeftViewRightGap);
    
    [self.leftView viewWillAppear];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
         self.leftView.layer.shouldRasterize = YES;
        _animated = YES;
        [UIView animateWithDuration:time animations:^{
            
            self.frameView.center = CGPointMake(CGRectGetMaxX(self.view.bounds) + CGRectGetMidX(self.vieCatOne.bounds) - kMainLeftViewRightGap, CGRectGetMidY(self.view.bounds));
        } completion:^(BOOL finished) {
            _animated = NO;
            [self.leftView viewDidAppear];
            self.leftView.layer.shouldRasterize = NO;
            self.leftView.userInteractionEnabled = YES;
            self.frameView.userInteractionEnabled = NO;
            
        }];
    }
                   );
    
}

- (void)HumDotaTopNav:(HumDotaTopNav *)topNav didClickRight:(id)sender{
    BqsLog(@"HumDotaTopNav didClickRight");
    
    
    if(nil == self.rightView) {
        self.rightView = [[[HumRightView alloc] initWithDotaCatFrameViewCtl:self Frame:self.view.bounds managedObjectContext:_managedObjectContext] autorelease];
        self.rightView.delegate = self;
        self.rightView.dsDelegate = self;
        [self.view insertSubview:self.rightView belowSubview:self.frameView];
    }
    
    CGFloat time = (CGRectGetMaxX(self.frameView.bounds)-kMainRightViewLeftGap+CGRectGetMinX(self.frameView.frame))*kTimeInterval/(CGRectGetMaxX(self.frameView.bounds) - kMainRightViewLeftGap);
    [self.rightView viewWillAppear];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.rightView.layer.shouldRasterize = YES;
        _animated = YES;
        [UIView animateWithDuration:time animations:^{
            
            self.frameView.center = CGPointMake(- CGRectGetMidX(self.vieCatOne.bounds) + kMainRightViewLeftGap, CGRectGetMidY(self.view.bounds));
        } completion:^(BOOL finished) {
            _animated = NO;
            [self.rightView viewDidAppear];
            self.rightView.layer.shouldRasterize = NO;
            self.rightView.userInteractionEnabled = YES;
            self.frameView.userInteractionEnabled = NO;
            
        }];
    }
                   );
    
}

#pragma #
#pragma mark HumLeftBaseViewDelegate
-(void)humLeftBaseView:(HumLeftBaseView*)v DidClickGoback:(id)sender{
    BqsLog(@"humLeftBaseView DidClickGoback");
    
    CGFloat time = (CGRectGetMinX(self.frameView.frame))*kTimeInterval/(CGRectGetMaxX(self.frameView.bounds) - kMainLeftViewRightGap);

    dispatch_async(dispatch_get_main_queue(), ^{
        self.leftView.layer.shouldRasterize = YES;
        _animated = YES;
        [UIView animateWithDuration:time animations:^{
            
            self.frameView.center = CGPointMake(CGRectGetMidX(self.vieCatOne.bounds), CGRectGetMidY(self.view.bounds));
        } completion:^(BOOL finished) {
            
            _animated = NO;
            [self.leftView viewDidDisappear];
            self.frameView.userInteractionEnabled = YES;
            self.leftView.layer.shouldRasterize = NO;
            [self.leftView removeFromSuperview];
            self.leftView = nil;
            
        }];
    }
                   );
}



- (void)humLeftBaseView:(HumLeftBaseView *)v TouchBegin:(CGPoint)begin{
    BqsLog(@"humLeftBaseView TouchBegin point x:%f y:%f",begin.x,begin.y);
    _swipeBeg = begin;
    _swiped = FALSE;
        
}

- (void)humLeftBaseView:(HumLeftBaseView *)v TouchMove:(CGPoint)move{
    BqsLog(@"humLeftBaseView TouchMove point x:%f y:%f",move.x,move.y);
    
    _swiped = YES;
    
    CGFloat distance = move.x - _swipeBeg.x;
    
    CGRect frame = self.frameView.frame;
    CGFloat newX = CGRectGetWidth(self.view.bounds) - kMainLeftViewRightGap + distance;
    frame.origin.x = newX>0?newX:0;
    
    self.frameView.frame = frame;
    
    
}

- (void)humLeftBaseView:(HumLeftBaseView *)v TouchEnd:(CGPoint)end{
    BqsLog(@"humLeftBaseView TouchEnd point x:%f y:%f",end.x,end.y);
    _swipeEnd = end;
    CGFloat absolateX = -1;
    DISTANCE_X(_swipeBeg, _swipeEnd, absolateX);
    absolateX = absolateX>0?absolateX:-absolateX;
    BqsLog(@"humLeftBaseView TouchEnd Distance : %f",absolateX);
    
    if (!_swiped) {
         [self humLeftBaseView:nil DidClickGoback:nil];
        
    } else if (absolateX<kPanGuestureDistance) {
        BqsLog(@"humLeftBaseView TouchEnd touch");
        [self HumDotaTopNav:nil didClickLeft:nil];
       
    }else{
        [self humLeftBaseView:nil DidClickGoback:nil];
    }
    
}


#pragma #
#pragma mark HumRightBaseViewDelegate
-(void)humRightBaseView:(HumLeftBaseView*)v DidClickGoback:(id)sender{
    BqsLog(@"humLeftBaseView DidClickGoback");
    
    CGFloat time = (-CGRectGetMinX(self.frameView.frame))*kTimeInterval/(CGRectGetMaxX(self.frameView.bounds) - kMainRightViewLeftGap);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rightView.layer.shouldRasterize = YES;
        _animated = YES;
        [UIView animateWithDuration:time animations:^{
            
            self.frameView.center = CGPointMake(CGRectGetMidX(self.vieCatOne.bounds), CGRectGetMidY(self.view.bounds));
        } completion:^(BOOL finished) {
            
            _animated = NO;
            
            self.frameView.userInteractionEnabled = YES;
            self.rightView.layer.shouldRasterize = NO;
            
        }];
    }
                   );
}



- (void)humRightBaseView:(HumLeftBaseView *)v TouchBegin:(CGPoint)begin{
    BqsLog(@"humLeftBaseView TouchBegin point x:%f y:%f",begin.x,begin.y);
    _swipeBeg = begin;
    _swiped = FALSE;
    
}

- (void)humRightBaseView:(HumLeftBaseView *)v TouchMove:(CGPoint)move{
    BqsLog(@"humLeftBaseView TouchMove point x:%f y:%f",move.x,move.y);
    
    _swiped = YES;
    
    CGFloat distance = move.x - _swipeBeg.x;
    
    CGRect frame = self.frameView.frame;
    CGFloat newX = -CGRectGetWidth(self.view.bounds) + kMainRightViewLeftGap + distance;
    frame.origin.x = newX<0?newX:0;
    
    self.frameView.frame = frame;
    
    
}

- (void)humRightBaseView:(HumLeftBaseView *)v TouchEnd:(CGPoint)end{
    BqsLog(@"humLeftBaseView TouchEnd point x:%f y:%f",end.x,end.y);
    _swipeEnd = end;
    CGFloat absolateX = -1;
    DISTANCE_X(_swipeBeg, _swipeEnd, absolateX);
    absolateX = absolateX>0?absolateX:-absolateX;
    BqsLog(@"humLeftBaseView TouchEnd Distance : %f",absolateX);
    
    if (!_swiped) {
        [self humRightBaseView:nil DidClickGoback:nil];
        
    } else if (absolateX<kPanGuestureDistance) {
        BqsLog(@"humLeftBaseView TouchEnd touch");
        [self HumDotaTopNav:nil didClickRight:nil];
        
    }else{
        [self humRightBaseView:nil DidClickGoback:nil];
    }
    
}


#pragma #
#pragma mark HumBaseFrameDelegate


-(void)humDotaBaseFrame:(HumDotaBaseFrame *)view initDirect:(HumBaseMoveDirect)direct{
    BqsLog(@"humDotaCateOne initDirect :%d",direct);
    if (direct == HumMoveDirectRight) { //frame move to right, leftview appear
        if(nil == self.leftView) { //add leftview
            self.leftView = [[[HumSettingView alloc] initWithDotaCatFrameViewCtl:self Frame:self.view.bounds] autorelease];
            self.leftView.delegate = self;
            self.leftView.userInteractionEnabled = NO; //first can not touch
            [self.view insertSubview:self.leftView belowSubview:self.frameView];
            [self.leftView viewDidAppear];
        }
        if (nil != self.rightView) {  //remove right view
            [self.rightView viewDidDisappear];
            [self.rightView removeFromSuperview];
            self.rightView = nil;
        }
    }else if(direct == HumMoveDirectLeft){
        if (nil != self.leftView) {  //remove left view
            [self.leftView viewDidDisappear];
            [self.leftView removeFromSuperview];
            self.leftView = nil;

        }
        if(nil == self.rightView) { //add rightview
            self.rightView = [[[HumRightView alloc] initWithDotaCatFrameViewCtl:self Frame:self.view.bounds] autorelease];
            self.rightView.delegate = self;
            self.rightView.userInteractionEnabled = NO;
            [self.view insertSubview:self.rightView belowSubview:self.frameView];
            [self.rightView viewDidAppear];
        }

    }
}


-(void)humDotaBaseFrameMoveingDistance:(CGFloat)distance{
    BqsLog(@"humDotaCateOneMoveingDistance distance : %f",distance);
    
    if (_animated) {
        return;
    }
    
    CGRect frame = self.frameView.frame;
    frame.origin.x = frame.origin.x+distance;
    self.frameView.frame = frame;
    
}

- (void)humDotaBaseFrameMoveEnd:(HumDotaBaseFrame *)view {
   
    if (_animated) {
        return;
    }
    CGFloat distance = CGRectGetMinX(view.frame);
    if (distance > kCatOneMoveGuestureDistance) {
        [self HumDotaTopNav:nil didClickLeft:nil];
    }else if(distance < -kCatOneMoveGuestureDistance){
        [self HumDotaTopNav:nil didClickRight:nil];
    }else{
        [self humLeftBaseView:nil DidClickGoback:nil];
    }
    
}


#define mark
#define makr DSDetailDelegate

- (void)didSelectHero:(HeroInfo *)hero{
    BqsLog(@"didSelectHero heroName = %@",hero.heroName);
    [self.vieCatOne didSelectHero:hero];
    
}
- (void)didSelectEquip:(Equipment *)equip{
    BqsLog(@"didSelectEquip heroName = %@",equip.equipName);
    [self.vieCatOne didSelectEquip:equip];

}



#pragma mark
#pragma mark IOS 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;  // 可以修改为任何方向
}

-(BOOL)shouldAutorotate{
    
    return NO;
}



@end
