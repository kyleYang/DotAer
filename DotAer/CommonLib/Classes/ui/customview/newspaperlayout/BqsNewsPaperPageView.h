//
//  BqsNewsPaperPageView.h
//  iMobeeNews
//
//  Created by ellison on 11-9-1.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BqsNewsPaperPageLayout.h"
#import "BqsNewsPaperItemView.h"

@protocol BqsNewsPaperPageView_Callback;

@interface BqsNewsPaperPageView : UIView {
    
}
@property (nonatomic, assign) id<BqsNewsPaperPageView_Callback> callback;

@property (nonatomic, retain) BqsNewsPaperPageLayout *pageLayout;
@property (nonatomic, assign) int pageId;

@property (nonatomic, assign) BOOL fPaddingHor;
@property (nonatomic, assign) BOOL fPaddingVer;
@property (nonatomic, assign) BOOL fGap;
@property (nonatomic, assign) BOOL bDrawGapLine;
@property (nonatomic, assign) float fGapLineWidth;
@property (nonatomic, retain) UIColor *gapLineColor;

-(void)unloadPage;
-(void)loadPage;

-(UIView*)viewOfIndex:(int)idx;

@end

@protocol BqsNewsPaperPageView_Callback <NSObject>

-(BqsNewsPaperItemView*)bqsNewsPaperPageView:(BqsNewsPaperPageView*)view GetViewForItem:(int)itemId;
-(void)bqsNewsPaperPageView:(BqsNewsPaperPageView*)view RecycleItemView:(BqsNewsPaperItemView*)itemView ItemIdx:(int)itemIdx;

@optional
-(void)bqsNewsPaperPageView:(BqsNewsPaperPageView*)view DidSelectItem:(int)itemId;

@end