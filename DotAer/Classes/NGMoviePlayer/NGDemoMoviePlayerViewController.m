//
//  NGMoviePlayerViewController.m
//  NGMoviePlayerDemo
//
//  Created by Tretter Matthias on 13.03.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGDemoMoviePlayerViewController.h"
#import "HumDotaUserCenterOps.h"
#import "News.h"
#import "Video.h"
#import "HMPopMsgView.h"
#import "MobClick.h"
#import "HumDotaMaco.h"
#import "HumDotaVideoManager.h"
#import "Env.h"
#import "HumDotaDataMgr.h"

#define kScreenHeighOff 70

#define AD_POS_CENTER      -1           //center in horizontal or vertical
#define AD_POS_REWIND      -2           //right or bottom

@interface NGDemoMoviePlayerViewController () {
    NSUInteger activeCount_;
    NSString *_strUrl;
    NSString *_title;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NGMoviePlayer *moviePlayer;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) NSString *strUrl;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL usedDone;

@property (nonatomic, strong) UIView *otherView;
@property (nonatomic, strong) UIButton *favButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UILabel *descript;
@property (nonatomic, strong) UILabel *helpMsg;


@end

@implementation NGDemoMoviePlayerViewController

@synthesize containerView = _containerView;
@synthesize moviePlayer = _moviePlayer;
@synthesize usedDone = _usedDone;
@synthesize strUrl = _strUrl;
@synthesize title = _title;

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////
- (id)initWithNews:(News *)vide{
    self =[super init];
    if (self) {
        self.news = vide;
    }
    return self;
    
}

- (id)initWithVideo:(Video *)vide{
    self =[super init];
    if (self) {
        self.video = vide;
    }
    return self;
    
    
}

- (id)initWithUrl:(NSString *)url title:(NSString *)title{
    self = [super init];
    if (self) {
        _strUrl = url;
        _title = title;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _usedDone =  FALSE;
    self.wantsFullScreenLayout = NO;
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bg.image = [[Env sharedEnv] cacheScretchableImage:@"background.png" X:20 Y:10];
    [self.view addSubview:bg];
    
    
    
    ad_x = -1;//-1;
    ad_y = 0;
    
    self.adView = [AdViewView requestAdViewViewWithDelegate:self];
    //    self.adView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), <#CGFloat height#>)
    [self.view addSubview:self.adView];
    self.adView.hidden = NO;
    
    
    VideoScreenStatus videoState= [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    if (self.news) {
        switch (videoState) {
            case VideoScreenNormal:
                _strUrl = self.news.norContent;
                break;
            case VideoScreenClear:
                _strUrl = self.news.content;
            case VideoScreenHD:
                _strUrl = self.news.hdContent;
            default:
                _strUrl = self.news.content;
                break;
        }
        _title = self.news.title;
    }else if(self.video){
        switch (videoState) {
            case VideoScreenNormal:
                _strUrl = self.video.norContent;
                break;
            case VideoScreenClear:
                _strUrl = self.video.content;
            case VideoScreenHD:
                _strUrl = self.video.hdContent;
            default:
                _strUrl = self.video.content;
                break;
        }
        _title = self.video.title;
        
    }
    
    
    
    
    self.moviePlayer = [[NGMoviePlayer alloc] initWithURL:[NSURL URLWithString:_strUrl] title:_title];
    self.moviePlayer.autostartWhenReady = YES;
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height/2-kScreenHeighOff)];
    self.containerView.backgroundColor = [UIColor underPageBackgroundColor];
    
    self.moviePlayer.delegate = self;
    [self.moviePlayer addToSuperview:self.containerView withFrame:self.containerView.bounds];
    
    [self.view addSubview:self.containerView];
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 44)];
    [self.view addSubview:self.backBtn];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/demoback"] forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"NGMoviePlayer.bundle/demobackdown"] forState:UIControlEventTouchDown];
    //    backBtn.showsTouchWhenHighlighted = YES;
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.backBtn addTarget:self action:@selector(backMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.otherView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.containerView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.containerView.frame))];
    [self.view addSubview:self.otherView];
    
    self.downButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-55, 5, 40, 40)];
    [self.downButton addTarget:self action:@selector(moviePlayerDidDownload:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherView addSubview:self.downButton];
    [self.downButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_download.png"] forState:UIControlStateNormal];
    [self.downButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_download_down.png"] forState:UIControlEventTouchDown];
    
    
    self.favButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.downButton.frame)-55, 2, 40, 40)];
    [self.otherView  addSubview:self.favButton];
    [self.favButton addTarget:self action:@selector(addFavVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav.png"] forState:UIControlStateNormal];
    [self.favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav_did.png"] forState:UIControlStateSelected];
    
    
    self.descript = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.favButton.frame)+10, CGRectGetWidth(self.otherView.bounds)-2*10 , 0)];
    self.descript.font = [UIFont systemFontOfSize:16.0f];
    self.descript.numberOfLines = 0;
    self.descript.backgroundColor = [UIColor clearColor];
    [self.otherView addSubview:self.descript];
    
    self.helpMsg = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.descript.frame), CGRectGetMaxY(self.descript.frame)+10, CGRectGetWidth(self.descript.frame) , 0)];
    self.helpMsg.font = [UIFont systemFontOfSize:16.0f];
    self.helpMsg.numberOfLines = 0;
    self.helpMsg.backgroundColor = [UIColor clearColor];
    [self.otherView addSubview:self.helpMsg];
    
    
    
    
}


#pragma mark
#pragma mark view

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    if (self.news) {
        self.favButton.selected = [[HumDotaDataMgr instance] judgeFavNews:self.news];
        
        CGSize size = [self.news.summary sizeWithFont:self.descript.font constrainedToSize:CGSizeMake(self.descript.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame = self.descript.frame;
        frame.size.height = size.height;
        self.descript.frame = frame;
        self.descript.text = self.news.summary;
        
        //        "detail.progrome.player.help"
        
        size = [NSLocalizedString(@"detail.progrome.player.help", nil) sizeWithFont:self.helpMsg.font constrainedToSize:CGSizeMake(self.helpMsg.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
        frame = self.helpMsg.frame;
        frame.size.height = size.height;
        frame.origin.y = (CGRectGetWidth(self.descript.frame)==0?0:10)+CGRectGetMaxY(self.descript.frame);
        self.helpMsg.frame = frame;
        self.helpMsg.text = NSLocalizedString(@"detail.progrome.player.help", nil);
        
        
        
    }else if(self.video){
        self.favButton.selected = [[HumDotaDataMgr instance] judgeFavVideo:self.video];
        
        CGSize size = [self.video.summary sizeWithFont:self.descript.font constrainedToSize:CGSizeMake(self.descript.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame = self.descript.frame;
        frame.size.height = size.height;
        self.descript.frame = frame;
        self.descript.text = self.video.summary;
        
        size = [NSLocalizedString(@"detail.progrome.player.help", nil) sizeWithFont:self.helpMsg.font constrainedToSize:CGSizeMake(self.helpMsg.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
        frame = self.helpMsg.frame;
        frame.size.height = size.height;
        frame.origin.y = (CGRectGetWidth(self.descript.frame)==0?0:10)+CGRectGetMaxY(self.descript.frame);
        self.helpMsg.frame = frame;
        self.helpMsg.text = NSLocalizedString(@"detail.progrome.player.help", nil);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)updateToOrientation:(UIDeviceOrientation)orientation
{
    //    if (_usedDone) {
    //        return;
    //    }
    
    CGRect bounds = [[ UIScreen mainScreen ] bounds ];
    CGRect videoBounds = [[ UIScreen mainScreen ] bounds ];
    CGAffineTransform t;
    CGFloat r = 0;
    switch (orientation ) {
        case UIDeviceOrientationLandscapeRight:
            r = -(M_PI / 2);
            break;
        case UIDeviceOrientationLandscapeLeft:
            r  = M_PI / 2;
            break;
        default :
            break;
    }
    if( r != 0 ){
        
        CGSize sz = bounds.size;
        bounds.size.width = sz.height;
        bounds.size.height = sz.width;
        videoBounds = bounds;
        
        t = CGAffineTransformMakeRotation( r );
        
        self.backBtn.hidden = YES;
        
        UIApplication *application = [ UIApplication sharedApplication ];
        
        [UIView animateWithDuration:[ application statusBarOrientationAnimationDuration ] delay:0 options:UIViewAnimationCurveEaseInOut animations:^(void){
            self.view.transform = t;
            self.view.bounds = bounds;
            self.view.center = CGPointMake(CGRectGetHeight(bounds)/2, CGRectGetWidth(bounds)/2);
            self.containerView.bounds = videoBounds;
            self.containerView.center = CGPointMake(CGRectGetWidth(videoBounds)/2, CGRectGetHeight(videoBounds)/2);
            self.otherView.frame = CGRectMake(0, CGRectGetMaxY(self.containerView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.containerView.frame));
        }completion:^(BOOL finish){
            self.containerView.center = CGPointMake(CGRectGetWidth(videoBounds)/2, CGRectGetHeight(videoBounds)/2);
        }];
        [application setStatusBarOrientation: orientation animated: YES ];
        
        
        //        videoBounds.origin.y = -120;
        //        videoBounds.origin.y = -140;
        
    }else{
        CGSize sz = bounds.size;
        bounds.size.width = sz.width;
        bounds.size.height = sz.height;
        
        videoBounds.size.width = sz.width;
        videoBounds.size.height = sz.height/2-kScreenHeighOff;
        //        self.wantsFullScreenLayout = NO;
        //        videoBounds.origin.y = 20;
        
        t = CGAffineTransformMakeRotation( r );
        
        UIApplication *application = [ UIApplication sharedApplication ];
        
        [UIView animateWithDuration:[ application statusBarOrientationAnimationDuration ] delay:0 options:UIViewAnimationCurveEaseInOut animations:^(void){
            self.view.transform = t;
            self.view.bounds = bounds;
            self.view.center = CGPointMake(CGRectGetWidth(bounds)/2, CGRectGetHeight(bounds)/2);
            self.containerView.bounds = videoBounds;
            self.containerView.center = CGPointMake(CGRectGetWidth(videoBounds)/2, CGRectGetHeight(videoBounds)/2+10);
            self.otherView.frame = CGRectMake(0, CGRectGetMaxY(self.containerView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.containerView.frame));
        }completion:^(BOOL finish){
            //           self.containerView.frame = videoBounds;
            CGRect frme = self.backBtn.frame;
            frme.origin.y = 20;
            self.backBtn.frame = frme;
            self.backBtn.hidden = NO;
            [self setAdPosition:CGPointMake(AD_POS_CENTER, AD_POS_REWIND)];
        }];
        [application setStatusBarOrientation: orientation animated: YES ];
        
        
    }
    
    
}



#pragma mark - Notifications
- (void)orientationDidChangeNotification:(NSNotification *)notification
{
    //    UIDeviceOrientation orientation = [[ UIDevice currentDevice ] orientation ];
    //    [self updateToOrientation:orientation];
}
- (void)backMethod:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(moviePlayerViewController:didFinishWithResult:error:)]) {
        [_delegate moviePlayerViewController:self didFinishWithResult:NGMoviePlayerCancelled error:nil];
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayer
////////////////////////////////////////////////////////////////////////


- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didChangeControlStyle:(NGMoviePlayerControlStyle)controlStyle {
    
    if (controlStyle == NGMoviePlayerControlStyleInline) {
        _usedDone = FALSE;
        [self updateToOrientation:UIDeviceOrientationPortrait];
        
    } else {
        [self updateToOrientation:UIDeviceOrientationLandscapeLeft];
        _usedDone = YES;
    }
}


- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didFailToLoadURL:(NSURL *)URL {
    NSLog(@"moviePlayer didFailToLoadURL : %@", URL);
    if (_delegate && [_delegate respondsToSelector:@selector(moviePlayerViewController:didFinishWithResult:error:)]) {
        [_delegate moviePlayerViewController:self didFinishWithResult:NGMoviePlayerURLError error:nil];
    }
}


- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didChangePlaybackRate:(float)rate {
    NSLog(@"PlaybackRate chagned %f", rate);
}

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didFinishPlaybackOfURL:(NSURL *)URL {
    NSLog(@"Playbackfinished with Player: %@", moviePlayer);
    if (_delegate && [_delegate respondsToSelector:@selector(moviePlayerViewController:didFinishWithResult:error:)]) {
        [_delegate moviePlayerViewController:self didFinishWithResult:NGMoviePlayerFinished error:nil];
    }
}

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didChangeStatus:(AVPlayerStatus)playerStatus {
    NSLog(@"Status chaned: %d", playerStatus);
}

- (void)moviePlayerDidDownload:(NGMoviePlayer *)moviePlayer{
    
    
    BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
    if (!haveNet) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"detail.video.download.nonetwork", nil) Delegate:self];
        return;
    }
    
    VideoScreenStatus videoState= [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    
    
    [MobClick endEvent:kUmen_video_download_event label:_title];
    BOOL isWifi = [HumDotaUserCenterOps BoolValueForKey:kDftNetTypeWifi];
    if (!isWifi) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"detail.video.3G.download", nil) Delegate:self];
        return;
    }
    
    //    TaskStatusSuccess = 1,
    //    TaskStatusAlready = 2,
    //    TaskStatusExist = 3,
    //    TaskStatusFailed = 4,
    
    //    "video.download.already.downloaded" = "该视频已经存在,请进入视频管理界面管理";
    //    "video.download.already.downloading" = "该视频已经在下载列表,请进入视频管理界面管理";
    //    "video.download.addsuccess" = "添加下载视频成功,请进入视频管理界面管理";
    //    "video.download.failed" = "添加下载视频失败,请稍后重试";
    //    "video.download.unknow" = "未知错误,请稍后重试";
    AddVideoTaskStatus addStatus ;
    NSString *tipsNSString = nil;
    if (self.news) {
        addStatus  =  [[HumDotaVideoManager instance] addDownloadTaskForNews:self.news withStep:videoState];
    }else if(self.video){
        addStatus  =  [[HumDotaVideoManager instance] addDownloadTaskForVideo:self.video withStep:videoState];
    }else{
        tipsNSString = NSLocalizedString(@"video.download.already.downloaded", nil);
        [HMPopMsgView showPopMsgError:nil Msg:tipsNSString Delegate:nil];
        NSLog(@"download not news or video");
        return;
    }
    
    switch (addStatus) {
        case TaskStatusSuccess:
            tipsNSString = NSLocalizedString(@"video.download.addsuccess", nil);
            break;
        case TaskStatusAlready:
            tipsNSString = NSLocalizedString(@"video.download.already.downloading", nil);
            break;
        case TaskStatusExist:
            tipsNSString = NSLocalizedString(@"video.download.already.downloaded", nil);
            break;
        case TaskStatusFailed:
            tipsNSString = NSLocalizedString(@"video.download.failed", nil);
            break;
        default:
            tipsNSString = NSLocalizedString(@"video.download.unknow", nil);
            break;
    }
    
    [HMPopMsgView showPopMsgError:nil Msg:tipsNSString Delegate:nil];
    
    
    
}

- (void)moviePlayer:(NGMoviePlayer *)moviePlayer didPlayStep:(int)setp initialPlaybackTime:(NSTimeInterval)initialPlaybackTime{
    
    
    VideoScreenStatus videoState= [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    if (self.news) {
        switch (videoState) {
            case VideoScreenNormal:
                _strUrl = self.news.norContent;
                break;
            case VideoScreenClear:
                _strUrl = self.news.content;
            case VideoScreenHD:
                _strUrl = self.news.hdContent;
            default:
                _strUrl = self.news.content;
                break;
        }
    }else if(self.video){
        switch (videoState) {
            case VideoScreenNormal:
                _strUrl = self.video.norContent;
                break;
            case VideoScreenClear:
                _strUrl = self.video.content;
            case VideoScreenHD:
                _strUrl = self.video.hdContent;
            default:
                _strUrl = self.video.content;
                break;
        }
        
    }
    
    [self.moviePlayer setURL:[NSURL URLWithString:_strUrl] initialPlaybackTime:initialPlaybackTime];
    
    
    
}


- (void)addFavVideo:(id)sender{
    BOOL success = FALSE;
    if (self.video) {
        success = [[HumDotaDataMgr instance] addFavoVideo:self.video];
    }else if(self.news){
        success = [[HumDotaDataMgr instance] addFavNews:self.news];
    }else{
        BqsLog(@"the source is not news or video");
    }
    if(success){
        self.favButton.selected = !self.favButton.selected;
    }
    
}

#pragma mark
#pragma mark AdView
#pragma mark
#pragma mark adviewdelegate
- (NSString*) adViewApplicationKey {
    return @"SDK20130920090554mg0tb5vbw6n01bc"; // 在 AdView 网站申请的 key.
}
- (UIViewController*) viewControllerForPresentingModalView {
    return self; // 全屏⼲⼴广告附着的控制器.
}
- (BOOL) adViewTestMode {
    return NO; //在测试时返回 YES;
}

- (BOOL)adGpsMode{
    return YES;
}

- (void)adViewDidReceiveAd:(AdViewView *)adViewView{
    self.adView.hidden = NO;
    if (_setVideo) {
        return;
    }
    
    [self setAdPosition:CGPointMake(AD_POS_CENTER, AD_POS_REWIND)];
}

- (void)setAdPosition:(CGPoint)start           //x = -1, means center in horizontal
//y = -1, means center in vertical
{
    _setVideo = YES;
    ad_x = start.x;
    ad_y = start.y;
    
    [self adjustAdSize];
}


- (void)adjustAdSize {
	CGSize adSize = [self.adView actualAdSize];
    
    if (adSize.width <= 0 || adSize.height <= 0) {
        if ([self respondsToSelector:@selector(adViewBannerAnimationType)]
            && AdViewBannerAnimationTypeNone != [self adViewBannerAnimationType])
            return;
    }
    
    //AdVLogInfo(@"AdSize:%@", NSStringFromCGSize(adSize));
    //AdVLogInfo(@"AdFrame:%@", NSStringFromCGRect(self.adView.frame));
    
    CGRect barRect = [UIApplication sharedApplication].statusBarFrame;
    
    CGFloat barHeight = barRect.size.width;
    if (barHeight >= 100) barHeight = barRect.size.height;
    
	CGRect newFrame = self.adView.frame;
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    CGRect winFrame = win.frame;
    
    BOOL        bScreenFrm = YES;
    if (nil != self.adView.superview)
    {
        winFrame = self.adView.superview.frame;
        winFrame.origin.y = 0;
        
        bScreenFrm = NO;
    }
    
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    
    BOOL bIsLand = UIDeviceOrientationIsLandscape(orientation);
    
    
    CGFloat winWidth = winFrame.size.width;
    CGFloat winHeight = winFrame.size.height;
    
    bScreenFrm |= self.bSuperOrientFix;
    if (bScreenFrm && bIsLand) winWidth = winFrame.size.height;
    if (bScreenFrm && bIsLand) winHeight = winFrame.size.width;
    
    CGFloat calHeight = winHeight;
    
    if (bScreenFrm && ![UIApplication sharedApplication].isStatusBarHidden)
        calHeight -= barHeight;
    
	newFrame.size.height = adSize.height;
	newFrame.size.width = adSize.width;
    if (AD_POS_CENTER == ad_x)
        newFrame.origin.x = (winWidth - adSize.width)/2;
    else if (AD_POS_REWIND == ad_x)
        newFrame.origin.x = (winWidth - adSize.width);
    else newFrame.origin.x = ad_x;
    
    if (AD_POS_CENTER == ad_y)
        newFrame.origin.y = (calHeight - adSize.height)/2;
    else if (AD_POS_REWIND == ad_y)
        newFrame.origin.y = (calHeight - adSize.height);
	else newFrame.origin.y = ad_y;
    
    if (bScreenFrm && ![UIApplication sharedApplication].isStatusBarHidden)
        newFrame.origin.y += barHeight;
    
    CGRect rectFrom = newFrame;
    CGRect rectConv = rectFrom;
    
    self.adView.frame = rectConv;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark
#pragma mark rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
};

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end