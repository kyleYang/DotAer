//
//  HumRightView.h
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumRightBaseView.h"
#import "DSDetailView.h"
#import "HeroInfo.h"
#import "Equipment.h"

@interface HumRightViewController : UIViewController

enum HUMDOTAITEM {
    DOTAHERO = 0,
    DOTAEQUIP = 1,
};



@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, assign) id<DSDetailDelegate>dsDelegate;

@end



