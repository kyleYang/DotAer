//
//  PanguPhotoWallView.m
//  pangu
//
//  Created by yang zhiyun on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HumDotaImageCateTwoView.h"
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


#define kImageEachDownNum 20

@interface HumDotaImageCateTwoView()<HumImageTableCellDelegate>

@property (nonatomic, retain) NSMutableArray *netArray;


@end

@implementation HumDotaImageCateTwoView
@synthesize netArray;
@synthesize imageCatId;
- (void)dealloc
{
    self.netArray = nil;
    self.imageCatId = nil;
    [super dealloc];
}



#pragma mark
#pragma mark instance method


- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] readLocalSaveImageDataCat:self.imageCatId];
    self.netArray = [NSMutableArray arrayWithArray:self.dataArray];
    _curPage = self.dataArray.count / kImageEachDownNum;
    if (_curPage != 0) {
        _curPage -= 1;
    }

    
    CGFloat lastUploadTs = [HumDotaUserCenterOps floatValueReadForKey:[NSString stringWithFormat:kDftImageCatSaveTimeForCat,self.imageCatId]];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    
    if (fNow - lastUploadTs > kRefreshImageIntervalS) {
        return TRUE;
    }
    
    return FALSE;

    
       
}


-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.netArray = nil;
        _curPage = 0;
        self.nTaskId = [HumDotaNetOps imageMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil categoryId:self.imageCatId page:_curPage pageNum:kImageEachDownNum];
    }else{
        _curPage++;
        self.nTaskId = [HumDotaNetOps imageMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil categoryId:self.imageCatId page:_curPage pageNum:kImageEachDownNum];
    }
    
}



    

#pragma mark
#pragma mark Downlaoder Callback
-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"HumDotaImageCateTwoView onLoadDataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
        return;
	}
    
    
    if(!self.netArray) self.netArray = [NSMutableArray arrayWithCapacity:20];
    NSArray *temp = [Photo parseXmlData:cb.rspData];
    
    if ([temp count] < kImageEachDownNum) {
        _hasMore = FALSE;
    }
    
    for (Photo *photo in temp) {
        [self.netArray addObject:photo];
    }
    
    if (self.netArray.count == 0) {
        [HMPopMsgView showPopMsgError:nil Msg:NSLocalizedString(@"pg.search.null", nil) RetMsg:nil RetStatus:nil];
    }
    
    self.dataArray = self.netArray;
    [[HumDotaDataMgr instance] saveImageData:self.dataArray forCat:self.imageCatId];
    
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    [HumDotaUserCenterOps floatVaule:fNow saveForKey:[NSString stringWithFormat:kDftImageCatSaveTimeForCat,self.imageCatId]];
   

}

#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    int row = [HumImageTableCell rowCntForItemCnt:[self.dataArray count] ColumnCnt:[HumImageTableCell columnCntForWidth:CGRectGetWidth(self.tableView.frame)]];
    BqsLog(@"numberOfRowsInSection :%d",row);
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
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
    
     return [[HumDotaDataMgr instance] addFavoImage:photo];
}


@end

