//
//  HumDotaSimuCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSimuCateOneView.h"
#import "HumDotaSimuCateTwoView.h"

@interface HumDotaSimuCateOneView()

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@end 

@implementation HumDotaSimuCateOneView
@synthesize managedObjectContext;

- (void)dealloc{
    self.managedObjectContext = nil;
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame managedObjectContext:(NSManagedObjectContext*)managed
{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
        self.managedObjectContext = managed;
    }
    return self;
}



- (void)viewWillAppear{
    [super viewWillAppear];
    [self.topNav setTitle:NSLocalizedString(@"dota.categor.simulator", nil) Show:YES];
}


-(HumDotaCateTowBaseView *)viewForViewController:(HumDotaBaseViewController *)ctl frame:(CGRect)frm{
    HumDotaSimuCateTwoView *viewContent = [[[HumDotaSimuCateTwoView alloc] initWithDotaCatFrameViewCtl:ctl Frame:frm managedObjectContext:self.managedObjectContext] autorelease];
    return viewContent;
}


// readWite for simulator
-(void)didSelectHero:(HeroInfo *)hero{
    [self.contentView didSelectHero:hero];
    
}

-(void)didSelectEquip:(Equipment *)equip{
    [self.contentView didSelectEquip:equip];

    
}



@end
