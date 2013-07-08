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
#import "HumAppDelegate.h"

#define AD_POS_CENTER      -1           //center in horizontal or vertical
#define AD_POS_REWIND      -2           //right or bottom

@interface HumDotaRevealBaseViewController (){
    BOOL _setVideo;
}

@end

@implementation HumDotaRevealBaseViewController
@synthesize downloader;
@synthesize adView;
@synthesize bSuperOrientFix;

- (void)dealloc{
    [self.downloader cancelAll];
    self.downloader = nil;
    self.contentView = nil;
    self.adView = nil;
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
    UIImage *revealLeftImageLandscape = [env cacheImage:@"dota_frame_option_down.png"];
    
    UIImage *revealRightImagePortrait = [env cacheImage:@"dota_frame_setting.png"];
    UIImage *revealRightImageLandscape = [env cacheImage:@"dota_frame_setting_down.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:revealLeftImagePortrait eventImg:revealLeftImageLandscape title:nil target:self action:@selector(showLeftView:)];
    }
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeRight)
    {
        self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:revealRightImagePortrait eventImg:revealRightImageLandscape title:nil target:self action:@selector(showRgihtView:)];
    }
    
    _setVideo = FALSE;
    
    self.contentView = [[[MptContentScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.dataSource = self;
    self.contentView.delegate = self;
    [self.view addSubview:self.contentView];
    
    ad_x = -1;//-1;
    ad_y = 0;
    
    self.adView = [AdViewView requestAdViewViewWithDelegate:self];
//    self.adView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), <#CGFloat height#>)
    [self.view addSubview:self.adView];
    self.adView.hidden = NO;
    
    
   

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
#pragma mark adviewdelegate
- (NSString*) adViewApplicationKey {
    return @"SDK20130920090554mg0tb5vbw6n01bc"; // 在 AdView 网站申请的 key.
}
- (UIViewController*) viewControllerForPresentingModalView {
        return [self navigationController]; // 全屏⼲⼴广告附着的控制器.
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


- (void)pushNotificationNews:(News *)info{
    BqsLog(@"pushNotificationNews news",info);

   [MobClick event:kUmeng_news_cell_event label:info.title];
    
    switch (info.category) {
        case HumDotaNewsTypeText:
        {
            LeavesViewController *leaves = [[[LeavesViewController alloc] initWithArtUrl:info.content articeId:info.newsId articlMd5:info.md5] autorelease];
            [HumDotaUIOps slideShowModalViewControler:leaves ParentVCtl:self];
        }
            break;
        case HumDotaNewsTypeImages:
        {
            NSMutableArray *arry = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *sumAry = [NSMutableArray arrayWithCapacity:10];
            for (NewsImg *newsImg in info.imgeArry) {
                
                [arry addObject:newsImg.url ];
                [sumAry addObject:newsImg.introduce];
            }
            
            HMImageViewController *image = [[[HMImageViewController alloc] initWithImgArray:arry SumArray:sumAry] autorelease];
            image.modalPresentationStyle = UIModalPresentationFullScreen;
            [HumDotaUIOps slideShowModalViewControler:image ParentVCtl:self];
            
        }
            break;
        case HumDotaNewsTypeVideo:
        {
            
            BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
            if (!haveNet) {
                [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"title.nonetwork.cannot.paly", nil) Delegate:nil];
                return;
            }
            
            
            NSString *localPlayM3u8 = [[HumDotaVideoManager instance] localPlayPathForVideo:info.youkuId];
            
            if(localPlayM3u8){
                
                NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithUrl:localPlayM3u8 title:info.title] autorelease];
                play.delegate = self;
                //    play.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                [self presentModalViewController:play animated:YES];
                return;
            }
            
            
            BOOL isWifi = [HumDotaUserCenterOps BoolValueForKey:kDftNetTypeWifi];
            if (!isWifi) {
                [HMPopMsgView showChaoseAlertError:nil Msg:NSLocalizedString(@"title.network.3G.play", nil) delegate:self];
                return;
            }
            NSString *titleName = info.title;
            NSArray *nameAry = [info.title componentsSeparatedByString:@"]"];
            if (nameAry && nameAry.count>0) {
                titleName = [nameAry lastObject];
            }
            
            NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithNews:info] autorelease];
            play.delegate = self;
            [self presentModalViewController:play animated:YES];
        }
            
            break;
        default:
            break;
    }
    
}


#pragma mark -
#pragma mark MptAVPlayerViewController_Callback
- (void)moviePlayerViewController:(NGDemoMoviePlayerViewController *)ctl didFinishWithResult:(NGMoviePlayerResult)result error:(NSError *)error{
    
    NSString *resultString = @"";
    
    switch (result) {
        case NGMoviePlayerCancelled:
            resultString = NSLocalizedString(@"detail.progrome.player.cancle", nil);
            break;
        case NGMoviePlayerFinished:
            resultString = NSLocalizedString(@"detail.progrome.player.fininsh", nil);
            break;
        case NGMoviePlayerURLError:
            resultString = NSLocalizedString(@"detail.progrome.player.urleror", nil);
            break;
        case NGMoviePlayerFailed:
            resultString = NSLocalizedString(@"detail.progrome.player.failed", nil);
            break;
        default:
            break;
    }
    
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    if ([osVersion floatValue] >= 5.0) {
        [ctl dismissViewControllerAnimated:YES completion:^(void){
            [HMPopMsgView showPopMsg:resultString];
        }];
    }else{
        [ctl dismissModalViewControllerAnimated:YES];
        [self performSelector:@selector(messageNotice:) withObject:[[resultString retain] autorelease] afterDelay:0.2];
    }
    
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

- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
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
