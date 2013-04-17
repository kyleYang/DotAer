//
//  HumLeavesDelegate.h
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMLeavesView.h"
#import "HMLeavesPadView.h"


@class HMLeavesView;

@protocol HumLeavesDelegate <NSObject>

@optional

- (void)humLeavesBack:(HMLeavesView *)leaves;

- (void)humLeavesPadBack:(HMLeavesPadView *)leaves;

@end

