//
//  HumDotaDowanloaderViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaDownloaderViewController.h"
#import "PKRevealController.h"
#import "CustomUIBarButtonItem.h"
#import "Env.h"
#import "BqsUtils.h"
#import "MptDetailSectionHeadView.h"
#import "HumDotaVideoManager.h"
#import "HumDotaDownloadCell.h"
#import "SaveVideo.h"
#import "HumDotaDownloadingCell.h"
#import "HMPopMsgView.h"
#import "HumDotaUIOps.h"
#import "HumDotaDataMgr.h"
#import "NGDemoMoviePlayerViewController.h"


#define kSectionHeigh 35

@interface HumDotaDownloaderViewController()<UITableViewDataSource,UITableViewDelegate,HumDotaVideoManagerDelegate,MptDetailSectionHeadView_delegate,HumDotaDownloadingCellDelegate,HumDotaDownloadCellDelegate,MoviePlayerViewControllerDelegate>{
    NSArray *_dataArray;
    NSMutableArray *_arrDownloaded;
    NSMutableArray *_arrDownloading;
    MptDetailType _detailType;
    
}
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSMutableArray *arrDownloaded;
@property (nonatomic, retain) NSMutableArray *arrDownloading;
@property (nonatomic, assign) MptDetailType detailType;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation HumDotaDownloaderViewController
@synthesize tableView;
@synthesize dataArray = _dataArray;
@synthesize detailType = _detailType;
@synthesize arrDownloaded = _arrDownloaded;
@synthesize arrDownloading = _arrDownloading;

- (void)dealloc{
    [HumDotaVideoManager instance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView = nil;
    [_dataArray release];
    [_arrDownloaded release];
    [_arrDownloading release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _detailType = MptDetailTypeDownloaded;
        [HumDotaVideoManager instance].delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:kNtfVideoDownloadFinished object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Env *env= [Env sharedEnv];
    
    UIImage *revealLeftImagePortrait = [env cacheImage:@"dota_frame_option.png"];
    UIImage *revealLeftImageLandscape = [env cacheImage:@"dota_frame_option.png"];
    
    
    NSString *rightBarName = NSLocalizedString(@"button.done", nil);
    
//    UIImage *revealRightImagePortrait = [env cacheImage:@"dota_frame_setting.png"];
//    UIImage *revealRightImageLandscape = [env cacheImage:@"dota_frame_setting.png"];
 
    self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_done.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_donedown.png" X:kBarStrePosX Y:kBarStrePosY]  title:rightBarName target:self action:@selector(onClickDone:)];


    
//    if (self.navigationController.revealController.type & PKRevealControllerTypeRight)
//    {
//        self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:revealRightImagePortrait eventImg:revealRightImageLandscape title:nil target:self action:@selector(showRgihtView:)];
//    }
//   
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bg.image = [[Env sharedEnv] cacheScretchableImage:@"background.png" X:20 Y:10];
    [self.view addSubview:bg];
    [bg release];

    
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollsToTop = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];


    
}


- (void)viewWillAppear:(BOOL)animated{
    [self loadLocalDataNeedFresh];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (BOOL)loadLocalDataNeedFresh{
    self.arrDownloaded = [[HumDotaVideoManager instance] readDownloadedVideoFile];
    self.arrDownloading = [HumDotaVideoManager instance].downloadingArry;
    
    if (_detailType == MptDetailTypeDownloaded) {
        self.dataArray = self.arrDownloaded;
        
    }else if(_detailType == MptDetailTypeDownloading){
        self.dataArray = self.arrDownloading;
    }
    
    return FALSE;
    
}

#pragma mark
#pragma mark porperty
- (void)setDetailType:(MptDetailType)detailType{
    if(_detailType == detailType) return;
    
    _detailType = detailType;
    
    if (_detailType == MptDetailTypeDownloaded) {
        self.dataArray = self.arrDownloaded;
        
    }else if(_detailType == MptDetailTypeDownloading){
        self.dataArray = self.arrDownloading;
    }
    
}

- (void)setDataArray:(NSArray *)dataArray{
    [_dataArray release];
    _dataArray = [dataArray retain];
    [self.tableView reloadData];
}


- (void)videoFinished{
    [self.tableView reloadData];
}

#pragma mark
#pragma mark MptDetailSectionHeadView_delegate

- (void)mptDetailSectionHeadView:(MptDetailSectionHeadView *)view didSelectType:(MptDetailType)type{
    BqsLog(@"mptDetailSectionHeadView didSelectType : %d",type);
    
    self.detailType = type;
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MptDetailSectionHeadView *sectionHead =  [[[MptDetailSectionHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), kSectionHeigh) withType:_detailType] autorelease];
    sectionHead.delegate = self;
    return sectionHead;
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
    static NSString *downloadInden = @"downloadCell";
    static NSString *downingId =@"dwonloadingCell";
    
    if (_detailType == MptDetailTypeDownloaded) {
        
        HumDotaDownloadCell *cell = (HumDotaDownloadCell *)[aTableView dequeueReusableCellWithIdentifier:downloadInden];
        if (!cell) {
            cell = [[[HumDotaDownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadInden] autorelease];
        }
        cell.delegate = self;
        if (indexPath.row<0 || indexPath.row >= [self.dataArray count]) {
            return cell;
        }
        SaveVideo *info = [self.dataArray objectAtIndex:indexPath.row];
        cell.imgLog.imgUrl = info.imageUrl;
        cell.titel.text = info.title;
        switch (info.videoStep) {
            case VideoScreenNormal:
                cell.sceenType.text = NSLocalizedString(@"settin.video.qulity.one", nil);
                break;
            case VideoScreenClear:
                cell.sceenType.text = NSLocalizedString(@"settin.video.qulity.two", nil);
                break;
            case VideoScreenHD:
                cell.sceenType.text = NSLocalizedString(@"settin.video.qulity.three", nil);
                break;
                
            default:
                break;
        }
        cell.precent.text = [[HumDotaDataMgr instance] fileSizeForDir:[[HumDotaVideoManager instance] pathofM3U8DirWithVideoId:info.youkuId]];
        
        return cell;
        
    }else if(_detailType == MptDetailTypeDownloading){
        HumDotaDownloadingCell *cell = (HumDotaDownloadingCell *)[aTableView dequeueReusableCellWithIdentifier:downingId];
        if (!cell) {
            cell = [[[HumDotaDownloadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downingId] autorelease];
        }
        cell.delegate = self;
        if (indexPath.row<0 || indexPath.row >= [self.dataArray count]) {
            return nil;
        }
        M3u8Downloader *m3u8Down = [self.dataArray objectAtIndex:indexPath.row];
        SaveVideo *info = m3u8Down.sVideo;
        cell.imgLog.imgUrl = info.imageUrl;
        cell.titel.text = info.title;
        switch (info.videoStep) {
            case VideoScreenNormal:
                cell.sceenType.text = NSLocalizedString(@"settin.video.qulity.one", nil);
                break;
            case VideoScreenClear:
                cell.sceenType.text = NSLocalizedString(@"settin.video.qulity.two", nil);
                break;
            case VideoScreenHD:
                cell.sceenType.text = NSLocalizedString(@"settin.video.qulity.three", nil);
                break;
                
            default:
                break;
        }

        
        cell.precent.text = [NSString stringWithFormat:@"%d",(int)m3u8Down.totalprogress *100];
        [cell.progress setProgress:m3u8Down.totalprogress animated:YES];
        cell.buttonState = m3u8Down.downingState;
        return cell;

        
    }
    
    
    return nil;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeigh;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_detailType == MptDetailTypeDownloaded) {
        return 90;
    }else if(_detailType == MptDetailTypeDownloading){
        return 105;
    }
    return 0;
}

-(void) tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        if (_detailType == MptDetailTypeDownloaded) {
            if (indexPath.row < self.arrDownloaded.count) {
                SaveVideo *sVideo = [[self.arrDownloaded objectAtIndex:indexPath.row] retain];
                [self.arrDownloaded removeObjectAtIndex:indexPath.row];
                [[HumDotaVideoManager instance] removeVideoFileForId:sVideo.youkuId];
                [[HumDotaVideoManager instance] saveToDownloadedFilePath];
                [sVideo release];
            }
        }else if(_detailType == MptDetailTypeDownloading){
            if (indexPath.row < self.arrDownloading.count) {
                M3u8Downloader *sVideo = [[self.arrDownloading objectAtIndex:indexPath.row] retain];
                [self.arrDownloading removeObjectAtIndex:indexPath.row];
                [sVideo stopDownloadVideo];
                [[HumDotaVideoManager instance] removeVideoFileForId:sVideo.youkuId];
                [[HumDotaVideoManager instance] autoSaveDownloadingRemoveId:sVideo.youkuId];
                [sVideo release];
            }

        }
        
//        [array removeObjectAtIndex:indexPath.row];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    BqsLog(@"moveRowAtIndexPath: %d:%d->%d:%d", sourceIndexPath.section, sourceIndexPath.row, destinationIndexPath.section, destinationIndexPath.row);
    if (_detailType == MptDetailTypeDownloaded) {
        
        NSUInteger fromRow = sourceIndexPath.row;
        NSUInteger toRow = destinationIndexPath.row;
        if (fromRow >= self.arrDownloaded.count) {
            [self.tableView reloadData];
        }
        
        SaveVideo *catFrom = [self.arrDownloaded objectAtIndex:fromRow];
        [catFrom retain];
        
        [self.arrDownloaded removeObjectAtIndex:fromRow];
        [self.arrDownloaded insertObject:catFrom atIndex:toRow];
        [catFrom release];

        [self.tableView reloadData];
        [[HumDotaVideoManager instance] saveToDownloadedFilePath];
    }else if(_detailType == MptDetailTypeDownloading){
        
        
        NSUInteger fromRow = sourceIndexPath.row;
        NSUInteger toRow = destinationIndexPath.row;
        if (fromRow >= self.arrDownloading.count) {
            [self.tableView reloadData];
        }
        
        M3u8Downloader *catFrom = [self.arrDownloading objectAtIndex:fromRow];
        [catFrom retain];
        
        [self.arrDownloading removeObjectAtIndex:fromRow];
        [self.arrDownloading insertObject:catFrom atIndex:toRow];
        [catFrom release];
        
        [self.tableView reloadData];
        [[HumDotaVideoManager instance] changeIndexOfDowanloadingFrom:fromRow destain:toRow];

        
    }
           
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    if (editing!=self.editing) {
        [super setEditing:editing animated:animated];
        [tableView setEditing:editing animated:animated];
        NSMutableArray *indicies=[[NSMutableArray alloc] init];
        for (int i=0; i<[self.dataArray count]; i++) {
            [indicies addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }

        if (editing==YES) {
            for (int i=0; i<self.dataArray.count; i++) {
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:[indicies objectAtIndex:i]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
    
            
        }else {
            for (int i=0; i<self.dataArray.count; i++) {
                UITableViewCell * cell=[tableView cellForRowAtIndexPath:[indicies objectAtIndex:i]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
    
        }
        [indicies release];
    }
}




#pragma mark
#pragma mark HumDotaVideoManagerDelegate

- (void)videoDownloadPecentChangedForM3u8Downloader:(M3u8Downloader *)m3u8{
    
    if (_detailType == MptDetailTypeDownloaded) return;
    
   NSUInteger idex =  [self.dataArray indexOfObject:m3u8];
    if (idex < [self.dataArray count]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idex inSection:0];
        HumDotaDownloadingCell *cell = (HumDotaDownloadingCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if(cell){
             cell.precent.text = [NSString stringWithFormat:@"%d",(int)(m3u8.totalprogress *100)];
            [cell.progress setProgress:m3u8.totalprogress animated:YES];
        }
            
        
    }
    
    
}


#pragma mark
#pragma mark HumDotaDownloadingCellDelegate
- (void)HumDotaDownloadingCell:(HumDotaDownloadingCell *)cell didCilicType:(ButtonState)state atIndex:(NSIndexPath *)path{
    if (path.row<0 || path.row >= [self.dataArray count]) {
        return ;
    }
    M3u8Downloader *m3u8Down = [self.dataArray objectAtIndex:path.row];
    if (state == VideoButtonStope) {
        [m3u8Down stopDownloadVideo];
    }else if(state == VideoButtonResum){
        [m3u8Down startDownloadVideo];
        m3u8Down.downingState = TRUE;
    }
    
}

- (void)HumDotaDownloadCell:(HumDotaDownloadCell *)cell didSelectAtIndex:(NSIndexPath *)path{
    if (path.row<0 || path.row >= [self.dataArray count]) {
        return ;
    }
    SaveVideo *sVideo = [self.dataArray objectAtIndex:path.row];
    
    NSString *localPlayM3u8 = [[HumDotaVideoManager instance] localPlayPathForVideo:sVideo.youkuId];
    
    if(localPlayM3u8){
        
        NGDemoMoviePlayerViewController *play = [[[NGDemoMoviePlayerViewController alloc] initWithUrl:localPlayM3u8 title:sVideo.title] autorelease];
        play.delegate = self;
        //    play.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self presentModalViewController:play animated:YES];
        return;
    }else{
        [HMPopMsgView showPopMsg:NSLocalizedString(@"video.download.file.wrong", nil)];
 
    }


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
#pragma mark barbutton method
- (void)onClickDone:(id)sender
{
    [HumDotaUIOps popUIViewControlInNavigationControl:self];
}

- (void)showRgihtView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.rightViewController];
    }
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
@end