//
//  HumDotaRevealBaseViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaRevealBaseViewController.h"
#import "PKRevealController.h"
#import "CustomUIBarButtonItem.h"


@interface HumDotaRevealBaseViewController ()

@end

@implementation HumDotaRevealBaseViewController
@synthesize downloader;

- (void)dealloc{
    [self.downloader cancelAll];
    self.downloader = nil;
    self.contentView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Env *env= [Env sharedEnv];
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    
    UIImage *revealLeftImagePortrait = [env cacheImage:@"dota_frame_option.png"];
    UIImage *revealLeftImageLandscape = [env cacheImage:@"dota_frame_option.png"];
    
    UIImage *revealRightImagePortrait = [env cacheImage:@"dota_frame_setting.png"];
    UIImage *revealRightImageLandscape = [env cacheImage:@"dota_frame_setting.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:revealLeftImagePortrait eventImg:revealLeftImageLandscape title:nil target:self action:@selector(showLeftView:)];
    }
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeRight)
    {
        self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:revealRightImagePortrait eventImg:revealRightImageLandscape title:nil target:self action:@selector(showRgihtView:)];
    }


    
    self.contentView = [[[MptContentScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.dataSource = self;
    self.contentView.delegate = self;
    [self.view addSubview:self.contentView];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contentView reloadDataInitOffset:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.downloader cancelAll];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


#pragma mark
#pragma mark barbutton method
- (void)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)showRgihtView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.rightViewController];
    }
}


- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView{ // must be rewrite
    return 0;
}

- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index{
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
