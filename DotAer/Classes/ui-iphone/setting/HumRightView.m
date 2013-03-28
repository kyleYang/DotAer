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

#define kSTGap 5
#define kSDGap 5

#define kDetailWidth 240


#define kDetailHeigh 180
#define kButtomH 10


@interface HumRightView()<UITableViewDelegate,UITableViewDataSource,DSDetailDelegate>
{
    int _selectTyp;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *resultAry;
@property (nonatomic, retain) DSDetailView *detailView;

@property (nonatomic, retain) NSArray *heroTav;
@property (nonatomic, retain) NSArray *equipTav;

@end


@implementation HumRightView

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView;
@synthesize resultAry;
@synthesize detailView;
@synthesize dsDelegate;
@synthesize heroTav;
@synthesize equipTav;


-(void)dealloc{
    
    [_managedObjectContext release];_managedObjectContext = nil;
    self.tableView = nil;
    self.resultAry = nil;
    self.detailView = nil;
    self.dsDelegate = nil;
    self.heroTav = nil;
    self.equipTav = nil;
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
        
        
    }
    return self;
    

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


@end
