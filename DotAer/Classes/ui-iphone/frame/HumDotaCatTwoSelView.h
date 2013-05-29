//
//  HumDotaCatTwoSelView.h
//  DotAer
//
//  Created by Kyle on 13-1-24.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumDotaCatTwoSelViewDelegate;

@interface HumDotaCatTwoSelView : UIView{
  
    int _itemSelectedId;
    int _catSelectedId;
    int _oldItemSelectedid;
}

@property (nonatomic, assign) id<HumDotaCatTwoSelViewDelegate> delegate;

@property (nonatomic, assign) int itemSelectedId;
@property (nonatomic, assign) int catSelectedId;

- (void)setCateTwoCurSelectIndex:(NSUInteger)index;

- (void)humDotaCateTwoSetCatArr:(NSArray *)arrCat;

-(void)humDotaCateOneSetCatArr:(NSArray *)arrCat;

@end

@protocol HumDotaCatTwoSelViewDelegate <NSObject>

@optional

-(void)humDotaCatTwoSelectView:(HumDotaCatTwoSelView*)v DidSelectCatOne:(int)onIdx;

-(void)humDotaCatTwoSelectView:(HumDotaCatTwoSelView*)v DidSelectCatTwo:(int)towIdx;

@end
