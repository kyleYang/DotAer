//
//  HumDotaSimuTableHeadView.m
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSimuTableHeadView.h"
#import "BqsUtils.h"
#import "Env.h"

#define kItemWidth 30
#define kItemHeigh 30

#define kLabelWidth 110
#define kLebelHeigh 17

#define kValueWidth 70
#define kAddtionWidth 40


#define kDftGrowHP 19
#define lDftGrowMP 13


@interface HumDotaSimuTableHeadView(){
    
    int _baseHP;
    int _baseMP;
    float _baseArmor;
    float _baseDamage;
    float _baseStrength;
    float _baseAgilityh;
    float _baseIntelligence;
    
    int _addHP;
    int _addMP;
    float _addArmor;
    float _addDamage;
    float _addStrength;
    float _addAgilityh;
    float _addIntelligence;
    
    
}



@end

@implementation HumDotaSimuTableHeadView
@synthesize delegate;
@synthesize grade= _grade;
@synthesize heroNameEn = _heroNameEn;
@synthesize heroGrade = _heroGrade;
@synthesize heroNameCN = _heroNameCN;
@synthesize heroHead = _heroHead;
@synthesize HPLeb =_HPLeb;
@synthesize damage = _damage;
@synthesize MPLeb = _MPLeb;
@synthesize armor = _armor;
@synthesize strength =_strength;
@synthesize agility = _agility;
@synthesize intelligence = _intelligence;
@synthesize equipSimu = _equipSimu;
@synthesize heroHistrory = _heroHistrory;
@synthesize hero = _hero;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize additionDamage;
@synthesize additionArmor;
@synthesize additionStrength;
@synthesize additionAgility;
@synthesize additionIntelligence;

- (void)dealloc{
    self.delegate = nil;
    [_heroNameEn release];
    [_heroGrade release];
    [_heroNameCN release];
    [_heroHead release];
    [_HPLeb release];
    [_damage release];
    [_MPLeb release];
    [_armor release];
    [_strength release];
    [_agility release];
    [_intelligence release];
    [_equipSimu release];
    [_heroHistrory release];
    [_hero release];
    
    self.additionDamage = nil;
    self.additionArmor = nil;
    self.additionStrength = nil;
    self.additionAgility = nil;
    self.additionIntelligence = nil;
    
    [_managedObjectContext release]; _managedObjectContext = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _heroNameEn = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), 25)];
        _heroNameEn.textAlignment = UITextAlignmentCenter;
        _heroNameEn.font = [UIFont systemFontOfSize:16];
        _heroNameEn.backgroundColor = [UIColor clearColor];
        _heroNameEn.textColor = [UIColor blackColor];
        [self addSubview:_heroNameEn];
        
        _grade = 1;
        
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_heroNameEn.frame), 300, 35)];
        titleImage.image = [[Env sharedEnv] cacheScretchableImage:@"simu_grade_bg.png" X:30 Y:10];
        [self addSubview:titleImage];
        titleImage.userInteractionEnabled = YES;
        [titleImage release];
        
        UIButton *buttonDown = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 30, CGRectGetHeight(titleImage.frame))];
        buttonDown.backgroundColor = [UIColor clearColor];
        [buttonDown setBackgroundImage:[[Env sharedEnv] cacheImage:@"simu_grade_down.png"] forState:UIControlStateNormal];
        buttonDown.showsTouchWhenHighlighted = YES;
        [buttonDown addTarget:self action:@selector(gradeDown:) forControlEvents:UIControlEventTouchUpInside];
        [titleImage addSubview:buttonDown];
        [buttonDown release];
        
        _heroGrade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonDown.frame)+20, CGRectGetMinY(buttonDown.frame), 70, CGRectGetHeight(titleImage.frame))];
        _heroGrade.font = [UIFont systemFontOfSize:14];
        _heroGrade.backgroundColor = [UIColor clearColor];
        _heroGrade.textColor = [UIColor blackColor];
        [titleImage addSubview:_heroGrade];
        
        _heroNameCN = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_heroGrade.frame)+10, CGRectGetMinY(buttonDown.frame), 120, CGRectGetHeight(titleImage.frame))];
        _heroNameCN.font = [UIFont systemFontOfSize:15];
        _heroNameCN.backgroundColor = [UIColor clearColor];
        _heroNameCN.textColor = [UIColor blackColor];
        [titleImage addSubview:_heroNameCN];
        
        UIButton *buttonUp = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(titleImage.frame)-50, CGRectGetMinY(buttonDown.frame), 30,  CGRectGetHeight(titleImage.frame))];
        buttonUp.backgroundColor = [UIColor clearColor];
        [buttonUp setBackgroundImage:[[Env sharedEnv] cacheImage:@"simu_grade_up.png"] forState:UIControlStateNormal];
        buttonUp.showsTouchWhenHighlighted = YES;
        [buttonUp addTarget:self action:@selector(gradeUp:) forControlEvents:UIControlEventTouchUpInside];
        [titleImage addSubview:buttonUp];
        [buttonUp release];
        
        _heroHead = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleImage.frame), CGRectGetMaxY(titleImage.frame)+10, 80, 80)];
        [self addSubview:_heroHead];
        
        _HPLeb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_heroHead.frame), CGRectGetMaxY(_heroHead.frame), CGRectGetWidth(_heroHead.frame), 20)];
        _HPLeb.textAlignment = UITextAlignmentCenter;
        _HPLeb.font = [UIFont systemFontOfSize:14];
        _HPLeb.textColor = [UIColor blackColor];
        _HPLeb.backgroundColor = [UIColor clearColor];
        [self addSubview:_HPLeb];
        
        _MPLeb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_HPLeb.frame), CGRectGetMaxY(_HPLeb.frame), CGRectGetWidth(_HPLeb.frame), CGRectGetHeight(_HPLeb.frame))];
        _MPLeb.textAlignment = UITextAlignmentCenter;
        _MPLeb.font = [UIFont systemFontOfSize:14];
        _MPLeb.textColor = [UIColor blackColor];
        _MPLeb.backgroundColor = [UIColor clearColor];
        [self addSubview:_MPLeb];
        
        
        _equipSimu = [[DSEquipView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)-180, CGRectGetMaxY(titleImage.frame)+10, 180, 120)];
        _equipSimu.backgroundColor = [UIColor clearColor];
        _equipSimu.delegate = self;
        [self addSubview:_equipSimu];
        
               
//        "dota.simu.damage" = "攻击力";
//        "dota.simu.armor" = "护甲";
//        "dota.simu.strength" = "力量";
//        "dota.simu.algor" = "敏捷";
//        "dota.simu.inteli" = "智力";
        
        //damege
        UIImageView *damageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_heroHead.frame)+5,CGRectGetMaxY(_MPLeb.frame)+25,kItemWidth,kItemHeigh)];
        damageView.image = [UIImage imageNamed:@"dota_dam.jpg"];
        [self addSubview:damageView];
        [damageView release];

        UILabel *damLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(damageView.frame)+8,CGRectGetMinY(damageView.frame),kLabelWidth,kLebelHeigh)];
        damLable.backgroundColor = [UIColor clearColor];
        damLable.font = [UIFont systemFontOfSize:14.0f];
        damLable.textColor = [UIColor blackColor];
        damLable.text = NSLocalizedString(@"dota.simu.damage", nil);
        [self addSubview:damLable];
        [damLable release];
        
        _damage = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(damLable.frame), CGRectGetMaxY(damLable.frame)+3, kValueWidth, 20)];
        _damage.font = [UIFont systemFontOfSize:12.0f];
        _damage.backgroundColor = [UIColor clearColor];
        _damage.textColor = [UIColor blackColor];
        [self addSubview:_damage];
        
        self.additionDamage = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_damage.frame), CGRectGetMinY(_damage.frame), kValueWidth, 20)] autorelease];
        self.additionDamage.font = [UIFont systemFontOfSize:12.0f];
        self.additionDamage.backgroundColor = [UIColor clearColor];
        self.additionDamage.textColor = [UIColor greenColor];
        [self addSubview: self.additionDamage];

        
        //armor
        UIImageView *armorView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(damageView.frame),CGRectGetMaxY(_damage.frame)+40,kItemWidth,kItemHeigh)];
        armorView.image = [UIImage imageNamed:@"dota_armo.jpg"];
        [self addSubview:armorView];
        [armorView release];
        
        UILabel *armorLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(armorView.frame)+6,CGRectGetMinY(armorView.frame),kLabelWidth,kLebelHeigh)];
        armorLable.backgroundColor = [UIColor clearColor];
        armorLable.font = [UIFont systemFontOfSize:14.0f];
        armorLable.textColor = [UIColor blackColor];
        armorLable.text = NSLocalizedString(@"dota.simu.armor", nil);
        [self addSubview:armorLable];
        [armorLable release];

        _armor = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_damage.frame), CGRectGetMaxY(armorLable.frame)+3, kValueWidth, 20)];
        _armor.font = [UIFont systemFontOfSize:14.0f];
        _armor.backgroundColor = [UIColor clearColor];
        _armor.textColor = [UIColor blackColor];
        [self addSubview:_armor];
        
        self.additionArmor = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_armor.frame), CGRectGetMinY(_armor.frame), kValueWidth, 20)] autorelease];
        self.additionArmor.font = [UIFont systemFontOfSize:12.0f];
        self.additionArmor.backgroundColor = [UIColor clearColor];
        self.additionArmor.textColor = [UIColor greenColor];
        [self addSubview:self.additionArmor];
        
        //strength
        UIImageView *strengthView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(damLable.frame),CGRectGetMinY(damageView.frame),kItemWidth,kItemHeigh)];
        strengthView.image = [UIImage imageNamed:@"dota_stren.jpg"];
        [self addSubview:strengthView];
        [strengthView release];
        
        UILabel *strengthLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(strengthView.frame)+6,CGRectGetMinY(strengthView.frame),kLabelWidth,kLebelHeigh)];
        strengthLable.backgroundColor = [UIColor clearColor];
        strengthLable.font = [UIFont systemFontOfSize:14.0f];
        strengthLable.text = NSLocalizedString(@"dota.simu.strength", nil);
        [self addSubview:strengthLable];
        strengthLable.textColor = [UIColor blackColor];
        [strengthLable release];

        _strength = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(strengthLable.frame), CGRectGetMaxY(strengthLable.frame), kValueWidth, kLebelHeigh)];
        _strength.font = [UIFont systemFontOfSize:12.0f];
        _strength.backgroundColor = [UIColor clearColor];
        _strength.textColor = [UIColor blackColor];

        [self addSubview:_strength];
        
        
        self.additionStrength = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_strength.frame), CGRectGetMinY(_strength.frame), kAddtionWidth, 20)] autorelease];
        self.additionStrength.font = [UIFont systemFontOfSize:12.0f];
        self.additionStrength.backgroundColor = [UIColor clearColor];
        self.additionStrength.textColor = [UIColor greenColor];
        [self addSubview:self.additionStrength];

        
        //agility
        UIImageView *agilityView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(strengthView.frame),CGRectGetMaxY(_strength.frame)+10,kItemWidth,kItemHeigh)];
        agilityView.image = [UIImage imageNamed:@"dota_algo.jpg"];
        [self addSubview:agilityView];
         
        [agilityView release];
        
        UILabel *agilityLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(strengthLable.frame),CGRectGetMinY(agilityView.frame),kLabelWidth,kLebelHeigh)];
        agilityLable.backgroundColor = [UIColor clearColor];
        agilityLable.font = [UIFont systemFontOfSize:14.0f];
        agilityLable.textColor = [UIColor blackColor];
        agilityLable.text = NSLocalizedString(@"dota.simu.algor", nil);
        [self addSubview:agilityLable];
        [agilityLable release];
        
        _agility = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(agilityLable.frame), CGRectGetMaxY(agilityLable.frame)+3, kValueWidth, kLebelHeigh)];
        _agility.font = [UIFont systemFontOfSize:12.0f];
        _agility.backgroundColor = [UIColor clearColor];
        _agility.textColor = [UIColor blackColor];
        [self addSubview:_agility];
        
        self.additionAgility = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_agility.frame), CGRectGetMinY(_agility.frame), kAddtionWidth, 20)] autorelease];
        self.additionAgility.font = [UIFont systemFontOfSize:12.0f];
        self.additionAgility.backgroundColor = [UIColor clearColor];
        self.additionAgility.textColor = [UIColor greenColor];
        [self addSubview:self.additionAgility];
        //agility
        UIImageView *intelligenceView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(strengthView.frame),CGRectGetMaxY(_agility.frame)+10,kItemWidth,kItemHeigh)];
        
        intelligenceView.image = [UIImage imageNamed:@"dota_inte.jpg"];
        [self addSubview:intelligenceView];
        [intelligenceView release];
        
        UILabel *intelligenceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(strengthLable.frame),CGRectGetMinY(intelligenceView.frame),kLabelWidth,kLebelHeigh)];
        intelligenceLable.backgroundColor = [UIColor clearColor];
        intelligenceLable.font = [UIFont systemFontOfSize:14.0f];
        intelligenceLable.text = NSLocalizedString(@"dota.simu.inteli", nil);
        [self addSubview:intelligenceLable];
        intelligenceLable.textColor = [UIColor blackColor];
        [intelligenceLable release];

        
        _intelligence = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(intelligenceLable.frame), CGRectGetMaxY(intelligenceLable.frame)+6, kValueWidth, kLebelHeigh)];
        _intelligence.font = [UIFont systemFontOfSize:12.0f];
        _intelligence.backgroundColor = [UIColor clearColor];
        _intelligence.textColor = [UIColor blackColor];
        [self addSubview:_intelligence];
        
        
        self.additionIntelligence = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_intelligence.frame), CGRectGetMinY(_intelligence.frame),kAddtionWidth, 20)] autorelease];
        self.additionIntelligence.font = [UIFont systemFontOfSize:12.0f];
        self.additionIntelligence.backgroundColor = [UIColor clearColor];
        self.additionIntelligence.textColor = [UIColor greenColor];
        [self addSubview:self.additionIntelligence];
        
        
        //
       

        _heroHistrory = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(armorView.frame)+20, CGRectGetWidth(self.frame)-20, 10)];
        _heroHistrory.font = [UIFont systemFontOfSize:15.0f];
        _heroHistrory.lineBreakMode = UILineBreakModeWordWrap;
        _heroHistrory.numberOfLines = 0;
        _heroHistrory.backgroundColor = [UIColor clearColor];
        _heroHistrory.textColor = [UIColor blackColor];
        [self addSubview:_heroHistrory];
        
        _addHP = 0;
        _addMP = 0;
        _addArmor = 0.0f;
        _addDamage = 0.0f;
        _addStrength = 0.0f;
        _addAgilityh = 0.0f;
        _addIntelligence = 0.0f;

        
        
    }
    return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext == managedObjectContext) {
        return;
    }
    
    [_managedObjectContext release]; _managedObjectContext = nil;
    _managedObjectContext = [managedObjectContext retain];
    
    _equipSimu.managedObjectContext = _managedObjectContext;
}

-(void)setHero:(HeroInfo *)hero{
    if (_hero == hero) {
        return;
    }
    [_hero release];
    _hero = [hero retain];
    
    _grade = 0;
    [self gradeUp:nil];
}


- (void)gradeDown:(id)sender
{
    if(_grade == 1)
        return;
    _grade--;
    _heroGrade.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"DS.Hero.Grade",@"simulator",nil),_grade];
    
    _baseStrength = [_hero.initialStrength floatValue] + (_grade-1)*[_hero.strengthGrow floatValue];
    _baseAgilityh = [_hero.initialAgility floatValue] + (_grade-1)*[_hero.agilityGrow floatValue];
    _baseIntelligence = [_hero.initialintelligence floatValue] + (_grade-1)*[_hero.intelligenceGrow floatValue];
    
    _baseHP = [_hero.initialHP intValue] + (int)floorf(((_grade-1)*[_hero.strengthGrow floatValue]))*kDftGrowHP;
    _baseMP = [_hero.initialMP intValue] + (int)floorf(((_grade-1)*[_hero.intelligenceGrow floatValue]))*lDftGrowMP;
    
    _HPLeb.text = [NSString stringWithFormat:@"%d", _baseHP+_addHP+(int)_addStrength *kDftGrowHP];
    _MPLeb.text = [NSString stringWithFormat:@"%d", _baseMP+_addMP+(int)_addIntelligence *lDftGrowMP];
    
    _strength.text = [NSString stringWithFormat:@"%d",(int)floorf(_baseStrength)];
    _agility.text = [NSString stringWithFormat:@"%d",(int)floorf(_baseAgilityh)];
    _intelligence.text = [NSString stringWithFormat:@"%d",(int)floorf(_baseIntelligence)];
    
    
    int addDamage = 0;
    switch ([_hero.heroQuality intValue]) {
        case 1:
            addDamage = (int)floorf((_grade-1)*[_hero.strengthGrow floatValue]);
            break;
        case 2:
            addDamage = (int)floorf((_grade-1)*[_hero.agilityGrow floatValue]);
            break;
        case 3:
            addDamage = (int)floorf((_grade-1)*[_hero.intelligenceGrow floatValue]);
            break;
        default:
            break;
    }
    
    int damege1 = [_hero.initialDamage1 intValue]+addDamage;
    int damege2 = [_hero.initialDamage2 intValue]+addDamage;
    
    _damage.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"DS.hero.Damge.Int",@"simulator",nil),damege1,damege2];
    
    _armor.text = [NSString stringWithFormat:@"%0.1f",[_hero.initialArmor floatValue]+ (_grade-1)*[_hero.agilityGrow floatValue]/7];
    
}

- (void)gradeUp:(id)sender
{
    if(_grade == 25)
        return ;
    _grade++;
    _heroGrade.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"DS.Hero.Grade",@"simulator",nil),_grade];
    
    _baseStrength = [_hero.initialStrength floatValue] + (_grade-1)*[_hero.strengthGrow floatValue];
    _baseAgilityh = [_hero.initialAgility floatValue] + (_grade-1)*[_hero.agilityGrow floatValue];
    _baseIntelligence = [_hero.initialintelligence floatValue] + (_grade-1)*[_hero.intelligenceGrow floatValue];
    
    _baseHP = [_hero.initialHP intValue] + (int)floorf(((_grade-1)*[_hero.strengthGrow floatValue]))*kDftGrowHP;
    _baseMP = [_hero.initialMP intValue] + (int)floorf(((_grade-1)*[_hero.intelligenceGrow floatValue]))*lDftGrowMP;
    
    _HPLeb.text = [NSString stringWithFormat:@"%d", _baseHP+_addHP+(int)_addStrength *kDftGrowHP];
    _MPLeb.text = [NSString stringWithFormat:@"%d", _baseMP+_addMP+(int)_addIntelligence *lDftGrowMP];
    
    _strength.text = [NSString stringWithFormat:@"%d",(int)floorf(_baseStrength)];
    _agility.text = [NSString stringWithFormat:@"%d",(int)floorf(_baseAgilityh)];
    _intelligence.text = [NSString stringWithFormat:@"%d",(int)floorf(_baseIntelligence)];
    
    
    int addDamage = 0;
    switch ([_hero.heroQuality intValue]) {
        case 1:
            addDamage = (int)floorf((_grade-1)*[_hero.strengthGrow floatValue]);
            break;
        case 2:
             addDamage = (int)floorf((_grade-1)*[_hero.agilityGrow floatValue]);
            break;
        case 3:
             addDamage = (int)floorf((_grade-1)*[_hero.intelligenceGrow floatValue]);
            break;
        default:
            break;
    }
    
    int damege1 = [_hero.initialDamage1 intValue]+addDamage;
    int damege2 = [_hero.initialDamage2 intValue]+addDamage;
    
    _damage.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"DS.hero.Damge.Int",@"simulator",nil),damege1,damege2];
    
    _armor.text = [NSString stringWithFormat:@"%0.1f",[_hero.initialArmor floatValue]+ (_grade-1)*[_hero.agilityGrow floatValue]/7];
    
    
}


#pragma mark
- (void)DSEquipViewAddition:(AddtionProperty *)addtion{
    BqsLog(@"DSEquipViewAddition :%@",addtion);
    
    _addHP = addtion.addHP;
    _addMP = addtion.addMP;
    _addArmor = addtion.addArmor;
    _addDamage = addtion.addDamage;
    _addStrength = addtion.addStrength ;
    _addAgilityh = addtion.addAgilityh;
    _addIntelligence = addtion.addIntelligence;

    _HPLeb.text = [NSString stringWithFormat:@"%d", _baseHP+_addHP+(int)floorf(_addStrength*kDftGrowHP)];
    _MPLeb.text = [NSString stringWithFormat:@"%d", _baseMP+_addMP+(int)floorf(_addIntelligence*lDftGrowMP)];
    
    int addDamage = 0;
    switch ([_hero.heroQuality intValue]) {
        case 1:
            addDamage = floorf(_addStrength);
            break;
        case 2:
            addDamage = floorf(_addAgilityh);
            break;
        case 3:
            addDamage = floorf(_addIntelligence);
            break;
        default:
            break;
    }
    
    int damageResult = (int)(_addDamage+addDamage);
    if (damageResult == 0) {
        self.additionDamage.hidden = YES;
    }else{
        self.additionDamage.hidden = NO;
        self.additionDamage.text = [NSString stringWithFormat:@"+ %d",damageResult];
    }
    
    CGFloat armorResult = _addArmor+_addAgilityh/7;
    if (armorResult ==0 ) {
        self.additionArmor.hidden = YES;
    }else{
        self.additionArmor.hidden = NO;
        self.additionArmor.text = [NSString stringWithFormat:@"+ %0.1f",armorResult];
    }
    
    if (_addStrength == 0) {
        self.additionStrength.hidden = YES;
    }else{
        self.additionStrength.hidden = NO;
        self.additionStrength.text = [NSString stringWithFormat:@"+ %d",(int)_addStrength];
    }
    
    if (_addAgilityh == 0) {
        self.additionAgility.hidden = YES;
    }else{
        self.additionAgility.hidden = NO;
        self.additionAgility.text = [NSString stringWithFormat:@"+ %d",(int)_addAgilityh];
    }

    if (_addIntelligence == 0) {
        self.additionIntelligence.hidden = YES;
    }else{
        self.additionIntelligence.hidden = NO;
        self.additionIntelligence.text = [NSString stringWithFormat:@"+ %d",(int)_addIntelligence];
    }

    
}



@end
