//
//  HumRightView.m
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumRightView.h"
#import "SVSegmentedControl.h"
#import "Env.h"
#import "BqsUtils.h"
#import "DSTavernTableCell.h"
#import "DSDetailView.h"
#import "SimuConstants.h"
#import "HeroInfo.h"
#import "Equipment.h"
#import "Downloader.h"
#import "HumDotaNetOps.h"
#import "HMPopMsgView.h"
#import "Simulator.h"
#import "NSString+Version.h"
#import "HumDotaDataMgr.h"
#import "HumDotaUserCenterOps.h"
#import "KDGoalBar.h"
#import "MBProgressHUD.h"
#import "ZipArchive.h"
#import "HeroInfo.h"
#import "HeroInfoSave.h"
#import "EquipInfo.h"


#define kSTGap 5
#define kSDGap 5

#define kDetailWidth 240


#define kDetailHeigh 180
#define kButtomH 10

#define SECONDS_IN_A_DAY 86400.0





@interface HumRightView()<UITableViewDelegate,UITableViewDataSource,DSDetailDelegate>
{
    int _selectTyp;
    int _checkTaskId;
    int _prePercentage;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *resultAry;
@property (nonatomic, retain) DSDetailView *detailView;

@property (nonatomic, retain) NSArray *heroTav;
@property (nonatomic, retain) NSArray *equipTav;
@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) Simulator *downSimlator;


@property (nonatomic, retain) UIView *progressBg;
@property (nonatomic, retain) KDGoalBar *progress;
@property (nonatomic, retain) MBProgressHUD *activityView;
@end


@implementation HumRightView

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView;
@synthesize resultAry;
@synthesize detailView;
@synthesize dsDelegate;
@synthesize heroTav;
@synthesize equipTav;
@synthesize downloader;
@synthesize downSimlator;
@synthesize progressBg;
@synthesize progress;
@synthesize activityView;

-(void)dealloc{
    
    [_managedObjectContext release];_managedObjectContext = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.tableView = nil;
    self.resultAry = nil;
    self.activityView = nil;
    self.detailView = nil;
    self.dsDelegate = nil;
    self.heroTav = nil;
    self.equipTav = nil;
    self.downSimlator = nil;
    self.progressBg = nil;
    self.progress = nil;
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame managedObjectContext:(NSManagedObjectContext *)context{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
        
        [_managedObjectContext release]; _managedObjectContext = nil;
        _managedObjectContext = [context retain];
        
        
        //        "dota.simu.hero" = "英雄";
        //        "dota.simu.equip" = "装备";
        
        _selectTyp = DOTAHERO;
        
        SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects: NSLocalizedString(@"dota.simu.hero", nil), NSLocalizedString(@"dota.simu.equip", nil),nil]];
        navSC.backgroundImage = [[Env sharedEnv] cacheImage:@"dota_seg_bg.png"];
        [self addSubview:navSC];
        
        navSC.center = CGPointMake(160, 20);
        [navSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [navSC release];
        [self segmentedControlChangedValue:navSC];
        
//        "dota.simu.hero.jw.strone" = "近卫力量（一）";
//        "dota.simu.hero.jw.strtwo" = "近卫力量（二）";
//        "dota.simu.hero.jw.agione" = "近卫敏捷（一）";
//        "dota.simu.hero.jw.agitwo" = "近卫敏捷（二）";
//        "dota.simu.hero.jw.intone" = "近卫智力（一）";
//        "dota.simu.hero.jw.inttwo" = "近卫智力（二）";
//        
//        "dota.simu.hero.tz.strone" = "天灾力量（一）";
//        "dota.simu.hero.tz.strtwo" = "天灾力量（二）";
//        "dota.simu.hero.tz.agione" = "天灾敏捷（一）";
//        "dota.simu.hero.tz.agitwo" = "天灾敏捷（二）";
//        "dota.simu.hero.tz.intone" = "天灾智力（一）";
//        "dota.simu.hero.tz.inttwo" = "天灾智力（二）";
        
        self.heroTav = [NSArray arrayWithObjects:NSLocalizedString(@"dota.simu.hero.jw.strone", nil), NSLocalizedString(@"dota.simu.hero.jw.strtwo", nil),NSLocalizedString(@"dota.simu.hero.jw.agione", nil),NSLocalizedString(@"dota.simu.hero.jw.agitwo", nil),NSLocalizedString(@"dota.simu.hero.jw.intone", nil),NSLocalizedString(@"dota.simu.hero.jw.inttwo", nil),NSLocalizedString(@"dota.simu.hero.tz.strone", nil),NSLocalizedString(@"dota.simu.hero.tz.strtwo", nil),NSLocalizedString(@"dota.simu.hero.tz.agione", nil),NSLocalizedString(@"dota.simu.hero.tz.agitwo", nil),NSLocalizedString(@"dota.simu.hero.tz.intone", nil),NSLocalizedString(@"dota.simu.hero.tz.inttwo", nil),nil];
        
//        dota.simu.equip.one" = "圣物关口";
//        "dota.simu.equip.two" = "支援法衣";
//        "dota.simu.equip.three" = "秘法圣所";
//        "dota.simu.equip.four" = "保护领地";
//        "dota.simu.equip.five" = "魅惑遗物";
//        "dota.simu.equip.six" = "远古兵器";
//        "dota.simu.equip.seven" = "武器商人";
//        "dota.simu.equip.egiht" = "饰品商人";
//        "dota.simu.equip.nine" = "奎尔瑟兰的密室";
//        "dota.simu.equip.ten" = "奇迹古树";
//        "dota.simu.equip.eleven" = "黑市商人";
        
           self.equipTav = [NSArray arrayWithObjects:NSLocalizedString(@"dota.simu.equip.one", nil), NSLocalizedString(@"dota.simu.equip.two", nil),NSLocalizedString(@"dota.simu.equip.three", nil),NSLocalizedString(@"dota.simu.equip.four", nil),NSLocalizedString(@"dota.simu.equip.five", nil),NSLocalizedString(@"dota.simu.equip.six", nil),NSLocalizedString(@"dota.simu.equip.seven", nil),NSLocalizedString(@"dota.simu.equip.egiht", nil),NSLocalizedString(@"dota.simu.equip.nine", nil),NSLocalizedString(@"dota.simu.equip.ten", nil),NSLocalizedString(@"dota.simu.equip.eleven", nil),nil];
        
        
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(navSC.frame), CGRectGetMaxY(navSC.frame)+kSTGap, CGRectGetWidth(navSC.frame), CGRectGetHeight(self.bounds)-CGRectGetMaxY(navSC.frame)-kDetailHeigh-kSTGap-20) style:UITableViewStylePlain] autorelease];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        
        self.detailView = [[[DSDetailView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-kDetailWidth)/2+ CGRectGetMinX(self.tableView.frame)/2,CGRectGetHeight(self.bounds)-kDetailHeigh-kButtomH, kDetailWidth, kDetailHeigh)] autorelease];
        self.detailView.delegate = self;
        [self addSubview:self.detailView];
        
        self.downloader = [[[Downloader alloc] init] autorelease];
        self.downloader.bSearialLoad = YES;
        _checkTaskId = -1;
        
    }
    return self;
    

}


- (void)viewWillAppear{
    [super viewWillAppear];
    if (_checkTaskId>0) {
        return;
    }
    self.downloader.delegate = nil;
    _checkTaskId = [HumDotaNetOps checkUpdataForSimulatorDownloader:self.downloader Target:self Sel:@selector(checkUpdataFinished:) Attached:nil];
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    [self.downloader cancelAll];
    self.downloader.delegate = nil;
    _checkTaskId = -1;
    
    if (self.progressBg != nil) {
        [self.progressBg removeFromSuperview];
        self.progressBg = nil;
    }
    [self.activityView hide:YES];
}



- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
    BqsLog(@"segmentedControlChangedValue did select %d",segmentedControl);
    if (segmentedControl.selectedIndex == DOTAHERO) {
        _selectTyp = DOTAHERO;
        
            
    }else if(segmentedControl.selectedIndex == DOTAEQUIP){
        _selectTyp = DOTAEQUIP;
    }

    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
    
}


- (void)configureResultWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    if(_selectTyp == DOTAHERO){
        self.resultAry = [HeroInfo fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate sortDescriptors:sortDescriptors];
    }else if(_selectTyp == DOTAEQUIP){
        self.resultAry = [Equipment fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate sortDescriptors:sortDescriptors];
    }
    [self detailViewReloadData];
}


- (void)detailViewReloadData
{
    if (_selectTyp == DOTAHERO) {
        [self.detailView setHeroArray:self.resultAry];
    }else if(_selectTyp == DOTAEQUIP){
        [self.detailView setEquipArray:self.resultAry];
    }
}



#pragma mark
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if(table == self.tableView){
        if(_selectTyp == DOTAHERO){
            return [self.heroTav count];
        }else if(_selectTyp == DOTAEQUIP){
            return 11;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tavernIdentify = @"tavernIdentify";
    if(table == self.tableView){
        DSTavernTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tavernIdentify];
        if(!cell){
            cell = [[[DSTavernTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tavernIdentify] autorelease];
        }
        NSString *name;
        if (_selectTyp == DOTAHERO) {
            name = [self.heroTav objectAtIndex:indexPath.row];
        }else if(_selectTyp == DOTAEQUIP){
            name = [self.equipTav objectAtIndex:indexPath.row];
        }
        
        cell.textLabel.text = name;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BqsLog(@"Table didSelectRowAtIndexPath %d",indexPath.row);
    if(_selectTyp == DOTAHERO){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kHeroTavern, [NSNumber numberWithInt:indexPath.row+1]];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kHeroOrder ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
        
        [self configureResultWithPredicate:predicate sortDescriptors:sortDescriptors];
    }else if(_selectTyp == DOTAEQUIP){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kShopNumber, [NSNumber numberWithInt:indexPath.row+1]];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kEquipOrder ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
        
        [self configureResultWithPredicate:predicate sortDescriptors:sortDescriptors];
        
    }
}


#define mark
#define makr DSDetailDelegate

- (void)didSelectHero:(HeroInfo *)hero{
    BqsLog(@"didSelectHero heroName = %@",hero.heroName);
    
    if(self.dsDelegate && [self.dsDelegate respondsToSelector:@selector(didSelectHero:)])
        [self.dsDelegate didSelectHero:hero];    

}
- (void)didSelectEquip:(Equipment *)equip{
    BqsLog(@"didSelectEquip heroName = %@",equip.equipName);
    
    if(self.dsDelegate && [self.dsDelegate respondsToSelector:@selector(didSelectEquip:)])
        [self.dsDelegate didSelectEquip:equip];
}

#pragma mark
#pragma mark checkUpdataFinished
- (void)checkUpdataFinished:(DownloaderCallbackObj *)cb{
    BqsLog(@"checkUpdataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:nil Delegate:nil];
        return;
	}
    self.downSimlator = [Simulator parseXmlData:cb.rspData];
    NSString *lastVerion = [HumDotaUserCenterOps objectValueForKey:kSimulatorLastVersionKey];
    NSString *ignoreVersion = [HumDotaUserCenterOps objectValueForKey:kSimulatorIgnoreVersion];
    if (lastVerion!=nil && [ignoreVersion isEqualToString:self.downSimlator.summary]) {
        BqsLog(@"the new version = ignoreVersion");
        return;
    }
    
    NSDate *lastRemindDate = [HumDotaUserCenterOps objectValueForKey:kSimulatorLastReminded];
    if (lastRemindDate != nil) {
        if([[NSDate date] timeIntervalSinceDate:lastRemindDate] < SECONDS_IN_A_DAY){
            BqsLog(@"the last remaind Date < one day");
            return;
        }
    }
    
    
    if (lastVerion == nil||[self.downSimlator.summary compareVersion:lastVerion] == NSOrderedAscending) {
        BqsLog(@"find a new version for simulator");
     
//        "dota.simu.newversion.first" = "您还没下载 DotA 模拟器数据，不能使用，最新版本是 %@,是否下载"；
//        "dota.simu.newversion.retry" = "您当前模拟器数据版本是 %@，最新版本是 %@,是否跟新"；
        NSString *details = @"";
        if (lastVerion == nil) {
            details = [NSString stringWithFormat:NSLocalizedString(@"dota.simu.newversion.first", nil),self.downSimlator.title];
        }else{
            NSString *lastName = [HumDotaUserCenterOps objectValueForKey:kSimulatorNowVersionName];
            details = [NSString stringWithFormat:NSLocalizedString(@"dota.simu.newversion.retry", nil),lastName,self.downSimlator.title];

        }
        
//        "dota.simu.ignore" = "忽略此版";
//        "dota.simu.download" = "下载更新";
//        "dota.simu.download.remind" = "稍后提示";
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil
                                    message:details
                                   delegate:(id<UIAlertViewDelegate>)self
                          cancelButtonTitle:NSLocalizedString(@"dota.simu.ignore", nil)
                          otherButtonTitles:NSLocalizedString(@"dota.simu.download", nil),NSLocalizedString(@"dota.simu.download.remind", nil),nil];
        [alter show];
        [alter release];
    }
    
    

}

- (void)simulatorFileFinished:(DownloaderCallbackObj *)cb{
    BqsLog(@"simulatorFileFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:nil Delegate:nil];
        return;
	}
    self.progress.hidden = YES;
    [self.activityView show:YES];
    
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:[[HumDotaDataMgr instance] pathOfSimlatorTempFile]] )
    {
        BOOL ret = [zip UnzipFileTo:[[HumDotaDataMgr instance] pathofSimulatorDir] overWrite:YES];
        if( NO==ret )
        {
            [HMPopMsgView showErrorAlert:nil Msg:NSLocalizedString(@"dota.simu.unzip.error", nil) Delegate:nil];
            return;
        }
        [zip UnzipCloseFile];
    }
    [zip release];
    
    NSFileManager *fm = [[NSFileManager alloc] init]; // delete temp file  for simulator
    NSError *error;
    [fm removeItemAtPath:[[HumDotaDataMgr instance] pathOfSimlatorTempFile] error:&error];
    
    
//    "dota.simu.save.hero.error" = "解析英雄数据出错,请重试";
//    "dota.simu.save.equip.error" = "解析物品装备数据出错,请重试";
//    "dota.simu.save.data.ok" = "解析数据成功,您可以使用最新版模拟器了";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //parase xml and save data to database;
        // 原代码块二
        BOOL result = [self saveHeroData];
        if (result) {
            // 原代码块三
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL done = [self saveEquipmentInfo];
                if (done) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activityView hide:YES];
                        [self.progressBg removeFromSuperview];
                        self.progressBg = nil;
                        [HumDotaUserCenterOps setObjectValue:self.downSimlator.title forKey:kSimulatorNowVersionName];
                        [HumDotaUserCenterOps setObjectValue:self.downSimlator.summary forKey:kSimulatorLastVersionKey];
                        [HMPopMsgView showPopMsgError:nil Msg:NSLocalizedString(@"dota.simu.save.data.ok", nil) Delegate:nil];
                    });
                }else{
                    NSLog(@"error when saveHeroData");
                    [self.activityView hide:YES];
                    [self.progressBg removeFromSuperview];
                    self.progressBg = nil;
                    [HMPopMsgView showErrorAlert:nil Msg:NSLocalizedString(@"dota.simu.save.equip.error", nil) Delegate:nil];
                }
                
            });
        } else {
            NSLog(@"error when stringParaseAgain");
            [self.activityView hide:YES];
            [self.progressBg removeFromSuperview];
            self.progressBg = nil;
            [HMPopMsgView showErrorAlert:nil Msg:NSLocalizedString(@"dota.simu.save.hero.error", nil) Delegate:nil];
        }
    });

    
}

-(void)DownloadProgres:(CGFloat)percentage{
    if (percentage <= _prePercentage) {
        return;
    }
    _prePercentage = percentage;
    [self.progress setPercent:_prePercentage animated:YES];
    
}


#pragma mark
#pragma mark UIAlterView Delegat
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //latest version
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        //ignore this version
        [HumDotaUserCenterOps setObjectValue:self.downSimlator.summary forKey:kSimulatorIgnoreVersion];
        [HumDotaUserCenterOps setObjectValue:nil forKey:kSimulatorLastReminded];
        
        //log event
    }
    else if (buttonIndex == 2)
    {
        //remind later
        [HumDotaUserCenterOps setObjectValue:[NSDate date] forKey:kSimulatorLastReminded];
               
        //log event
    }
    else
    {
        //clear reminder
       [HumDotaUserCenterOps setObjectValue:nil forKey:kSimulatorLastReminded];
        
        self.progressBg = [[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.btnRightMask.frame), 0, CGRectGetWidth(self.bounds)-CGRectGetMaxX(self.btnRightMask.frame), CGRectGetHeight(self.bounds))] autorelease];
        self.progressBg.backgroundColor = [UIColor blackColor];
        self.progressBg.alpha = 0.8f;
        [self addSubview:self.progressBg];
        
        self.progress = [[[KDGoalBar alloc] initWithFrame:CGRectMake(0, 0, 177, 177)] autorelease];
        [self.progress setAllowDragging:NO];
        [self.progress setAllowSwitching:NO];
        [self.progress setPercent:0 animated:NO];
        self.progress.hidden = NO;
        _prePercentage = 0;
        [self addSubview:self.progress];
        
        self.activityView = [[[MBProgressHUD alloc] initWithView:self] autorelease];
        self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.activityView.mode = MBProgressHUDModeIndeterminate;
        self.activityView.animationType = MBProgressHUDAnimationZoom;
        self.activityView.screenType = MBProgressHUDSectionScreen;
        self.activityView.opacity = 0.5;
        self.activityView.labelText = NSLocalizedString(@"dota.simu.data.ready", nil);
        [self  addSubview:self.activityView];
        [self.activityView hide:YES];
        
        self.progress.center = self.progressBg.center;
        
        
       self.downloader.delegate = self;
       [self.downloader addTask:self.downSimlator.content DownloadPath:[[HumDotaDataMgr instance] pathOfSimlatorTempFile] Resume:NO Target:self Callback:@selector(simulatorFileFinished:) Attached:nil];

        //log event
        
    }
    
    //release alert
}




#pragma mark
#pragma mark save data
- (BOOL)saveHeroData{
        
    NSString *txtPath = [[HumDotaDataMgr instance] pathOfHeroInfoXML];

    NSData *heroData = [NSData dataWithContentsOfFile:txtPath];
    if (heroData == nil) {
        BqsLog(@"heroData read data = nil");
        return FALSE;
    }
    
    NSArray *heroList = [HeroInfoParase parseHeroList:heroData];
    if (heroList == nil || heroList.count == 0) {
        BqsLog(@"HeroInfo heroList = nil or heroList count = 0");
        return FALSE;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    for (HeroInfoSave *hero in heroList) {
        
        HeroInfo *heroInfo = [HeroInfo fetchWithManagedObjectContext:context keyAttributeName:kHeroDBSN keyAttributeValue:[NSString stringWithFormat:@"%d",hero.HeroSN] ];
        if (!heroInfo) {
            heroInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HeroInfo class]) inManagedObjectContext:context];
            
        }
        
        heroInfo.heroSN = [NSNumber numberWithInt:hero.HeroSN];
        heroInfo.available = [NSNumber numberWithBool:hero.Available];
        heroInfo.heroName = hero.HeroName;
        heroInfo.heroGif = [NSString stringWithFormat:@"character_%d.gif",hero.HeroSN];
        heroInfo.heroImage = [NSString stringWithFormat:@"hero_%d_0.jpg",hero.HeroSN];
        heroInfo.heroNameEn = hero.HeroNameEn;
        heroInfo.heroTitleEn = hero.HeroTitleEn;
        heroInfo.heroTitleCN = hero.HeroTitleCN;
        heroInfo.heroStory = hero.HeroStory;
        heroInfo.heroQuality = [NSNumber numberWithInt:hero.HeroQuality];
        heroInfo.heroTavern = [NSNumber numberWithInt:hero.HeroTavern];
        heroInfo.heroOrder = [NSNumber numberWithInt:hero.HeroOrder];
        heroInfo.initialStrength = hero.initialStrength;
        heroInfo.initialAgility = hero.initialAgility;
        heroInfo.initialintelligence = hero.initialintelligence;
        heroInfo.strengthGrow = hero.StrengthGrow;
        heroInfo.agilityGrow = hero.AgilityGrow;
        heroInfo.intelligenceGrow = hero.IntelligenceGrow;
        heroInfo.initialintelligence = hero.initialintelligence;
        heroInfo.initialHP = [NSNumber numberWithInt:hero.initialHP];
        heroInfo.initialMP =  [NSNumber numberWithInt:hero.initialMP];
        heroInfo.initialDef = hero.initialDef;
        heroInfo.initialArmor = hero.initialArmor;
        heroInfo.initialDamage1 = [NSNumber numberWithInt:hero.initialDamage1];
        heroInfo.initialDamage2 = [NSNumber numberWithInt:hero.initialDamage2];
        heroInfo.moveSpeed = [NSNumber numberWithInt:hero.MoveSpeed];
        heroInfo.attackRange = hero.AttackRange;
        heroInfo.attackAnimation = hero.AttackAnimation;
        heroInfo.castingAnimation = hero.CastingAnimation;
        heroInfo.baseAttackTime = hero.BaseAttackTime;
        heroInfo.missileSpeed = [NSNumber numberWithInt:hero.MissileSpeed];
        heroInfo.sightRange = hero.SightRange;
        
        heroInfo.skill1Name = hero.Skill1Name;
        heroInfo.skill1Image = [NSString stringWithFormat:@"hero_%d_3.jpg",hero.HeroSN];
        heroInfo.skill1Introduce = hero.Skill1Introduce;
        heroInfo.skill1Note = hero.Skill1Note;
        heroInfo.skill1Level1 = hero.Skill1Level1;
        heroInfo.skill1Level2 = hero.Skill1Level2;
        heroInfo.skill1Level3 = hero.Skill1Level3;
        heroInfo.skill1Level4 = hero.Skill1Level4;
        
        heroInfo.skill2Name = hero.Skill2Name;
        heroInfo.skill2Image = [NSString stringWithFormat:@"hero_%d_4.jpg",hero.HeroSN];
        heroInfo.skill2Introduce = hero.Skill2Introduce;
        heroInfo.skill2Note = hero.Skill2Note;
        heroInfo.skill2Level1 = hero.Skill2Level1;
        heroInfo.skill2Level2 = hero.Skill2Level2;
        heroInfo.skill2Level3 = hero.Skill2Level3;
        heroInfo.skill2Level4 = hero.Skill2Level4;
        
        
        heroInfo.skill3Name = hero.Skill3Name;
        heroInfo.skill3Image = [NSString stringWithFormat:@"hero_%d_5.jpg",hero.HeroSN];
        heroInfo.skill3Introduce = hero.Skill3Introduce;
        heroInfo.skill3Note = hero.Skill3Note;
        heroInfo.skill3Level1 = hero.Skill3Level1;
        heroInfo.skill3Level2 = hero.Skill3Level2;
        heroInfo.skill3Level3 = hero.Skill3Level3;
        heroInfo.skill3Level4 = hero.Skill3Level4;
        
        heroInfo.skill4Name = hero.Skill4Name;
        heroInfo.skill4Image = [NSString stringWithFormat:@"hero_%d_6.jpg",hero.HeroSN];
        heroInfo.skill4Introduce = hero.Skill4Introduce;
        heroInfo.skill4Note = hero.Skill4Note;
        heroInfo.skill4Level1 = hero.Skill4Level1;
        heroInfo.skill4Level2 = hero.Skill4Level2;
        heroInfo.skill4Level3 = hero.Skill4Level3;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return FALSE;
        }
        
    }
    
    return TRUE;

}

- (BOOL)saveEquipmentInfo{
    
    
    NSString *txtPath = [[HumDotaDataMgr instance] pathOfEquipInfoXML];
    NSData *equipData = [NSData dataWithContentsOfFile:txtPath];
    if (equipData == nil) {
        BqsLog(@"Equipment read data = nil");
        return FALSE;
    }
    NSArray *equipList = [EquipParase parseEqpuipList:equipData];
    if (equipList == nil || equipList.count == 0) {
        BqsLog(@"Equipment equipList = nil or equiplist count = 0");
        return FALSE;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * allUpdata = [[NSFetchRequest alloc] init];
    [allUpdata setEntity:[NSEntityDescription entityForName:NSStringFromClass([Upgrade class]) inManagedObjectContext:context]];
    [allUpdata setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * updatas = [context executeFetchRequest:allUpdata error:&error];
    [allUpdata release];
    //error handling goes here
    for (NSManagedObject * updata in updatas) {
        [context deleteObject:updata];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
    
    NSFetchRequest * allMaterial = [[NSFetchRequest alloc] init];
    [allMaterial setEntity:[NSEntityDescription entityForName:NSStringFromClass([Material class]) inManagedObjectContext:context]];
    [allMaterial setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    error = nil;
    NSArray * materials = [context executeFetchRequest:allMaterial error:&error];
    [allMaterial release];
    //error handling goes here
    for (NSManagedObject * material in materials) {
        [context deleteObject:material];
    }
    saveError = nil;
    [context save:&saveError];
    
    
    for (EquipInfo *equipInfo in equipList) {
        
        
        NSDictionary *dic;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip1Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip2Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip3Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip4Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip5Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip6Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip7Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip8Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.equip9Upg],kUpgradSN, nil];
        [Upgrade insertWithManagedObjectContext:context value:dic];
        
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material1Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material2Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material3Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material4Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material5Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material6Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material7Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material8Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:equipInfo.equipSN],kEquipSN,[NSNumber numberWithInt:equipInfo.material9Need],kMaterialSN, nil];
        [Material insertWithManagedObjectContext:context value:dic];
        
        Equipment *equip = [Equipment fetchWithManagedObjectContext:context keyAttributeName:kEquipSN keyAttributeValue:[NSString stringWithFormat:@"%d",equipInfo.equipSN] ];
        if (!equip) {
            equip = [NSEntityDescription insertNewObjectForEntityForName:@"Equipment" inManagedObjectContext:context];
            
        }
        
        equip.equipSN = [NSNumber numberWithInt:equipInfo.equipSN];
        equip.available = [NSNumber numberWithBool:equipInfo.available];
        equip.upgrade = [NSNumber numberWithBool:equipInfo.upgrade];
        equip.shopNumber = [NSNumber numberWithInt:equipInfo.shopNumber];
        equip.equipOrder = [NSNumber numberWithInt:equipInfo.equipOrder];
        equip.equipName = equipInfo.equipName;
        equip.equipImage = [NSString stringWithFormat:@"item__%d.JPG",equipInfo.equipSN];
        equip.formulaBe = [NSNumber numberWithBool:equipInfo.formulaBe];
        equip.equipPrice = [NSNumber numberWithInt:equipInfo.equipPrice];
        equip.equipDescrip = equipInfo.equipDescrip;
        equip.addHP = [NSNumber numberWithInt:equipInfo.addHP];
        equip.addMP = [NSNumber numberWithInt:equipInfo.addMP];
        equip.addArmor = [NSNumber numberWithFloat:equipInfo.addArmor];
        equip.addDamage = [NSNumber numberWithInt:equipInfo.addDamage];
        
        equip.addStrength = [NSNumber numberWithInt:equipInfo.addStrength];
        equip.addAgilityh = [NSNumber numberWithInt:equipInfo.addAgilityh];
        equip.addIntelligence = [NSNumber numberWithInt:equipInfo.addIntelligence];
        equip.upgradeNum = [NSNumber numberWithInt:equipInfo.upgradeNum];
        
        equip.materialNum = [NSNumber numberWithInt:equipInfo.materialNum];
        equip.formulaNeed = [NSNumber numberWithBool:equipInfo.formulaNeed];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return FALSE;
        }
        
    }
    
    return TRUE;

}



@end
