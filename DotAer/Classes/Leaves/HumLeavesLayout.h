//
//  HumLeavesLayout.h
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HumLeavesControlView.h"
#import "HumLeavesControlStyle.h"

@interface HumLeavesLayout : NSObject

@property (nonatomic, assign) HumLeavesControlView *controlsView;
@property (nonatomic, readonly) HumLeavesControlStyle controlStyle;

@property (nonatomic, retain, readonly) UIView *topControlsView;
@property (nonatomic, retain, readonly) UIView *bottomControlsView;
@property (nonatomic, retain, readonly) UIView *topControlsContainerView;

@property (nonatomic, retain, readonly) UIButton *backControl;
@property (nonatomic, retain, readonly) UIButton *addControl;
@property (nonatomic, retain, readonly) UIButton *cutControl;


- (void)updateControlStyle:(HumLeavesControlStyle)controlStyle;

- (void)layoutTopControlsViewWithControlStyle:(HumLeavesControlStyle)controlStyle;
- (void)layoutBottomControlsViewWithControlStyle:(HumLeavesControlStyle)controlStyle;
- (void)layoutControlsWithControlStyle:(HumLeavesControlStyle)controlStyle;

@end
