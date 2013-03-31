//
//  HumDotaStrategyCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaStrategyCateOneView.h"
#import "HumDotaStrategyCateTwoView.h"

@implementation HumDotaStrategyCateOneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewWillAppear{
    [super viewWillAppear];
    [self.topNav setTitle:NSLocalizedString(@"dota.categor.strategy", nil) Show:YES];
    self.topNav.ivRight.hidden = YES;
    self.topNav.btnRight.hidden = YES;
}



-(HumDotaCateTowBaseView *)viewForViewController:(HumDotaBaseViewController *)ctl frame:(CGRect)frm{
    HumDotaStrategyCateTwoView *viewContent = [[[HumDotaStrategyCateTwoView alloc] initWithDotaCatFrameViewCtl:ctl Frame:frm] autorelease];
    return viewContent;
}

@end
