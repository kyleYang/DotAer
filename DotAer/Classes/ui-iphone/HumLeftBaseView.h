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

@protocol HumLeftBaseViewDelegate;


@interface HumLeftBaseView : UIView

@property (nonatomic, assign) UIViewController *parCtl;
@property (nonatomic, assign) id<HumLeftBaseViewDelegate> delegate;

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)viewDidAppear;
-(void)viewDidDisappear;

-(void)viewWillAppear;
-(void)viewWillDisappear;


@end

@protocol HumLeftBaseViewDelegate <NSObject>

@optional
-(void)humLeftBaseView:(HumLeftBaseView*)v DidClickGoback:(id)sender;

-(void)humLeftBaseView:(HumLeftBaseView *)v TouchBegin:(CGPoint)begin;
-(void)humLeftBaseView:(HumLeftBaseView *)v TouchMove:(CGPoint)move;
-(void)humLeftBaseView:(HumLeftBaseView *)v TouchEnd:(CGPoint)end;

@end
