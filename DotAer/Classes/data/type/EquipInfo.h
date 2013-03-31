//
//  EquipInfo.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-20.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipInfo : NSObject
@property(nonatomic, assign) int equipSN;
@property(nonatomic, assign) BOOL available;
@property(nonatomic, assign) BOOL upgrade;
@property(nonatomic, assign) int shopNumber;
@property(nonatomic, assign) int equipOrder;
@property(nonatomic, retain) NSString* equipName;
@property(nonatomic, retain) NSString* equipImage;
@property(nonatomic, assign) BOOL formulaBe;
@property(nonatomic, assign) int equipPrice;
@property(nonatomic, retain) NSString* equipDescrip;
@property(nonatomic, assign) int addHP;
@property(nonatomic, assign) int addMP;
@property(nonatomic, assign) float addArmor;
@property(nonatomic, assign) int addDamage;
@property(nonatomic, assign) int addStrength;
@property(nonatomic, assign) int addAgilityh;
@property(nonatomic, assign) int addIntelligence;
@property(nonatomic, assign) int upgradeNum;
@property(nonatomic, assign) int equip1Upg;
@property(nonatomic, assign) int equip2Upg;
@property(nonatomic, assign) int equip3Upg;
@property(nonatomic, assign) int equip4Upg;
@property(nonatomic, assign) int equip5Upg;
@property(nonatomic, assign) int equip6Upg;
@property(nonatomic, assign) int equip7Upg;
@property(nonatomic, assign) int equip8Upg;
@property(nonatomic, assign) int equip9Upg;
@property(nonatomic, assign) int materialNum;
@property(nonatomic, assign) BOOL formulaNeed;
@property(nonatomic, assign) int material1Need;
@property(nonatomic, assign) int material2Need;
@property(nonatomic, assign) int material3Need;
@property(nonatomic, assign) int material4Need;
@property(nonatomic, assign) int material5Need;
@property(nonatomic, assign) int material6Need;
@property(nonatomic, assign) int material7Need;
@property(nonatomic, assign) int material8Need;
@property(nonatomic, assign) int material9Need;


@end

@interface EquipParase : NSObject

+(NSMutableArray *)parseEqpuipList:(NSData *)data;

@end

