//
//  MptGuideLoadingFooterView.h
//  TVGuide
//
//  Created by ellison on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPgLoadingFooterView_H 44

@protocol pgFootViewDelegate;

typedef enum{
    PgFootRefreshInit = 0,
	PgFootRefreshNormal,
	PgFootRefreshLoading,
    PgFootRefreshAllDown,
} PgFootRefreshState;


@interface PgLoadingFooterView : UIView
{
    PgFootRefreshState _state;
    id<pgFootViewDelegate> _delegate;
}

@property (nonatomic, retain) UIActivityIndicatorView *viewAct;
@property (nonatomic, retain) UILabel *message;

@property (nonatomic, assign) PgFootRefreshState state;
@property (nonatomic, assign) id<pgFootViewDelegate> delegate;


@end

@protocol pgFootViewDelegate <NSObject>

- (NSString *)messageTxtForState:(PgFootRefreshState)state;
- (void)footLoadMore;

@end
