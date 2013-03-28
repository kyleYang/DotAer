//
//  HumDotaCatOneBaseView.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCatOneBaseView.h"
#import "BqsUtils.h"



@interface HumDotaCatOneBaseView(){
}
@property (nonatomic, readwrite) HumDotaTopNav *topNav;

@end

@implementation HumDotaCatOneBaseView
@synthesize parCtl;
@synthesize topNav;
@synthesize catTitle;
@synthesize contentView;

-(void)dealloc{
    self.parCtl = nil;
    self.topNav = nil;
    self.catTitle = nil;
    self.contentView = nil;
    [super dealloc];
}


-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.parCtl = ctl;
    
    self.topNav = [[[HumDotaTopNav alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTopNavHeigh)] autorelease];
    [self addSubview:self.topNav];
    
    self.contentView = [[[HumDotaCateTowBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.topNav.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-CGRectGetHeight(self.topNav.frame))] autorelease];
    [self addSubview:self.contentView];
    
    
    return self;
}




#pragma mark - ifc methods
// view show/hide
-(void)viewWillAppear {
}

-(void)viewDidAppear {
    
}

-(void)viewWillDisappear {
}

-(void)viewDidDisappear {
}



//must be rewirte in simulator
-(void)didSelectHero:(HeroInfo *)hero{
    
}
-(void)didSelectEquip:(Equipment *)equip{
    
}


@end
