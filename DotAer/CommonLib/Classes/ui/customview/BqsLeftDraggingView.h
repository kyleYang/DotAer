//
//  BqsLeftDraggingView.h
//  iMobeeBook
//
//  Created by ellison on 11-7-5.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsLeftDraggingView : UIView {
    CGFloat _dragBeginX;
    CGPoint _touchBeganPoint;
	BOOL _touchDragging;
    UITouch *_dragTouch;
    BOOL _interactionLocked;
}
@property (nonatomic, assign) float bClickTogglePop;
@property (nonatomic, assign) float dragMinX;
@property (nonatomic, assign) float dragMaxX;
@property (nonatomic, assign) id callback;

-(BOOL) isShrinked;
-(void)pop:(BOOL)bAnim;
-(void)shrink:(BOOL)bAnim;
@end


@protocol BqsLeftDraggingView_Callback <NSObject>
@optional
-(void)bqsLeftDraggingViewBeginDrag:(BqsLeftDraggingView*)v;
-(void)bqsLeftDraggingViewDidShrink:(BqsLeftDraggingView*)v;
-(void)bqsLeftDraggingViewDidPop:(BqsLeftDraggingView*)v;

@end
