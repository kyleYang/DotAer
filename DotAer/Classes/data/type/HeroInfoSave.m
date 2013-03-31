//
//  HeroInfo.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-7.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "HeroInfoSave.h"
#import "TBXML.h"

#define kHeroData @"HeroData"
#define kHeroSN @"HeroSN"
#define kAvailable @"Available"
#define kHeroName @"HeroName"
#define kHeroNameEn @"HeroNameEn"
#define kHeroTitleEn @"HeroTitleEn"
#define kHeroTitleCN @"HeroTitleCN"
#define kHeroStory @"HeroStory"
#define kHeroQuality @"HeroQuality"
#define kHeroTavern @"HeroTavern"
#define kHeroOrder @"HeroOrder"
#define kinitialStrength @"initialStrength"
#define kinitialAgility @"initialAgility"
#define kinitialintelligence @"initialintelligence"
#define kStrengthGrow @"StrengthGrow"
#define kAgilityGrow @"AgilityGrow"
#define kIntelligenceGrow @"IntelligenceGrow"
#define kinitialHP @"initialHP"
#define kinitialMP @"initialMP"
#define kinitialDef @"initialDef"
#define kinitialArmor @"initialArmor"
#define kinitialDamage1 @"initialDamage1"
#define kinitialDamage2 @"initialDamage2"
#define kMoveSpeed @"MoveSpeed"
#define kAttackRange @"AttackRange"
#define kAttackAnimation @"AttackAnimation"
#define kCastingAnimation @"CastingAnimation"
#define kBaseAttackTime @"BaseAttackTime"
#define kMissileSpeed @"MissileSpeed"
#define kSightRange @"SightRange"
#define kbasicHpRegain @"basicHpRegain"
#define kbasicMpRegain @"basicMpRegain"
#define kSkill1Name @"Skill1Name"
#define kSkill1Introduce @"Skill1Introduce"
#define kSkill1Note @"Skill1Note"
#define kSkill1Level1 @"Skill1Level1"
#define kSkill1Level2 @"Skill1Level2"
#define kSkill1Level3 @"Skill1Level3"
#define kSkill1Level4 @"Skill1Level4"
#define kSkill2Name @"Skill2Name"
#define kSkill2Introduce @"Skill2Introduce"
#define kSkill2Note @"Skill2Note"
#define kSkill2Level1 @"Skill2Level1"
#define kSkill2Level2 @"Skill2Level2"
#define kSkill2Level3 @"Skill2Level3"
#define kSkill2Level4 @"Skill2Level4"
#define kSkill3Name @"Skill3Name"
#define kSkill3Introduce @"Skill3Introduce"
#define kSkill3Note @"Skill3Note"
#define kSkill3Level1 @"Skill3Level1"
#define kSkill3Level2 @"Skill3Level2"
#define kSkill3Level3 @"Skill3Level3"
#define kSkill3Level4 @"Skill3Level4"
#define kSkill4Name @"Skill4Name"
#define kSkill4Introduce @"Skill4Introduce"
#define kSkill4Note @"Skill4Note"
#define kSkill4Level1 @"Skill4Level1"
#define kSkill4Level2 @"Skill4Level2"
#define kSkill4Level3 @"Skill4Level3"



@implementation HeroInfoSave
@synthesize HeroSN;
@synthesize Available;
@synthesize HeroName;
@synthesize HeroNameEn;
@synthesize HeroTitleEn;
@synthesize HeroTitleCN;
@synthesize HeroStory;
@synthesize HeroQuality;
@synthesize HeroTavern;
@synthesize HeroOrder;
@synthesize initialStrength;
@synthesize initialAgility;
@synthesize initialintelligence;
@synthesize StrengthGrow;
@synthesize AgilityGrow;
@synthesize IntelligenceGrow;
@synthesize initialHP;
@synthesize initialMP;
@synthesize initialDef;
@synthesize initialArmor;
@synthesize initialDamage1;
@synthesize initialDamage2;
@synthesize MoveSpeed;
@synthesize AttackRange;
@synthesize AttackAnimation;
@synthesize CastingAnimation;
@synthesize BaseAttackTime;
@synthesize MissileSpeed;
@synthesize SightRange;
@synthesize basicHpRegain;
@synthesize basicMpRegain;
@synthesize Skill1Name;
@synthesize Skill1Introduce;
@synthesize Skill1Note;
@synthesize Skill1Level1;
@synthesize Skill1Level2;
@synthesize Skill1Level3;
@synthesize Skill1Level4;
@synthesize Skill2Name;
@synthesize Skill2Introduce;
@synthesize Skill2Note;
@synthesize Skill2Level1;
@synthesize Skill2Level2;
@synthesize Skill2Level3;
@synthesize Skill2Level4;
@synthesize Skill3Name;
@synthesize Skill3Introduce;
@synthesize Skill3Note;
@synthesize Skill3Level1;
@synthesize Skill3Level2;
@synthesize Skill3Level3;
@synthesize Skill3Level4;
@synthesize Skill4Name;
@synthesize Skill4Introduce;
@synthesize Skill4Note;
@synthesize Skill4Level1;
@synthesize Skill4Level2;
@synthesize Skill4Level3;
@synthesize HeroImage;
@synthesize HeroGif;
@synthesize Skill1Image;
@synthesize Skill2Image;
@synthesize Skill3Image;
@synthesize Skill4Image;

@end

@implementation HeroInfoParase



+(HeroInfoSave *)parseHotXml:(TBXMLElement*)element
{
    if (NULL == element || NULL == element->name) {
        return nil;
    }
    
    TBXMLElement *item = element->firstChild;
    
    if (NULL == item || NULL == item->name) {
        return nil;
    }
   
    
    HeroInfoSave *temp = [[[HeroInfoSave alloc] init] autorelease];
    
    while (NULL != item) {
        NSString *sElementName = [TBXML elementName:item];
        NSString *vale = [TBXML textForElement:item];
        
        if ([kHeroSN  isEqualToString:sElementName]) {
            temp.HeroSN = [vale intValue];
        }else if([kAvailable isEqualToString:sElementName]){
            temp.Available = [vale boolValue];
        }else if([kHeroName isEqualToString:sElementName]){
            temp.HeroName = vale;
        }else if([kHeroNameEn isEqualToString:sElementName]){
            temp.HeroNameEn = vale;
        }else if([kHeroTitleEn isEqualToString:sElementName]){
            temp.HeroTitleEn = vale;
        }else if([kHeroTitleCN isEqualToString:sElementName]){
            temp.HeroTitleCN = vale;
        }else if([kHeroStory isEqualToString:sElementName]){
            temp.HeroStory = vale;
        }else if([kHeroQuality isEqualToString:sElementName]){
            temp.HeroQuality = [vale intValue];
        }else if ([kHeroTavern isEqualToString:sElementName]){
            temp.HeroTavern = [vale intValue];
        }else if([kHeroOrder isEqualToString:sElementName]){
            temp.HeroOrder = [vale intValue];
        }else if([kinitialStrength isEqualToString:sElementName]){
            temp.initialStrength = vale;
        }else if([kinitialAgility isEqualToString:sElementName]){
            temp.initialAgility = vale;
        }else if([kinitialintelligence isEqualToString:sElementName]){
            temp.initialintelligence = vale;
        }else if([kStrengthGrow isEqualToString:sElementName]){
            temp.StrengthGrow = vale;
        }else if([kAgilityGrow isEqualToString:sElementName]){
            temp.AgilityGrow = vale;
        }else if([kIntelligenceGrow isEqualToString:sElementName]){
            temp.IntelligenceGrow = vale;
        }else if([kinitialHP isEqualToString:sElementName]){
            temp.initialHP = [vale intValue];
        }else if([kinitialMP isEqualToString:sElementName]){
            temp.initialMP = [vale intValue];
        }else if([kinitialDef isEqualToString:sElementName]){
            temp.initialDef = vale;
        }else if([kinitialArmor isEqualToString:sElementName]){
            temp.initialArmor = vale;
        }else if([kinitialDamage1 isEqualToString:sElementName]){
            temp.initialDamage1 = [vale intValue];
        }else if([kinitialDamage2 isEqualToString:sElementName]){
            temp.initialDamage2 = [vale intValue];
        }else if([kMoveSpeed isEqualToString:sElementName]){
            temp.MoveSpeed = [vale intValue];
        }else if([kAttackRange isEqualToString:sElementName]){
            temp.AttackRange = vale;
        }else if([kAttackAnimation isEqualToString:sElementName]){
            temp.AttackAnimation = vale;
        }else if([kCastingAnimation isEqualToString:sElementName]){
            temp.CastingAnimation = vale;
        }else if([kBaseAttackTime isEqualToString:sElementName]){
            temp.BaseAttackTime = vale;
        }else if([kMissileSpeed isEqualToString:sElementName]){
            temp.MissileSpeed = [vale intValue];
        }else if([kSightRange isEqualToString:sElementName]){
            temp.SightRange = vale;
        }else if([kbasicHpRegain isEqualToString:sElementName]){
            temp.basicHpRegain = vale;
        }else if([kbasicMpRegain isEqualToString:sElementName]){
            temp.basicMpRegain = vale;
        }else if([kSkill1Name isEqualToString:sElementName]){
            temp.Skill1Name = vale;
        }else if([kSkill1Introduce isEqualToString:sElementName]){
            temp.Skill1Introduce = vale;
        }else if([kSkill1Note isEqualToString:sElementName]){
            temp.Skill1Note = vale;
        }else if([kSkill1Level1 isEqualToString:sElementName]){
            temp.Skill1Level1 = vale;
        }else if([kSkill1Level2 isEqualToString:sElementName]){
            temp.Skill1Level2 = vale;
        }else if([kSkill1Level3 isEqualToString:sElementName]){
            temp.Skill1Level3 = vale;
        }else if([kSkill1Level4 isEqualToString:sElementName]){
            temp.Skill1Level4 = vale;
        }else if([kSkill2Name isEqualToString:sElementName]){
            temp.Skill2Name = vale;
        }else if([kSkill2Introduce isEqualToString:sElementName]){
            temp.Skill2Introduce = vale;
        }else if([kSkill2Note isEqualToString:sElementName]){
            temp.Skill2Note = vale;
        }else if([kSkill2Level1 isEqualToString:sElementName]){
            temp.Skill2Level1 = vale;
        }else if([kSkill2Level2 isEqualToString:sElementName]){
            temp.Skill2Level2 = vale;
        }else if([kSkill2Level3 isEqualToString:sElementName]){
            temp.Skill2Level3 = vale;
        }else if([kSkill2Level4 isEqualToString:sElementName]){
            temp.Skill2Level4 = vale;
        }else if([kSkill3Name isEqualToString:sElementName]){
            temp.Skill3Name = vale;
        }else if([kSkill3Introduce isEqualToString:sElementName]){
            temp.Skill3Introduce = vale;
        }else if([kSkill3Note isEqualToString:sElementName]){
            temp.Skill3Note = vale;
        }else if([kSkill3Level1 isEqualToString:sElementName]){
            temp.Skill3Level1 = vale;
        }else if([kSkill3Level2 isEqualToString:sElementName]){
            temp.Skill3Level2 = vale;
        }else if([kSkill3Level3 isEqualToString:sElementName]){
            temp.Skill3Level3 = vale;
        }else if([kSkill3Level4 isEqualToString:sElementName]){
            temp.Skill3Level4 = vale;
        }else if([kSkill4Name isEqualToString:sElementName]){
            temp.Skill4Name = vale;
        }else if([kSkill4Introduce isEqualToString:sElementName]){
            temp.Skill4Introduce = vale;
        }else if([kSkill4Note isEqualToString:sElementName]){
            temp.Skill4Note = vale;
        }else if([kSkill4Level1 isEqualToString:sElementName]){
            temp.Skill4Level1 = vale;
        }else if([kSkill4Level2 isEqualToString:sElementName]){
            temp.Skill4Level2 = vale;
        }else if([kSkill4Level3 isEqualToString:sElementName]){
            temp.Skill4Level3 = vale;
        }
        item = item->nextSibling;
    }
    
    return temp;
    
}

+(NSMutableArray *)parseHeroList:(NSData *)data
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
        if([kHeroData isEqualToString:name]){
            
           
                HeroInfoSave *temp = [self parseHotXml:item];
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

