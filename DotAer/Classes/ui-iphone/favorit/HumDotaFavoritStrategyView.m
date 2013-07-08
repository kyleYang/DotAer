//
//  HumDotaFavoritStrategyView.m
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaFavoritStrategyView.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "HumStrategyTableCell.h"
#import "Strategy.h"
#import "LeavesViewController.h"
#import "HumDotaUIOps.h"
#import "HMPopMsgView.h"
#import "HumDotaUserCenterOps.h"
#import "HumUserCenterCell.h"

#define kAllCategory @"1"
#define kStrategyPageEachNum 10

@interface HumDotaFavoritStrategyView()<HumStrategyCellDelegate>

@end

@implementation HumDotaFavoritStrategyView

- (void)dealloc{

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
    self.dataArray = [[HumDotaDataMgr instance] arrOfLocalFavStragety];
    
    return FALSE;
    
    
}

#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.dataArray ||[self.dataArray count] == 0) {
        return 1;
    }
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
    static NSString *cellNoIde = @"cellNoId";
    
    if (!self.dataArray ||[self.dataArray count] == 0) {
        HumUserCenterCell *cell = (HumUserCenterCell *)[aTableView dequeueReusableCellWithIdentifier:cellNoIde];
        if (!cell) {
            cell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNoIde] autorelease];
        }
        cell.cellType = USCellTypeLeft;
        cell.titleLabel.text = NSLocalizedString(@"detail.fav.mannager.strategy.no", nil);
        return cell;
    }

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
    
    if (!self.dataArray ||[self.dataArray count] == 0) {
        return 40;
    }
    
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
    BOOL value = [[HumDotaDataMgr instance] addFavoStragtegy:info];
    if (value) {
        [self.tableView reloadData];
    }
    return value;
}

@end
