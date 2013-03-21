//
//  LeavesViewController.m
//  DotAer
//
//  Created by Kyle on 13-2-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "LeavesViewController.h"
#import "HMLeavesView.h"
#import "HumDotaUIOps.h"

@interface LeavesViewController ()<HumLeavesDelegate>{
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;
}
@property (nonatomic, retain, readwrite) HMLeavesView *leavesView; // overwrite as readwrite

@property (nonatomic, copy) NSString  *path;
@property (nonatomic, copy) NSString  *string;

@end

@implementation LeavesViewController
@synthesize leavesView = _leavesView;
@synthesize path = _path;
@synthesize string = _string;


- (void)dealloc{
    [_leavesView release];_leavesView = nil;
    [_path release]; _path = nil;
    [_string release]; _string = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithLocalPath:(NSString *)path{
    self = [super init];
    if (self) {
        _path = [path copy];
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;

    }
    return self;
}

- (id)initWithString:(NSString *)string{
    self = [super init];
    if (self) {
         _string = [string copy];
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _leavesView = [[HMLeavesView alloc] initWithFrame:self.view.bounds];
    _leavesView.delegate = self;
    [self.view addSubview:_leavesView];
    
    if (_path) {
        NSString *text = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:NULL];
        
        _leavesView.content = text;

    }else if(_string){
        _leavesView.content = _string;
    }
    
    

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark IOS 6

-(NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;  // 可以修改为任何方向
}

-(BOOL)shouldAutorotate{
    
    return YES;
}

/////////////////////////////////////////////////////
#pragma mark HumLeavesDelegate
////////////////////////////////////////////////////
- (void)humLeavesBack:(HMLeavesView *)leaves{
    [HumDotaUIOps slideDismissModalViewController:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
