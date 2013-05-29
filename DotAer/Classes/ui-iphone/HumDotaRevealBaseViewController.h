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

@interface HumDotaRevealBaseViewController : UIViewController<scrollDataSource,scrollDelegate>


@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) MptContentScrollView *contentView;

@end
