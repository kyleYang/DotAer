//
//  HumDotaRevealBaseViewController.h
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Env.h"
#import "BqsUtils.h"
#import "Downloader.h"
#import "MptContentScrollView.h"
#import "HumDotaMaco.h"
#import "MobClick.h"
#import "AdViewView.h"
#import "AdViewDelegateProtocol.h"
#import "News.h"
#import "LeavesViewController.h"
#import "HumTypeConstant.h"
#import "HumDotaUIOps.h"
#import "HMImageViewController.h"
#import "HumDotaUserCenterOps.h"
#import "HMPopMsgView.h"
#import "HumDotaVideoManager.h"
#import "NGDemoMoviePlayerViewController.h"

@interface HumDotaRevealBaseViewController : UIViewController<scrollDataSource,scrollDelegate,MoviePlayerViewControllerDelegate,AdViewDelegate>{
     AdViewView *_adView;
     BOOL                bSuperOrientFix;
     CGFloat             ad_x;         //-1 means center in horizontal
     CGFloat             ad_y;         //-1 means center in vertical

}


@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) MptContentScrollView *contentView;
@property (nonatomic, retain) AdViewView* adView;
@property (nonatomic,assign) BOOL bSuperOrientFix;

- (void)pushNotificationNews:(News *)info;

@end
