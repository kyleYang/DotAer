//
//  HumSimulaterCell.h
//  DotAer
//
//  Created by Kyle on 13-6-5.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeroInfo;
@class Equipment;

@protocol simulateCellDelegate;

@interface HumSimulaterCell : UITableViewCell


@property (nonatomic, assign) id<simulateCellDelegate> delegate;

-(void)setHeroArr:(NSArray*)arr Row:(NSInteger)rowid;
-(void)setEquipArr:(NSArray *)arr Row:(NSInteger)rowid;

+(int)rowCntForItemCnt:(int)itemCnt ColumnCnt:(int)columnCnt;
+(int)columnCntForWidth:(float)tableWidth;

@end


@protocol simulateCellDelegate <NSObject>

@optional
- (void)humSimulateCell:(HumSimulaterCell *)cell didSelectHero:(HeroInfo *)hero;
- (void)humSimulateCell:(HumSimulaterCell *)cell didSelectEquip:(Equipment *)equip;

@end
