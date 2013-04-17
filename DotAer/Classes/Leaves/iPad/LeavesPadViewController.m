//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesPadViewController.h"
#import "HMLeavesPadView.h"
#import "HumDotaUIOps.h"
#import "Downloader.h"
#import "HumDotaDataMgr.h"
#import "BqsUtils.h"
#import "HMPopMsgView.h"
#import "DDProgressView.h"
#import "Article.h"
#import "HumLeavesDelegate.h"

@interface LeavesPadViewController ()<HumLeavesDelegate>{
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;
    BOOL _firstLoad;
}
@property (nonatomic, retain, readwrite) HMLeavesPadView *leavesView; // overwrite as readwrite

@property (nonatomic, copy) NSString  *path;
@property (nonatomic, copy) NSString  *string;

@property (nonatomic, copy) NSString  *artUrl;
@property (nonatomic, copy) NSString  *articleId;
@property (nonatomic, copy) NSString  *articlMd5;

@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) DDProgressView *progress;


@end

@implementation LeavesPadViewController
@synthesize leavesView = _leavesView;
@synthesize path = _path;
@synthesize string = _string;
@synthesize downloader;
@synthesize articleId;
@synthesize articlMd5;
@synthesize artUrl;
@synthesize progress;

- (void)dealloc{
    [_leavesView release];_leavesView = nil;
    [_path release]; _path = nil;
    [_string release]; _string = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.articleId = nil;
    self.articlMd5 = nil;
    self.artUrl = nil;
    self.progress = nil;
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

- (id)initWithArtUrl:(NSString *)url articeId:(NSString *)artId articlMd5:(NSString *)md5{
    self  = [super init];
    if (self) {
        
        self.artUrl = url;
        self.articleId = artId;
        self.articlMd5 = md5;
        
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        
        _firstLoad = YES;
        
    }
    return self;
    
}


- (id)initWithArtUrl:(NSString *)url articeId:(NSString *)artId{
    
    return [self initWithArtUrl:url articeId:artId articlMd5:@""];
}


- (id)initWithLocalPath:(NSString *)path{
    self = [super init];
    if (self) {
        _path = [path copy];
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        _firstLoad = YES;
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
        _firstLoad = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    self.downloader.delegate = self;
    
    
    _leavesView = [[HMLeavesPadView alloc] initWithFrame:self.view.bounds];
    _leavesView.delegate = self;
    _leavesView.parentController = self;
    [self.view addSubview:_leavesView];
    
    self.progress = [[[DDProgressView alloc] initWithFrame: CGRectMake(20.0f, 140.0f, self.view.bounds.size.width-40.0f, 0.0f)] autorelease] ;
	[self.progress setOuterColor: [UIColor grayColor]] ;
	[self.progress setInnerColor: [UIColor lightGrayColor]] ;
	[self.view addSubview: self.progress] ;
    self.progress.hidden = YES;
	
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (animated) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    
    if (!_firstLoad) {
        return;
    }
    
    _firstLoad = NO;
    
    if (articleId != nil) {
        Article *content = [[HumDotaDataMgr instance] articleContentOfAritcleID:self.articleId];
        if (content==nil || ![content.articleId isEqualToString:self.articleId]){
            [self.downloader addTask:self.artUrl Target:self Callback:@selector(contentFinishCB:) Attached:nil];
            self.progress.hidden = NO;
            return;
            
        }
    }
    
    [self performSelector:@selector(loadContentForLeaves) withObject:nil afterDelay:0.2];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)loadContentForLeaves{
    if (_string != nil) {
        _leavesView.content = _string;
        
    }else if(_path != nil){
        NSString *text = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:NULL];
        
        _leavesView.content = text;
    }else if(articleId != nil){
        Article *content = [[HumDotaDataMgr instance] articleContentOfAritcleID:self.articleId];
        if (content!=nil && [content.articleId isEqualToString:self.articleId] &&[content.md5 isEqualToString:self.articlMd5] && content.content != nil) {
            _leavesView.content = content.content;
        }
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

#pragma mark
#pragma mark DownloaderCallBack
-(void)DownloadProgres:(CGFloat)percentage{
    [self.progress setProgress: percentage/100] ;
}


- (void)contentFinishCB:(DownloaderCallbackObj *)cb{
    BqsLog(@" contentFinishCB:%@",cb);
    self.progress.hidden = YES;
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:nil Delegate:nil];
        return;
	}
    NSString *content = [[NSString alloc] initWithData:cb.rspData encoding:NSUTF8StringEncoding];
    if (content == nil) {
        return;
    }
    Article *article = [[[Article alloc] init] autorelease];
    _leavesView.content = content;
    article.articleId = self.articleId;
    article.md5 = self.articlMd5;
    article.content = content;
    [[HumDotaDataMgr instance] saveArticleContent:article ArticleID:self.articleId];
    [content release];
    
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
