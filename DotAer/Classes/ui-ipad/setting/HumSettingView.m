//
//  HumSettingView.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumSettingView.h"
#import "BqsUtils.h"
#import "Env.h"
#import "HMLeftRightTextCell.h"
#import "iRate.h"
#import "iVersion.h"
#import "HumMassCleanViewController.h"
#import "HumDotaUIOps.h"
#import "HumFeedbackViewController.h"

@interface HumSettingView()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) HMLeftRightTextCell *cellMyAccount;


@property (nonatomic, retain) HMLeftRightTextCell *cellClean;
@property (nonatomic, retain) HMLeftRightTextCell *cellCheckNewVersion;
@property (nonatomic, retain) HMLeftRightTextCell *cellFeedback;
@property (nonatomic, retain) HMLeftRightTextCell *cellAppCommit;
@property (nonatomic, retain) HMLeftRightTextCell *cellAppRecommend;
@property (nonatomic, retain) HMLeftRightTextCell *cellAbout;

@property (nonatomic, retain) NSArray *arrSectionTitles; // NSString
@property (nonatomic, retain) NSArray *arrTableCells; // NSArray(NSArray(Cell))

@end


@implementation HumSettingView
@synthesize tableView;
@synthesize cellMyAccount;
@synthesize cellClean,cellCheckNewVersion,cellFeedback,cellAppCommit,cellAppRecommend,cellAbout;
@synthesize arrSectionTitles,arrTableCells;

- (void)dealloc{
    self.tableView = nil;
    self.cellMyAccount = nil;
    self.cellClean = nil;
    self.cellCheckNewVersion = nil;
    self.cellFeedback = nil;
    self.cellAppCommit = nil;
    self.cellAppRecommend = nil;
    self.cellAbout = nil;
    self.arrSectionTitles = nil;
    self.arrTableCells = nil;
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
       
                    
        // create subviews
        // table view
        
        CGRect rct = CGRectMake(0, 20, CGRectGetWidth(self.bounds)-kMainLeftViewRightGap, CGRectGetHeight(self.bounds)-20);
        
        self.tableView = [[[UITableView alloc] initWithFrame:rct style:UITableViewStylePlain] autorelease];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        
        NSMutableArray *arrBasic = [NSMutableArray arrayWithCapacity:2];
        NSMutableArray *arrOther = [NSMutableArray arrayWithCapacity:5];
        
        const float kPaddingHori = 10;
        
        
        // basic
        {
            self.cellMyAccount = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"10"] autorelease];
            
            self.cellMyAccount.lblLeft.text = NSLocalizedString(@"setting.main.basic.account", nil);
            self.cellMyAccount.lblRight.hidden = YES;
            self.cellMyAccount.imgDisclosure.hidden = NO;
            self.cellMyAccount.paddingHori = kPaddingHori;
            
            [arrBasic addObject:self.cellMyAccount];
        }
        
        //other
        {
            self.cellClean = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"20"] autorelease];
            
            self.cellClean.lblLeft.text = NSLocalizedString(@"setting.main.other.cleanMass", nil);
            self.cellClean.lblRight.hidden = YES;
            self.cellClean.imgDisclosure.hidden = NO;
            self.cellClean.paddingHori = kPaddingHori;
            
            
            //            unsigned int size = [[[MptTvGuideDataMgr instance] onlinePkgFile] getFileSize];
            
            //            NSString *sizeStr = [NSString stringWithFormat:@"%0.1f MB",size/1024.0f/1024.0f ];
            //            self.cellClean.lblRight.text = sizeStr;
            
            [arrOther addObject:self.cellClean];
        }
        
        {
            self.cellCheckNewVersion = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"21"] autorelease];
            
            self.cellCheckNewVersion.lblLeft.text = NSLocalizedString(@"setting.main.other.checknewversion", nil);
            self.cellCheckNewVersion.lblRight.hidden = YES;
            self.cellCheckNewVersion.imgDisclosure.hidden = YES;
            self.cellCheckNewVersion.paddingHori = kPaddingHori;
            
            [arrOther addObject:self.cellCheckNewVersion];
        }
        
        {
            self.cellFeedback = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"22"] autorelease];
            
            self.cellFeedback.lblLeft.text = NSLocalizedString(@"setting.main.other.feedback", nil);
            self.cellFeedback.lblRight.hidden = YES;
            self.cellFeedback.imgDisclosure.hidden = NO;
            self.cellFeedback.paddingHori = kPaddingHori;
            
            [arrOther addObject:self.cellFeedback];
        }
        
        {
            self.cellAppCommit = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"23"] autorelease];
            
            self.cellAppCommit.lblLeft.text = NSLocalizedString(@"setting.main.other.pingfen", nil);
            self.cellAppCommit.lblRight.hidden = YES;
            self.cellAppCommit.imgDisclosure.hidden = YES;
            self.cellAppCommit.paddingHori = kPaddingHori;
            
            [arrOther addObject:self.cellAppCommit];
        }
        
        {
            self.cellAppRecommend = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"24"] autorelease];
            
            self.cellAppRecommend.lblLeft.text = NSLocalizedString(@"setting.main.other.apprecommend", nil);
            self.cellAppRecommend.lblRight.hidden = YES;
            self.cellAppRecommend.imgDisclosure.hidden = NO;
            self.cellAppRecommend.paddingHori = kPaddingHori;
            
            [arrOther addObject:self.cellAppRecommend];
        }

        
        {
            self.cellAbout = [[[HMLeftRightTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"25"] autorelease];
            
            self.cellAbout.lblLeft.text = NSLocalizedString(@"setting.main.other.about", nil);
            self.cellAbout.lblRight.hidden = YES;
            self.cellAbout.imgDisclosure.hidden = NO;
            self.cellAbout.paddingHori = kPaddingHori;
            
            [arrOther addObject:self.cellAbout];
        }
                
                            
                
        self.arrSectionTitles = [NSArray arrayWithObjects:
                                 NSLocalizedString(@"setting.main.section.basic", nil),
                                 NSLocalizedString(@"setting.main.section.other", nil),
                                 nil];
        self.arrTableCells = [NSArray arrayWithObjects:
                              arrBasic,
                              arrOther,
                              nil];


       
    }
    return self;

}


- (void)viewWillAppear{
    [self.tableView reloadData];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BqsLog(@"select: %d", indexPath.row);
    
    const UITableViewCell *cell = [[self.arrTableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    if(cell == self.cellMyAccount) [self onClickMyAccount];
    else if(cell == self.cellClean) [self onClickCellClean];
    else if(cell == self.cellCheckNewVersion) [self onClickCheckNewVersion];
    else if(cell == self.cellFeedback) [self onClickFeedback];
    else if(cell == self.cellAppCommit) [self onclickCommit];
    else if(cell == self.cellAppRecommend) [self onclickAppRecommend];
    else if(cell == self.cellAbout) [self onClickAbout];
    else {
        BqsLog(@"Invalid cell: %@", cell);
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrTableCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.arrTableCells objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.arrTableCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Env *env = [Env sharedEnv];
    
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 23)] autorelease];
    v.backgroundColor = [UIColor clearColor];
    
    UIImageView *iv = [[[UIImageView alloc] initWithImage:[env cacheScretchableImage:@"main_setting_section_bg.png" X:1 Y:10]] autorelease];
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    iv.frame = v.bounds;
    [v addSubview:iv];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = RGBA(0xff, 0xff, 0xff, .5);
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = [self.arrSectionTitles objectAtIndex:section];
    [lbl sizeToFit];
    lbl.center = CGPointMake(CGRectGetMidX(lbl.frame) + 17, CGRectGetMidY(v.bounds));
    [v addSubview:lbl];
    
    return v;
}



#define kCellMethod
-(void)onClickMyAccount {
    BqsLog(@"onClickMyAccount");
}

-(void)onClickCellClean {
    BqsLog(@"onClickCellClean");
    HumMassCleanViewController *massVcl = [[[HumMassCleanViewController alloc] init] autorelease];
    [HumDotaUIOps slideShowModalViewInNavControler:massVcl ParentVCtl:self.parCtl];
    
}

-(void)onClickCheckNewVersion {
    BqsLog(@"onClickCheckNewVersion");
    [[iVersion sharedInstance] checkForNewVersion];
}

-(void)onClickFeedback {
    BqsLog(@"onClickFeedback");
    HumFeedbackViewController *feedbackCt =[[[ HumFeedbackViewController alloc] init] autorelease];
    [HumDotaUIOps slideShowModalViewInNavControler:feedbackCt ParentVCtl:self.parCtl];
}


-(void)onclickCommit {
    BqsLog(@"onclickCommit");
    [[iRate sharedInstance] promptForRating];
}


-(void)onclickAppRecommend {
    BqsLog(@"onclickAppRecommend");
}


-(void)onClickAbout {
    BqsLog(@"onClickAbout");
}


@end
