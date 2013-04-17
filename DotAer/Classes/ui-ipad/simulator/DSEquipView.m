//
//  DSEquipView.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-21.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "DSEquipView.h"
#import "DSItemImag.h"
#import "Equipment.h"
#import "Upgrade.h"
#import "Material.h"
#import "Constants.h"
#import "BqsUtils.h"

#define kEquipGap 5

@interface DSEquipView()

@property (nonatomic, retain) NSMutableArray *itemArrary;
@property (nonatomic, retain) NSMutableArray *upgradeAry;
@property (nonatomic, retain) NSMutableArray *materalAry;
@property (nonatomic, retain) DSItemImag *item11;
@property (nonatomic, retain) DSItemImag *item12;
@property (nonatomic, retain) DSItemImag *item13;

@property (nonatomic, retain) DSItemImag *item21;
@property (nonatomic, retain) DSItemImag *item22;
@property (nonatomic, retain) DSItemImag *item23;

@end

@implementation DSEquipView
@synthesize upgradeAry;
@synthesize materalAry;
@synthesize managedObjectContext;
@synthesize itemArrary;
@synthesize item11,item12,item13;
@synthesize item21,item22,item23;
@synthesize additionEquip;
@synthesize delegate;

- (void)dealloc
{
    self.upgradeAry = nil;
    self.managedObjectContext = nil;
    self.additionEquip = nil;
    self.delegate = nil;
    self.materalAry = nil;
    self.itemArrary = nil;
    self.item11 = nil;self.item12 = nil;self.item13 = nil;
    self.item21 = nil;self.item22 = nil;self.item23 = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemArrary = [NSMutableArray arrayWithCapacity:1];
        float width = CGRectGetWidth(frame)/3 - 2*kEquipGap;
        float height = CGRectGetHeight(frame)/2 - 2*kEquipGap;
        
        self.item11 = [[[DSItemImag alloc] initWithFrame:CGRectMake(kEquipGap, kEquipGap, width, height)] autorelease];
        self.item11.goods = TRUE;
        [self.item11 addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item11];
        
        self.item12 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item11.frame.origin.x+ self.item11.frame.size.width+2*kEquipGap, self.item11.frame.origin.y, width, height)] autorelease];
        self.item12.goods = TRUE;
        [self.item12 addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item12];
        
        self.item13 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item12.frame.origin.x+self.item12.frame.size.width+2* kEquipGap, self.item11.frame.origin.y, width, height)] autorelease];
        self.item13.goods = TRUE;
        [self.item13 addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item13];
        
       
        
        
        /**********************************/
        
        self.item21 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item11.frame.origin.x, self.item11.frame.origin.y+self.item12.frame.size.height+2*kEquipGap, width, height)] autorelease];
        self.item21.goods = TRUE;
        [self.item21 addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item21];
        
        self.item22 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item21.frame.origin.x+ self.item21.frame.size.width+2*kEquipGap, self.item21.frame.origin.y, width, height)] autorelease];
        self.item22.goods = TRUE;
        [self.item22 addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item22];
        
        self.item23 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item22.frame.origin.x+ self.item22.frame.size.width+2*kEquipGap, self.item21.frame.origin.y, width, height)] autorelease];
        self.item23.goods = TRUE;
        [self.item23 addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item23];
        
        
        
        
        [self.itemArrary addObject:self.item11];
        [self.itemArrary addObject:self.item21];
        [self.itemArrary addObject:self.item12];
        [self.itemArrary addObject:self.item22];
        [self.itemArrary addObject:self.item13];
        [self.itemArrary addObject:self.item23];
        
        self.additionEquip = [[[AddtionProperty alloc] init] autorelease];
        
    
        
    }
    return self;
}
/**********When the quip is not NULL, remove the item*************/
- (void)itemRemove:(id)sender
{
    DSItemImag *item = (DSItemImag *)sender;
    if (item.equip) {
        item.isFormula = FALSE;
        item.equip = nil;
    }
    
    int addHP = 0;
    int addMP = 0;
    float addArmor = 0.0f;
    float addDamage = 0.0f;
    float addStrength = 0.0f;
    float addAgilityh = 0.0f;
    float addIntelligence = 0.0f;
    
    
    for (DSItemImag *item in self.itemArrary) {
        if(item.equip){
            if (!item.isFormula) { //非卷轴，合成属性
                addHP += [item.equip.addHP intValue];
                addMP += [item.equip.addMP intValue];
                addArmor += [item.equip.addArmor floatValue];
                addDamage += [item.equip.addDamage floatValue];
                addStrength += [item.equip.addStrength floatValue];
                addAgilityh += [item.equip.addAgilityh floatValue];
                addIntelligence += [item.equip.addIntelligence floatValue];
            }
        }
        
    }
    
    self.additionEquip.addHP = addHP;
    self.additionEquip.addMP = addMP;
    self.additionEquip.addArmor = addArmor;
    self.additionEquip.addDamage = addDamage;
    self.additionEquip.addStrength = addStrength;
    self.additionEquip.addAgilityh = addAgilityh;
    self.additionEquip.addIntelligence = addIntelligence;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(DSEquipViewAddition:)]){
        [self.delegate DSEquipViewAddition:self.additionEquip];
    }

}


- (void)addEquip:(Equipment *)equip formula:(BOOL)value
{
    BOOL hasPos = FALSE;
    
    
    for (DSItemImag *item in self.itemArrary) {
        if(item.equip == nil){
            item.isFormula = value;
            item.equip = equip;
            hasPos= TRUE;
            break;
        }
    }
    if(!hasPos){
        return;
    }
    for (DSItemImag *item in self.itemArrary) {
        if(item.equip){
            if (item.isFormula) { //卷轴，优先判断卷轴是不是能合成物品
                BqsLog(@"Equip formulaBe the Equip SN is %d",[item.equip.equipSN integerValue]);
                self.materalAry = [self fetchMaterialResultWithSN:item.equip.equipSN];
                Equipment *eqip = item.equip;
                BOOL canUpgrade = [self materialUpdata:item.equip];
                if(canUpgrade){
                    [self addEquip:eqip formula:FALSE];
                }
                
            }else {
                BqsLog(@"Equip upgrade the Equip SN is %d",[item.equip.equipSN integerValue]);
                self.upgradeAry = [self fetchUpgradeResultWithSN:item.equip.equipSN];
                if(self.upgradeAry){
                    for (Upgrade *upg in self.upgradeAry) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, upg.upgradSN];
                        BqsLog(@"in DSEquipment predicate:%@",predicate);
                        Equipment *eqip = [Equipment fetchWithManagedObjectContext:self.managedObjectContext predicate:predicate];
                        self.materalAry = [self fetchMaterialResultWithSN:upg.upgradSN];
                        BOOL canUpgrade = [self materialUpdata:eqip];
                        if(canUpgrade){
                            BqsLog(@"Equip materail the Equip SN is %d",[upg.upgradSN integerValue]);
                            [self addEquip:eqip formula:FALSE];
                        }
                    }
                }
            }
        }
        
    }
    
    int addHP = 0;
    int addMP = 0;
    float addArmor = 0.0f;
    float addDamage = 0.0f;
    float addStrength = 0.0f;
    float addAgilityh = 0.0f;
    float addIntelligence = 0.0f;
    
    
    for (DSItemImag *item in self.itemArrary) {
        if(item.equip){
            if (!item.isFormula) { //非卷轴，合成属性
                addHP += [item.equip.addHP intValue];
                addMP += [item.equip.addMP intValue];
                addArmor += [item.equip.addArmor floatValue];
                addDamage += [item.equip.addDamage floatValue];
                addStrength += [item.equip.addStrength floatValue];
                addAgilityh += [item.equip.addAgilityh floatValue];
                addIntelligence += [item.equip.addIntelligence floatValue];
            }
        }
        
    }
    
    self.additionEquip.addHP = addHP;
    self.additionEquip.addMP = addMP;
    self.additionEquip.addArmor = addArmor;
    self.additionEquip.addDamage = addDamage;
    self.additionEquip.addStrength = addStrength;
    self.additionEquip.addAgilityh = addAgilityh;
    self.additionEquip.addIntelligence = addIntelligence;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(DSEquipViewAddition:)]){
        [self.delegate DSEquipViewAddition:self.additionEquip];
    }
    
    
}


- (BOOL)materialUpdata:(Equipment *)equip
{
    BqsLog(@"the equip SN is %d",[equip.equipSN intValue]);
    BOOL canUpgrade = TRUE;
    if(!self.materalAry ||[self.materalAry count]==0)
        return FALSE;
    for(Material *mat in self.materalAry){
        BOOL itemMatch = FALSE;
        for (DSItemImag *item in self.itemArrary) {
            BqsLog(@"the hasMatch is %d, the mat sn = %d, equip sn = %d",item.hasMatch, [mat.materialSN intValue],[item.equip.equipSN intValue]);
            if(!item.hasMatch&&[item.equip.equipSN intValue] == [mat.materialSN intValue]&&[item.equip.equipSN intValue]!=[equip.equipSN intValue]&&!item.isFormula){ //先判断是不是已经匹配过，然后判断是不是原材料，再判断是不是需要升级到所用物品的合成书，如果都符合，要排除都是合成书的情况，如梅肯。本事合成书已经讲其看作本事物品
                itemMatch = TRUE;
                item.autoRemove = TRUE;
                item.hasMatch = TRUE;
                break;
            }else if(!item.hasMatch&&[item.equip.equipSN intValue] == [mat.materialSN intValue]&&[item.equip.equipSN intValue]==[equip.equipSN intValue]){
                if (item.isFormula) {
                    itemMatch = TRUE;
                    item.autoRemove = TRUE;
                    item.hasMatch = TRUE;
                    break;
                }
            }
        }
        if(!itemMatch){
            canUpgrade = FALSE;
            break;
        }
    }
    if(canUpgrade){
        for (DSItemImag *item in self.itemArrary) {
            if (item.autoRemove) {
                item.equip = nil;
                item.autoRemove = FALSE;
                item.hasMatch = FALSE;
                item.isFormula = FALSE;
            }
        }
        
    }else{
        for (DSItemImag *item in self.itemArrary) {
            item.autoRemove = FALSE;
            item.hasMatch = FALSE;
            
        }
    }
    
    return canUpgrade;
    
}

- (NSMutableArray *)fetchUpgradeResultWithSN:(NSNumber *)sn
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, sn];
    return [Upgrade fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate];
}


- (NSMutableArray *)fetchMaterialResultWithSN:(NSNumber *)sn
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, sn];
    return [Material fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate];
}





@end


@implementation AddtionProperty

@synthesize addHP;
@synthesize addMP;
@synthesize addArmor;
@synthesize addDamage;
@synthesize addStrength;
@synthesize addAgilityh;
@synthesize addIntelligence;


- (NSString *)description{
    return [NSString stringWithFormat:@"AddtionProperty addHP:%d,addMP:%d,addArmor:%0.1f,addDamage:%0.1f,addStrength:%0.1f,addAgilityh:%0.1f,addIntelligence:%0.1f",self.addHP,self.addMP,self.addArmor,self.addDamage,self.addStrength,self.addAgilityh,self.addIntelligence];
}

@end
