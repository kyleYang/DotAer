//
//  HeroInfo.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-7.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HeroInfoSave : NSObject

@property(nonatomic, assign) int HeroSN;
@property(nonatomic, assign) BOOL Available;
@property(nonatomic, copy) NSString* HeroName;
@property(nonatomic, copy) NSString* HeroNameEn;
@property(nonatomic, copy) NSString* HeroTitleEn;
@property(nonatomic, copy) NSString* HeroTitleCN;
@property(nonatomic, copy) NSString* HeroImage;
@property(nonatomic, copy) NSString* HeroGif;
@property(nonatomic, copy) NSString* HeroStory;
@property(nonatomic, assign) int HeroQuality;
@property(nonatomic, assign) int HeroTavern;
@property(nonatomic, assign) int HeroOrder;
@property(nonatomic, copy) NSString* initialStrength;
@property(nonatomic, copy) NSString* initialAgility;
@property(nonatomic, copy) NSString* initialintelligence;
@property(nonatomic, copy) NSString* StrengthGrow;
@property(nonatomic, copy) NSString* AgilityGrow;
@property(nonatomic, copy) NSString* IntelligenceGrow;
@property(nonatomic, assign) int initialHP;
@property(nonatomic, assign) int initialMP;
@property(nonatomic, copy) NSString* initialDef;
@property(nonatomic, copy) NSString* initialArmor;
@property(nonatomic, assign) int initialDamage1;
@property(nonatomic, assign) int initialDamage2;
@property(nonatomic, assign) int MoveSpeed;
@property(nonatomic, copy) NSString* AttackRange;
@property(nonatomic, copy) NSString* AttackAnimation;
@property(nonatomic, copy) NSString* CastingAnimation;
@property(nonatomic, copy) NSString* BaseAttackTime;
@property(nonatomic, assign) int MissileSpeed;
@property(nonatomic, copy) NSString* SightRange;
@property(nonatomic, copy) NSString* basicHpRegain;
@property(nonatomic, copy) NSString* basicMpRegain;
@property(nonatomic, copy) NSString* Skill1Name;
@property(nonatomic, copy) NSString* Skill1Image;
@property(nonatomic, copy) NSString* Skill1Introduce;
@property(nonatomic, copy) NSString* Skill1Note;
@property(nonatomic, copy) NSString* Skill1Level1;
@property(nonatomic, copy) NSString* Skill1Level2;
@property(nonatomic, copy) NSString* Skill1Level3;
@property(nonatomic, copy) NSString* Skill1Level4;
@property(nonatomic, copy) NSString* Skill2Name;
@property(nonatomic, copy) NSString* Skill2Image;
@property(nonatomic, copy) NSString* Skill2Introduce;
@property(nonatomic, copy) NSString* Skill2Note;
@property(nonatomic, copy) NSString* Skill2Level1;
@property(nonatomic, copy) NSString* Skill2Level2;
@property(nonatomic, copy) NSString* Skill2Level3;
@property(nonatomic, copy) NSString* Skill2Level4;
@property(nonatomic, copy) NSString* Skill3Name;
@property(nonatomic, copy) NSString* Skill3Image;
@property(nonatomic, copy) NSString* Skill3Introduce;
@property(nonatomic, copy) NSString* Skill3Note;
@property(nonatomic, copy) NSString* Skill3Level1;
@property(nonatomic, copy) NSString* Skill3Level2;
@property(nonatomic, copy) NSString* Skill3Level3;
@property(nonatomic, copy) NSString* Skill3Level4;
@property(nonatomic, copy) NSString* Skill4Name;
@property(nonatomic, copy) NSString* Skill4Image;
@property(nonatomic, copy) NSString* Skill4Introduce;
@property(nonatomic, copy) NSString* Skill4Note;
@property(nonatomic, copy) NSString* Skill4Level1;
@property(nonatomic, copy) NSString* Skill4Level2;
@property(nonatomic, copy) NSString* Skill4Level3;


@end


@interface HeroInfoParase : NSObject

+(NSMutableArray *)parseHeroList:(NSData *)data;

@end
