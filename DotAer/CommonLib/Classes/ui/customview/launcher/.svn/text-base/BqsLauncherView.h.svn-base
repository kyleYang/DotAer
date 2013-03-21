//
//  BqsLauncherItem.h
//  iMobeeNews
//
//  Created by ellison on 11-6-9.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BqsLauncherView_Callback;
@class BqsLauncherButton;

@interface BqsLauncherView : UIView <UIScrollViewDelegate> {
    
    NSInteger _columnCount;
    NSInteger _rowCount;
        
    NSTimer* _editHoldTimer;
    NSTimer* _springLoadTimer;
    
    BqsLauncherButton* _dragButton;
    UITouch* _dragTouch;
    NSInteger _positionOrigin;
    CGPoint _dragOrigin;
    CGPoint _touchOrigin;
    
    BOOL _editing;
    BOOL _springing;
    
    id<BqsLauncherView_Callback> _callback;
    
    float _beginDecelerateX;
}

@property (nonatomic, assign) id<BqsLauncherView_Callback> callback;

@property (nonatomic, assign) CGFloat fPaddingHori;
@property (nonatomic, assign) CGFloat fPaddingVert;
@property (nonatomic, assign) CGFloat fColumnGap;
@property (nonatomic, assign) CGFloat fRowGap;
@property (nonatomic, assign) CGSize szItemSize;

@property (nonatomic) NSInteger columnCount;
@property (nonatomic, readonly) NSInteger rowCount;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic, readonly) int nPageCnt;
@property (nonatomic, readonly) BOOL editing;


- (void)beginEditingAnimate:(BOOL)bAnimate;
- (void)endEditingAnimate:(BOOL)bAnimate;

///**
// * Dims the launcher view except for a transparent circle around the given item. The given text
// * will also be shown center-aligned below or above the circle, as appropriate. The item can be
// * tapped while the overlay is up; tapping anywhere else on the overlay simply dismisses the
// * overlay and does not pass the event through.
// */
//- (void)beginHighlightItem:(BqsLauncherItem*)item withText:(NSString*)text;
//
///**
// * Removes the highlighting overlay introduced by -beginHighlightItem:withText:. This will be done
// * automatically if the user taps anywhere on the overlay except the transparent circle.
// */
//- (void)endHighlightItem:(BqsLauncherItem*)item;

-(BqsLauncherButton*)cachedLauncherButton:(NSString*)identifier;
-(BqsLauncherButton*)buttonOfIndex:(int)idx;
-(void)removeButtonAtIndex:(int)idx;
-(void)reloadData;

-(void)setCurrentPageIndex:(int)pageId Animate:(BOOL)bAni;
@end

@protocol BqsLauncherView_Callback <NSObject>


- (BqsLauncherButton*)bqsLauncherView:(BqsLauncherView*)launcher buttonForItem:(int)itemIdx;
- (int)bqsLauncherViewNumberOfItem:(BqsLauncherView*)launcher;

@optional

- (BOOL)bqsLauncherView:(BqsLauncherView*)launcher canDeleteItem:(int)itemIdx;
- (BOOL)bqsLauncherView:(BqsLauncherView*)launcher canMoveItem:(int)item;
- (void)bqsLauncherView:(BqsLauncherView*)launcher didRemoveItem:(int)item;
- (void)bqsLauncherView:(BqsLauncherView*)launcher didMoveItemFrom:(int)fromPos To:(int)toPos;
- (void)bqsLauncherView:(BqsLauncherView*)launcher didSelectItem:(int)item;
- (void)bqsLauncherViewDidEndDragging:(BqsLauncherView*)launcher;
- (void)bqsLauncherViewDidSwipeRightOnFirstPage:(BqsLauncherView*)launcher;
- (void)bqsLauncherViewDidSwipeLeftOnLastPage:(BqsLauncherView*)launcher;
- (void)bqsLauncherViewWillBeginEditing:(BqsLauncherView*)launcher;
- (void)bqsLauncherViewDidBeginEditing:(BqsLauncherView*)launcher;
- (void)bqsLauncherViewDidEndEditing:(BqsLauncherView*)launcher;

- (void)bqsLauncherView:(BqsLauncherView*)launcher DidTurnToPage:(int)pageId TotalPage:(int)totalPage;

@end

