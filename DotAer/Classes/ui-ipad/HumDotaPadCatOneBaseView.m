//
//  HumDotaCatOneBaseView.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadCatOneBaseView.h"
#import "BqsUtils.h"



@interface HumDotaPadCatOneBaseView(){
}
@property (nonatomic, readwrite) HumDotaPadTopNav *topNav;

@end

@implementation HumDotaPadCatOneBaseView
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


-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.parCtl = ctl;
    
    self.topNav = [[[HumDotaPadTopNav alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTopNavHeigh)] autorelease];
    [self addSubview:self.topNav];
    
    self.contentView = [[[HumDotaPadCateTowBaseView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topNav.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-CGRectGetMaxY(self.topNav.frame))] autorelease];
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
