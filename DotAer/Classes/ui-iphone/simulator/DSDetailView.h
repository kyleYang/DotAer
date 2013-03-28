//
//  DSDetailView.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSItemImag.h"
#import "HeroInfo.h"
#import "Equipment.h"

@protocol DSDetailDelegate;

@interface DSDetailView : UIView{
    NSMutableArray *_dataAry; //HeroInfo or Equipment DataArrary
}


@property (nonatomic, assign) id<DSDetailDelegate> delegate;

@property (nonatomic, retain) DSItemImag *item11;
@property (nonatomic, retain) DSItemImag *item12;
@property (nonatomic, retain) DSItemImag *item13;
@property (nonatomic, retain) DSItemImag *item14;
@property (nonatomic, retain) DSItemImag *item21;
@property (nonatomic, retain) DSItemImag *item22;
@property (nonatomic, retain) DSItemImag *item23;
@property (nonatomic, retain) DSItemImag *item24;
@property (nonatomic, retain) DSItemImag *item31;
@property (nonatomic, retain) DSItemImag *item32;
@property (nonatomic, retain) DSItemImag *item33;
@property (nonatomic, retain) DSItemImag *item34;


- (void)setHeroArray:(NSMutableArray *)ary;
- (void)setEquipArray:(NSMutableArray *)ary;

@end


@protocol DSDetailDelegate <NSObject>

- (void)didSelectHero:(HeroInfo *)hero;
- (void)didSelectEquip:(Equipment *)equip;



@end
