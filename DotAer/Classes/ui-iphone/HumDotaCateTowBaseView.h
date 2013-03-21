//
//  HumDotaCateTowBaseView.h
//  DotAer
//
//  Created by Kyle on 13-1-21.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumDotaBaseViewController.h"
#import "Downloader.h"
#import "Env.h"
#import "BqsUtils.h"

@interface HumDotaCateTowBaseView : UIView

@property (nonatomic, assign) HumDotaBaseViewController *parCtl;
@property (nonatomic, retain) Downloader *downloader;

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame;

-(void)loadLocalData;
-(void)loadNetworkData:(BOOL)bLoadMore;

-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb;

-(void)viewWillAppear;
-(void)viewDidAppear;
-(void)viewWillDisappear;
-(void)viewDidDisappear;

@end
