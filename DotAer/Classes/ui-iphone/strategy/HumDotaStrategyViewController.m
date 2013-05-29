//
//  HumDotaStrategyViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-26.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaStrategyViewController.h"
#import "HumDotaStrategyCateTwoView.h"

@interface HumDotaStrategyViewController ()

@end

@implementation HumDotaStrategyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"dota.categor.strategy", nil);

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kUmeng_strategyPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:kUmeng_strategyPage];
    [super viewWillDisappear:animated];
}


- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView{ // must be rewrite
    return 1;
}

- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index{
    static NSString *identifier = @"cell";
    HumDotaStrategyCateTwoView *cell = (HumDotaStrategyCateTwoView *)[scrollView dequeueCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[HumDotaStrategyCateTwoView alloc] initWithFrame:frame withIdentifier:identifier withController:self] autorelease];
    }
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
