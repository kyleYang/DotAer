//
//  HumDotaBaseFrame.m
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaBaseFrame.h"
#import "HumDotaButtomNav.h"
#import "Env.h"
#import "BqsUtils.h"

#define kBottomNavigation_Heigh 50

#define kInitGap 0
#define kTouchUpDown 10

@interface HumDotaBaseFrame(){
    CGPoint _beginPoint;
    CGPoint _endPoint;
    CGFloat _distance;
    BOOL _didMoved;
    HumBaseMoveDirect _direct;

}
@property (nonatomic, retain, readwrite) HumDotaButtomNav *viewCatSel;
@property (nonatomic, retain, readwrite) UIView *viewContent;


@end



@implementation HumDotaBaseFrame
@synthesize viewCatSel;
@synthesize viewContent;
@synthesize ivBg;
@synthesize delegate;

-(void)dealloc{
    self.viewCatSel = nil;
    self.viewContent = nil;
    self.ivBg = nil;
    self.delegate = nil;
    [super dealloc];
}





- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        Env *env = [Env sharedEnv];
        
        //background view
        self.ivBg = [[[UIImageView alloc] initWithImage:[env cacheImage:@"dota_table_bg.png"]] autorelease];
        self.ivBg.frame = self.bounds;
        self.ivBg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.ivBg];
        
        
        // content view
        self.viewContent = [[[UIView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)+20-kBottomNavigation_Heigh)] autorelease];
        self.viewContent.backgroundColor = [UIColor clearColor];
        self.viewContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.viewContent];
        

        //buttom category select view
        self.viewCatSel = [[[HumDotaButtomNav alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-kBottomNavigation_Heigh+20, CGRectGetWidth(self.bounds), kBottomNavigation_Heigh)] autorelease];
        self.viewCatSel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.viewCatSel];
        
        _direct = HumMoveDirectUnknow;
        _didMoved = FALSE;


    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma #
#pragma mark Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [event.allTouches anyObject];
    _beginPoint =  [touch locationInView:self];
    _distance = 0;
    _direct = HumMoveDirectUnknow;
    BqsLog(@"HumDotaBaseFrameView TouchesBegan point x:%f y:%f",_beginPoint.x,_beginPoint.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [event.allTouches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    BqsLog(@"HumDotaBaseFrameView touchesMoved point x:%f y:%f",curPoint.x,curPoint.y);
    CGFloat distance = curPoint.x - _beginPoint.x;
    CGFloat distanceY = curPoint.y - _beginPoint.y;
    
    if ((distanceY > kTouchUpDown || distanceY< - kTouchUpDown) && !_didMoved) {
        return;
    }
    
    HumBaseMoveDirect curDirect = HumMoveDirectUnknow;
    CGFloat orgX = CGRectGetMinX(self.frame);
    if (orgX>kInitGap) {
        curDirect = HumMoveDirectRight;
    }else if(orgX < -kInitGap){
        curDirect = HumMoveDirectLeft;
    }
    
    if (curDirect != _direct) {
        _direct = curDirect;
        _distance = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(humDotaBaseFrame:initDirect:)]) {
            [self.delegate humDotaBaseFrame:self initDirect:_direct];
        }
        
    }
    _distance = distance;
    if (self.delegate && [self.delegate respondsToSelector:@selector(humDotaBaseFrameMoveingDistance:)]) {
            _didMoved = TRUE;
//            [self.delegate humDotaBaseFrameMoveingDistance:distance];
    }
        
    

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [event.allTouches anyObject];
    _endPoint =  [touch locationInView:self];
    _direct = HumMoveDirectUnknow;
    
        
    if (!_didMoved) {
        return;
    }
    _didMoved = FALSE;
    BqsLog(@"HumDotaBaseFrameView touchesEnded point x:%f y:%f distance:%f",_endPoint.x,_endPoint.y,_endPoint.x - _beginPoint.x);
    if (self.delegate && [self.delegate respondsToSelector:@selector(humDotaBaseFrameMoveEnd:)]) {
//        [self.delegate humDotaBaseFrameMoveEnd:self];
    }
}




@end
