//
//  HumDotaSimuViewController.h
//  DotAer
//
//  Created by Kyle on 13-5-26.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaNoSplitViewController.h"
#import "DSDetailView.h"


@interface HumDotaSimuViewController : HumDotaNoSplitViewController<DSDetailDelegate>

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@end
