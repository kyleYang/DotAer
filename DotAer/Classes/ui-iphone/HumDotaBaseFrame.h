//
//  HumDotaBaseFrame.h
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>


enum HumBaseMoveDirect {
    HumMoveDirectUnknow,
    HumMoveDirectLeft,
    HumMoveDirectRight,
    HumMoveDirectUp,
    HumMoveDirectDown,
};
typedef enum HumBaseMoveDirect HumBaseMoveDirect;


@class HumDotaButtomNav;
@protocol HumBaseFrameDelegate;

@interface HumDotaBaseFrame : UIView

@property (nonatomic, assign) id<HumBaseFrameDelegate> delegate;
@property (nonatomic, retain, readonly) HumDotaButtomNav *viewCatSel;
@property (nonatomic, retain, readonly) UIView *viewContent;

@property (nonatomic, retain) UIImageView *ivBg;


@end




@protocol HumBaseFrameDelegate <NSObject>

- (void)humDotaBaseFrame:(HumDotaBaseFrame *)view initDirect:(HumBaseMoveDirect)direct;
- (void)humDotaBaseFrameMoveingDistance:(CGFloat)distance; //moving distance
- (void)humDotaBaseFrameMoveEnd:(HumDotaBaseFrame *)view ; //moveEnd distance


@end
