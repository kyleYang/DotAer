//
//  HumDotaNewsCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-1-24.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaNewsCateOneView.h"

@implementation HumDotaNewsCateOneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)viewWillAppear{
    [super viewWillAppear];
    [self.topNav setTitle:NSLocalizedString(@"dota.news.title", nil) Show:YES];
    self.topNav.ivRight.hidden = YES;
    self.topNav.btnRight.hidden = YES;
}



-(HumDotaCateTowBaseView *)viewForViewController:(HumDotaBaseViewController *)ctl frame:(CGRect)frm{
    HumDotaNewsCateTwoView *viewContent = [[[HumDotaNewsCateTwoView alloc] initWithDotaCatFrameViewCtl:ctl Frame:frm] autorelease];
    return viewContent;
}


@end
