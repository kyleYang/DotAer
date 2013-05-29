//
//  HumDotaVideCateTwoView.m
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaVideCateTwoView.h"
#import "HumDotaNetOps.h"
#import "HumDotaDataMgr.h"
#import "Video.h"
#import "HumVideoTableCell.h"
#import "MptAVPlayerViewController.h"
#import "HumDotaUserCenterOps.h"
#import "HMPopMsgView.h"

#define kVideoPageEachNum 10

@interface HumDotaVideCateTwoView()<HumVideoTableCellDelegate,MptAVPlayerViewController_Callback>

@property (nonatomic, retain) Video *retainInfo;
@property (nonatomic, retain) NSMutableArray *netArray;

@end

@implementation HumDotaVideCateTwoView
@synthesize videoCatId;
@synthesize netArray;
@synthesize retainInfo;
- (void)dealloc{
    self.retainInfo = nil;
    self.videoCatId = nil;
    self.netArray = nil;
    [super dealloc];
}



- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] readLocalSaveVideoDataCat:self.videoCatId];
    self.netArray = [NSMutableArray arrayWithArray:self.dataArray];
    _curPage = self.dataArray.count / kVideoPageEachNum;
    if (_curPage != 0) {
        _curPage -= 1;
    }
    
    CGFloat lastUploadTs = [HumDotaUserCenterOps floatValueReadForKey:[NSString stringWithFormat:kDftVideoCatSaveTimeForCat,self.videoCatId]];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    
    if (fNow - lastUploadTs > kRefreshVideoInterVals) {
        return TRUE;
    }
    
    return FALSE;
}


-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.netArray = nil;
        _curPage = 0;
        self.nTaskId = [HumDotaNetOps videoMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil categoryId:self.videoCatId page:_curPage];
    }else{
        _curPage++;
        self.nTaskId = [HumDotaNetOps videoMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil categoryId:self.videoCatId page:_curPage];
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
    NSArray *arry = [Video parseXmlData:cb.rspData];
    if ([arry count] < kVideoPageEachNum) {
        _hasMore = FALSE;
    }
    
    for (Video *video in arry) {
        [self.netArray addObject:video];
    }
    self.dataArray = self.netArray;
    [[HumDotaDataMgr instance] saveVideoData:self.dataArray forCat:self.videoCatId];
    
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    [HumDotaUserCenterOps floatVaule:fNow saveForKey:[NSString stringWithFormat:kDftVideoCatSaveTimeForCat,self.videoCatId]];

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
    HumVideoTableCell *cell = (HumVideoTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumVideoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    if (indexPath.row % 2 == 0) {
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_singer_bg.png"];
    }else{
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_double_bg.png"];
    }

    
    Video *info = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat heigh = kOrgY;
    
    [cell.videoCover displayImage:[[Env sharedEnv] cacheImage:@"dota_video_default.png"]];
    cell.videoCover.imgUrl = info.imageUrl;
    
    CGSize size = [info.title sizeWithFont:cell.title.font constrainedToSize:CGSizeMake(cell.title.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = cell.title.frame;
    frame.size.height = size.height;
    cell.title.frame = frame;
    cell.title.text = info.title;
    
    
    heigh += (size.height > kCoverHeigh)? size.height:kCoverHeigh; //图片跟 title 高的
    
    size = [info.summary sizeWithFont:cell.summary.font constrainedToSize:CGSizeMake(cell.summary.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
    frame = cell.summary.frame;
    frame.origin.y = heigh+kVSGap;
    frame.size.height = size.height;
    cell.summary.frame = frame;
    cell.summary.text = info.summary;
    
    heigh += kVSGap+ size.height;
    
    frame = cell.timeLeb.frame;
    frame.origin.y = heigh+kSTGap;
    cell.timeLeb.frame = frame;
    cell.timeLeb.text = info.time;
    
    heigh += kSTGap+kTimeHeigh; //timelable heig
    
    heigh += kOrgY;
    

    
  
    frame = cell.frame;
    frame.size.height = heigh;
    cell.frame = frame;
    [cell setNeedsLayout];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Video *info = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat height= kOrgY;
    
    CGSize size = [info.title sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX-kCoverWidth-kVTGap, 1000) lineBreakMode:UILineBreakModeWordWrap];
    height += (size.height > kCoverHeigh)? size.height:kCoverHeigh;
    
    size = [info.summary sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-2*kOrgX, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    height += kVSGap+size.height;
    
    height += kSTGap+kTimeHeigh; //timelable heig
    
    height += kOrgY;
    
    
    return height;
}


#pragma mark MptAVPlayerViewController_Callback
- (void)MptAVPlayerViewController:(MptAVPlayerViewController *)ctl didFinishWithResult:(MptAVPlayerResult)result error:(NSError *)error{
    
    NSString *resultString = @"";
    
    switch (result) {
        case MptAVPlayerCancelled:
            resultString = NSLocalizedString(@"detail.progrome.player.cancle", nil);
            break;
        case MptAVPlayerFinished:
            resultString = NSLocalizedString(@"detail.progrome.player.fininsh", nil);
            break;
        case MptAVPlayerURLError:
            resultString = NSLocalizedString(@"detail.progrome.player.urleror", nil);
            break;
        case MptAVPlayerFailed:
            resultString = NSLocalizedString(@"detail.progrome.player.failed", nil);
            break;
        default:
            break;
    }
    
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    if ([osVersion floatValue] >= 5.0) {
        [ctl dismissViewControllerAnimated:YES completion:^(void){
            [HMPopMsgView showPopMsg:resultString];
        }];
    }else{
        [ctl dismissModalViewControllerAnimated:YES];
        [self performSelector:@selector(messageNotice:) withObject:[[resultString retain] autorelease] afterDelay:0.2];
    }
    
}


- (void)messageNotice:(NSString *)message{
    [HMPopMsgView showPopMsg:message];
}




#pragma mark
#pragma mark HumVideoTableCellDelegate

- (void)humVideoCell:(HumVideoTableCell *)cell didSelectIndex:(NSIndexPath *)index{
    
    BqsLog(@"HumDotaVideoCateTwoView humVideoCell didSelectIndex section:%d row:%d",index.section,index.row);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaVideoCateTwoView humNewsCell didSelectIndex row > all row");
        
        return;
    }
    BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
    if (!haveNet) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"title.nonetwork.cannot.paly", nil) Delegate:self];
        return;
    }
    
    Video *info = [self.dataArray objectAtIndex:index.row];
    [MobClick endEvent:kUmeng_video_cell_event label:info.title];
    self.retainInfo = info;
    BOOL isWifi = [HumDotaUserCenterOps BoolValueForKey:kDftNetTypeWifi];
    if (!isWifi) {
        [HMPopMsgView showChaoseAlertError:nil Msg:NSLocalizedString(@"title.network.3G.play", self) delegate:nil];
        return;
    }
    

    MptAVPlayerViewController *play = [[[MptAVPlayerViewController alloc] initWithContentString:info.content name:info.title] autorelease];
    play.call_back = self;
//    play.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.parCtl presentModalViewController:play animated:YES];
       
    
}

#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    BqsLog(@"alertView didClick Button at index:%d",buttonIndex);
    if (buttonIndex == 1) {
        if (self.retainInfo == nil) {
            BqsLog(@"Error because the retain info == nil");
        }
        MptAVPlayerViewController *play = [[[MptAVPlayerViewController alloc] initWithContentString:self.retainInfo.content name:self.retainInfo.title] autorelease];
        play.call_back = self;
        [self.parCtl presentModalViewController:play animated:YES];        
    }
    
    
}


@end
