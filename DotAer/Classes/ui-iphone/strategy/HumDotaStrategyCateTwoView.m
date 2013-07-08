//
//  HumDotaStrategyCateTwoView.m
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaStrategyCateTwoView.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "HumStrategyTableCell.h"
#import "Strategy.h"
#import "LeavesViewController.h"
#import "HumDotaUIOps.h"
#import "HMPopMsgView.h"
#import "HumDotaUserCenterOps.h"

#define kAllCategory @"1"
#define kStrategyPageEachNum 10

@interface HumDotaStrategyCateTwoView()<HumStrategyCellDelegate>

@property (nonatomic, retain) NSMutableArray *netArray;

@end

@implementation HumDotaStrategyCateTwoView
@synthesize netArray;

- (void)dealloc{
    self.netArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] readLocalSaveStrategyDataCat:kAllCategory];
    self.netArray = [NSMutableArray arrayWithArray:self.dataArray];
    _curPage = self.dataArray.count / kStrategyPageEachNum;
    if (_curPage != 0) {
        _curPage -= 1;
    }
    
    CGFloat lastUploadTs = [HumDotaUserCenterOps floatValueReadForKey:[NSString stringWithFormat:kDftStrategyCatSaveTimeForCat,kAllCategory]];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    
    if (fNow - lastUploadTs > kRefreshStrategyInterVals) {
        return TRUE;
    }
    
    return FALSE;

    
}


-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.netArray = nil;
        _curPage = 0;
        self.nTaskId = [HumDotaNetOps strategyMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_curPage];
    }else{
        _curPage++;
        self.nTaskId = [HumDotaNetOps strategyMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_curPage];
    }
    
}

-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"HumDotaNewsCateTwoView onLoadDataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
       [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
        
        return;
	}
    if (nil == self.netArray) {
        self.netArray = [[[NSMutableArray alloc] initWithCapacity:15] autorelease];
    }
    NSArray *arry = [Strategy parseXmlData:cb.rspData];
    if ([arry count] < kStrategyPageEachNum) {
        _hasMore = FALSE;
    }
    
    for (Strategy *strategy in arry) {
        [self.netArray addObject:strategy];
    }
    self.dataArray = self.netArray;
    [[HumDotaDataMgr instance] saveStrategyData:self.dataArray forCat:kAllCategory];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    [HumDotaUserCenterOps floatVaule:fNow saveForKey:[NSString stringWithFormat:kDftStrategyCatSaveTimeForCat,kAllCategory]];
    
}


#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
    HumStrategyTableCell *cell = (HumStrategyTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumStrategyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    
    Strategy *info = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat heigh = kOrgY;
    
    CGSize size = [info.title sizeWithFont:cell.title.font constrainedToSize:CGSizeMake(cell.title.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = cell.title.frame;
    frame.size.height = size.height;
    cell.title.frame = frame;
    cell.title.text = info.title;
    heigh += size.height;
    
    
    size = [info.summary sizeWithFont:cell.summary.font constrainedToSize:CGSizeMake(cell.summary.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
    frame = cell.summary.frame;
    frame.origin.y = heigh+kTSGap;
    frame.size.height = size.height;
    cell.summary.frame = frame;
    cell.summary.text = info.summary;
    
    heigh += kTSGap+ size.height;
    
    frame = cell.timeLeb.frame;
    frame.origin.y = heigh+kSTGap;
    cell.timeLeb.frame = frame;
    cell.timeLeb.text = info.time;

    
    frame = cell.favButton.frame;
    frame.origin.y = CGRectGetMinY(cell.timeLeb.frame);
    cell.favButton.frame = frame;
    
    cell.favButton.selected = [[HumDotaDataMgr instance] judgeFavStrategy:info];
    
    
    heigh += kSTGap+kTimeHeigh; //timelable heig
    
    heigh += kOrgY;
        
    frame = cell.frame;
    frame.size.height = heigh;
    cell.frame = frame;
    [cell setNeedsLayout];

    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Strategy *info = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat height= kOrgY;
    
    CGSize size = [info.title sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    height += size.height;
    
    size = [info.summary sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    height += kTSGap+size.height;
    
    height += kSTGap+kTimeHeigh; //timelable heig
    
    height += kOrgY;
    
    
    return height;
}


#pragma mark
#pragma makr HumStrategyCellDelegate
- (void)humNewsCell:(HumStrategyTableCell *)cell didSelectIndex:(NSIndexPath *)index{
    BqsLog(@"HumDotaStrategyCateTwoView HumStrategyTableCell didSelectIndex section:%d row:%d",index.section,index.row);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaStrategyCateTwoView HumStrategyTableCell didSelectIndex row > all row");
        
        return;
    }
    
    Strategy *info = [self.dataArray objectAtIndex:index.row];
    [MobClick endEvent:kUmeng_strategy_cell_event label:info.title];
    LeavesViewController *leaves = [[[LeavesViewController alloc] initWithArtUrl:info.content articeId:info.articleId articlMd5:info.md5] autorelease];
    [HumDotaUIOps slideShowModalViewControler:leaves ParentVCtl:self.parCtl];
    
}


- (BOOL)humNewsStrategyCell:(HumStrategyTableCell *)cell addFavAtIndex:(NSIndexPath *)index{
    BqsLog(@"HumDotaStrategyCateTwoView HumStrategyTableCell addFavAtIndex indexPaht;%@",index);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaStrategyCateTwoView HumStrategyTableCell addFavAtIndex row > all row");
        return FALSE;
    }
    
    Strategy *info = [self.dataArray objectAtIndex:index.row];
    [MobClick endEvent:kUmeng_stategy_addFav_event label:info.title];
    return [[HumDotaDataMgr instance] addFavoStragtegy:info];
}

@end
