//
//  EquipInfo.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-20.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "EquipInfo.h"
#import "TBXML.h"

#define kEquipData @"EquipData"

#define kEquipSN @"EquipSN"
#define kAvailable @"Available"
#define kUpgrade @"Upgrade"
#define kShopNumber @"ShopNumber"
#define kEquipOrder @"EquipOrder"
#define kEquipName @"EquipName"
#define kEquipImage @"EquipImage"
#define kFormulaBe @"FormulaBe"
#define kEquipPrice @"EquipPrice"
#define kEquipDescrip @"EquipDescrip"
#define kAddHP @"AddHP"
#define kAddMP @"AddMP"
#define kAddArmor @"AddArmor"
#define kAddDamage @"AddDamage"
#define kAddStrength @"AddStrength"
#define kAddAgilityh @"AddAgilityh"
#define kAddIntelligence @"AddIntelligence"
#define kUpgradeNum @"UpgradeNum"
#define kEquip1Upg @"Equip1Upg"
#define kEquip2Upg @"Equip2Upg"
#define kEquip3Upg @"Equip3Upg"
#define kEquip4Upg @"Equip4Upg"
#define kEquip5Upg @"Equip5Upg"
#define kEquip6Upg @"Equip6Upg"
#define kEquip7Upg @"Equip7Upg"
#define kEquip8Upg @"Equip8Upg"
#define kEquip9Upg @"Equip9Upg"
#define kMaterialNum @"MaterialNum"
#define kFormulaNeed @"FormulaNeed"
#define kMaterial1Need @"Material1Need"
#define kMaterial2Need @"Material2Need"
#define kMaterial3Need @"Material3Need"
#define kMaterial4Need @"Material4Need"
#define kMaterial5Need @"Material5Need"
#define kMaterial6Need @"Material6Need"
#define kMaterial7Need @"Material7Need"
#define kMaterial8Need @"Material8Need"
#define kMaterial9Need @"Material9Need"


@implementation EquipInfo
@synthesize equipSN;
@synthesize available;
@synthesize upgrade;
@synthesize shopNumber;
@synthesize equipOrder;
@synthesize equipName;
@synthesize equipImage;
@synthesize formulaBe;
@synthesize equipPrice;
@synthesize equipDescrip;
@synthesize addHP;
@synthesize addMP;
@synthesize addArmor;
@synthesize addDamage;
@synthesize addStrength;
@synthesize addAgilityh;
@synthesize addIntelligence;
@synthesize upgradeNum;
@synthesize equip1Upg;
@synthesize equip2Upg;
@synthesize equip3Upg;
@synthesize equip4Upg;
@synthesize equip5Upg;
@synthesize equip6Upg;
@synthesize equip7Upg;
@synthesize equip8Upg;
@synthesize equip9Upg;
@synthesize materialNum;
@synthesize formulaNeed;
@synthesize material1Need;
@synthesize material2Need;
@synthesize material3Need;
@synthesize material4Need;
@synthesize material5Need;
@synthesize material6Need;
@synthesize material7Need;
@synthesize material8Need;
@synthesize material9Need;
@end

@implementation EquipParase

+(EquipInfo *)parseHotXml:(TBXMLElement*)element
{
    if (NULL == element || NULL == element->name) {
        return nil;
    }
    
    TBXMLElement *item = element->firstChild;
    
    if (NULL == item || NULL == item->name) {
        return nil;
    }
    
    
    EquipInfo *temp = [[[EquipInfo alloc] init] autorelease];
    
    while (NULL != item) {
        NSString *sElementName = [TBXML elementName:item];
        NSString *vale = [TBXML textForElement:item];
        
        if ([kEquipSN  isEqualToString:sElementName]) {
            temp.equipSN = [vale intValue];
        }else if([kAvailable isEqualToString:sElementName]){
            temp.Available = [vale boolValue];
        }else if([kUpgrade isEqualToString:sElementName]){
            temp.upgrade = [vale boolValue];
        }else if([kShopNumber isEqualToString:sElementName]){
            temp.shopNumber = [vale intValue];
        }else if([kEquipOrder isEqualToString:sElementName]){
            temp.equipOrder = [vale intValue];
        }else if([kEquipName isEqualToString:sElementName]){
            temp.equipName = vale;
        }else if([kEquipImage isEqualToString:sElementName]){
            temp.equipImage = vale;
        }else if([kFormulaBe isEqualToString:sElementName]){
            temp.formulaBe = [vale boolValue];
        }else if ([kEquipPrice isEqualToString:sElementName]){
            temp.equipPrice = [vale intValue];
        }else if([kEquipDescrip isEqualToString:sElementName]){
            temp.equipDescrip = vale;
        }else if([kAddHP isEqualToString:sElementName]){
            temp.addHP = [vale intValue];
        }else if([kAddMP isEqualToString:sElementName]){
            temp.addMP = [vale intValue];
        }else if([kAddArmor isEqualToString:sElementName]){
            temp.addArmor = [vale floatValue];
        }else if([kAddDamage isEqualToString:sElementName]){
            temp.addDamage = [vale intValue];
        }else if([kAddStrength isEqualToString:sElementName]){
            temp.addStrength = [vale intValue];
        }else if([kAddAgilityh isEqualToString:sElementName]){
            temp.addAgilityh = [vale intValue];
        }else if([kAddIntelligence isEqualToString:sElementName]){
            temp.addIntelligence = [vale intValue];
        }else if([kUpgradeNum isEqualToString:sElementName]){
            temp.upgradeNum = [vale intValue];
        }else if([kEquip1Upg isEqualToString:sElementName]){
            temp.equip1Upg = [vale intValue];
        }else if([kEquip2Upg isEqualToString:sElementName]){
            temp.equip2Upg = [vale intValue];
        }else if([kEquip3Upg isEqualToString:sElementName]){
            temp.equip3Upg = [vale intValue];
        }else if([kEquip4Upg isEqualToString:sElementName]){
            temp.equip4Upg = [vale intValue];
        }else if([kEquip5Upg isEqualToString:sElementName]){
            temp.equip5Upg = [vale intValue];
        }else if([kEquip6Upg isEqualToString:sElementName]){
            temp.equip6Upg = [vale intValue];
        }else if([kEquip7Upg isEqualToString:sElementName]){
            temp.equip7Upg = [vale intValue];
        }else if([kEquip8Upg isEqualToString:sElementName]){
            temp.equip8Upg = [vale intValue];
        }else if([kEquip9Upg isEqualToString:sElementName]){
            temp.equip9Upg = [vale intValue];
        }else if([kMaterialNum isEqualToString:sElementName]){
            temp.materialNum = [vale intValue];
        }else if([kFormulaNeed isEqualToString:sElementName]){
            temp.formulaNeed = [vale boolValue];
        }else if([kMaterial1Need isEqualToString:sElementName]){
            temp.material1Need = [vale intValue];
        }else if([kMaterial2Need isEqualToString:sElementName]){
            temp.material2Need = [vale intValue];
        }else if([kMaterial3Need isEqualToString:sElementName]){
            temp.material3Need = [vale intValue];
        }else if([kMaterial4Need isEqualToString:sElementName]){
            temp.material4Need = [vale intValue];
        }else if([kMaterial5Need isEqualToString:sElementName]){
            temp.material5Need = [vale intValue];
        }else if([kMaterial6Need isEqualToString:sElementName]){
            temp.material6Need = [vale intValue];
        }else if([kMaterial7Need isEqualToString:sElementName]){
            temp.material7Need = [vale intValue];
        }else if([kMaterial8Need isEqualToString:sElementName]){
            temp.material8Need = [vale intValue];
        }else if([kMaterial9Need isEqualToString:sElementName]){
            temp.material9Need = [vale intValue];
        }
        item = item->nextSibling;
    }
    
    return temp;
    
}

+(NSMutableArray *)parseEqpuipList:(NSData *)data
{
    if (nil == data) {
        return nil;
    }
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if (NULL == tbxml.rootXMLElement) {
        [tbxml release];
        return nil;
    }
    
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:1];;
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    while(NULL != item) {
        NSString *name = [TBXML elementName:item];
        if([kEquipData isEqualToString:name]){
            
            
            EquipInfo *temp = [self parseHotXml:item];
            if (nil != temp) {
                [contentArray addObject:temp];
            }
        }
        item = item->nextSibling;
    }
    
    [tbxml release];
    
    
    return contentArray;
    
}



@end
