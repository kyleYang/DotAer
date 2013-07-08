//
//  HumUserCenterViewController.m
//  DotAer
//
//  Created by Kyle on 13-6-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumUserCenterViewController.h"
#import "BqsUtils.h"
#import "PKRevealController.h"
#import "Env.h"
#import "HMLeftRightTextCell.h"
#import "iRate.h"
#import "iVersion.h"
#import "HumMassCleanViewController.h"
#import "HumDotaUIOps.h"
#import "HumFeedbackViewController.h"
#import "HMLogoinViewController.h"
#import "HumAboutViewController.h"
#import "HumLeftTableCell.h"
#import "HumUserCenterCell.h"
#import "HumDotaUserCenterOps.h"
#import "Video.h"

#import "Downloader.h"
#import "HumDotaDataMgr.h"
#import "M3U8Kit.h"
#import "M3u8Downloader.h"

#import "CustomNavigationBar.h"
#import "HumDotaNewsViewController.h"
#import "HumDotaVideoViewController.h"
#import "HumDotaImageViewController.h"
#import "HumDotaStrategyViewController.h"
#import "HumDotaSimuViewController.h"
#import "HumRightViewController.h"
#import "HumDotaDownloaderViewController.h"
#import "HumDotaFavoritViewController.h"
#import "HumPlaySettingViewController.h"
#import "HumDownSettinViewController.h"
#import "HumDotaHelpViewController.h"

#define kMainRightViewRightGap 40

@interface HumUserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,iVersionDelegate,VideoDownloadDelegate>


@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) HumUserCenterCell *downloadCell;
@property (nonatomic, retain) HumUserCenterCell *favCollectCell;

@property (nonatomic, retain) HumUserCenterCell *playSettinCell;
@property (nonatomic, retain) HumUserCenterCell *downSettinCell;

@property (nonatomic, retain) HumUserCenterCell *cellClean;
@property (nonatomic, retain) HumUserCenterCell *cellCheckNewVersion;
@property (nonatomic, retain) HumUserCenterCell *cellFeedback;
@property (nonatomic, retain) HumUserCenterCell *cellAppCommit;
@property (nonatomic, retain) HumUserCenterCell *cellHelp;
@property (nonatomic, retain) HumUserCenterCell *cellAbout;



@property (nonatomic, retain) NSArray *arrTableCells;
@property (nonatomic, retain) Downloader *downloader;


@end


@implementation HumUserCenterViewController
@synthesize arrTableCells;
@synthesize downloader;

@synthesize downloadCell,favCollectCell;
@synthesize playSettinCell,downSettinCell;

@synthesize cellClean,cellCheckNewVersion,cellFeedback,cellAppCommit,cellAbout,cellHelp;


- (void)dealloc{
    self.tableView = nil;
    self.arrTableCells = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    
    self.downloadCell = nil;
    self.favCollectCell = nil;
    
    self.playSettinCell = nil;
    self.downSettinCell = nil;
    
    self.cellClean = nil;
    self.cellCheckNewVersion = nil;
    self.cellFeedback = nil;
    self.cellAppCommit = nil;
    self.cellAbout = nil;
    self.cellHelp = nil;
    
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
    
    [self.revealController setMinimumWidth:280.0f maximumWidth:324.0f forViewController:self];
    self.revealController.animationDuration = 0.35f;
    self.revealController.animationCurve = UIViewAnimationCurveEaseInOut;
    
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(kMainRightViewRightGap, 0, CGRectGetWidth(self.view.bounds), 44)];
    UIImage *bgImg = [[Env sharedEnv] cacheImage:@"dota_frame_title_bg.png"];
    [navBar setCustomBgImage:bgImg];
	[self.view addSubview:navBar];
    [navBar release];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"dota.buttom.nav.usercenter", nil)];
    [navBar pushNavigationItem:navItem animated:false];
    [navItem release];

    self.view.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
      
    CGRect rct = CGRectMake(kMainRightViewRightGap, CGRectGetMaxY(navBar.frame), CGRectGetWidth(self.view.bounds)-kMainRightViewRightGap, CGRectGetHeight(self.view.bounds)- CGRectGetMaxY(navBar.frame));
    
    self.tableView = [[[UITableView alloc] initWithFrame:rct style:UITableViewStyleGrouped] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self.view addSubview:self.tableView];
    
    
    NSMutableArray *arrManager = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *arrSetting = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *arrBasic = [NSMutableArray arrayWithCapacity:5];
    
    
//    "settin.main.manger.downloader" = "下载管理";
//    "settin.main.manger.favorit" = "收藏管理";
//    
//    "setting.main.setting.play" = "播放";
//    "setting.main.setting.downloader" = "下载";
//    
//    "settin.video.qulity.one" = "标清";
//    "settin.video.qulity.two" = "高清";

    
    //manmager
    {
        self.downloadCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"00"] autorelease];
        self.downloadCell.cellType = USCellTypeLeft;
        self.downloadCell.titleLabel.text = NSLocalizedString(@"settin.main.manger.downloader", nil);
        [arrManager addObject:self.downloadCell];
        
        self.favCollectCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"01"] autorelease];
        self.favCollectCell.cellType = USCellTypeLeft;
        self.favCollectCell.titleLabel.text = NSLocalizedString(@"settin.main.manger.favorit", nil);
        [arrManager addObject:self.favCollectCell];
    }
    
    //setting
    {
        self.playSettinCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"10"] autorelease];
        self.playSettinCell.cellType = USCellTypeBoth;
        self.playSettinCell.titleLabel.text = NSLocalizedString(@"setting.main.setting.play", nil);
        [arrSetting addObject:self.playSettinCell];
        
        self.downSettinCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"] autorelease];
        self.downSettinCell.cellType = USCellTypeBoth;
        self.downSettinCell.titleLabel.text = NSLocalizedString(@"setting.main.setting.downloader", nil);
        [arrSetting addObject:self.downSettinCell];

    }

    //other
    {
        self.cellClean = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"20"] autorelease];
        self.cellClean.cellType = USCellTypeLeft;
        self.cellClean.titleLabel.text = NSLocalizedString(@"setting.main.other.cleanMass", nil);
        [arrBasic addObject:self.cellClean];
    
        
        self.cellCheckNewVersion = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"21"] autorelease];
        self.cellCheckNewVersion.cellType = USCellTypeLeft;
        self.cellCheckNewVersion.titleLabel.text = NSLocalizedString(@"setting.main.other.checknewversion", nil);
        [arrBasic addObject:self.cellCheckNewVersion];

        self.cellFeedback = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"22"] autorelease];
        self.cellFeedback.cellType = USCellTypeLeft;
        self.cellFeedback.titleLabel.text = NSLocalizedString(@"setting.main.other.feedback", nil);
        [arrBasic addObject:self.cellFeedback];
        
        self.cellAppCommit = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"23"] autorelease];
        self.cellAppCommit.cellType = USCellTypeLeft;
        self.cellAppCommit.titleLabel.text = NSLocalizedString(@"setting.main.other.pingfen", nil);
        [arrBasic addObject:self.cellAppCommit];
        
        self.cellHelp = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"24"] autorelease];
        self.cellHelp.cellType = USCellTypeLeft;
        self.cellHelp.titleLabel.text = NSLocalizedString(@"setting.main.other.help", nil);
        [arrBasic addObject:self.cellHelp];
        
        self.cellAbout = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"25"] autorelease];
        self.cellAbout.cellType = USCellTypeLeft;
        self.cellAbout.titleLabel.text = NSLocalizedString(@"setting.main.other.about", nil);
        [arrBasic addObject:self.cellAbout];
        
//       "setting.main.other.help" = "使用帮助";
        
        
    }
    self.arrTableCells = [NSArray arrayWithObjects:arrManager,arrSetting,arrBasic, nil];

    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkSetting];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkSetting{
    
    int playStep = [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    switch (playStep) {
        case VideoScreenNormal:
            self.playSettinCell.detailLabel.text = NSLocalizedString(@"settin.video.qulity.one", nil);
            break;
        case VideoScreenClear:
            self.playSettinCell.detailLabel.text = NSLocalizedString(@"settin.video.qulity.two", nil);
            break;
        case VideoScreenHD:
            self.playSettinCell.detailLabel.text = NSLocalizedString(@"settin.video.qulity.three", nil);
            break;
            
        default:
            break;
    }
    
    int downStep = [HumDotaUserCenterOps intValueReadForKey:kScreenDownType];
    switch (downStep) {
        case VideoScreenNormal:
            self.downSettinCell.detailLabel.text = NSLocalizedString(@"settin.video.qulity.one", nil);
            break;
        case VideoScreenClear:
            self.downSettinCell.detailLabel.text = NSLocalizedString(@"settin.video.qulity.two", nil);
            break;
        case VideoScreenHD:
            self.downSettinCell.detailLabel.text = NSLocalizedString(@"settin.video.qulity.three", nil);
            break;
        default:
            break;
    }


}


#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BqsLog(@"select: %d", indexPath.row);
    
    const UITableViewCell *cell = [[self.arrTableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    //    -(void)onClickItemNews ;
    //    -(void)onClickItemVideo ;
    //    -(void)onClickItemImages ;
    //    -(void)onClickItemStrategy ;
    //    -(void)onClickItemSimulator ;
    

    if(cell == self.downloadCell) [self onClickDownloaderManager];
    else if(cell == self.favCollectCell) [self onClickFavoratyManager];
    
    else if(cell == self.playSettinCell) [self onClickPlaySetting];
    else if(cell == self.downSettinCell) [self onClickDownloaderSetting];
    
    else if(cell == self.cellClean) [self onClickCellClean];
    else if(cell == self.cellCheckNewVersion) [self onClickCheckNewVersion];
    else if(cell == self.cellFeedback) [self onClickFeedback];
    else if(cell == self.cellAppCommit) [self onclickCommit];
    else if(cell == self.cellHelp) [self onclickHelp];
    else if(cell == self.cellAbout) [self onClickAbout];
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrTableCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.arrTableCells objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[self.arrTableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setNeedsLayout];
    return cell;
}


//cell method
-(void)onClickDownloaderManager {
    BqsLog(@"onClickDownloaderManager");
    
    
    HumDotaDownloaderViewController *down = [[[HumDotaDownloaderViewController alloc] init] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:down];

}

-(void)onClickFavoratyManager {
    BqsLog(@"onClickFavoratyManager");
    HumDotaFavoritViewController *favCtl = [[[HumDotaFavoritViewController alloc] init] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:favCtl];
    //    [HumDotaUIOps slideShowModalViewInNavControler:loginVC ParentVCtl:self.parCtl];
}

-(void)onClickPlaySetting {
    BqsLog(@"onClickPlaySetting");
    HumPlaySettingViewController *playSetting = [[[HumPlaySettingViewController alloc] init] autorelease];
    
     [HumDotaUIOps revealViewControl:self presentViewControlel:playSetting];
    
    //    [HumDotaUIOps slideShowModalViewInNavControler:loginVC ParentVCtl:self.parCtl];
}


-(void)onClickDownloaderSetting {
    BqsLog(@"onClickDownloaderSetting");
    HumDownSettinViewController *downSetting = [[[HumDownSettinViewController alloc] init] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:downSetting];
}





-(void)onClickMyAccount {
    BqsLog(@"onClickMyAccount");
    HMLogoinViewController *loginVC = [[[HMLogoinViewController alloc] init] autorelease];
    
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:loginVC wihtOtherViewControle:nil];
    
    //    [HumDotaUIOps slideShowModalViewInNavControler:loginVC ParentVCtl:self.parCtl];
}

-(void)onClickCellClean {
    BqsLog(@"onClickCellClean");
    
    HumMassCleanViewController *massVcl = [[[HumMassCleanViewController alloc] init] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:massVcl];
    
    //    [HumDotaUIOps slideShowModalViewInNavControler:massVcl ParentVCtl:self.parCtl];
    
}

-(void)onClickCheckNewVersion {
    BqsLog(@"onClickCheckNewVersion");
    [iVersion sharedInstance].delegate = self;
    [[iVersion sharedInstance] checkForNewVersion];
}

-(void)onClickFeedback {
    BqsLog(@"onClickFeedback");
    HumFeedbackViewController *feedbackCt =[[[ HumFeedbackViewController alloc] init] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:feedbackCt];
    
    //    [HumDotaUIOps slideShowModalViewInNavControler:feedbackCt ParentVCtl:self.parCtl];
}


-(void)onclickCommit {
    BqsLog(@"onclickCommit");
    [[iRate sharedInstance] promptForRating];
}


-(void)onclickAppRecommend {
    BqsLog(@"onclickAppRecommend");
}

- (void)onclickHelp{
    HumDotaHelpViewController *help = [[[HumDotaHelpViewController alloc] initWithTitle:@"" html:@"help"] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:help];
}

-(void)onClickAbout {
    //    BqsLog(@"onClickAbout");
    //    HumAboutViewController *about = [[[HumAboutViewController alloc] init] autorelease];
    //    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:about wihtOtherViewControle:nil];
    //
    ////    [HumDotaUIOps slideShowModalViewInNavControler:about ParentVCtl:self.parCtl];
    //
    ////    [self.downloader addTask:@"http://v.youku.com/player/getRealM3U8/vid/XNTYzMjczOTcy/type/mp4/v.m3u8" DownloadPath:[[HumDotaDataMgr instance] pathofTestM3u8]  Resume:YES Target:self Callback:@selector(finished:) Attached:nil];
    //
    
    
    HumAboutViewController *about = [[[HumAboutViewController alloc] init] autorelease];
    [HumDotaUIOps revealViewControl:self presentViewControlel:about];
    
//    HumDotaDownloaderViewController *about = [[[HumDotaDownloaderViewController alloc] init] autorelease];
//    [HumDotaUIOps revealViewControl:self presentViewControlel:about];
//    
    
    
}

#pragma mark
#pragma mark iversion delegate

- (void)iVersionDidNotDetectNewVersion{
    
    //    "button.cancle" = "取消";
    //    "button.sure" = "确定";
    //    "button.back" = "返回";
    //    "version.no.newversion" = "当前版本已经是最新版本";
    
    UIAlertView *alter =  [[UIAlertView alloc] initWithTitle:nil
                                                     message:NSLocalizedString(@"version.no.newversion", nil)
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"button.sure", nil)
                                           otherButtonTitles:nil,nil];
    [alter show];
    [alter release];
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


@end
