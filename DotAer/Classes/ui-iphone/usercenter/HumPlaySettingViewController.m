//
//  HumPlaySettingViewController.m
//  DotAer
//
//  Created by Kyle on 13-6-24.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumPlaySettingViewController.h"
#import "CustomUIBarButtonItem.h"
#import "PKRevealController.h"
#import "HumUserCenterCell.h"
#import "HMLeftRightTextCell.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUIOps.h"
#import "Env.h"
#import "Video.h"
#import "HumDotaUserCenterOps.h"

@interface HumPlaySettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) HumUserCenterCell *norCell;
@property (nonatomic, retain) HumUserCenterCell *clearCell;
@property (nonatomic, retain) HumUserCenterCell *hdCell;

@end

@implementation HumPlaySettingViewController
@synthesize tableView;
@synthesize dataArray;

- (void)dealloc{
    self.tableView = nil;
    self.dataArray = nil;
    self.norCell = nil;
    self.clearCell = nil;
    self.hdCell = nil;
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
    Env *env = [Env sharedEnv];
    
    self.view.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
    
    //    "settin.video.down.qulity.setting" = "下载设置";
    //    "settin.video.play.qulity.setting" = "播放设置";
    
    self.navigationItem.title = NSLocalizedString(@"settin.video.play.qulity.setting", nil);
    
    NSString *rightBarName = NSLocalizedString(@"button.done", nil);
    
    self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_done.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_donedown.png" X:kBarStrePosX Y:kBarStrePosY]  title:rightBarName target:self action:@selector(backToTop)];
    
    
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.tableView];
    
    //    "massclean.mass.image" = "清空图片缓存";
    //    "massclean.mass.article" = "清空文章缓存";
    //    "massclean.mass.other" = "清空其他缓存";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:3];
    
    {
        self.norCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"10"] autorelease];
        self.norCell.cellType = USCellTypeSelected;
        
        self.norCell.titleLabel.text = NSLocalizedString(@"settin.video.qulity.one", nil);
        
        [self.dataArray addObject:self.norCell];
        

    }
    
    {
        self.clearCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"] autorelease];
        self.clearCell.cellType = USCellTypeSelected;
        self.clearCell.titleLabel.text = NSLocalizedString(@"settin.video.qulity.two", nil);
        [self.dataArray addObject:self.clearCell];
    }
    
    {
        self.hdCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12"] autorelease];
        self.hdCell.cellType = USCellTypeSelected;
        self.hdCell.titleLabel.text = NSLocalizedString(@"settin.video.qulity.three", nil);
        [self.dataArray addObject:self.hdCell];
    
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HumUserCenterCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    VideoScreen type =[HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    if (indexPath.row == type) {
        cell.showIcon = YES;
    }else{
        cell.showIcon = NO;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BqsLog(@"select: %d", indexPath.row);
    
    const UITableViewCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    
    
    if(cell == self.norCell) [self norCellSelect];
    else if(cell == self.clearCell) [self clearCellSelect];
    else if(cell == self.hdCell) [self hdCellSelect];
    else {
        BqsLog(@"Invalid cell: %@", cell);
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)norCellSelect{
    [HumDotaUserCenterOps intVaule:VideoScreenNormal saveForKey:kScreenPlayType];
    [HumDotaUIOps popUIViewControlInNavigationControl:self];
}

- (void)clearCellSelect{
    [HumDotaUserCenterOps intVaule:VideoScreenClear saveForKey:kScreenPlayType];
    [HumDotaUIOps popUIViewControlInNavigationControl:self];

}

- (void)hdCellSelect{
    [HumDotaUserCenterOps intVaule:VideoScreenHD saveForKey:kScreenPlayType];
    [HumDotaUIOps popUIViewControlInNavigationControl:self];

    
}

- (void)backToTop{
    [HumDotaUIOps popUIViewControlInNavigationControl:self];
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
