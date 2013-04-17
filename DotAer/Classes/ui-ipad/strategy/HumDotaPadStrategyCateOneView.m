//
//  HumDotaStrategyCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadStrategyCateOneView.h"
#import "HumDotaPadStrategyCateTwoView.h"

@implementation HumDotaPadStrategyCateOneView

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



-(HumDotaPadCateTowBaseView *)viewForViewController:(HumPadDotaBaseViewController *)ctl frame:(CGRect)frm{
    HumDotaPadStrategyCateTwoView *viewContent = [[[HumDotaPadStrategyCateTwoView alloc] initWithDotaCatFrameViewCtl:ctl Frame:frm] autorelease];
    return viewContent;
}

@end
