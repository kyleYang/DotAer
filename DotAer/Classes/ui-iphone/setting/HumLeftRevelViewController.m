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
#import "HumLeftTableCell.h"

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

#import "HumUserCenterViewController.h"

#define kMainLeftViewRightGap 60


@interface HumLeftRevelViewController ()<UITableViewDataSource,UITableViewDelegate,iVersionDelegate,VideoDownloadDelegate>


@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) HumLeftTableCell *cellNews;
@property (nonatomic, retain) HumLeftTableCell *cellVideo;
@property (nonatomic, retain) HumLeftTableCell *cellImages;
@property (nonatomic, retain) HumLeftTableCell *cellCategory;
@property (nonatomic, retain) HumLeftTableCell *cellSimulator;



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
@synthesize arrTableCells;
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
    self.arrTableCells = nil;
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
    
    [self.revealController setMinimumWidth:180.0f maximumWidth:324.0f forViewController:self];
    self.revealController.animationDuration = 0.25f;
    self.revealController.animationCurve = UIViewAnimationCurveEaseInOut;
    
    CGRect rct = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-kMainLeftViewRightGap, CGRectGetHeight(self.view.bounds));
    
    self.tableView = [[[UITableView alloc] initWithFrame:rct style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:42.0f/255.0f green:44.0f/255.0f blue:43.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.tableView];
    
    NSMutableArray *arrItem = [NSMutableArray arrayWithCapacity:5];
   
    
    const float kPaddingHori = 10;
    
//    "dota.buttom.nav.news"="新闻";
//    "dota.buttom.nav.video"="视频";
//    "dota.buttom.nav.photo"="图片";
//    "dota.buttom.nav.strategy"="攻略";
//    "dota.buttom.nav.simulator"="模拟器";
    
    Env *env = [Env sharedEnv];
    
    //item
    {
        self.cellNews = [[[HumLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"00"] autorelease];
        self.cellNews.nameLabel.text = NSLocalizedString(@"dota.buttom.nav.news", nil);
        self.cellNews.logoImage.image = [env cacheImage:@"lfte_news.png"];
        [arrItem addObject:self.cellNews];
        
        self.cellVideo = [[[HumLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"01"] autorelease];
        self.cellVideo.nameLabel.text = NSLocalizedString(@"dota.buttom.nav.video", nil);
        self.cellVideo.logoImage.image = [env cacheImage:@"lfte_video.png"];
        [arrItem addObject:self.cellVideo];
        
        self.cellImages = [[[HumLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"02"] autorelease];
        self.cellImages.nameLabel.text = NSLocalizedString(@"dota.buttom.nav.photo", nil);
        self.cellImages.logoImage.image = [env cacheImage:@"lfte_image.png"];
        [arrItem addObject:self.cellImages];
        
        self.cellCategory = [[[HumLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"03"] autorelease];
        self.cellCategory.nameLabel.text = NSLocalizedString(@"dota.buttom.nav.strategy", nil);
        self.cellCategory.logoImage.image = [env cacheImage:@"lfte_catetory.png"];
        [arrItem addObject:self.cellCategory];
        
        self.cellSimulator = [[[HumLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"04"] autorelease];
        self.cellSimulator.nameLabel.text = NSLocalizedString(@"dota.buttom.nav.simulator", nil);
        self.cellSimulator.logoImage.image = [env cacheImage:@"lfte_simulate.png"];
        [arrItem addObject:self.cellSimulator];

        
    }
    
    
    

    self.arrTableCells = [NSArray arrayWithObjects:arrItem,
                          nil];
    
    
    
    

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
    
    if(cell == self.cellNews) [self onClickItemNews];
    else if(cell == self.cellVideo) [self onClickItemVideo];
    else if(cell == self.cellImages) [self onClickItemImages];
    else if(cell == self.cellCategory) [self onClickItemStrategy];
    else if(cell == self.cellSimulator) [self onClickItemSimulator];

    
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


#pragma mark
#pragma kCellMethod

-(void)onClickItemNews {
    BqsLog(@"onClickItemNews");
    HumDotaNewsViewController *newsCtl = [[[HumDotaNewsViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    HumUserCenterViewController *rightCtl = [[[HumUserCenterViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:newsCtl wihtOtherViewControle:rightCtl];
}

-(void)onClickItemVideo {
    BqsLog(@"onClickItemVideo");
    HumDotaVideoViewController *videoCtl = [[[HumDotaVideoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    HumUserCenterViewController *rightCtl = [[[HumUserCenterViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:videoCtl wihtOtherViewControle:rightCtl];
}


-(void)onClickItemImages {
    BqsLog(@"onClickItemImages");
    HumDotaImageViewController *imageCtl = [[[HumDotaImageViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    HumUserCenterViewController *rightCtl = [[[HumUserCenterViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:imageCtl wihtOtherViewControle:rightCtl];
}



-(void)onClickItemStrategy {
    BqsLog(@"onClickItemStrategy");
    HumDotaStrategyViewController *strategyCtl = [[[HumDotaStrategyViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    HumUserCenterViewController *rightCtl = [[[HumUserCenterViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:strategyCtl wihtOtherViewControle:rightCtl];
}

-(void)onClickItemSimulator {
    BqsLog(@"onClickItemSimulator");
    HumDotaSimuViewController *simu = [[[HumDotaSimuViewController alloc] init] autorelease];
    HumRightViewController *right = [[[HumRightViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    right.delegate = simu;
    right.managedObjectContext = self.managedObjectContext;
    [HumDotaUIOps revealLeftViewControl:self showNavigationFontViewControl:simu wihtOtherViewControle:right];
    
   
    //    [HumDotaUIOps slideShowModalViewInNavControler:loginVC ParentVCtl:self.parCtl];
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




@end
