//
//  HumDotaNewsCateTwoView.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadNewsCateTwoView.h"
#import "HumDotaNetOps.h"
#import "HumDotaUIOps.h"
#import "HumPadNewsTxtCell.h"
#import "News.h"
#import "HumTypeConstant.h"
#import "MptAVPlayerViewController.h"
#import "HumWebImageView.h"
#import "HMImageViewController.h"
#import "LeavesViewController.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUserCenterOps.h"
#import "HMPopMsgView.h"

#define kNewsPageEachNum 10

@interface HumDotaPadNewsCateTwoView()<HumPadNewsCellDelegate,MptAVPlayerViewController_Callback>

@property (nonatomic, retain) NSMutableArray *netArray;
@property (nonatomic, retain) News *retainInfo;
@end


@implementation HumDotaPadNewsCateTwoView
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
    self.dataArray = [[HumDotaDataMgr instance] readLocalSaveNewsData];
    self.netArray = [NSMutableArray arrayWithArray:self.dataArray];
    _curPage = self.dataArray.count / kNewsPageEachNum;
    if (_curPage != 0) {
        _curPage -= 1;
    }

    
    CGFloat lastUploadTs = [HumDotaUserCenterOps floatValueReadForKey:kDftNewsCatSaveTime];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    
    if (fNow - lastUploadTs > kRefreshNewsIntervalS) {
        return TRUE;
    }
    
    return FALSE;

}


-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.netArray = nil;
        _curPage = 0;
        self.nTaskId = [HumDotaNetOps newsMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:0];
    }else{
        _curPage++;
        self.nTaskId = [HumDotaNetOps newsMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_curPage];
    }
    
}

-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"HumDotaNewsCateTwoView onLoadDataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        return;
	}
    if (nil == self.netArray) {
        self.netArray = [[[NSMutableArray alloc] initWithCapacity:15] autorelease];
    }
    NSArray *arry = [News parseXmlData:cb.rspData];
    if ([arry count] < kNewsPageEachNum) {
        _hasMore = FALSE;
    }
    
    for (News *news in arry) {
        [self.netArray addObject:news];
    }
    self.dataArray = self.netArray;
    [[HumDotaDataMgr instance] saveNewsData:self.dataArray];
    const float fNow = (float)[NSDate timeIntervalSinceReferenceDate];
    [HumDotaUserCenterOps floatVaule:fNow saveForKey:kDftNewsCatSaveTime];

    
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
    HumPadNewsTxtCell *cell = (HumPadNewsTxtCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumPadNewsTxtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
    cell.delegate = self;
    
    if (indexPath.row % 2 == 0) {
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_singer_bg.png"];
    }else{
        cell.bgImg.image = [[Env sharedEnv] cacheImage:@"dota_cell_double_bg.png"];
    }

    
    News *info = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat heigh = kOrgY;
    
    CGSize size = [info.title sizeWithFont:cell.title.font constrainedToSize:CGSizeMake(cell.title.frame.size.width, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = cell.title.frame;
    frame.size.height = size.height;
    cell.title.frame = frame;
    cell.title.text = info.title;
    heigh += size.height;
    
        
    
//    "dota.categor.strategy" = "资讯";
//    "dota.categor.photo" = "图片";
//    "dota.categor.video" = "视频";
    
    switch (info.category) {
        case HumDotaNewsTypeText:
            cell.typeImg.image = [[Env sharedEnv] cacheImage:@"dota_news_type_txt.png"];
            cell.typeLeb.text = NSLocalizedString(@"dota.categor.strategy", nil);
            break;
        case HumDotaNewsTypeImages:
            cell.typeImg.image = [[Env sharedEnv] cacheImage:@"dota_news_type_img.png"];
            cell.typeLeb.text = NSLocalizedString(@"dota.categor.photo", nil);
            break;
        case HumDotaNewsTypeVideo:
            cell.typeImg.image = [[Env sharedEnv] cacheImage:@"dota_news_type_video.png"];
            cell.typeLeb.text = NSLocalizedString(@"dota.categor.video", nil);
            break;
        default:
            break;
    }
    
    
    if (info.category == HumDotaNewsTypeImages) {
        frame = cell.contImage.frame;
        frame.origin.x = 30;
        frame.origin.y = CGRectGetMaxY(cell.title.frame)+5;
        frame.size.width = kTxtCellImageWidth;
        frame.size.height = kTxtCellImageHeigh;
        
        cell.contImage.frame =frame;
        heigh += kTIGap+kTxtCellImageHeigh;
        
        if([info.imgeArry count] != 0){
            NewsImg *newsImg = [info.imgeArry objectAtIndex:0];
            BqsLog(@"cell at section: %d,row :%d url = %@",indexPath.section,indexPath.row,newsImg.url);
            [cell.contImage displayImage:[[Env sharedEnv] cacheImage:@"dota_news_default.png"]];
            cell.contImage.imgUrl = newsImg.url;
        }
        
    }else{
        cell.contImage.frame = CGRectZero;
    }
    heigh += kTTGap;
    
    frame = cell.timeLeb.frame;
    frame.origin.y = heigh;
    cell.timeLeb.text = info.time;
    cell.timeLeb.frame = frame;
  
    
    frame = cell.typeImg.frame;
    frame.origin.y = CGRectGetMinY(cell.timeLeb.frame);
    cell.typeImg.frame = frame;
    
    frame = cell.typeLeb.frame;
    frame.origin.y = CGRectGetMinY(cell.typeImg.frame);
    cell.typeLeb.frame = frame;
    
    heigh += kOrgY;
    
    frame = cell.frame;
    frame.size.height = heigh;
    cell.frame = frame;
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    News *info = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat height= kOrgY;
    
    CGSize size = [info.title sizeWithFont:kTitleFont constrainedToSize:CGSizeMake(kTxtCellImageWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    height += size.height;
    if (info.category == HumDotaNewsTypeImages) {
        height += kTIGap+kTxtCellImageHeigh;
    }
    height += kTTGap+kTimeHeigh;
    
    height += kOrgY;
    
    
    return height;
}

#pragma mark
#pragma mark HumNesCellDelegate

- (void)humNewsCell:(HumPadNewsTxtCell *)cell didSelectIndex:(NSIndexPath *)index{
    BqsLog(@"HumDotaNesCateTwoView humNewsCell didSelectIndex section:%d row:%d",index.section,index.row);
    if (index.row >= self.dataArray.count) {
        BqsLog(@"HumDotaNesCateTwoView humNewsCell didSelectIndex row > all row",index.section,index.row);
        
        return;
    }
    News *info = [self.dataArray objectAtIndex:index.row];

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
            
            
            MptAVPlayerViewController *play = [[[MptAVPlayerViewController alloc] initWithContentString:info.content name:titleName] autorelease];
            play.call_back = self;
            [self.parCtl presentModalViewController:play animated:YES];
        }
            
        break;
    default:
        break;
    }

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

        
        MptAVPlayerViewController *play = [[[MptAVPlayerViewController alloc] initWithContentString:self.retainInfo.content name:titleName] autorelease];
        play.call_back = self;
        [self.parCtl presentModalViewController:play animated:YES];
        
        
    }
    
    
}


#pragma mark -
#pragma mark MptAVPlayerViewController_Callback
- (void)MptAVPlayerViewController:(MptAVPlayerViewController *)ctl didFinishWithResult:(MptAVPlayerResult)result error:(NSError *)error{
    
    BqsLog(@"MptAVPlayerViewController didFinished result = %d",result);
    
   
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




@end
