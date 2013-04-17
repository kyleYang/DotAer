//
//  HumDotaBaseFrame.h
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>


enum HumBasePadMoveDirect {
    HumPadMoveDirectUnknow,
    HumPadMoveDirectLeft,
    HumPadMoveDirectRight,
    HumPadMoveDirectUp,
    HumPadMoveDirectDown,
};
typedef enum HumBasePadMoveDirect HumBasePadMoveDirect;


@class HumDotaPadButtomNav;
@protocol HumBasePadFrameDelegate;

@interface HumDotaPadBaseFrame : UIView

@property (nonatomic, assign) id<HumBasePadFrameDelegate> delegate;
@property (nonatomic, retain, readonly) HumDotaPadButtomNav *viewCatSel;
@property (nonatomic, retain, readonly) UIView *viewContent;

@property (nonatomic, retain) UIImageView *ivBg;


@end




@protocol HumBasePadFrameDelegate <NSObject>

- (void)humDotaBaseFrame:(HumDotaPadBaseFrame *)view initDirect:(HumBasePadMoveDirect)direct;
- (void)humDotaBaseFrameMoveingDistance:(CGFloat)distance; //moving distance
- (void)humDotaBaseFrameMoveEnd:(HumDotaPadBaseFrame *)view ; //moveEnd distance


@end
