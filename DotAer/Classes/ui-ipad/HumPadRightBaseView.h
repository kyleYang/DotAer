//
//  HumRightBaseView.h
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumPadDotaBaseViewController.h"

#define kMainRightViewLeftGap 60

@protocol HumPadRightBaseViewDelegate;

@interface HumPadRightBaseView : UIView

@property (nonatomic, retain) UIView *btnRightMask;
@property (nonatomic, assign) UIViewController *parCtl;
@property (nonatomic, assign) id<HumPadRightBaseViewDelegate> delegate;

-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)viewDidAppear;
-(void)viewDidDisappear;

-(void)viewWillAppear;
-(void)viewWillDisappear;


@end

@protocol HumPadRightBaseViewDelegate <NSObject>

@optional
-(void)humRightBaseView:(HumPadRightBaseView*)v DidClickGoback:(id)sender;

-(void)humRightBaseView:(HumPadRightBaseView *)v TouchBegin:(CGPoint)begin;
-(void)humRightBaseView:(HumPadRightBaseView *)v TouchMove:(CGPoint)move;
-(void)humRightBaseView:(HumPadRightBaseView *)v TouchEnd:(CGPoint)end;

@end

