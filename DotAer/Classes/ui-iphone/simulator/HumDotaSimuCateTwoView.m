//
//  HumDotaSimuCateTwoView.m
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSimuCateTwoView.h"
#import "HumDotaSimuTableHeadView.h"
#import "HumDotaSimuTableCell.h"
#import "SimuImageHelp.h"

#define kCellGap 5

@interface HumDotaSimuCateTwoView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) HumDotaSimuTableHeadView *headView;
@property (nonatomic, retain) HeroInfo *selectHero;
@property (nonatomic, retain) Equipment *selectEquip;


@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@end

@implementation HumDotaSimuCateTwoView
@synthesize tableView;
@synthesize headView;
@synthesize selectHero = _selectHero;
@synthesize selectEquip = _selectEquip;
@synthesize managedObjectContext;

- (void)dealloc{
    self.tableView = nil;
    self.headView = nil;
    self.managedObjectContext = nil;
    [_selectHero release];
    [_selectEquip release];
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame managedObjectContext:(NSManagedObjectContext *)manager
{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (nil == self) return nil;
    
    self.backgroundColor = [UIColor colorWithRed:117.0f/255.0f green:95.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
    
    self.managedObjectContext = manager;
    // create subview
    self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    self.headView = [[[HumDotaSimuTableHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 200)] autorelease];
    self.headView.managedObjectContext = self.managedObjectContext;
    self.tableView.tableHeaderView = self.headView;
    
    return self;
    
}

-(void)setSelectHero:(HeroInfo *)aHero
{
    if (_selectHero == aHero) {
        BqsLog(@"Hero already selected, hero name = %@",aHero.heroName);
        return;
    }
    
    [_selectHero release];
    _selectHero = [aHero retain];
    
    if (!_selectHero) {
        return;
    }
    
    self.headView.hero = _selectHero;
    
    self.headView.heroNameEn.text = _selectHero.heroNameEn;
    self.headView.grade = 1;
    
    self.headView.heroNameCN.text = _selectHero.heroName;
    
    self.headView.heroHead.image = [SimuImageHelp imageForHeroSN:_selectHero.heroSN WithFileName:_selectHero.heroImage];
    
    CGRect frame;
    
    frame = self.headView.HPLeb.frame;
    frame.origin.y = 170;
    self.headView.HPLeb.frame = frame;
    self.headView.HPLeb.text = [_selectHero.initialHP stringValue];
    
    frame = self.headView.MPLeb.frame;
    frame.origin.y = CGRectGetMaxY(self.headView.HPLeb.frame)+3;
    self.headView.MPLeb.frame = frame;
    self.headView.MPLeb.text = [_selectHero.initialMP stringValue];
    
    self.headView.damage.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"DS.hero.Damge",@"simulator",nil),[_selectHero.initialDamage1 stringValue],[_selectHero.initialDamage2 stringValue]];
    self.headView.armor.text = _selectHero.initialArmor;
    
    self.headView.strength.text = _selectHero.initialStrength;
    self.headView.agility.text = _selectHero.initialAgility;
    self.headView.intelligence.text = _selectHero.initialintelligence;
    
    
    CGSize frameSize = [_selectHero.heroStory sizeWithFont:self.headView.heroHistrory.font constrainedToSize:CGSizeMake(300, 800) lineBreakMode:UILineBreakModeWordWrap];
    frame = self.headView.heroHistrory.frame;
    frame.origin.y = CGRectGetMaxY(self.headView.additionIntelligence.frame)+20;
    frame.size.height = frameSize.height;
    self.headView.heroHistrory.frame = frame;
    self.headView.heroHistrory.text = _selectHero.heroStory;
    
    frame = self.headView.frame;
    frame.size.height = CGRectGetMaxY(self.headView.heroHistrory.frame);
    self.headView.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView reloadData];
    
}

- (void)setSelectEquip:(Equipment *)aselectEquip
{
    if (!aselectEquip) {
        return;
    }
    [self.headView.equipSimu addEquip:aselectEquip formula:[aselectEquip.formulaBe boolValue]];
}


#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (!_selectHero) {
        return 0;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cellId";
    HumDotaSimuTableCell *cell = (HumDotaSimuTableCell *)[aTableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[[HumDotaSimuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden] autorelease];
    }
   
    NSMutableArray *arrItem = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    if (indexPath.row == 0) {
        [arrItem addObject:_selectHero.skill1Image];
        [arrItem addObject:_selectHero.skill1Name];
        [arrItem addObject:_selectHero.skill1Introduce];
        [arrItem addObject:_selectHero.skill1Note];
        [arrItem addObject:_selectHero.skill1Level1];
        [arrItem addObject:_selectHero.skill1Level2];
        [arrItem addObject:_selectHero.skill1Level3];
        [arrItem addObject:_selectHero.skill1Level4];
        
    }else if(indexPath.row == 1){
        [arrItem addObject:_selectHero.skill2Image];
        [arrItem addObject:_selectHero.skill2Name];
        [arrItem addObject:_selectHero.skill2Introduce];
        [arrItem addObject:_selectHero.skill2Note];
        [arrItem addObject:_selectHero.skill2Level1];
        [arrItem addObject:_selectHero.skill2Level2];
        [arrItem addObject:_selectHero.skill2Level3];
        [arrItem addObject:_selectHero.skill2Level4];
        
    }else if(indexPath.row == 2){
        [arrItem addObject:_selectHero.skill3Image];
        [arrItem addObject:_selectHero.skill3Name];
        [arrItem addObject:_selectHero.skill3Introduce];
        [arrItem addObject:_selectHero.skill3Note];
        [arrItem addObject:_selectHero.skill3Level1];
        [arrItem addObject:_selectHero.skill3Level2];
        [arrItem addObject:_selectHero.skill3Level3];
        [arrItem addObject:_selectHero.skill3Level4];
        
    }else if(indexPath.row == 3){
        [arrItem addObject:_selectHero.skill4Image];
        [arrItem addObject:_selectHero.skill4Name];
        [arrItem addObject:_selectHero.skill4Introduce];
        [arrItem addObject:_selectHero.skill4Note];
        [arrItem addObject:_selectHero.skill4Level1];
        [arrItem addObject:_selectHero.skill4Level2];
        [arrItem addObject:_selectHero.skill4Level3];
        [arrItem addObject:@""];
        
    }else{
        BqsLog(@"error skill Level");
        return nil;
    }
    
    cell.skillImg.image = [SimuImageHelp imageForHeroSN:_selectHero.heroSN WithFileName:[arrItem objectAtIndex:0]];
    CGFloat cellHeigh = 10.0f;

    
    NSString *descript = [arrItem objectAtIndex:1];
    CGSize frameSize = [descript sizeWithFont:cell.skillName.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillName.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame  = cell.skillName.frame;
    frame.size.height = kBgHeigh;
    cell.skillName.frame = frame;
    cell.skillName.text = descript;
    
    cellHeigh +=kBgHeigh+kCellGap;
    
    descript = [arrItem objectAtIndex:2];
    frameSize = [descript sizeWithFont:cell.skillIntro.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillIntro.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
    frame  = cell.skillIntro.frame;
    frame.origin.y = cellHeigh+kCellGap;
    frame.size.height = frameSize.height;
    cell.skillIntro.frame = frame;
    cell.skillIntro.text = descript;
    
    cellHeigh +=frameSize.height+kCellGap;
    
    descript = [arrItem objectAtIndex:3];
    frameSize = [descript sizeWithFont:cell.skillNote.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillNote.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
    frame  = cell.skillNote.frame;
    frame.origin.y = CGRectGetMaxY(cell.skillIntro.frame)+kCellGap;
    frame.size.height = frameSize.height;
    cell.skillNote.frame = frame;
    cell.skillNote.text = descript;
    
    cellHeigh +=frameSize.height+kCellGap;

    
    
    descript = [arrItem objectAtIndex:4];
    frameSize = [descript sizeWithFont:cell.skillLev1.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillLev1.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
    frame  = cell.skillLev1.frame;
    frame.origin.y = CGRectGetMaxY(cell.skillNote.frame)+kCellGap;
    frame.size.height = frameSize.height;
    cell.skillLev1.frame = frame;
    cell.skillLev1.text = descript;
    
    cellHeigh +=frameSize.height+kCellGap;
    
    
    descript = [arrItem objectAtIndex:5];
    frameSize = [descript sizeWithFont:cell.skillLev2.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillLev2.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
    frame  = cell.skillLev2.frame;
    frame.origin.y = CGRectGetMaxY(cell.skillLev1.frame)+kCellGap;
    frame.size.height = frameSize.height;
    cell.skillLev2.frame = frame;
    cell.skillLev2.text = descript;
    
    cellHeigh +=frameSize.height+kCellGap;
    
    descript = [arrItem objectAtIndex:6];
    frameSize = [descript sizeWithFont:cell.skillLev3.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillLev3.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
    frame  = cell.skillLev3.frame;
    frame.origin.y = CGRectGetMaxY(cell.skillLev2.frame)+kCellGap;
    frame.size.height = frameSize.height;
    cell.skillLev3.frame = frame;
    cell.skillLev3.text = descript;
    
    cellHeigh +=frameSize.height+kCellGap;
    
    descript = [arrItem objectAtIndex:7];
    if (descript.length == 0) {
        cell.skillLev4.frame = CGRectZero;
    }else{
        
        frameSize = [descript sizeWithFont:cell.skillLev4.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.skillLev4.frame), 800) lineBreakMode:UILineBreakModeWordWrap];
        frame  = cell.skillLev4.frame;
        frame.origin.y = CGRectGetMaxY(cell.skillLev3.frame)+kCellGap;
        frame.size.height = frameSize.height;
        cell.skillLev4.frame = frame;
        cell.skillLev4.text = descript;
        
        cellHeigh +=frameSize.height+kCellGap;
    }
    
    
    frame = cell.frame;
    frame.size.height = cellHeigh;
    cell.frame = frame;
    
    cellHeigh +=5;
    
    return cell;


    
    
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *arrItem = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    if (indexPath.row == 0) {
        [arrItem addObject:_selectHero.skill1Image];
        [arrItem addObject:_selectHero.skill1Name];
        [arrItem addObject:_selectHero.skill1Introduce];
        [arrItem addObject:_selectHero.skill1Note];
        [arrItem addObject:_selectHero.skill1Level1];
        [arrItem addObject:_selectHero.skill1Level2];
        [arrItem addObject:_selectHero.skill1Level3];
        [arrItem addObject:_selectHero.skill1Level4];
        
        
    }else if(indexPath.row == 1){
        [arrItem addObject:_selectHero.skill2Image];
        [arrItem addObject:_selectHero.skill2Name];
        [arrItem addObject:_selectHero.skill2Introduce];
        [arrItem addObject:_selectHero.skill2Note];
        [arrItem addObject:_selectHero.skill2Level1];
        [arrItem addObject:_selectHero.skill2Level2];
        [arrItem addObject:_selectHero.skill2Level3];
        [arrItem addObject:_selectHero.skill2Level4];
        
    }else if(indexPath.row == 2){
        [arrItem addObject:_selectHero.skill3Image];
        [arrItem addObject:_selectHero.skill3Name];
        [arrItem addObject:_selectHero.skill3Introduce];
        [arrItem addObject:_selectHero.skill3Note];
        [arrItem addObject:_selectHero.skill3Level1];
        [arrItem addObject:_selectHero.skill3Level2];
        [arrItem addObject:_selectHero.skill3Level3];
        [arrItem addObject:_selectHero.skill3Level4];
        
    }else if(indexPath.row == 3){
        [arrItem addObject:_selectHero.skill4Image];
        [arrItem addObject:_selectHero.skill4Name];
        [arrItem addObject:_selectHero.skill4Introduce];
        [arrItem addObject:_selectHero.skill4Note];
        [arrItem addObject:_selectHero.skill4Level1];
        [arrItem addObject:_selectHero.skill4Level2];
        [arrItem addObject:_selectHero.skill4Level3];
        [arrItem addObject:@""];
        
    }else{
        BqsLog(@"error skill Level");
        return 0;
    }

    
    CGFloat cellHeigh = 10.0f;
    
    NSString *descript = [arrItem objectAtIndex:1];
    CGSize frameSize = [descript sizeWithFont:kNameFont constrainedToSize:CGSizeMake(kSillNameWidth, 800) lineBreakMode:UILineBreakModeWordWrap];
        
    cellHeigh += kBgHeigh+kCellGap;
    
    descript = [arrItem objectAtIndex:2];
    frameSize = [descript sizeWithFont:kIntroFont constrainedToSize:CGSizeMake(kSillIntoWidht, 800) lineBreakMode:UILineBreakModeWordWrap];
    cellHeigh +=frameSize.height+kCellGap;
    
    descript = [arrItem objectAtIndex:3];
    frameSize = [descript sizeWithFont:kNoteFont constrainedToSize:CGSizeMake(kSillIntoWidht, 800) lineBreakMode:UILineBreakModeWordWrap];
    
    cellHeigh +=frameSize.height+kCellGap;
    
    
    
    descript = [arrItem objectAtIndex:4];
    frameSize = [descript sizeWithFont:kLevel1Font constrainedToSize:CGSizeMake(kSillIntoWidht, 800) lineBreakMode:UILineBreakModeWordWrap];
    cellHeigh +=frameSize.height+kCellGap;
    
    descript = [arrItem objectAtIndex:5];
    frameSize = [descript sizeWithFont:kLevel2Font constrainedToSize:CGSizeMake(kSillIntoWidht, 800) lineBreakMode:UILineBreakModeWordWrap];
    cellHeigh +=frameSize.height+kCellGap;
    
    descript = [arrItem objectAtIndex:6];
    frameSize = [descript sizeWithFont:kLevel3Font constrainedToSize:CGSizeMake(kSillIntoWidht, 800) lineBreakMode:UILineBreakModeWordWrap];
    cellHeigh +=frameSize.height+kCellGap;
    

    descript = [arrItem objectAtIndex:7];
    if (descript.length == 0) {
    }else{
        frameSize = [descript sizeWithFont:kLevel4Font constrainedToSize:CGSizeMake(kSillIntoWidht, 800) lineBreakMode:UILineBreakModeWordWrap];
        cellHeigh +=frameSize.height+kCellGap;
    }
    cellHeigh +=5;
    
    return cellHeigh;
}


-(void)didSelectHero:(HeroInfo *)hero{
    self.selectHero = hero;
    
}

-(void)didSelectEquip:(Equipment *)equip{
    self.selectEquip = equip;

}








@end
