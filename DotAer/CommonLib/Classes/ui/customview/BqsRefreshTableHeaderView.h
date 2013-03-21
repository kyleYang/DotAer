//
//  BqsRefreshTableHeaderView.h
//  iMobeeNews
//
//  Created by ellison on 11-7-17.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	BRTH_PullRefreshPulling = 0,
	BRTH_PullRefreshNormal,
	BRTH_PullRefreshLoading,	
} BRTH_PullRefreshState;

@protocol BqsRefreshTableHeaderView_Callback;

@interface BqsRefreshTableHeaderView : UIView {
	
	id _callback;
	BRTH_PullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;

}

@property(nonatomic,assign) id <BqsRefreshTableHeaderView_Callback> callback;
@property (nonatomic, assign) CGFloat fPullDistance; // default 65.0

- (id)initWithFrame:(CGRect)frame arrowImage:(UIImage *)arrow textColor:(UIColor *)textColor;

-(void)setArrowLeftPadding:(float)x;

- (void)refreshLastUpdatedDate;
- (void)bqsRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)bqsRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)bqsRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol BqsRefreshTableHeaderView_Callback
- (void)bqsRefreshTableHeaderDidTriggerRefresh:(BqsRefreshTableHeaderView*)view;
- (BOOL)bqsRefreshTableHeaderDataSourceIsLoading:(BqsRefreshTableHeaderView*)view;
@optional
- (NSDate*)bqsRefreshTableHeaderDataSourceLastUpdated:(BqsRefreshTableHeaderView*)view;
@end
