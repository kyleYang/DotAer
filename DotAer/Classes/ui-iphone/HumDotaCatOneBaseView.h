//
//  HumDotaCatOneBaseView.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumDotaTopNav.h"
#import "HumDotaCatTitle.h"
#import "HumDotaBaseViewController.h"
#import "HumDotaCateTowBaseView.h"





#define kTopNavHeigh 40


@interface HumDotaCatOneBaseView : UIView


@property (nonatomic, readonly) HumDotaTopNav *topNav;
@property (nonatomic, assign) HumDotaBaseViewController *parCtl;
@property (nonatomic, retain) HumDotaCatTitle *catTitle;
@property (nonatomic, retain) HumDotaCateTowBaseView *contentView;

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)viewWillAppear;
-(void)viewDidAppear;
-(void)viewWillDisappear;
-(void)viewDidDisappear;

@end


