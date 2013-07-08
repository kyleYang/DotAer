//
//  HumRightView.m
//  DotAer
//
//  Created by Kyle on 13-2-4.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumRightViewController.h"
#import "SVSegmentedControl.h"
#import "Env.h"
#import "BqsUtils.h"
#import "DSTavernTableCell.h"
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
#import "HumShopCell.h"
#import "DSEquipView.h"
#import "PKRevealController.h"
#import "HumSimulaterCell.h"
#import "CustomNavigationBar.h"
#import "AKSegmentedControl.h"

#define kSTGap 5
#define kSDGap 5

#define kDetailWidth 240


#define kDetailHeigh 180
#define kButtomH 18

#define SECONDS_IN_A_DAY 86400.0

#define kMainRightViewRightGap 30



@interface HumRightViewController()<UITableViewDataSource,UITableViewDelegate,HumShopCellDelegate,DSEquipViewDelegate,simulateCellDelegate>
{
    int _selectTyp;
    int _checkTaskId;
    int _prePercentage;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *resultAry;
@property (nonatomic, retain) AKSegmentedControl *navSC;

@property (nonatomic, retain) NSArray *heroTav;
@property (nonatomic, retain) NSArray *equipTav;
@property (nonatomic, retain) NSArray *equipImgAry;
@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) Simulator *downSimlator;
@property (nonatomic, retain) NSMutableArray *heroArray;
@property (nonatomic, retain) NSMutableArray *equipArray;

@property (nonatomic, retain) UITextView *equipDescript;

@property (nonatomic, retain) UIView *progressBg;
@property (nonatomic, retain) KDGoalBar *progress;
@property (nonatomic, retain) MBProgressHUD *activityView;
@end


@implementation HumRightViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView = _tableView;
@synthesize resultAry;
@synthesize heroTav;
@synthesize equipTav;
@synthesize equipImgAry;
@synthesize downloader;
@synthesize downSimlator;
@synthesize progressBg;
@synthesize progress;
@synthesize activityView;
@synthesize equipDescript;
@synthesize heroArray;
@synthesize equipArray;
@synthesize navSC;
@synthesize delegate;

-(void)dealloc{
    
    [_managedObjectContext release];_managedObjectContext = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.tableView = nil;
    self.resultAry = nil;
    self.activityView = nil;
    self.heroTav = nil;
    self.equipTav = nil;
    self.downSimlator = nil;
    self.progressBg = nil;
    self.progress = nil;
    self.equipImgAry = nil;
    self.heroArray = nil;
    self.equipArray = nil;
    self.navSC = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bg.image = [[Env sharedEnv] cacheScretchableImage:@"background.png" X:20 Y:10];
    [self.view addSubview:bg];
    [bg release];
    
    
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(kMainRightViewRightGap, 0, CGRectGetWidth(self.view.bounds), 44)];
    UIImage *bgImg = [[Env sharedEnv] cacheImage:@"dota_frame_title_bg.png"];
    [navBar setCustomBgImage:bgImg];
	[self.view addSubview:navBar];
    [navBar release];
    

    
    _selectTyp = DOTAHERO;
    
    
    self.navSC = [[[AKSegmentedControl alloc] initWithFrame:CGRectMake(65, 10, 170, 30)] autorelease];
    
    
    UIImage *backgroundImage = [[Env sharedEnv] cacheImage:@"segmented-bg.png"];
    [self.navSC setBackgroundImage:backgroundImage];
    [self.navSC setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [self.navSC setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.navSC setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [self.navSC setSeparatorImage:[[Env sharedEnv] cacheImage:@"segmented-separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[Env sharedEnv] cacheImage:@"segmented-bg-pressed-left.png"];
    UIImage *buttonBackgroundImagePressedRight = [[Env sharedEnv] cacheImage:@"segmented-bg-pressed-right.png"];
    // Button 1
    UIButton *buttonSocial = [[UIButton alloc] init];
    
//    "dota.simu.hero" = "英雄酒馆";
//    "dota.simu.equip" = "装备商店";
    
    [buttonSocial setTitle:NSLocalizedString(@"dota.simu.hero", nil) forState:UIControlStateNormal];
    [buttonSocial setTitle:NSLocalizedString(@"dota.simu.hero", nil) forState:UIControlStateHighlighted];
    [buttonSocial setTitle:NSLocalizedString(@"dota.simu.hero", nil) forState:UIControlStateSelected];
    [buttonSocial setTitle:NSLocalizedString(@"dota.simu.hero", nil) forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [buttonSocial addTarget:self action:@selector(dota1Select:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    
    // Button 3
    UIButton *buttonSettings = [[UIButton alloc] init];
    [buttonSettings setTitle:NSLocalizedString(@"dota.simu.equip", nil) forState:UIControlStateNormal];
    [buttonSettings setTitle:NSLocalizedString(@"dota.simu.equip", nil) forState:UIControlStateHighlighted];
    [buttonSettings setTitle:NSLocalizedString(@"dota.simu.equip", nil) forState:UIControlStateSelected];
    [buttonSettings setTitle:NSLocalizedString(@"dota.simu.equip", nil) forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonSettings addTarget:self action:@selector(dota2Select:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.navSC setButtonsArray:[NSArray arrayWithObjects:buttonSocial,buttonSettings,nil]];
   
    [buttonSocial release];
    [buttonSettings release];
    [navBar addSubview:self.navSC];
    

    
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
//    [NSArray arrayWithObjects:@"jw_strone.gif",@"jw_strtwo.gif",@"jw_agione.gif",@"jw_agitwo.gif",@"jw_intone.gif",@"jw_inttwo.gif",@"tz_strone.gif",@"tz_strtwo.gif",@"tz_agione.gif",@"tz_agitwo.gif",@"tz_intone.gif",@"tz_inttwo.gif",nil];
//    
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
    self.equipImgAry = [NSArray arrayWithObjects:@"equip_one.jpg",@"equip_two.jpg",@"equip_three.gif",@"equip_four.jpg",@"equip_five.jpg",@"equip_six.jpg",@"equip_seven.jpg",@"equip_egiht.jpg",@"equip_nine.jpg",@"equip_ten.jpg",@"equip_eleven.jpg", nil];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(navBar.frame)+kSTGap, CGRectGetWidth(self.view.bounds)-50, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(navBar.frame)-kSTGap-120)] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-kDetailWidth)/2+ CGRectGetMinX(self.tableView.frame)/2-10,CGRectGetMaxY(self.tableView.frame)+2, kDetailWidth+10, 2)];
    line.image = [[Env sharedEnv] cacheImage:@"dota_line.png"];
    [self.view addSubview:line];
    [line release];

    
    self.equipDescript = [[[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMaxY(self.tableView.frame)+4, kDetailWidth, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.tableView.frame)-8 )] autorelease];
    self.equipDescript.backgroundColor = [UIColor clearColor];
    self.equipDescript.textColor = [UIColor blackColor];
    self.equipDescript.font = [UIFont systemFontOfSize:14.0f];
    self.equipDescript.editable = NO;
    self.equipDescript.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.equipDescript];
    
        
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    _checkTaskId = -1;
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_checkTaskId>0) {
        return;
    }
    self.downloader.delegate = nil;
    _checkTaskId = [HumDotaNetOps checkUpdataForSimulatorDownloader:self.downloader Target:self Sel:@selector(checkUpdataFinished:) Attached:nil];
   
    NSString *lastVerion = [HumDotaUserCenterOps objectValueForKey:kSimulatorLastVersionKey];
    if (lastVerion) {
        [self dota1Select:nil];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.downloader cancelAll];
    self.downloader.delegate = nil;
    _checkTaskId = -1;
    
    if (self.progressBg != nil) {
        [self.progressBg removeFromSuperview];
        self.progressBg = nil;
    }
    [self.activityView hide:YES];
}

- (void)dota1Select:(id)sender{
    BqsLog(@"dota2Select");
      _selectTyp = DOTAHERO;
     [self configHeroData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
}

- (void)dota2Select:(id)sender{
    BqsLog(@"dota1Select");
    _selectTyp = DOTAEQUIP;
    [self configEquipData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
    
}



- (void)configHeroData{
    
    if (!self.heroArray) {
        
        
        self.heroArray = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
        
        for (int indx= 0; indx<[self.heroTav count]; indx++) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kHeroTavern, [NSNumber numberWithInt:indx+1]];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kHeroOrder ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
            NSArray *result =  [HeroInfo fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate sortDescriptors:sortDescriptors];
            if (result) {
                [self.heroArray addObject:result];
            }
            
        }
    }
    
}


- (void)configEquipData{
    
    if (!self.equipArray) {
        self.equipArray = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
        
        for (int indx=0; indx<[self.equipTav count]; indx++) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kShopNumber, [NSNumber numberWithInt:indx+1]];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kEquipOrder ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
            
            NSArray *result = [Equipment fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate sortDescriptors:sortDescriptors];
            if (result) {
                [self.equipArray addObject:result];
            }
            
        }
    }
    
}




#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.tableView){
        if(_selectTyp == DOTAHERO){
            return [self.heroTav count];
        }else if(_selectTyp == DOTAEQUIP){
            return [self.equipTav count];
        }
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.tableView){
        if(_selectTyp == DOTAHERO){
            if (section>= self.heroTav.count) {
                return nil;
            }
            return [self.heroTav objectAtIndex:section];
        }else if(_selectTyp == DOTAEQUIP){
            if (section>= self.equipTav.count) {
                return nil;
            }
            return [self.equipTav objectAtIndex:section];
        }
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *dataAry = nil;
    if (_selectTyp == DOTAHERO) {
        if ([self.heroArray count] > section) {
            dataAry = [self.heroArray objectAtIndex:section];
        }
    }else if(_selectTyp == DOTAEQUIP){
        if ([self.equipArray count] > section) {
            dataAry = [self.equipArray objectAtIndex:section];
        }
    }
    
    if (!dataAry) {
        return 0;
    }
    
    int row = [HumSimulaterCell rowCntForItemCnt:[dataAry count] ColumnCnt:[HumSimulaterCell columnCntForWidth:CGRectGetWidth(self.tableView.frame)]];
    
    BqsLog(@"numberOfRowsInSection :%d",row);
    return row;


    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde = @"cell";
    HumSimulaterCell *cell = (HumSimulaterCell *)[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[[HumSimulaterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *dataAry = nil;
    cell.delegate = self;
    if (_selectTyp == DOTAHERO) {
        if ([self.heroArray count] > indexPath.section) {
            dataAry = [self.heroArray objectAtIndex:indexPath.section];
            [cell setHeroArr:dataAry Row:indexPath.row];
        }
    }else if(_selectTyp == DOTAEQUIP){
        if ([self.equipArray count] > indexPath.section) {
            dataAry = [self.equipArray objectAtIndex:indexPath.section];
            [cell setEquipArr:dataAry Row:indexPath.row];
        }
    }
    
    
    return cell;
    
}



#define mark
#define makr DSDetailDelegate

- (void)humSimulateCell:(HumSimulaterCell *)cell didSelectHero:(HeroInfo *)hero{
    BqsLog(@"didSelectHero heroName = %@",hero.heroName);
    
    self.equipDescript.text = hero.heroStory;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectHero:)]) {
        [self.delegate didSelectHero:hero];
    }
    [self.revealController showViewController:self.revealController.frontViewController];
}



- (void)humSimulateCell:(HumSimulaterCell *)cell didSelectEquip:(Equipment *)equip{
    
    BqsLog(@"didSelectEquip heroName = %@",equip.equipName);
    NSArray *upgrades = [self fetchUpgradeResultWithSN:equip.equipSN];
    NSArray *materials = [self fetchMaterialResultWithSN:equip.equipSN];
    NSMutableString *descrip = [NSMutableString stringWithCapacity:1024];
    
    
    [descrip appendString:NSLocalizedString(@"dota.simu.equip.name", nil)];
    [descrip appendString:equip.equipName];
    [descrip appendString:@"\n"];
    [descrip appendString:NSLocalizedString(@"dota.simu.equip.desrip", nil)];
    [descrip appendString:equip.equipDescrip];
    [descrip appendString:@"\n"];
    [descrip appendString:NSLocalizedString(@"dota.simu.equip.mataril", nil)];
    if (!materials || materials.count == 0) {
        [descrip appendString:NSLocalizedString(@"dota.simu.equip.null", nil)];
    }else {
        for (Material *material in materials) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, material.materialSN];
            BqsLog(@"in DSEquipment predicate:%@",predicate);
            Equipment *eqip = [Equipment fetchWithManagedObjectContext:self.managedObjectContext predicate:predicate];
            [descrip appendString:eqip.equipName];
            [descrip appendString:@" "];
        }
    }
    
    [descrip appendString:@"\n"];
    [descrip appendString:NSLocalizedString(@"dota.simu.equip.upgade", nil)];
    if (!upgrades || upgrades.count == 0) {
        [descrip appendString:NSLocalizedString(@"dota.simu.equip.null", nil)];
    }else {
        
        for (Upgrade *upg in upgrades) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, upg.upgradSN];
            BqsLog(@"in DSEquipment predicate:%@",predicate);
            Equipment *eqip = [Equipment fetchWithManagedObjectContext:self.managedObjectContext predicate:predicate];
            [descrip appendString:eqip.equipName];
            [descrip appendString:@" "];
        }
    }
    [descrip appendString:@"\n"];
    [descrip appendString:NSLocalizedString(@"dota.simu.equip.mual", nil)];
    [descrip appendString:[equip.formulaNeed boolValue]?NSLocalizedString(@"dota.simu.equip.mual.need", nil):NSLocalizedString(@"dota.simu.equip.mual.noneed", nil)];
    
    self.equipDescript.text = descrip;
    
    //    "dota.simu.equip.name" = "装备名字:"
    //    "dota.simu.equip.desrip" = "简介:";
    //    "dota.simu.equip.mataril" = "原材料:";
    //    "dota.simu.equip.upgade" = "可升级:"
    //    "dota.simu.equip.mual" = "需要合成书:";
    //    "dota.simu.equip.mual.need" = "需要";
    //    "dota.simu.equip.mual.noneed" = "不需要";
    //    "dota.simu.equip.null" = "无";
    
//    [self.equipSimu addEquip:equip formula:[equip.formulaBe boolValue]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectEquip:)]) {
        [self.delegate didSelectEquip:equip];
    }
    
}


- (void)DSEquipViewDidSelect:(Equipment *)equip{
    
}

#pragma mark
#pragma mark DataBase

- (NSMutableArray *)fetchUpgradeResultWithSN:(NSNumber *)sn
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, sn];
    return [Upgrade fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate];
}


- (NSMutableArray *)fetchMaterialResultWithSN:(NSNumber *)sn
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kEquipSN, sn];
    return [Material fetchedResultsWithManagedObjectContext:self.managedObjectContext predicate:predicate];
}


#pragma mark
#pragma mark checkUpdataFinished
- (void)checkUpdataFinished:(DownloaderCallbackObj *)cb{
    BqsLog(@"checkUpdataFinished:%@",cb);
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
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
    if (lastVerion&&lastRemindDate != nil) {
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
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
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
            [zip release];
            return;
        }
        [zip UnzipCloseFile];
    }
    [zip release];
    
    NSFileManager *fm = [[NSFileManager alloc] init]; // delete temp file  for simulator
    NSError *error;
    [fm removeItemAtPath:[[HumDotaDataMgr instance] pathOfSimlatorTempFile] error:&error];
    [fm release];
    
    
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
        
        if (self.progressBg) {
            [self.progressBg removeFromSuperview];
            self.progressBg = nil;
        }
        self.progressBg = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))] autorelease];
        self.progressBg.backgroundColor = [UIColor blackColor];
        self.progressBg.alpha = 0.8f;
        [self.view addSubview:self.progressBg];
        
        if (self.progress) {
            [self.progress removeFromSuperview];
            self.progress = nil;
        }
        self.progress = [[[KDGoalBar alloc] initWithFrame:CGRectMake(0, 0, 177, 177)] autorelease];
        [self.progress setAllowDragging:NO];
        [self.progress setAllowSwitching:NO];
        [self.progress setPercent:0 animated:NO];
        self.progress.hidden = NO;
        _prePercentage = 0;
        self.progress.allowTap = NO;
        [self.progress setPercent:_prePercentage animated:NO];
        [self.view addSubview:self.progress];
        
        if (self.activityView) {
            [self.activityView removeFromSuperview];
            self.activityView = nil;
        }
        self.activityView = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.activityView.mode = MBProgressHUDModeIndeterminate;
        self.activityView.animationType = MBProgressHUDAnimationZoom;
        self.activityView.screenType = MBProgressHUDSectionScreen;
        self.activityView.opacity = 0.5;
        self.activityView.labelText = NSLocalizedString(@"dota.simu.data.ready", nil);
        [self.view  addSubview:self.activityView];
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



- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}




@end
