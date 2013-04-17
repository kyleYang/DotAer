//
//  HMImageViewController.m
//  DotAer
//
//  Created by Kyle on 13-3-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HMImageViewController.h"
#import "HMImageScrollView.h"
#import "HumDotaUIOps.h"

@interface HMImageViewController ()<HMImageScrollDataSource,HMImageScrollDelegate>{
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;

}

@property (nonatomic, retain) HMImageScrollView *scrollView;



@end

@implementation HMImageViewController
@synthesize scrollView =_scrollView;
@synthesize imgArray = _imgArray;
@synthesize sumArray = _sumArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_scrollView release];_scrollView = nil;
    [_imgArray release]; _imgArray = nil;
    [_sumArray release]; _sumArray = nil;
    [super dealloc];
}

- (id)initWithImgArray:(NSArray *)imgary SumArray:(NSArray *)sumary{
    self = [super init];
    if (self) {
        _imgArray = [imgary retain];
        _sumArray = [sumary retain];
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    }
    return  self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"self.view.bounds width:%f,heigh:%f",self.view.bounds.size.width,self.view.bounds.size.height);
    self.view.backgroundColor = [UIColor clearColor];

   
    _scrollView = [[HMImageScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _scrollView.dataSource = self;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (animated) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    if (animated) {
        [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHidden withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHidden withAnimation:UIStatusBarAnimationNone];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:animated];
}




#pragma mark IOS < 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark IOS 6

-(NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskPortrait;  // 可以修改为任何方向
}

-(BOOL)shouldAutorotate{
    
    return YES;
}

- (void)setImgArray:(NSArray *)imgArray{
    [_imgArray release]; _imgArray = nil;
    _imgArray = [imgArray retain];
    [_scrollView reloadData];
}

- (void)setSumArray:(NSArray *)sumArray{
    [_sumArray release]; _sumArray = nil;
    _imgArray = [sumArray retain];
    [_scrollView reloadData];
}


#pragma mark
#pragma mark HMImageScrollDataSource

- (NSUInteger)numberOfItemFor:(HMImageScrollView *)scrollView{
    NSLog(@"Total number :%d",[_imgArray count]);
    return [_imgArray count];
}


- (NSString *)imageUrlForScrollView:(HMImageScrollView *)scrollView AtIndex:(NSUInteger)index{
    if (index >= [_imgArray count]) {
        return @"";
    }
    
    return [_imgArray objectAtIndex:index];
}


- (NSString *)summaryForScrollView:(HMImageScrollView *)scrollView AtIndex:(NSUInteger)index{
    if (index >= [_sumArray count]) {
        return @"";
    }
    return [_sumArray objectAtIndex:index];
    
}

/////////////////////////////////////////////////////
#pragma mark HumLeavesDelegate
//////////////////////////////////////////////////
- (void)humImageViewBack:(HMImageScrollView *)scroll{
    [HumDotaUIOps slideDismissModalViewController:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
