//
//  Equipment.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "Equipment.h"

@implementation Equipment

@dynamic equipSN;
@dynamic available;
@dynamic upgrade;
@dynamic shopNumber;
@dynamic equipOrder;
@dynamic equipName;
@dynamic equipImage;
@dynamic formulaBe;
@dynamic equipPrice;
@dynamic equipDescrip;
@dynamic addHP;
@dynamic addMP;
@dynamic addArmor;
@dynamic addDamage;
@dynamic addStrength;
@dynamic addAgilityh;
@dynamic addIntelligence;
@dynamic upgradeNum;
@dynamic materialNum;
@dynamic formulaNeed;



- (NSString *)description{
        return [NSString stringWithFormat:@"[Equip equipSN:%@,available:%@,upgrade:%@,shopNumber:%@,equipOrder:%@,equipName:%@,equipPrice:%@,addHP:%@,addMP:%@,addArmor:%@,addDamage:%@,addStrength:%@,addAgilityh:%@,addIntelligence:%@]",
                self.equipSN, self.available,self.upgrade,self.shopNumber,self.equipOrder, self.equipName, self.equipPrice,self.addHP,self.addMP,self.addArmor, self.addDamage, self.addStrength,self.addAgilityh,self.addIntelligence];
}


@end
