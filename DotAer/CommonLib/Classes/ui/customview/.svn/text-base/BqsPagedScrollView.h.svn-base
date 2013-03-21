//
//  BqsPagedScrollView.h
//  iMobeeBook
//
//  Created by ellison on 11-9-6.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BqsPagedScrollView_Callback;

@interface BqsPagedScrollView : UIView {
 	int _totalPages;
    int _curPageId;
    
	UIScrollView *_scrollView;
	
	NSMutableDictionary *_viewCache;
    
    BOOL _bZooming;
    BOOL _bBlockScrollEvent;
    
    float _beginDecelerateX;

}
@property (nonatomic, assign) id<BqsPagedScrollView_Callback> callback;
@property (nonatomic, assign) BOOL bEnableZoom;
@property (nonatomic, assign) float fMaxZoomScale;
@property (nonatomic, assign) float fMinZoomScale;
@property (nonatomic, assign, readonly) int totalPages;
@property (nonatomic, assign, readonly) int curPageId;

-(void)reloadData;
-(void)reloadData:(int)aPageId;
-(void)showPage:(int)pageId Animate:(BOOL)bAni;
-(UIView*)viewOfPage:(int)idx;
@end

@protocol BqsPagedScrollView_Callback <NSObject>

-(int)bqsPagedScrollViewGetPageCnt:(BqsPagedScrollView*)sv;
-(UIView*)bqsPagedScrollView:(BqsPagedScrollView*)sv ViewForPage:(int)pageId;

@optional
-(void)bqsPagedScrollView:(BqsPagedScrollView*)sv WillTurnToPage:(int)pageId;
-(void)bqsPagedScrollView:(BqsPagedScrollView*)sv DidTurnToPage:(int)pageId;
-(void)bqsPagedScrollView:(BqsPagedScrollView*)sv DidTap:(CGPoint)pt;
-(void)bqsPagedScrollView:(BqsPagedScrollView*)sv DidDoubleTap:(CGPoint)pt;
-(void)bqsPagedScrollView:(BqsPagedScrollView*)sv DidUnloadPage:(int)pageId View:(UIView*)pageView;

- (void)bqsPagedScrollViewDidSwipeRightOnFirstPage:(BqsPagedScrollView*)sv;
- (void)bqsPagedScrollViewDidSwipeLeftOnLastPage:(BqsPagedScrollView*)sv;


-(void)bqsPagedScrollView:(BqsPagedScrollView*)sv EndZoomAtScale:(float)scale;
@end