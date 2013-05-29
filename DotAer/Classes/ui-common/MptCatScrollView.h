//
//  MptCatScrollView.h
//  TVGontrol
//
//  Created by Kyle on 13-5-23.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MptMacro.h"

#define kGuideCatTwoViewH 35

@protocol MptCatScrollViewDelegate;

@interface MptCatScrollView : UIView{

@private
    id<MptCatScrollViewDelegate> __weak_delegate _delegate;
    NSArray *_arrItems;
    NSInteger _selectedId;
    UIColor *_normalColor;
    UIColor *_hilightColor;
    BOOL _indicaHidden;
}

@property (nonatomic, weak_delegate) id<MptCatScrollViewDelegate> delegate;
@property (nonatomic, strong) NSArray *arrItems;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *hilightColor;
@property (nonatomic, assign) BOOL indicaHidden;

- (void)setSelectedIndex:(NSInteger)index;

@end


@protocol MptCatScrollViewDelegate <NSObject>

- (void)catScrollView:(MptCatScrollView *)scrollView didSelect:(NSInteger)index;

@end
