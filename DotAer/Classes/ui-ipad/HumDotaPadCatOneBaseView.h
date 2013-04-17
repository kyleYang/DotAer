//
//  HumDotaCatOneBaseView.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumDotaPadTopNav.h"
#import "HumDotaCatTitle.h"
#import "HumPadDotaBaseViewController.h"
#import "HumDotaPadCateTowBaseView.h"
#import "HeroInfo.h"
#import "Equipment.h"





#define kTopNavHeigh 40


@interface HumDotaPadCatOneBaseView : UIView


@property (nonatomic, readonly) HumDotaPadTopNav *topNav;
@property (nonatomic, assign) HumPadDotaBaseViewController *parCtl;
@property (nonatomic, retain) HumDotaCatTitle *catTitle;
@property (nonatomic, retain) HumDotaPadCateTowBaseView *contentView;

-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)viewWillAppear;
-(void)viewDidAppear;
-(void)viewWillDisappear;
-(void)viewDidDisappear;

-(void)didSelectHero:(HeroInfo *)hero;
-(void)didSelectEquip:(Equipment *)equip;

@end


