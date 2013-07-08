//
//  HumDotaFavoritNewsView.m
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaFavoritNewsView.h"
#import "HumDotaNetOps.h"
#import "HumDotaUIOps.h"
#import "HumNewsTxtCell.h"
#import "News.h"
#import "HumTypeConstant.h"
#import "HumWebImageView.h"
#import "HMImageViewController.h"
#import "LeavesViewController.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUserCenterOps.h"
#import "HMPopMsgView.h"
#import "HumDotaVideoManager.h"
#import "HumUserCenterCell.h"
#import "NGDemoMoviePlayerViewController.h"


#define kNewsPageEachNum 10

@interface HumDotaFavoritNewsView()<HumNewsCellDelegate,MoviePlayerViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *netArray;
@property (nonatomic, retain) News *retainInfo;
@end


@implementation HumDotaFavoritNewsView
@synthesize netArray;
@synthesize retainInfo;
- (void)dealloc{
    self.netArray = nil;
    self.retainInfo = nil;
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
    self.dataArray = [[HumDotaDataMgr instance] arrOfLocalFavNews];
    return FALSE;
}




#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray && [self.dataArray count] > 0) {
        return [self.dataArray count];
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
    static NSString *cellNoIden = @"noticCell";
    
//    "detail.fav.mannager.news.no" = "无新闻收藏，请添加";
//    "detail.fav.mannager.video.no" = "无视频收藏，请添加";
//    "detail.fav.mannager.image.no" = "无收藏，请添加";
//    "detail.fav.mannager.strategy.no" = "无攻略收藏，请添加";
    
    if (!self.dataArray || [self.dataArray count] == 0) {
        HumUserCenterCell *cell = (HumUserCenterCell *)[aTableView dequeueReusableCellWithIdentifier:cellNoIden];
        if (!cell) {
             cell = [[[HumUserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNoIden] autorelease];
        }
        cell.cellType = USCellTypeLeft;
        cell.titleLabel.text = NSLocalizedString(@"detail.fav.mannager.news.no", nil);
        return cell;
    }
    
    HumNewsTxtCell *cell = (HumNewsTxtCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumNewsTxtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    
    News *info = [self.dataArray objectAtIndex:indexPath.row];
    
    CGSize titSize = CGSizeMake(292, 1000);
    
    if (info.category == HumDotaNewsTypeImages) {
        titSize = CGSizeMake(212, 1000);
    }
    
    CGFloat height= 10;
    
    CGSize size = [info.title sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:titSize lineBreakMode:UILineBreakModeWordWrap];
    
    if (info.category == HumDotaNewsTypeImages) {
        height += (size.height>kTxtCellImageHeigh?size.height:kTxtCellImageHeigh);
    }else{
        height += size.height;
    }
    
    CGRect frame = cell.title.frame;
    frame.size.height = size.height;
    frame.size.width = size.width;
    
    cell.title.frame = frame;
    cell.title.text = info.title;
    
    
    
    
    //    "dota.categor.strategy" = "资讯";
    //    "dota.categor.photo" = "图片";
    //    "dota.categor.video" = "视频";
    
    //    cell.typeImg.frame = CGRectMake(0, 0, 35, 20);
    switch (info.category) {
        case HumDotaNewsTypeText:
            cell.typeImg.image = [[Env sharedEnv] cacheImage:@"dota_news_type_txt.png"];
            cell.downButton.hidden = YES;
            break;
        case HumDotaNewsTypeImages:
            cell.typeImg.image = [[Env sharedEnv] cacheImage:@"dota_news_type_img.png"];
            cell.downButton.hidden = YES;
            break;
        case HumDotaNewsTypeVideo:
            cell.typeImg.image = [[Env sharedEnv] cacheImage:@"dota_news_type_video.png"];
            cell.downButton.hidden = NO;
            break;
        default:
            break;
    }
    
    
    if (info.category == HumDotaNewsTypeImages) {
        frame = cell.contImage.frame;
        frame.origin.x = CGRectGetWidth(cell.frame)-kTxtCellImageWidth-25;
        frame.origin.y = CGRectGetMinY(cell.title.frame)+5;
        frame.size.width = kTxtCellImageWidth;
        frame.size.height = kTxtCellImageHeigh;
        
        cell.contImage.frame =frame;
        if([info.imgeArry count] != 0){
            NewsImg *newsImg = [info.imgeArry objectAtIndex:0];
            BqsLog(@"cell at section: %d,row :%d url = %@",indexPath.section,indexPath.row,newsImg.url);
            [cell.contImage displayImage:[[Env sharedEnv] cacheImage:@"dota_news_default.png"]];
            cell.contImage.imgUrl = newsImg.url;
        }
    }else{
        cell.contImage.frame = CGRectZero;
    }
    
    height = height+5;
    
    frame = cell.timeLeb.frame;
    frame.origin.y = height;
    cell.timeLeb.text = info.time;
    cell.timeLeb.frame = frame;
  
    BOOL favAdded = [[HumDotaDataMgr instance] judgeFavNews:info];
    
    frame = cell.favButton.frame;
    frame.origin.y = CGRectGetMinY(cell.timeLeb.frame);
    cell.favButton.frame = frame;
    cell.favButton.selected = favAdded;
    
    frame = cell.downButton.frame;
    frame.origin.y = CGRectGetMinY(cell.timeLeb.frame);
    cell.downButton.frame = frame;
    
    
    height += 10+20;
    
    frame = cell.frame;
    frame.size.height = height;
    cell.frame = frame;
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArray || [self.dataArray count] == 0) {
        return 40;
    }
    
    News *info = [self.dataArray objectAtIndex:indexPath.row];
    
    CGSize titSize = CGSizeMake(292, 1000);
    
    if (info.category == HumDotaNewsTypeImages) {
        titSize = CGSizeMake(212, 1000);
    }
    
    CGFloat height= 10;
    
    CGSize size = [info.title sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:titSize lineBreakMode:UILineBreakModeWordWrap];
    
    if (info.category == HumDotaNewsTypeImages) {
        height += (size.height>kTxtCellImageHeigh?size.height:kTxtCellImageHeigh);
    }else{
        height += size.height;
    }
    
    height += 5+20;
    
    height += 10;
    
    
    return height;
}

#pragma mark
#pragma mark HumNesCellDelegate

- (void)humNewsCell:(HumNewsTxtCell *)cell didSelectIndex:(NSIndexPath *)index{
    BqsLog(@"HumDotaNesCateTwoView humNewsCell didSelectIndex section:%d row:%d",index.section,index.row);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaNesCateTwoView humNewsCell didSelectIndex row > all row",index.section,index.row);
        
        return;
    }
    News *info = [self.dataArray objectAtIndex:index.row];
    [MobClick event:kUmeng_news_cell_event label:info.title];
    
    switch (info.category) {
        case HumDotaNewsTypeText:
        {
            LeavesViewController *leaves = [[[LeavesViewController alloc] initWithArtUrl:info.content articeId:info.newsId articlMd5:info.md5] autorelease];
            [HumDotaUIOps slideShowModalViewControler:leaves ParentVCtl:self.parCtl];
        }
            break;
        case HumDotaNewsTypeImages:
        {
            NSMutableArray *arry = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *sumAry = [NSMutableArray arrayWithCapacity:10];
            for (NewsImg *newsImg in info.imgeArry) {
                
                BqsLog(@"cell at section: %d,row :%d url = %@",index.section,index.row,newsImg.url);
                [arry addObject:newsImg.url ];
                [sumAry addObject:newsImg.introduce];
            }
            
            HMImageViewController *image = [[[HMImageViewController alloc] initWithImgArray:arry SumArray:sumAry] autorelease];
            image.modalPresentationStyle = UIModalPresentationFullScreen;
            [HumDotaUIOps slideShowModalViewControler:image ParentVCtl:self.parCtl];
            
        }
            break;
        case HumDotaNewsTypeVideo:
        {
            
            BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
            if (!haveNet) {
                [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"title.nonetwork.cannot.paly", nil) Delegate:nil];
                return;
            }
            
            
            NSString *localPlayM3u8 = [[HumDotaVideoManager instance] localPlayPathForVideo:info.youkuId];
            
            if(localPlayM3u8){
                
                NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithUrl:localPlayM3u8 title:info.title] autorelease];
                play.delegate = self;
                //    play.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                [self.parCtl presentModalViewController:play animated:YES];
                return;
            }
            
            
            self.retainInfo = info;
            BOOL isWifi = [HumDotaUserCenterOps BoolValueForKey:kDftNetTypeWifi];
            if (!isWifi) {
                [HMPopMsgView showChaoseAlertError:nil Msg:NSLocalizedString(@"title.network.3G.play", nil) delegate:self];
                return;
            }
            NSString *titleName = info.title;
            NSArray *nameAry = [info.title componentsSeparatedByString:@"]"];
            if (nameAry && nameAry.count>0) {
                titleName = [nameAry lastObject];
            }
            
            NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithNews:info] autorelease];
            play.delegate = self;
            [self.parCtl presentModalViewController:play animated:YES];
        }
            
            break;
        default:
            break;
    }
    
}


- (BOOL)humNewsCell:(HumNewsTxtCell *)cell addFavNewsAtIndex:(NSIndexPath *)index{
    BqsLog(@"HumDotaNesCateTwoView humNewsCell addFavNewsAtIndex index:%@",index);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaNesCateTwoView humNewsCell didSelectIndex row > all row",index.section,index.row);
        
        return FALSE;
    }
    News *info = [self.dataArray objectAtIndex:index.row];
    [MobClick event:kUmeng_news_addFav_event label:info.title];
    
    BOOL value =  [[HumDotaDataMgr instance] addFavNews:info];
    [self.tableView reloadData];
    return value;
}


- (void)humNewsCell:(HumNewsTxtCell *)cell addDownNewsAtIndex:(NSIndexPath *)index{
    
    BqsLog(@"HumDotaNesCateTwoView humNewsCell addDownNewsAtIndex index",index);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaNesCateTwoView humNewsCell addDownNewsAtIndex row > all row",index.section,index.row);
        
        return;
    }
    News *info = [self.dataArray objectAtIndex:index.row];
    [MobClick event:kUmeng_news_addDown_event label:info.title];
    
    
    BOOL haveNet = [HumDotaUserCenterOps BoolValueForKey:kDftHaveNetWork];
    if (!haveNet) {
        [HMPopMsgView showAlterError:nil Msg:NSLocalizedString(@"detail.video.download.nonetwork", nil) Delegate:self];
        return;
    }
    
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
    
    AddVideoTaskStatus addStatus =  [[HumDotaVideoManager instance] addDownloadTaskForNews:info withStep:videoState];
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
}


#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    BqsLog(@"alertView didClick Button at index:%d",buttonIndex);
    if (buttonIndex == 1) {
        if (self.retainInfo == nil) {
            BqsLog(@"Error because the retain info == nil");
        }
        NSString *titleName = self.retainInfo.title;
        NSArray *nameAry = [self.retainInfo.title componentsSeparatedByString:@"]"];
        if (nameAry && nameAry.count>0) {
            titleName = [nameAry lastObject];
        }
        
        
        NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithNews:self.retainInfo] autorelease];
        play.delegate = self;
        [self.parCtl presentModalViewController:play animated:YES];
        
        
    }
    
    
}


#pragma mark -
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


@end
