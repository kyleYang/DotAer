//
//  HumMassCleanViewController.m
//  DotAer
//
//  Created by Kyle on 13-3-28.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumMassCleanViewController.h"
#import "CustomUIBarButtonItem.h"
#import "HMLeftRightTextCell.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUIOps.h"
#import "Env.h"

@interface HumMassCleanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) HMLeftRightTextCell *imageCell;
@property (nonatomic, retain) HMLeftRightTextCell *articleCell;
@property (nonatomic, retain) HMLeftRightTextCell *otherCell;

@end

@implementation HumMassCleanViewController
@synthesize tableView;
@synthesize dataArray;

- (void)dealloc{
    self.tableView = nil;
    self.dataArray = nil;
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
    
    self.navigationItem.title = NSLocalizedString(@"massclean.navigation.title", nil);
    
    NSString *leftBarName = NSLocalizedString(@"button.back", nil);
        
    self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_back.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_backdown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(backToTop)];
    
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    "massclean.mass.image" = "清空图片缓存";
//    "massclean.mass.article" = "清空文章缓存";
//    "massclean.mass.other" = "清空其他缓存";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:3];
    const float kPaddingHori = 10;
    
    {
        self.imageCell = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"10"] autorelease];
        
        self.imageCell.lblLeft.text = NSLocalizedString(@"massclean.mass.image", nil);
        self.imageCell.lblRight.hidden = NO;
        self.imageCell.imgDisclosure.hidden = YES;
        self.imageCell.paddingHori = kPaddingHori;       
        [self.dataArray addObject:self.imageCell];
        
        unsigned int size = [[[HumDotaDataMgr instance] imgCacheFilePath] getFileSize];
        NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
        self.imageCell.lblRight.text = sizeStr;
    }
    
    {
        self.articleCell = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"] autorelease];
        
        self.articleCell.lblLeft.text = NSLocalizedString(@"massclean.mass.article", nil);
        self.articleCell.lblRight.hidden = NO;
        self.articleCell.imgDisclosure.hidden = YES;
        self.articleCell.paddingHori = kPaddingHori;
        [self.dataArray addObject:self.articleCell];
        
        unsigned int size = (unsigned int)[[HumDotaDataMgr instance] fileSizeForDir:[HumDotaDataMgr instance].articlePath];
        NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
        self.articleCell.lblRight.text = sizeStr;

    }
    
    {
        self.otherCell = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12"] autorelease];
        
        self.otherCell.lblLeft.text = NSLocalizedString(@"massclean.mass.other", nil);
        self.otherCell.lblRight.hidden = NO;
        self.otherCell.imgDisclosure.hidden = YES;
        self.otherCell.paddingHori = kPaddingHori;
        [self.dataArray addObject:self.otherCell];
        
        unsigned int size = [[[HumDotaDataMgr instance] onlineCacheFilePath] getFileSize];
        NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
        self.otherCell.lblRight.text = sizeStr;
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
    self.imageCell.lblRight.text = @"0.0 MB";

}

- (void)articleCacheClean{
    BqsLog(@"articleCacheClean");
    [[HumDotaDataMgr instance] cleanAllFileForDir:[HumDotaDataMgr instance].articlePath];
    self.articleCell.lblRight.text = @"0.0 MB";
}

- (void)otherCacheClean{
    BqsLog(@"otherCacheClean");
    [[HumDotaDataMgr instance] cleanOtherCacheFile];
    self.otherCell.lblRight.text = @"0.0 MB";

}

- (void)backToTop{
    [HumDotaUIOps slideDismissModalViewController:self];
}

@end
