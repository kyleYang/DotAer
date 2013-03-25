//
//  HumLeavesControlActionDelegate.h
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHumFadeDuration                     0.33
#define kHumControlVisibilityDuration        5.


typedef enum {
    HumLeavesControlActionBack,
    HumLeavesControlActionFontAdd,
    HumLeavesControlActionFontCut,
    HumLeavesControlActionWillShowControls,
    HumLeavesControlActionDidShowControls,
    HumLeavesControlActionWillHideControls,
    HumLeavesControlActionDidHideControls,

} HumLeavesControlAction;




@protocol HumLeavesControlActionDelegate <NSObject>

- (void)humLeavesControl:(id)control didPerformAction:(HumLeavesControlAction)action;

@end

