//
//  DSEquipView.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-21.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Equipment.h"

@protocol DSEquipViewDelegate;

@interface AddtionProperty : NSObject


@property(nonatomic, assign) int addHP;
@property(nonatomic, assign) int addMP;
@property(nonatomic, assign) CGFloat addArmor;
@property(nonatomic, assign) CGFloat addDamage;
@property(nonatomic, assign) CGFloat addStrength;
@property(nonatomic, assign) CGFloat addAgilityh;
@property(nonatomic, assign) CGFloat addIntelligence;

@end

@interface DSEquipView : UIView

@property (nonatomic,retain) id<DSEquipViewDelegate> delegate;
@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@property (nonatomic,retain) AddtionProperty *additionEquip;

- (void)addEquip:(Equipment *)equip formula:(BOOL)value;
@end






@protocol DSEquipViewDelegate <NSObject>

- (void)DSEquipViewAddition:(AddtionProperty*)addtion;

@end
