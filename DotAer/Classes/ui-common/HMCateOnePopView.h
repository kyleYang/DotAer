//
//  HMCateOnePopView.h
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMCateOnePopViewDelegate;

@interface HMCateOnePopView : UIView

@property (nonatomic, assign) id<HMCateOnePopViewDelegate>delegate;

@property (nonatomic, retain) NSArray *arrItem; //item array
@property (nonatomic, assign) CGPoint popPoint;

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)arr popAt:(CGPoint)point withTableFrame:(CGRect)tableFrame;
- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)arr popAt:(CGPoint)point;

- (void)popViewAnimation;
- (void)selfDimss;

@end


@protocol HMCateOnePopViewDelegate <NSObject>

- (void)hmCateOnePopView:(HMCateOnePopView *)popView didSelectAt:(NSIndexPath*)index;
- (void)hmCateOneDismissPopView:(HMCateOnePopView *)popView;

@end
