//
//  ImageViewController.h
//  CoreTextDemo
//
//  Created by xuejun cai on 12-7-24.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHumFadeDuration                     0.33
#define kHumControlVisibilityDuration        5.


@protocol HumLeavesControlActionDelegate;

typedef enum {
    HMImageControlActionBack,
    HMImageControlActionWillShowControls,
    HMImagesControlActionDidShowControls,
    HMImageControlActionWillHideControls,
    HMImageControlActionDidHideControls,
    
} HMImageControlAction;

@interface HMImageControllerView : UIView

@property (nonatomic, assign) id<HumLeavesControlActionDelegate> delegate;

@property (nonatomic, retain, readonly) UIView *topControlsView;

@property (nonatomic, retain, readonly) UIButton *backControl;


@end



@protocol HumLeavesControlActionDelegate <NSObject>

- (void)humLeavesControl:(HMImageControllerView *)control didPerformAction:(HMImageControlAction)action;

@end

