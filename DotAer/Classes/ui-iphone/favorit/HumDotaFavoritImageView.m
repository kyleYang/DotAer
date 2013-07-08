//
//  HumDotaFavoritImageView.m
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaFavoritImageView.h"
#import "BqsUtils.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUIOps.h"
#import "HumDotaNetOps.h"
#import "Env.h"
#import "Photo.h"
#import "EGORefreshTableHeaderView.h"
#import "HMPopMsgView.h"
#import "HumWebImageView.h"
#import "HumImageTableCell.h"
#import "HMImageViewController.h"
#import "HumDotaUserCenterOps.h"
#import "HumUserCenterCell.h"


#define kImageEachDownNum 20

@interface HumDotaFavoritImageView()<HumImageTableCellDelegate>



@end

@implementation HumDotaFavoritImageView

- (void)dealloc
{
    [super dealloc];
}



#pragma mark
#pragma mark instance method


- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] arrOfLocalFavImage];
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
    
    int row = [HumImageTableCell rowCntForItemCnt:[self.dataArray count] ColumnCnt:[HumImageTableCell columnCntForWidth:CGRectGetWidth(self.tableView.frame)]];
    BqsLog(@"numberOfRowsInSection :%d",row);
    return row;
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
        cell.titleLabel.text = NSLocalizedString(@"detail.fav.mannager.image.no", nil);
        return cell;
    }

    
    HumImageTableCell *cell = (HumImageTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumImageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    [cell setItemArr:self.dataArray Row:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArray ||[self.dataArray count] == 0) {
        return 40;
    }
    
    return kMptImageCell_Heigh;
}

#pragma mark
#pragma mark HumImageTableCellDelegate

- (void)humItemCell:(HumImageTableCell *)cell didPlayImage:(Photo *)photoes{
    
    [MobClick endEvent:kUmeng_image_cell_event label:photoes.title];
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *sumAry = [NSMutableArray arrayWithCapacity:10];
    for (PhotoImg *photo in photoes.arrImgUrls) {
        
        [arry addObject:photo.url ];
        [sumAry addObject:photo.introduce];
    }
    
    HMImageViewController *image = [[[HMImageViewController alloc] initWithImgArray:arry SumArray:sumAry] autorelease];
    image.modalPresentationStyle = UIModalPresentationFullScreen;
    [HumDotaUIOps slideShowModalViewControler:image ParentVCtl:self.parCtl];
}

- (BOOL)humItemCell:(HumImageTableCell *)cell addFavImage:(Photo *)photo{
    BOOL value = [[HumDotaDataMgr instance] addFavoImage:photo];
    if (value) {
        [self.tableView reloadData];
    }
    return value;
}

@end
