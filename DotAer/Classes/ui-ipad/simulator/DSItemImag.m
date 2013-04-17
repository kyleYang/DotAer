//
//  DSItemImag.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "DSItemImag.h"
#import "SimuImageHelp.h"


@implementation DSItemImag
@synthesize hero = _hero;
@synthesize equip = _equip;
@synthesize imageView;
@synthesize goods;
@synthesize autoRemove;
@synthesize hasMatch;
@synthesize isFormula = _isFormula;
-(void)dealloc
{
    [_hero release]; _hero = nil;
    [_equip release]; _equip = nil;
    self.imageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.goods = FALSE;
        self.autoRemove = FALSE;
        self.hasMatch = FALSE;
        _isFormula = FALSE;
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))] autorelease];
        [self addSubview:self.imageView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self){
        self.goods = FALSE;
        self.autoRemove = FALSE;
        self.hasMatch = FALSE;
        _isFormula = FALSE;
        self.imageView = [[[UIImageView alloc] init] autorelease];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setHero:(HeroInfo *)ahero
{
    [_hero release]; _hero = nil;
    _hero = [ahero retain];
    [_equip release]; _equip = nil;
    if(_hero){
        NSLog(@"the imageName is %@",_hero.heroImage);
        UIImage *img = [SimuImageHelp imageForHeroSN:_hero.heroSN WithFileName:_hero.heroImage];
        self.imageView.image = img;
    }else{ //defalut Image
        self.imageView.image = nil;
    }
}

- (void)setEquip:(Equipment *)aequip
{
    [_equip release]; _equip = nil;
    _equip = [aequip retain];
    [_hero release]; _hero = nil;
    if(_equip){
        if(self.goods){
            if(_isFormula)
                self.imageView.image = [UIImage imageNamed:@"item__500.jpeg"];
            else
                self.imageView.image = [SimuImageHelp imageForEquipWithFileName:_equip.equipImage];

        }else {
            NSLog(@"the imageName is %@",_equip.equipImage);
            self.imageView.image = [SimuImageHelp imageForEquipWithFileName:_equip.equipImage];
        }
    }else{ //default Image
        self.imageView.image = nil;
    }
    
}

- (void)setIsFormula:(BOOL)aFormula
{
    _isFormula = aFormula;
    if(_equip){
    if (_isFormula) {
        self.imageView.image = [UIImage imageNamed:@"item__500.jpeg"];
    }else{
        self.imageView.image = [SimuImageHelp imageForEquipWithFileName:_equip.equipImage];
    }
    }
}


@end
