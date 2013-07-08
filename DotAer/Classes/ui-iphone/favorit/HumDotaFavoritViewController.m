//
//  HumDotaFavoritViewController.m
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaFavoritViewController.h"
#import "CustomUIBarButtonItem.h"
#import "HumDotaUIOps.h"
#import "HumDotaFavoritNewsView.h"
#import "HumDotaFavoritVideoView.h"
#import "HumDotaFavoritImageView.h"
#import "HumDotaFavoritStrategyView.h"

@interface HumDotaFavoritViewController ()

@end

@implementation HumDotaFavoritViewController

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
    
    self.title = NSLocalizedString(@"dota.navigation.title.favorit.manager", nil);
    
//    "dota.buttom.nav.news"="新闻";
//    "dota.buttom.nav.video"="视频";
//    "dota.buttom.nav.photo"="图片";
//    "dota.buttom.nav.strategy"="攻略";
    
	// Do any additional setup after loading the view.
    
    
    self.arrCateTwo = [NSArray arrayWithObjects:[NSArray arrayWithObjects: NSLocalizedString(@"dota.buttom.nav.news", nil), NSLocalizedString(@"dota.buttom.nav.video", nil), NSLocalizedString(@"dota.buttom.nav.photo", nil), NSLocalizedString(@"dota.buttom.nav.strategy", nil), nil],nil];
    
    self.arrCatList = [NSArray arrayWithObjects:self.arrCateTwo, nil];
    self.arrCateOne = [NSArray arrayWithObjects:@"test", nil];
    
//    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    bg.image = [[Env sharedEnv] cacheScretchableImage:@"background.png" X:20 Y:10];
//    [self.view addSubview:bg];
//    [bg release];
    
    
    
    //LeftBack Button;
    {
        
        
        NSString *leftBarName = NSLocalizedString(@"button.done", nil);
        self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:[[Env sharedEnv] cacheScretchableImage:@"pg_bar_done.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[[Env sharedEnv] cacheScretchableImage:@"pg_bar_donedown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(onLeftBackButtonClick)];
        
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
    [MobClick beginLogPageView:kUmeng_favoritPage];
}

- (void)viewWillDisappear:(BOOL)animated{
   [MobClick endLogPageView:kUmeng_favoritPage];
    [super viewWillDisappear:animated];
}


- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView{ // must be rewrite
    return 4;
}

- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index{
    static NSString *newsIdent = @"newscell";
    static NSString *videoIdent = @"videocell";
    static NSString *imageIdent = @"imagecell";
    static NSString *strategyIdent = @"strategycell";
    
    if (index == 0) {
        HumDotaFavoritNewsView *cell = (HumDotaFavoritNewsView *)[scrollView dequeueCellWithIdentifier:newsIdent];
        if (!cell) {
            cell = [[[HumDotaFavoritNewsView alloc] initWithFrame:frame withIdentifier:newsIdent withController:self] autorelease];
        }
        return cell;

        
    }else if(index == 1){
        HumDotaFavoritVideoView *cell = (HumDotaFavoritVideoView *)[scrollView dequeueCellWithIdentifier:videoIdent];
        if (!cell) {
            cell = [[[HumDotaFavoritVideoView alloc] initWithFrame:frame withIdentifier:videoIdent withController:self] autorelease];
        }
        return cell;
    }else if(index == 2){
        
        HumDotaFavoritImageView *cell = (HumDotaFavoritImageView *)[scrollView dequeueCellWithIdentifier:imageIdent];
        if (!cell) {
            cell = [[[HumDotaFavoritImageView alloc] initWithFrame:frame withIdentifier:imageIdent withController:self] autorelease];
        }
        return cell;
        
    }else if(index == 3){
        HumDotaFavoritStrategyView *cell = (HumDotaFavoritStrategyView *)[scrollView dequeueCellWithIdentifier:strategyIdent];
        if (!cell) {
            cell = [[[HumDotaFavoritStrategyView alloc] initWithFrame:frame withIdentifier:strategyIdent withController:self] autorelease];
        }
        return cell;
        
    }else{
        return nil;
    }
    
    
    
    
}


#pragma mark
#pragma mark rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
};

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



- (void)onLeftBackButtonClick{
    [HumDotaUIOps popUIViewControlInNavigationControl:self];
}


@end
