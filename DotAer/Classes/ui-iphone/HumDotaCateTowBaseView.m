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


- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident withController:(UIViewController *)ctrl
{
    self = [super initWithFrame:frame withIdentifier:ident withController:ctrl];
    if (nil == self) return nil;
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    
    return self;
}


#pragma mark - ifc methods
// view show/hide
-(void)viewWillAppear {
    [super viewWillAppear];
    
}

-(void)viewDidAppear {
    [super viewDidAppear];
}

-(void)viewWillDisappear {
    [self.downloader cancelAll];
    [super viewWillDisappear];
}

-(void)viewDidDisappear {
    [super viewDidAppear];
}

-(void)loadNetworkData:(BOOL)bLoadMore{
    
}

- (BOOL)loadLocalDataNeedFresh{
    return TRUE;
}



-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb{
    
}

//must be rewirte in simulator
-(void)didSelectHero:(HeroInfo *)hero{
    
}
-(void)didSelectEquip:(Equipment *)equip{
    
}

@end
