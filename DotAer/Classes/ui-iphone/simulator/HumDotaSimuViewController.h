//
//  HumDotaSimuViewController.h
//  DotAer
//
//  Created by Kyle on 13-5-26.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaNoSplitViewController.h"
#import "HumRightViewController.h"


@interface HumDotaSimuViewController : HumDotaNoSplitViewController<rightViewDelegate>

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;

@end
