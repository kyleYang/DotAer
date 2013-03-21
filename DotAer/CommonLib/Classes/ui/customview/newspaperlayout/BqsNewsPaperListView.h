//
//  BqsNewsPaperListView.h
//  iMobeeNews
//
//  Created by ellison on 11-9-1.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BqsNewsPaperPageLayout.h"
#import "BqsNewsPaperItemView.h"

@protocol BqsNewsPaperListView_Callback;

@interface BqsNewsPaperListView : UIView {
    float _beginDecelerateX;
}

@property (nonatomic, assign) id<BqsNewsPaperListView_Callback> callback;
@property (nonatomic, assign, readonly) int curPageId;
@property (nonatomic, assign, readonly) int totalPage;
@property (nonatomic, assign, readonly) int totalItemCnt;

@property (nonatomic, assign) BOOL fPaddingHor;
@property (nonatomic, assign) BOOL fPaddingVer;
@property (nonatomic, assign) BOOL fGap;
@property (nonatomic, assign) BOOL bDrawGapLine;
@property (nonatomic, assign) float fGapLineWidth;
@property (nonatomic, retain) UIColor *gapLineColor;

-(void)showPage:(int)pageId Animate:(BOOL)bAni;
-(void)reloadData;
-(void)reloadData:(int)pageIdx;

-(BqsNewsPaperItemView*)viewOfIndex:(int)idx;

-(BqsNewsPaperItemView*)cachedItemView:(NSString*)identifier;

@end

@protocol BqsNewsPaperListView_Callback <NSObject>
-(BqsNewsPaperPageLayout*)bqsNewsPaperListViewGetPageLayout:(BqsNewsPaperListView*)view;
-(BqsNewsPaperItemView*)bqsNewsPaperListView:(BqsNewsPaperListView*)view GetViewForItem:(int)itemId;

@optional
-(void)bqsNewsPaperListView:(BqsNewsPaperListView*)view DidTurnToPage:(int)pageId;
-(void)bqsNewsPaperListView:(BqsNewsPaperListView*)view DidSelectItem:(int)itemId;
-(void)bqsNewsPaperListView:(BqsNewsPaperListView*)view DidUnloadItem:(BqsNewsPaperItemView*)itemView Idx:(int)itemId;
-(void)bqsNewsPaperListViewDidSwipeRightOnFirstPage:(BqsNewsPaperListView*)view;
-(void)bqsNewsPaperListViewDidSwipeLeftOnLastPage:(BqsNewsPaperListView*)view;

@end