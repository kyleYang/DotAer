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

-(void)humDotaCateTwoSetCatArr:(NSArray *)arrCat itemArr:(NSArray *)arrItem;


@end

@protocol HumDotaCatTwoSelViewDelegate <NSObject>

@optional
-(void)humDotaCatTwoSelectView:(HumDotaCatTwoSelView*)v DidSelectCatOne:(int)onIdx CatTwo:(int)twoIdx PrevSelect:(int)prevIdx;

@end
