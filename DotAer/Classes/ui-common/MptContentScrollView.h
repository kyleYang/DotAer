//
//  MptContentScrollView.h
//  TVGontrol
//
//  Created by Kyle on 13-4-26.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MptMacro.h"
#import "MptCotentCell.h"

@protocol scrollDataSource;
@protocol scrollDelegate;
@class MptTouchScrollView;

@interface MptContentScrollView : UIView<UIScrollViewDelegate>{
@private
    id<scrollDataSource> __weak_delegate _dataSource;
    id<scrollDelegate>  __weak_delegate _delegate;
    MptTouchScrollView *_scrollView;
    NSMutableArray *_onScreenCells;
    NSMutableDictionary *_saveCells;
    
    NSUInteger _total;
}

@property (nonatomic, weak_delegate) id<scrollDataSource> dataSource;
@property (nonatomic, weak_delegate) id<scrollDelegate> delegate;

@property (nonatomic, strong) MptTouchScrollView *scrollView;

- (MptCotentCell *)dequeueCellWithIdentifier:(NSString *)identifier;

- (void)reloadDataInitOffset:(BOOL)value;

- (void)setCurrentDisplayItemIndex:(NSUInteger)index;


@end



@protocol scrollDataSource <NSObject>

@required
- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView;
- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index ;

@optional


@end

@protocol scrollDelegate <NSObject>

@optional

- (void)scrollView:(MptContentScrollView *)scrollView curOffsetPercent:(CGFloat)percent;
- (void)scrollView:(MptContentScrollView *)scrollView curIndex:(NSUInteger)index;

@end
