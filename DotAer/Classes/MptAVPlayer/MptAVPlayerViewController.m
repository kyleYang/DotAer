//
//  MptAVPlayerViewController.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-4.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerViewController.h"
#import "MptAVPlayer.h"

#define REQUEST_TIMEOUT 60.0

@interface MptAVPlayerViewController ()<NSURLConnectionDataDelegate> {
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;
    NSUInteger _urlIndex;
    BOOL _redirect;
}

@property (nonatomic, retain, readwrite) MptAVPlayer *moviePlayer; // overwrite as readwrite
@property (nonatomic, retain) NSURL *playURL;
@property (nonatomic, retain) NSArray *urlArray; //use for the same video with many url
@property (nonatomic, copy) NSString *name;

@end


@implementation MptAVPlayerViewController
@synthesize moviePlayer = _moviePlayer;
@synthesize mptControlAble = _mptControlAble;
@synthesize call_back;
@synthesize urlArray;
@synthesize playURL;
@synthesize name;

- (void)dealloc
{
    [self.moviePlayer removeFromeSuperView];
    _moviePlayer.delegate = nil;
    NSLog(@"the _moviePlayer retain count = %d", _moviePlayer.retainCount);
    [_moviePlayer release];
    NSLog(@"the _moviePlayer retain count = %d", _moviePlayer.retainCount);
    _moviePlayer = nil;
    self.call_back = nil;
    self.urlArray = nil;
    self.playURL = nil;
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////



- (id)initWithContentURL:(NSURL *)contentURL {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.playURL  = contentURL;
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        
        
        _moviePlayer = [[[[self class] moviePlayerClass] alloc] initWithURL:self.playURL];
        NSLog(@"the _moviePlayer retain count = %d", _moviePlayer.retainCount);
        _moviePlayer.delegate = self;
        _moviePlayer.autostartWhenReady = YES;
        _mptControlAble = FALSE;
        _redirect = FALSE;
        self.urlArray = nil;
    }
    
    return self;
}

- (id)initWithContentString:(NSString *)contentURL {
    
    return [self initWithContentString:contentURL name:@""];
}

- (id)initWithContentString:(NSString *)contentURL name:(NSString*)videoName{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        
        self.playURL= [NSURL URLWithString:contentURL];
        self.name = videoName;
        _moviePlayer = [[[[self class] moviePlayerClass] alloc] initWithURL:self.playURL name:self.name];
        NSLog(@"the _moviePlayer retain count = %d", _moviePlayer.retainCount);
        _moviePlayer.delegate = self;
        _moviePlayer.autostartWhenReady = YES;
        _redirect = FALSE;
        self.urlArray = nil;
    }
    return self;
    
}



- (id)initWithContentURLArray:(NSArray *)playUrlArray{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        
        self.urlArray = playUrlArray;
        NSString *contentURL = nil;
        if (playUrlArray&&[playUrlArray count]!=0) {
            contentURL = [playUrlArray objectAtIndex:0];
        }else{
            return self;
        }
        
        _urlIndex = 0;
        _redirect = FALSE;
        self.playURL = [NSURL URLWithString:contentURL];
        _moviePlayer = [[[[self class] moviePlayerClass] alloc] initWithURL:self.playURL];
        NSLog(@"the _moviePlayer retain count = %d", _moviePlayer.retainCount);
        _moviePlayer.delegate = self;
        _moviePlayer.autostartWhenReady = YES;
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithContentURL:nil];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
////////////////////////////////////////////////////////////////////////

+ (Class)moviePlayerClass {
    return [MptAVPlayer class];
}


- (void)setMptControlAble:(BOOL)value{
    if (_mptControlAble == value) {
        return;
    }
    _mptControlAble = value;
    _moviePlayer.mptControlAble = _mptControlAble;
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.moviePlayer addToSuperview:self.view withFrame:self.view.bounds];
    NSLog(@"the _moviePlayer retain count = %d", _moviePlayer.retainCount);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
//    [self.moviePlayer.view removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (animated) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.moviePlayer play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.moviePlayer pause];
    
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
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark IOS 6

-(NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;  // 可以修改为任何方向
}

-(BOOL)shouldAutorotate{
    
    return YES;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayerDelegate
////////////////////////////////////////////////////////////////////////

- (void)playNextUrl{
    
    _urlIndex ++;
    _redirect = FALSE;
    if (self.urlArray && _urlIndex < self.urlArray.count) {
        NSLog(@"player ulr in array ,the index = %d",_urlIndex);
        NSString *contenUrl = [self.urlArray objectAtIndex:_urlIndex];
        self.playURL = [NSURL URLWithString:contenUrl];
        _moviePlayer.URL = self.playURL;
    }else{
        if (self.call_back && [self.call_back respondsToSelector:@selector(MptAVPlayerViewController:didFinishWithResult:error:)]) {
            [self.call_back MptAVPlayerViewController:self didFinishWithResult:MptAVPlayerURLError error:nil];
        }
    }

    
}


- (void)moviePlayer:(MptAVPlayer *)moviePlayer didChangeControlStyle:(MptAVPlayerControlStyle)controlStyle {
//    if (controlStyle == MptAVPlayerControlStyleInline) {
//        [self dismiss];
//    }
}

- (void)moviePlayer:(MptAVPlayer *)moviePlayer didFinishPlaybackOfURL:(NSURL *)URL {
    if (self.call_back && [self.call_back respondsToSelector:@selector(MptAVPlayerViewController:didFinishWithResult:error:)]) {
        [self.call_back MptAVPlayerViewController:self didFinishWithResult:MptAVPlayerFinished error:nil];
    }
}

- (void)moviePlayer:(MptAVPlayer *)moviePlayer didFailToLoadURL:(NSURL *)URL {
    if (!_redirect) {
        
                   
        _redirect = TRUE;
        
        NSLog(@"player ulr in array ,the index = %d redirect URL = %@",_urlIndex,self.playURL);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.playURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: REQUEST_TIMEOUT];
        NSString *uaStr = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; U; CPU OS 3_2_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B500 Safari/531.21.10"];
        [request setValue:uaStr forHTTPHeaderField:@"User-Agent"];

        
        if(nil == request) {
            [self playNextUrl];
            return;
        }
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        return;
    }
    [self playNextUrl];
}

- (void)moviePlayerDidDismissPlay:(MptAVPlayer *)moviePlayer
{
    if (self.call_back && [self.call_back respondsToSelector:@selector(MptAVPlayerViewController:didFinishWithResult:error:)]) {
        [self.call_back MptAVPlayerViewController:self didFinishWithResult:MptAVPlayerCancelled error:nil];
    }
}

- (void)moviePlayer:(MptAVPlayer *)moviePlayer didClickOtt:(id)sender{
    if (self.call_back && [self.call_back respondsToSelector:@selector(MptAVPlayerViewControllerDidClickOtt:)]) {
        [self.call_back MptAVPlayerViewControllerDidClickOtt:self];
    }
}


#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
      NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)response;
     [theConnection cancel];
    if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *headDic= [httpResponse allHeaderFields];
        if (headDic){
            NSString *redirectUrl = [headDic valueForKey:@"Location"];
            if (redirectUrl && redirectUrl.length>0) {
                NSLog(@"the redirect location URL = %@",redirectUrl);
                _moviePlayer.URL = [NSURL URLWithString:redirectUrl];
                return;
            }
            
        }
    }
    
   [self playNextUrl];

}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    NSString *msg = [error localizedDescription];
    NSLog(@"didFailWithError: %@ Msg:%@", error,msg);
    [theConnection cancel];
    
    [self playNextUrl];
}



////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)dismiss {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}








@end
