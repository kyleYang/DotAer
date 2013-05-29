//
//  HumDotaNewsViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaNewsViewController.h"
#import "Env.h"
#import "Downloader.h"
#import "HumDotaNewsCateTwoView.h"



@interface HumDotaNewsViewController ()

@end

@implementation HumDotaNewsViewController

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
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"dota.news.title", nil);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kUmeng_newspage];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:kUmeng_newspage];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView{ // must be rewrite
    return 1;
}

- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index{
    static NSString *identifier = @"cell";
    HumDotaNewsCateTwoView *cell = (HumDotaNewsCateTwoView *)[scrollView dequeueCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[HumDotaNewsCateTwoView alloc] initWithFrame:frame withIdentifier:identifier withController:self] autorelease];
    }
    return cell;
    
}



@end
