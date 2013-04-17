//
//  HumDotaNewsCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-1-24.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadNewsCateOneView.h"

@implementation HumDotaPadNewsCateOneView

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
    self.topNav.ivLeft.hidden = YES;
    self.topNav.ivLeft.hidden = YES;
    self.topNav.ivRight.hidden = YES;
    self.topNav.btnRight.hidden = YES;
}



-(HumDotaPadCateTowBaseView *)viewForViewController:(HumPadDotaBaseViewController *)ctl frame:(CGRect)frm{
    frm.size.height += 20;
    HumDotaPadNewsCateTwoView *viewContent = [[[HumDotaPadNewsCateTwoView alloc] initWithDotaCatFrameViewCtl:ctl Frame:frm] autorelease];
    return viewContent;
}


@end
