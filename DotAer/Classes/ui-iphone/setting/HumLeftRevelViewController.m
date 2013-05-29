//
//  HumLeftRevelViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumLeftRevelViewController.h"
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

#import "Downloader.h"
#import "HumDotaDataMgr.h"
#import "M3U8Kit.h"

#import "CustomNavigationBar.h"
#import "HumDotaNewsViewController.h"
#import "HumDotaVideoViewController.h"
#import "HumDotaImageViewController.h"
#import "HumDotaStrategyViewController.h"
#import "HumDotaSimuViewController.h"
#import "HumRightViewController.h"

#define kMainLeftViewRightGap 60


@interface HumLeftRevelViewController ()<UITableViewDataSource,UITableViewDelegate,iVersionDelegate>


@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) HMLeftRightTextCell *cellNews;
@property (nonatomic, retain) HMLeftRightTextCell *cellVideo;
@property (nonatomic, retain) HMLeftRightTextCell *cellImages;
@property (nonatomic, retain) HMLeftRightTextCell *cellCategory;
@property (nonatomic, retain) HMLeftRightTextCell *cellSimulator;

@property (nonatomic, retain) HMLeftRightTextCell *cellMyAccount;

@property (nonatomic, retain) HMLeftRightTextCell *cellClean;
@property (nonatomic, retain) HMLeftRightTextCell *cellCheckNewVersion;
@property (nonatomic, retain) HMLeftRightTextCell *cellFeedback;
@property (nonatomic, retain) HMLeftRightTextCell *cellAppCommit;
@property (nonatomic, retain) HMLeftRightTextCell *cellAppRecommend;
@property (nonatomic, retain) HMLeftRightTextCell *cellAbout;

@property (nonatomic, retain) NSArray *arrSectionTitles; // NSString
@property (nonatomic, retain) NSArray *arrSectionImages; // NSString
@property (nonatomic, retain) NSArray *arrTableCells; // NSArray(NSArray(Cell))

@property (nonatomic, retain) Downloader *downloader;

-(void)onClickItemNews ;
-(void)onClickItemVideo ;
-(void)onClickItemImages ;
-(void)onClickItemStrategy ;
-(void)onClickItemSimulator ;

-(void)onClickMyAccount ;

-(void)onClickCellClean ;
-(void)onClickCheckNewVersion ;
-(void)onClickFeedback ;
-(void)onclickCommit ;
-(void)onclickAppRecommend;
-(void)onClickAbout;



@end

@implementation HumLeftRevelViewController
@synthesize cellNews,cellVideo,cellImages,cellCategory,cellSimulator;
@synthesize tableView;
@synthesize cellMyAccount;
@synthesize cellClean,cellCheckNewVersion,cellFeedback,cellAppCommit,cellAppRecommend,cellAbout;
@synthesize arrSectionTitles,arrSectionImages,arrTableCells;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize downloader;

- (void)dealloc{
    [iVersion sharedInstance].delegate = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.cellNews = nil;
    self.cellVideo = nil;
    self.cellImages = nil;
    self.cellCategory = nil;
    self.cellSimulator = nil;    
    self.cellMyAccount = nil;
    self.cellClean = nil;
    self.cellCheckNewVersion = nil;
    self.cellFeedback = nil;
    self.cellAppCommit = nil;
    self.cellAppRecommend = nil;
    self.cellAbout = nil;
    self.arrSectionTitles = nil;
    self.arrTableCells = nil;
    self.arrSectionImages = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:64.0f/255.0f blue:59.0f/255.0f alpha:1.0f];
    
    [self.revealController setMinimumWidth:260.0f maximumWidth:324.0f forViewController:self];
    self.revealController.animationDuration = 0.35f;
    self.revealController.animationCurve = UIViewAnimationCurveEaseInOut;
    
    CGRect rct = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-kMainLeftViewRightGap, CGRectGetHeight(self.view.bounds));
    
    self.tableView = [[[UITableView alloc] initWithFrame:rct style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:64.0f/255.0f blue:59.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.tableView];
    
    NSMutableArray *arrItem = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *arrBasic = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *arrOther = [NSMutableArray arrayWithCapacity:5];
    
    const float kPaddingHori = 10;
    
//    "dota.buttom.nav.news"="新闻";
//    "dota.buttom.nav.video"="视频";
//    "dota.buttom.nav.photo"="图片";
//    "dota.buttom.nav.strategy"="攻略";
//    "dota.buttom.nav.simulator"="模拟器";
    
    //item
    {
        self.cellNews = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"00"] autorelease];
        self.cellNews.lblLeft.text = NSLocalizedString(@"dota.buttom.nav.news", nil);
        self.cellNews.lblRight.hidden = YES;
        self.cellNews.imgDisclosure.hidden = NO;
        self.cellNews.paddingHori = kPaddingHori;
        [arrItem addObject:self.cellNews];
        
        self.cellVideo = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"01"] autorelease];
        self.cellVideo.lblLeft.text = NSLocalizedString(@"dota.buttom.nav.video", nil);
        self.cellVideo.lblRight.hidden = YES;
        self.cellVideo.imgDisclosure.hidden = NO;
        self.cellVideo.paddingHori = kPaddingHori;
        [arrItem addObject:self.cellVideo];
        
        self.cellImages = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"02"] autorelease];
        self.cellImages.lblLeft.text = NSLocalizedString(@"dota.buttom.nav.photo", nil);
        self.cellImages.lblRight.hidden = YES;
        self.cellImages.imgDisclosure.hidden = NO;
        self.cellImages.paddingHori = kPaddingHori;
        [arrItem addObject:self.cellImages];
        
        self.cellCategory = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"03"] autorelease];
        self.cellCategory.lblLeft.text = NSLocalizedString(@"dota.buttom.nav.strategy", nil);
        self.cellCategory.lblRight.hidden = YES;
        self.cellCategory.imgDisclosure.hidden = NO;
        self.cellCategory.paddingHori = kPaddingHori;
        [arrItem addObject:self.cellCategory];
        
        self.cellSimulator = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"04"] autorelease];
        self.cellSimulator.lblLeft.text = NSLocalizedString(@"dota.buttom.nav.simulator", nil);
        self.cellSimulator.lblRight.hidden = YES;
        self.cellSimulator.imgDisclosure.hidden = NO;
        self.cellSimulator.paddingHori = kPaddingHori;
        [arrItem addObject:self.cellSimulator];

        
    }
    
    
    
    // basic
    {
        self.cellMyAccount = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"10"] autorelease];
        
        self.cellMyAccount.lblLeft.text = NSLocalizedString(@"setting.main.basic.account", nil);
        self.cellMyAccount.lblRight.hidden = YES;
        self.cellMyAccount.imgDisclosure.hidden = NO;
        self.cellMyAccount.paddingHori = kPaddingHori;
        
        [arrBasic addObject:self.cellMyAccount];
    }
    
    //other
    {
        self.cellClean = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"20"] autorelease];
        
        self.cellClean.lblLeft.text = NSLocalizedString(@"setting.main.other.cleanMass", nil);
        self.cellClean.lblRight.hidden = YES;
        self.cellClean.imgDisclosure.hidden = NO;
        self.cellClean.paddingHori = kPaddingHori;
        
        
        //            unsigned int size = [[[MptTvGuideDataMgr instance] onlinePkgFile] getFileSize];
        
        //            NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
        //            self.cellClean.lblRight.text = sizeStr;
        
        [arrOther addObject:self.cellClean];
    }
    
    {
        self.cellCheckNewVersion = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"21"] autorelease];
        
        self.cellCheckNewVersion.lblLeft.text = NSLocalizedString(@"setting.main.other.checknewversion", nil);
        self.cellCheckNewVersion.lblRight.hidden = YES;
        self.cellCheckNewVersion.imgDisclosure.hidden = YES;
        self.cellCheckNewVersion.paddingHori = kPaddingHori;
        
        [arrOther addObject:self.cellCheckNewVersion];
    }
    
    {
        self.cellFeedback = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"22"] autorelease];
        
        self.cellFeedback.lblLeft.text = NSLocalizedString(@"setting.main.other.feedback", nil);
        self.cellFeedback.lblRight.hidden = YES;
        self.cellFeedback.imgDisclosure.hidden = NO;
        self.cellFeedback.paddingHori = kPaddingHori;
        
        [arrOther addObject:self.cellFeedback];
    }
    
    {
        self.cellAppCommit = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"23"] autorelease];
        
        self.cellAppCommit.lblLeft.text = NSLocalizedString(@"setting.main.other.pingfen", nil);
        self.cellAppCommit.lblRight.hidden = YES;
        self.cellAppCommit.imgDisclosure.hidden = YES;
        self.cellAppCommit.paddingHori = kPaddingHori;
        
        [arrOther addObject:self.cellAppCommit];
    }
    // no recommen
    //        {
    //            self.cellAppRecommend = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"24"] autorelease];
    //
    //            self.cellAppRecommend.lblLeft.text = NSLocalizedString(@"setting.main.other.apprecommend", nil);
    //            self.cellAppRecommend.lblRight.hidden = YES;
    //            self.cellAppRecommend.imgDisclosure.hidden = NO;
    //            self.cellAppRecommend.paddingHori = kPaddingHori;
    //
    //            [arrOther addObject:self.cellAppRecommend];
    //        }
    
    
    {
        self.cellAbout = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"25"] autorelease];
        
        self.cellAbout.lblLeft.text = NSLocalizedString(@"setting.main.other.about", nil);
        self.cellAbout.lblRight.hidden = YES;
        self.cellAbout.imgDisclosure.hidden = NO;
        self.cellAbout.paddingHori = kPaddingHori;
        
        [arrOther addObject:self.cellAbout];
    }
    
    
    
    //        self.arrSectionTitles = [NSArray arrayWithObjects:
    //                                 NSLocalizedString(@"setting.main.section.basic", nil),
    //                                 NSLocalizedString(@"setting.main.section.other", nil),
    //                                 nil];
    //        self.arrSectionImages = [NSArray arrayWithObjects:@"setting_user_icon.png",@"setting_user_other.png", nil];
    //        self.arrTableCells = [NSArray arrayWithObjects:
    //                              arrBasic,
    //                              arrOther,
    //                              nil];
    //
    
    //no user
//    "setting.main.section.item" = "栏目";
//    "setting.main.section.basic"="基本信息";
//    "setting.main.section.other"="其他";
    
    self.arrSectionTitles = [NSArray arrayWithObjects:NSLocalizedString(@"setting.main.section.item", nil),
                             NSLocalizedString(@"setting.main.section.other", nil),
                             nil];
    self.arrSectionImages = [NSArray arrayWithObjects:@"setting_user_other.png",@"setting_user_other.png", nil];
    self.arrTableCells = [NSArray arrayWithObjects:arrItem,
                          arrOther,
                          nil];
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
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
    
    if(cell == self.cellNews) [self onClickItemNews];
    else if(cell == self.cellVideo) [self onClickItemVideo];
    else if(cell == self.cellImages) [self onClickItemImages];
    else if(cell == self.cellCategory) [self onClickItemStrategy];
    else if(cell == self.cellSimulator) [self onClickItemSimulator];
    
    else if(cell == self.cellMyAccount) [self onClickMyAccount];
    
    else if(cell == self.cellClean) [self onClickCellClean];
    else if(cell == self.cellCheckNewVersion) [self onClickCheckNewVersion];
    else if(cell == self.cellFeedback) [self onClickFeedback];
    else if(cell == self.cellAppCommit) [self onclickCommit];
    else if(cell == self.cellAppRecommend) [self onclickAppRecommend];
    else if(cell == self.cellAbout) [self onClickAbout];
    else {
        BqsLog(@"Invalid cell: %@", cell);
    }
    
    
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
    return [[self.arrTableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Env *env = [Env sharedEnv];
    
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 23)] autorelease];
    v.backgroundColor = [UIColor colorWithRed:145.0f/255.0f green:117.0f/255.0f blue:98.0f/255.0f alpha:1.0f];
    
    UIImageView *iv = [[[UIImageView alloc] initWithImage:[env cacheImage:[self.arrSectionImages objectAtIndex:section]]] autorelease];
    //    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [v addSubview:iv];
    CGRect frame = iv.frame;
    frame.origin.x = 20;
    frame.origin.y = 5;
    iv.frame = frame;
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = RGBA(0xff, 0xff, 0xff, .5);
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = [self.arrSectionTitles objectAtIndex:section];
    [lbl sizeToFit];
    lbl.center = CGPointMake(CGRectGetMidX(lbl.frame) + 50, CGRectGetMidY(v.bounds));
    [v addSubview:lbl];
    
    return v;
}


#pragma mark
#pragma kCellMethod

-(void)onClickItemNews {
    BqsLog(@"onClickItemNews");
    HumDotaNewsViewController *newsCtl = [[[HumDotaNewsViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:newsCtl wihtOtherViewControle:nil];
}

-(void)onClickItemVideo {
    BqsLog(@"onClickItemVideo");
    HumDotaVideoViewController *videoCtl = [[[HumDotaVideoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:videoCtl wihtOtherViewControle:nil];
}


-(void)onClickItemImages {
    BqsLog(@"onClickItemImages");
    HumDotaImageViewController *imageCtl = [[[HumDotaImageViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:imageCtl wihtOtherViewControle:nil];
}



-(void)onClickItemStrategy {
    BqsLog(@"onClickItemStrategy");
    HumDotaStrategyViewController *strategyCtl = [[[HumDotaStrategyViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:strategyCtl wihtOtherViewControle:nil];
}

-(void)onClickItemSimulator {
    BqsLog(@"onClickItemSimulator");
    HumDotaSimuViewController *simu = [[[HumDotaSimuViewController alloc] init] autorelease];
    HumRightViewController *right = [[[HumRightViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    right.dsDelegate = simu;
    right.managedObjectContext = self.managedObjectContext;
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:simu wihtOtherViewControle:right];
    
   
    
    //    [HumDotaUIOps slideShowModalViewInNavControler:loginVC ParentVCtl:self.parCtl];
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
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:massVcl wihtOtherViewControle:nil];

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
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:feedbackCt wihtOtherViewControle:nil];

//    [HumDotaUIOps slideShowModalViewInNavControler:feedbackCt ParentVCtl:self.parCtl];
}


-(void)onclickCommit {
    BqsLog(@"onclickCommit");
    [[iRate sharedInstance] promptForRating];
}


-(void)onclickAppRecommend {
    BqsLog(@"onclickAppRecommend");
}


-(void)onClickAbout {
    BqsLog(@"onClickAbout");
    HumAboutViewController *about = [[[HumAboutViewController alloc] init] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:about wihtOtherViewControle:nil];
//
////    [HumDotaUIOps slideShowModalViewInNavControler:about ParentVCtl:self.parCtl];
//    
////    [self.downloader addTask:@"http://v.youku.com/player/getRealM3U8/vid/XNTYzMjczOTcy/type/mp4/v.m3u8" DownloadPath:[[HumDotaDataMgr instance] pathofTestM3u8]  Resume:YES Target:self Callback:@selector(finished:) Attached:nil];
//    
//    [self.downloader addTask:@"http://v.youku.com/player/getRealM3U8/vid/XNTYzMjczOTcy/type/mp4/v.m3u8" Target:self Callback:@selector(finished:) Attached:nil];
}

- (void)finished:(DownloaderCallbackObj *)cb{
    
    if (!cb) {
        return;
    }
    
    M3U8SegmentInfoList *M3U8InfoList = [M3U8Parser m3u8SegmentInfoListFromData:cb.rspData baseURL:nil];
    for (int i=0;i< M3U8InfoList.count;i++) {
        M3U8SegmentInfo *segInfo = [M3U8InfoList segmentInfoAtIndex:i];
        BqsLog(@"seginfo :%@ n",segInfo);
        [self.downloader addTask:segInfo.mediaURL.absoluteString DownloadPath:[[HumDotaDataMgr instance] pathofTestM3u8:i]  Resume:YES Target:self Callback:@selector(finished:) Attached:nil];
    }
    
    
}


- (void)mediaFinish:(DownloaderCallbackObj *)cb{
    
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

@end
