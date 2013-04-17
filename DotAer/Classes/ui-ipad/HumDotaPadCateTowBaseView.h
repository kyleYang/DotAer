//
//  HumDotaCateTowBaseView.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumPadDotaBaseViewController.h"
#import "Downloader.h"
#import "Env.h"
#import "BqsUtils.h"
#import "HeroInfo.h"
#import "Equipment.h"

@interface HumDotaPadCateTowBaseView : UIView

@property (nonatomic, assign) HumPadDotaBaseViewController *parCtl;
@property (nonatomic, retain) Downloader *downloader;

-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame;


-(BOOL)loadLocalDataNeedFresh;
-(void)loadNetworkData:(BOOL)bLoadMore;



-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb;

-(void)viewWillAppear;
-(void)viewDidAppear;
-(void)viewWillDisappear;
-(void)viewDidDisappear;

-(void)didSelectHero:(HeroInfo *)hero;
-(void)didSelectEquip:(Equipment *)equip;


@end
