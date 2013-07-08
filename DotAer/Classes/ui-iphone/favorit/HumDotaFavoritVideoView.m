//
//  HumDotaFavoritVideoView.m
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaFavoritVideoView.h"
#import "HumDotaNetOps.h"
#import "HumDotaDataMgr.h"
#import "Video.h"
#import "HumVideoTableCell.h"
#import "NGDemoMoviePlayerViewController.h"
#import "HumDotaUserCenterOps.h"
#import "HMPopMsgView.h"
#import "HumDotaVideoManager.h"
#import "HumUserCenterCell.h"

#define kVideoPageEachNum 10

@interface HumDotaFavoritVideoView()<HumVideoTableCellDelegate,MoviePlayerViewControllerDelegate>

@property (nonatomic, retain) Video *retainInfo;

@end

@implementation HumDotaFavoritVideoView
@synthesize retainInfo;
- (void)dealloc{
    self.retainInfo = nil;
    [super dealloc];
}



- (BOOL)loadLocalDataNeedFresh{
    self.dataArray = [[HumDotaDataMgr instance] arrOfLocalFavVideo];
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
    
    int row = [HumVideoTableCell rowCntForItemCnt:[self.dataArray count] ColumnCnt:[HumVideoTableCell columnCntForWidth:CGRectGetWidth(self.tableView.frame)]];
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
        cell.titleLabel.text = NSLocalizedString(@"detail.fav.mannager.video.no", nil);
        return cell;
    }

    
    HumVideoTableCell *cell = (HumVideoTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumVideoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    [cell setItemArr:self.dataArray Row:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    //    "video.download.has.download" = "已下载";
    //    "video.download.is.downloading" = "下载中";
    //    "detail.video.download.title" = "下载";
    
    
    //    AddVideoTaskStatus addStatus =  [[HumDotaVideoManager instance] judgeStatusForVideo:info];
    //    NSString *tipsNSString = nil;
    //    switch (addStatus) {
    //        case TaskStatusSuccess:
    //            tipsNSString = NSLocalizedString(@"detail.video.download.title", nil);
    //            break;
    //        case TaskStatusAlready:
    //            tipsNSString = NSLocalizedString(@"video.download.is.downloading", nil);
    //            break;
    //        case TaskStatusExist:
    //            tipsNSString = NSLocalizedString(@"video.download.has.download", nil);
    //            break;
    //        default:
    //            tipsNSString = NSLocalizedString(@"detail.video.download.title", nil);
    //            break;
    //    }
    
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArray || [self.dataArray count] == 0) {
        return 40;
    }
    
    
    return kMptRecommnCell_nameHeigh+kMptRcommonCell_iconHeith+4*kMptRecommoCell_iconPaddingVert;
}


#pragma mark MptAVPlayerViewController_Callback
- (void)moviePlayerViewController:(NGDemoMoviePlayerViewController *)ctl didFinishWithResult:(NGMoviePlayerResult)result error:(NSError *)error{
    
    NSString *resultString = @"";
    
    switch (result) {
        case NGMoviePlayerCancelled:
            resultString = NSLocalizedString(@"detail.progrome.player.cancle", nil);
            break;
        case NGMoviePlayerFinished:
            resultString = NSLocalizedString(@"detail.progrome.player.fininsh", nil);
            break;
        case NGMoviePlayerURLError:
            resultString = NSLocalizedString(@"detail.progrome.player.urleror", nil);
            break;
        case NGMoviePlayerFailed:
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

- (void)humVideoCell:(HumVideoTableCell *)cell didPlayVideo:(Video *)video{
    
    BqsLog(@"HumDotaVideoCateTwoView humVideoCell didPlayVideo:%@",video);
    
    
    NSString *localPlayM3u8 = [[HumDotaVideoManager instance] localPlayPathForVideo:video.youkuId];
    
    if(localPlayM3u8){
        
        NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithUrl:localPlayM3u8 title:video.title] autorelease];
        play.delegate = self;
        //    play.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self.parCtl presentModalViewController:play animated:YES];
        return;
    }
    
    
    BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
    if (!haveNet) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"title.nonetwork.cannot.paly", nil) Delegate:self];
        return;
    }
    
    [MobClick endEvent:kUmeng_video_play_event label:video.title];
    self.retainInfo = video;
    BOOL isWifi = [HumDotaUserCenterOps BoolValueForKey:kDftNetTypeWifi];
    if (!isWifi) {
        [HMPopMsgView showChaoseAlertError:nil Msg:NSLocalizedString(@"title.network.3G.play", self) delegate:nil];
        return;
    }
    
    
    NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithVideo:video] autorelease];
    play.delegate = self;
    //    play.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.parCtl presentModalViewController:play animated:YES];
    
    
}

- (void)humVideoCell:(HumVideoTableCell *)cell downloadVideo:(Video *)info{
    
    BqsLog(@"HumDotaVideoCateTwoView humVideoCell downloadVideo:%@ row:%d",info);
    
    //    "detail.video.download.nonetwork" = "您已经断开网络,下载失败,请稍后重试";
    //    "detail.video.3G.download" = "您正在使用 3G 网络,会消耗较多流量,是否继续下载?"
    
    
    BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
    if (!haveNet) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"detail.video.download.nonetwork", nil) Delegate:self];
        return;
    }
    
    [MobClick endEvent:kUmen_video_download_event label:info.title];
    self.retainInfo = info;
    BOOL isWifi = [HumDotaUserCenterOps BoolValueForKey:kDftNetTypeWifi];
    if (!isWifi) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"detail.video.3G.download", nil) Delegate:self];
        return;
    }
    
    //    TaskStatusSuccess = 1,
    //    TaskStatusAlready = 2,
    //    TaskStatusExist = 3,
    //    TaskStatusFailed = 4,
    
    //    "video.download.already.downloaded" = "该视频已经存在,请进入视频管理界面管理";
    //    "video.download.already.downloading" = "该视频已经在下载列表,请进入视频管理界面管理";
    //    "video.download.addsuccess" = "添加下载视频成功,请进入视频管理界面管理";
    //    "video.download.failed" = "添加下载视频失败,请稍后重试";
    //    "video.download.unknow" = "未知错误,请稍后重试";
    VideoScreenStatus videoState= [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
    
    AddVideoTaskStatus addStatus =  [[HumDotaVideoManager instance] addDownloadTaskForVideo:info withStep:videoState];
    NSString *tipsNSString = nil;
    switch (addStatus) {
        case TaskStatusSuccess:
            tipsNSString = NSLocalizedString(@"video.download.addsuccess", nil);
            break;
        case TaskStatusAlready:
            tipsNSString = NSLocalizedString(@"video.download.already.downloading", nil);
            break;
        case TaskStatusExist:
            tipsNSString = NSLocalizedString(@"video.download.already.downloaded", nil);
            break;
        case TaskStatusFailed:
            tipsNSString = NSLocalizedString(@"video.download.failed", nil);
            break;
        default:
            tipsNSString = NSLocalizedString(@"video.download.unknow", nil);
            break;
    }
    
    [HMPopMsgView showPopMsgError:nil Msg:tipsNSString Delegate:nil];
    
    
    //    NSArray *arry = [NSArray arrayWithObject:index];
    //    [self.tableView reloadRowsAtIndexPaths:arry withRowAnimation:UITableViewRowAnimationNone];
    //
    
}

- (BOOL)humVideoCell:(HumVideoTableCell *)cell addFavVideo:(Video *)info{
    BqsLog(@"HumDotaVideoCateTwoView humVideoCell addFavVideo:%@",info);
    
    BOOL value =  [[HumDotaDataMgr instance] addFavoVideo:info];
    if (value) {
        [self.tableView reloadData];
    }
    
    return value;
}

#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    BqsLog(@"alertView didClick Button at index:%d",buttonIndex);
    if (buttonIndex == 1) {
        if (self.retainInfo == nil) {
            BqsLog(@"Error because the retain info == nil");
        }
        NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithVideo:self.retainInfo] autorelease];
        play.delegate = self;
        [self.parCtl presentModalViewController:play animated:YES];        
    }
    
    
}


@end