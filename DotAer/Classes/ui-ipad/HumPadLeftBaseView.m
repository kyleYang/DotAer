//
//  HumLeftBaseView.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumPadLeftBaseView.h"
#import "BqsUtils.h"

@interface HumPadLeftBaseView(){
    BOOL _touchActivity;
    CGPoint _beginPoint;
    CGPoint _endPoint;
}

@property (nonatomic, retain) UIView *btnRightMask;

@end

@implementation HumPadLeftBaseView
@synthesize parCtl;
@synthesize btnRightMask;

- (void)dealloc{
    self.parCtl = nil;
    self.btnRightMask = nil;
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.parCtl = ctl;
        
        //rigt btn mask 
        self.btnRightMask = [[[UIView alloc] init] autorelease];
        self.btnRightMask.backgroundColor = [UIColor clearColor];
        [self addSubview:self.btnRightMask];
        
//        if([BqsUtils getOsVer] >= 3.2)
//        {
//            // -----------------------------
//            // One finger, swipe left
//            // -----------------------------
//            UISwipeGestureRecognizer *oneFingerSwipeLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHideLeftView:)] autorelease];
//            [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//            [self addGestureRecognizer:oneFingerSwipeLeft];
//            
//            // -----------------------------
//            // One finger, swipe right
//            // -----------------------------
//            
//            UISwipeGestureRecognizer *oneFingerSwipeRight = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureShowLeftView:)] autorelease];
//            [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//            [self addGestureRecognizer:oneFingerSwipeRight];
//            
//        }

        
    }
    return self;

}

-(void)viewDidAppear{
    
}
-(void)viewDidDisappear{

}

-(void)viewWillAppear{
    
}
-(void)viewWillDisappear{
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.btnRightMask.frame = CGRectMake(CGRectGetMaxX(self.bounds)-kMainLeftViewRightGap, 0, kMainLeftViewRightGap, CGRectGetHeight(self.bounds));

}

#pragma #
#pragma mark Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [event.allTouches anyObject];
    _beginPoint =  [touch locationInView:self];
    
    BqsLog(@"touchesBegan point x:%f y:%f",_beginPoint.x,_beginPoint.y);
    
    _touchActivity = CGRectContainsPoint(self.btnRightMask.frame, _beginPoint);
    if (_touchActivity) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(humLeftBaseView:TouchBegin:)]) {
            [self.delegate humLeftBaseView:self TouchBegin:_beginPoint];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [event.allTouches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    BqsLog(@"touchesMoved point x:%f y:%f",curPoint.x,curPoint.y);
    if (_touchActivity) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(humLeftBaseView:TouchMove:)]) {
            [self.delegate humLeftBaseView:self TouchMove:curPoint];
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [event.allTouches anyObject];
    _endPoint =  [touch locationInView:self];
    BqsLog(@"touchesEnded point x:%f y:%f",_endPoint.x,_endPoint.y);
    if (_touchActivity) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(humLeftBaseView:TouchEnd:)]) {
            [self.delegate humLeftBaseView:self TouchEnd:_endPoint];
        }
    }
    _touchActivity = FALSE;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


#pragma #
#pragma mark HumLeftBaseViewDelegate

- (void)didClickHideLefttView{
    BqsLog(@"didClickHideLefttView");
    if (self.delegate && [self.delegate respondsToSelector:@selector(humLeftBaseView:DidClickGoback:)]) {
        [self.delegate humLeftBaseView:self DidClickGoback:nil];
    }
}



@end
