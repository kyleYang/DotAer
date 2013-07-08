//
//  HumMassCleanViewController.m
//  DotAer
//
//  Created by Kyle on 13-3-28.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumMassCleanViewController.h"
#import "CustomUIBarButtonItem.h"
#import "PKRevealController.h"
#import "HumUserCenterCell.h"
#import "HMLeftRightTextCell.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUIOps.h"
#import "Env.h"

@interface HumMassCleanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) HumUserCenterCell *imageCell;
@property (nonatomic, retain) HumUserCenterCell *articleCell;
@property (nonatomic, retain) HumUserCenterCell *otherCell;

@end

@implementation HumMassCleanViewController
@synthesize tableView;
@synthesize dataArray;

- (void)dealloc{
    self.tableView = nil;
    self.dataArray = nil;
    self.imageCell = nil;
    self.articleCell = nil;
    self.otherCell = nil;
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

    
    self.navigationItem.title = NSLocalizedString(@"massclean.navigation.title", nil);
    
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
    const float kPaddingHori = 10;
    
    {
        self.imageCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"10"] autorelease];
        self.imageCell.cellType = USCellTypeBoth;
        
        self.imageCell.titleLabel.text = NSLocalizedString(@"massclean.mass.image", nil);

        [self.dataArray addObject:self.imageCell];
        
        unsigned int size = [[[HumDotaDataMgr instance] imgCacheFilePath] getFileSize];
        NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
        self.imageCell.detailLabel.text = sizeStr;
    }
    
    {
        self.articleCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"] autorelease];
        self.articleCell.cellType = USCellTypeBoth;
        self.articleCell.titleLabel.text = NSLocalizedString(@"massclean.mass.article", nil);
        [self.dataArray addObject:self.articleCell];
        
        self.articleCell.detailLabel.text = [[HumDotaDataMgr instance] fileSizeForDir:[HumDotaDataMgr instance].articlePath];

    }
    
    {
        self.otherCell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12"] autorelease];
        self.otherCell.cellType = USCellTypeBoth;
        self.otherCell.titleLabel.text = NSLocalizedString(@"massclean.mass.other", nil);
        [self.dataArray addObject:self.otherCell];
        
        unsigned int size = [[[HumDotaDataMgr instance] onlineCacheFilePath] getFileSize];
        NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
        self.otherCell.detailLabel.text = sizeStr;
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
    return [self.dataArray objectAtIndex:indexPath.row];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BqsLog(@"select: %d", indexPath.row);
    
    const UITableViewCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    
    
    if(cell == self.imageCell) [self imageCacheClean];
    else if(cell == self.articleCell) [self articleCacheClean];
    else if(cell == self.otherCell) [self otherCacheClean];
    else {
        BqsLog(@"Invalid cell: %@", cell);
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)imageCacheClean{
    BqsLog(@"imageCacheClean");
    
    [[HumDotaDataMgr instance] cleanImageCacheFile];
    self.imageCell.detailLabel.text = @"0.0 MB";

}

- (void)articleCacheClean{
    BqsLog(@"articleCacheClean");
    [[HumDotaDataMgr instance] cleanAllFileForDir:[HumDotaDataMgr instance].articlePath];
    self.articleCell.detailLabel.text = @"0.0 MB";
}

- (void)otherCacheClean{
    BqsLog(@"otherCacheClean");
    [[HumDotaDataMgr instance] cleanOtherCacheFile];
    self.otherCell.detailLabel.text = @"0.0 MB";

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
