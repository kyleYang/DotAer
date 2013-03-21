//
//  HMImageViewController.h
//  DotAer
//
//  Created by Kyle on 13-3-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMImageViewController : UIViewController

@property (nonatomic, retain) NSArray *imgArray;
@property (nonatomic, retain) NSArray *sumArray;

- (id)initWithImgArray:(NSArray *)imgary SumArray:(NSArray *)sumary;

@end
