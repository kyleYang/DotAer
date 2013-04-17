//
//  Equipment.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "DSBaseModel.h"
#import "Upgrade.h"
#import "Material.h"

@interface Equipment : DSBaseModel
@property(nonatomic, retain) NSNumber* equipSN;
@property(nonatomic, retain) NSNumber* available;
@property(nonatomic, retain) NSNumber* upgrade;
@property(nonatomic, retain) NSNumber* shopNumber;
@property(nonatomic, retain) NSNumber* equipOrder;
@property(nonatomic, retain) NSString* equipName;
@property(nonatomic, retain) NSString* equipImage;
@property(nonatomic, retain) NSNumber* formulaBe;
@property(nonatomic, retain) NSNumber* equipPrice;
@property(nonatomic, retain) NSString* equipDescrip;
@property(nonatomic, retain) NSNumber* addHP;
@property(nonatomic, retain) NSNumber* addMP;
@property(nonatomic, retain) NSNumber* addArmor;
@property(nonatomic, retain) NSNumber* addDamage;
@property(nonatomic, retain) NSNumber* addStrength;
@property(nonatomic, retain) NSNumber* addAgilityh;
@property(nonatomic, retain) NSNumber* addIntelligence;
@property(nonatomic, retain) NSNumber* upgradeNum;
@property(nonatomic, retain) NSNumber* materialNum;
@property(nonatomic, retain) NSNumber* formulaNeed;

@end
