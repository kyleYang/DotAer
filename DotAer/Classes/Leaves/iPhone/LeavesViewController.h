//
//  LeavesViewController.h
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeavesViewController : UIViewController

- (id)initWithLocalPath:(NSString *)path;

- (id)initWithString:(NSString *)string;

- (id)initWithArtUrl:(NSString *)url articeId:(NSString *)artId;

@end
