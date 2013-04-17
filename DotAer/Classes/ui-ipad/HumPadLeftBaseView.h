//
//  HumLeftBaseView.h
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumDotaBaseViewController.h"

#define kMainLeftViewRightGap 60

@protocol HumPadLeftBaseViewDelegate;


@interface HumPadLeftBaseView : UIView

@property (nonatomic, assign) UIViewController *parCtl;
@property (nonatomic, assign) id<HumPadLeftBaseViewDelegate> delegate;

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)viewDidAppear;
-(void)viewDidDisappear;

-(void)viewWillAppear;
-(void)viewWillDisappear;


@end

@protocol HumPadLeftBaseViewDelegate <NSObject>

@optional
-(void)humLeftBaseView:(HumPadLeftBaseView*)v DidClickGoback:(id)sender;

-(void)humLeftBaseView:(HumPadLeftBaseView *)v TouchBegin:(CGPoint)begin;
-(void)humLeftBaseView:(HumPadLeftBaseView *)v TouchMove:(CGPoint)move;
-(void)humLeftBaseView:(HumPadLeftBaseView *)v TouchEnd:(CGPoint)end;

@end
