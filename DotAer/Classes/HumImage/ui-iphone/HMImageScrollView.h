//
//  PanguImageShowView.h
//  pangu
//
//  Created by yang zhiyun on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMImageControllerView.h"

@protocol HMImageScrollDataSource;
@protocol HMImageScrollDelegate;

@interface HMImageScrollView :  UIView<UIAlertViewDelegate>
{
    NSMutableArray *_onScreenCells;
    BOOL _bBlockScrollEvent;
    BOOL _positset;
    BOOL _bZooming;
    BOOL _loadMore;
    BOOL thumbViewShowing;
    CGPoint _zoomOff;
    NSInteger _nowIndex;
}

@property (nonatomic, retain, readonly) HMImageControllerView *controlsView;
@property (nonatomic, assign) BOOL controlsVisible;

@property (nonatomic, assign) id<HMImageScrollDataSource> dataSource;
@property (nonatomic, assign) id<HMImageScrollDelegate> delegate;

@property (nonatomic, retain) NSArray *imgesAry;

@property (nonatomic, retain) UIImageView *viewImg;

- (void)reloadData;
@end

@protocol HMImageScrollDataSource <NSObject>

@required
- (NSUInteger)numberOfItemFor:(HMImageScrollView *)scrollView;
- (NSString*)imageUrlForScrollView:(HMImageScrollView *)scrollView AtIndex:(NSUInteger)index;
- (NSString *)summaryForScrollView:(HMImageScrollView *)scrollView AtIndex:(NSUInteger)index;

@end

@protocol HMImageScrollDelegate <NSObject>

- (void)humImageViewBack:(HMImageScrollView *)scroll;

@end

