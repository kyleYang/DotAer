//
//  HumRightBaseView.h
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumDotaBaseViewController.h"

#define kMainRightViewLeftGap 60

@protocol HumRightBaseViewDelegate;

@interface HumRightBaseView : UIView


@property (nonatomic, assign) UIViewController *parCtl;
@property (nonatomic, assign) id<HumRightBaseViewDelegate> delegate;

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)viewDidAppear;
-(void)viewDidDisappear;

-(void)viewWillAppear;
-(void)viewWillDisappear;


@end

@protocol HumRightBaseViewDelegate <NSObject>

@optional
-(void)humRightBaseView:(HumRightBaseView*)v DidClickGoback:(id)sender;

-(void)humRightBaseView:(HumRightBaseView *)v TouchBegin:(CGPoint)begin;
-(void)humRightBaseView:(HumRightBaseView *)v TouchMove:(CGPoint)move;
-(void)humRightBaseView:(HumRightBaseView *)v TouchEnd:(CGPoint)end;

@end

