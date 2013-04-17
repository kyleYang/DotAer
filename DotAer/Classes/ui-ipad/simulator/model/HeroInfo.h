//
//  HeroInfo.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "DSBaseModel.h"

@interface HeroInfo : DSBaseModel

@property(nonatomic, retain) NSNumber *heroSN;
@property(nonatomic, retain) NSNumber *available;
@property(nonatomic, retain) NSString* heroName;
@property(nonatomic, retain) NSString* heroNameEn;
@property(nonatomic, retain) NSString* heroTitleEn;
@property(nonatomic, retain) NSString* heroTitleCN;
@property(nonatomic, retain) NSString* heroImage;
@property(nonatomic, retain) NSString* heroGif;
@property(nonatomic, retain) NSString* heroStory;
@property(nonatomic, retain) NSNumber* heroQuality;
@property(nonatomic, retain) NSNumber* heroTavern;
@property(nonatomic, retain) NSNumber *heroOrder;
@property(nonatomic, retain) NSString* initialStrength;
@property(nonatomic, retain) NSString* initialAgility;
@property(nonatomic, retain) NSString* initialintelligence;
@property(nonatomic, retain) NSString* strengthGrow;
@property(nonatomic, retain) NSString* agilityGrow;
@property(nonatomic, retain) NSString* intelligenceGrow;
@property(nonatomic, retain) NSNumber* initialHP;
@property(nonatomic, retain) NSNumber* initialMP;
@property(nonatomic, retain) NSString* initialDef;
@property(nonatomic, retain) NSString* initialArmor;
@property(nonatomic, retain) NSNumber* initialDamage1;
@property(nonatomic, retain) NSNumber* initialDamage2;
@property(nonatomic, retain) NSNumber* moveSpeed;
@property(nonatomic, retain) NSString* attackRange;
@property(nonatomic, retain) NSString* attackAnimation;
@property(nonatomic, retain) NSString* castingAnimation;
@property(nonatomic, retain) NSString* baseAttackTime;
@property(nonatomic, retain) NSNumber* missileSpeed;
@property(nonatomic, retain) NSString* sightRange;
@property(nonatomic, retain) NSString* basicHpRegain;
@property(nonatomic, retain) NSString* basicMpRegain;
@property(nonatomic, retain) NSString* skill1Name;
@property(nonatomic, retain) NSString* skill1Image;
@property(nonatomic, retain) NSString* skill1Introduce;
@property(nonatomic, retain) NSString* skill1Note;
@property(nonatomic, retain) NSString* skill1Level1;
@property(nonatomic, retain) NSString* skill1Level2;
@property(nonatomic, retain) NSString* skill1Level3;
@property(nonatomic, retain) NSString* skill1Level4;
@property(nonatomic, retain) NSString* skill2Name;
@property(nonatomic, retain) NSString* skill2Image;
@property(nonatomic, retain) NSString* skill2Introduce;
@property(nonatomic, retain) NSString* skill2Note;
@property(nonatomic, retain) NSString* skill2Level1;
@property(nonatomic, retain) NSString* skill2Level2;
@property(nonatomic, retain) NSString* skill2Level3;
@property(nonatomic, retain) NSString* skill2Level4;
@property(nonatomic, retain) NSString* skill3Name;
@property(nonatomic, retain) NSString* skill3Image;
@property(nonatomic, retain) NSString* skill3Introduce;
@property(nonatomic, retain) NSString* skill3Note;
@property(nonatomic, retain) NSString* skill3Level1;
@property(nonatomic, retain) NSString* skill3Level2;
@property(nonatomic, retain) NSString* skill3Level3;
@property(nonatomic, retain) NSString* skill3Level4;
@property(nonatomic, retain) NSString* skill4Name;
@property(nonatomic, retain) NSString* skill4Image;
@property(nonatomic, retain) NSString* skill4Introduce;
@property(nonatomic, retain) NSString* skill4Note;
@property(nonatomic, retain) NSString* skill4Level1;
@property(nonatomic, retain) NSString* skill4Level2;
@property(nonatomic, retain) NSString* skill4Level3;

@end
