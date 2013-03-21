//
//  BqsTabBar.h
//  iMobeeBook
//
//  Created by ellison on 11-7-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBqsTabBarHeight 49

@protocol BqsTabBar_Callback;
@interface BqsTabBar : UIView {
    NSInteger _selectedIdx;
    
    CGPoint _touchBeganPoint;
    UITouch *_touch;
    NSInteger _clickEffectIdx;
}
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIColor *itemFontColor;
@property (nonatomic, retain) UIColor *itemSelectedFontColor;
@property (nonatomic, retain) UIImage *itemSelectedBgImg;
@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, assign) id<BqsTabBar_Callback> callback;

@property (nonatomic, assign) BOOL bFillWidth; // default NO

-(void)setItems:(NSArray*)arr; // UITabBarItem
-(UITabBarItem*)getItem:(int)idx;
-(int)selectItemByTag:(int)tag;

@end

@protocol BqsTabBar_Callback <NSObject>

@optional
-(void)bqsTabBar:(BqsTabBar*)tb DidSelect:(int)idx PrevSelect:(int)prevIdx;

@end