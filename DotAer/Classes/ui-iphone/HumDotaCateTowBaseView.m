//
//  HumDotaCateTowBaseView.m
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCateTowBaseView.h"

@implementation HumDotaCateTowBaseView

@synthesize parCtl;
@synthesize downloader;

-(void)dealloc {
    self.parCtl = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    [super dealloc];
}


-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.parCtl = ctl;
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    
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

-(void)loadNetworkData:(BOOL)bLoadMore{
    
}

- (void)loadLocalData{
    
}

-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb{
    
}

//must be rewirte in simulator
-(void)didSelectHero:(HeroInfo *)hero{
    
}
-(void)didSelectEquip:(Equipment *)equip{
    
}

@end
