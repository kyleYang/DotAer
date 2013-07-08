//
//  HumRightView.h
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumRightBaseView.h"
#import "HeroInfo.h"
#import "Equipment.h"

@protocol rightViewDelegate;

@interface HumRightViewController : UIViewController

enum HUMDOTAITEM {
    DOTAHERO = 0,
    DOTAEQUIP = 1,
};


@property (nonatomic, assign) id<rightViewDelegate> delegate;
@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;


@end


@protocol rightViewDelegate <NSObject>

-(void)didSelectHero:(HeroInfo *)hero;

-(void)didSelectEquip:(Equipment *)equip;

@end



