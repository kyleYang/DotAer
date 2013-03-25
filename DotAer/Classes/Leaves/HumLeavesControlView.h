//
//  HumLeavesControlView.h
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumLeavesControlActionDelegate.h"
#import "HumLeavesControlStyle.h"


@interface HumLeavesControlView : UIView

@property (nonatomic, assign) id<HumLeavesControlActionDelegate> delegate;

@property (nonatomic, retain, readonly) UIView *topControlsView;
@property (nonatomic, retain, readonly) UIView *bottomControlsView;
@property (nonatomic, retain, readonly) UIView *topControlsContainerView;

@property (nonatomic, retain, readonly) UIButton *backControl;
@property (nonatomic, retain, readonly) UIButton *addControl;
@property (nonatomic, retain, readonly) UIButton *cutControl;

@property (nonatomic, assign) HumLeavesControlStyle controlStyle;


@end
