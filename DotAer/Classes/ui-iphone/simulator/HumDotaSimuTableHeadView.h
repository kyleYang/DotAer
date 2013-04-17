//
//  HumDotaSimuTableHeadView.h
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSEquipView.h"
#import "HeroInfo.h"

enum  HeroProperty {
    HeroPropertyStreng,
    HeroPropertyAgility,
    HeroPropertyIntelligence,
    HeroPropertyGrowStreng,
    HeroPropertyGrowAgility,
    HeroPropertyGrowIntelligence,
    HeroPropertyHP,
    HeroPropertyMP,
};

typedef enum HeroProperty HeroProperty;

@protocol simuHeadViewDelegate;

@interface HumDotaSimuTableHeadView : UIView<DSEquipViewDelegate>{
    
}

@property (nonatomic, assign) id<simuHeadViewDelegate> delegate;
@property (nonatomic, assign) int grade;
@property (nonatomic, retain) UILabel *heroNameEn;
@property (nonatomic, retain) UILabel *heroGrade;
@property (nonatomic, retain) UILabel *heroNameCN;
@property (nonatomic, retain) UIImageView *heroHead;
@property (nonatomic, retain) UILabel *HPLeb;
@property (nonatomic, retain) UILabel *damage;
@property (nonatomic, retain) UILabel *MPLeb;
@property (nonatomic, retain) UILabel *armor;
@property (nonatomic, retain) UILabel *strength;
@property (nonatomic, retain) UILabel *agility;
@property (nonatomic, retain) UILabel *intelligence;

@property (nonatomic, retain) UILabel *additionDamage;
@property (nonatomic, retain) UILabel *additionArmor;
@property (nonatomic, retain) UILabel *additionStrength;
@property (nonatomic, retain) UILabel *additionAgility;
@property (nonatomic, retain) UILabel *additionIntelligence;

@property (nonatomic, retain) DSEquipView *equipSimu;
@property (nonatomic, retain) UILabel *heroHistrory;
@property (nonatomic, retain) HeroInfo *hero;
@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@end

@protocol simuHeadViewDelegate<NSObject>

- (CGFloat)valueForHeroType:(HeroProperty)type defultValue:(CGFloat)defValue;

@end

