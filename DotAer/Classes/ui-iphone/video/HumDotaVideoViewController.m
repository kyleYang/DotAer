//
//  HumDotaVideoViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaVideoViewController.h"
#import "HumDotaUIOps.h"
#import "HumDotaDataMgr.h"
#import "HMCategory.h"
#import "SVSegmentedControl.h"
#import "HumDotaVideCateTwoView.h"
#import "AKSegmentedControl.h"

enum VIDEOCASE {
    VIDEOONE = 0,
    VIDEOTWO = 1,
};

@interface HumDotaVideoViewController (){
    NSUInteger _videoCase;
}

@property (nonatomic, retain) AKSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSUInteger nCatHash;

-(NSArray *)loadCatForCatOneId; //one for dota1
-(NSArray *)loadCatForCatTwoId; //two for dota2
- (NSString *)allCatIdFor:(HMCategory *)cat;
-(NSUInteger)calcCatTwoHash:(NSArray *)arr;
-(void)checkDotaCatChanged;


@end

@implementation HumDotaVideoViewController
@synthesize nCatHash;
@synthesize segmentedControl;

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNtfDotaOneVideoChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNtfDotaTwoVideoChanged object:nil];
    self.segmentedControl = nil;
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _videoCase = VIDEOONE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneVideoChanged) name:kNtfDotaOneVideoChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twoVideoChanged) name:kNtfDotaTwoVideoChanged object:nil];
    
    
    self.segmentedControl = [[[AKSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 170, 30)] autorelease];

    
    UIImage *backgroundImage = [[Env sharedEnv] cacheImage:@"segmented-bg.png"];
    [self.segmentedControl setBackgroundImage:backgroundImage];
    [self.segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [self.segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [self.segmentedControl setSeparatorImage:[[Env sharedEnv] cacheImage:@"segmented-separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[Env sharedEnv] cacheImage:@"segmented-bg-pressed-left.png"];
    UIImage *buttonBackgroundImagePressedRight = [[Env sharedEnv] cacheImage:@"segmented-bg-pressed-right.png"];
    // Button 1
    UIButton *buttonSocial = [[UIButton alloc] init];
   
    [buttonSocial setTitle:@"DotA1" forState:UIControlStateNormal];
    [buttonSocial setTitle:@"DotA1" forState:UIControlStateHighlighted];
    [buttonSocial setTitle:@"DotA1" forState:UIControlStateSelected];
    [buttonSocial setTitle:@"DotA1" forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [buttonSocial addTarget:self action:@selector(dota1Select:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
      
    // Button 3
    UIButton *buttonSettings = [[UIButton alloc] init];
    [buttonSettings setTitle:@"DotA2" forState:UIControlStateNormal];
    [buttonSettings setTitle:@"DotA2" forState:UIControlStateHighlighted];
    [buttonSettings setTitle:@"DotA2" forState:UIControlStateSelected];
    [buttonSettings setTitle:@"DotA2" forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonSettings addTarget:self action:@selector(dota2Select:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.segmentedControl setButtonsArray:[NSArray arrayWithObjects:buttonSocial,buttonSettings,nil]];
    [buttonSocial release];
    [buttonSettings release];
    self.navigationItem.titleView = self.segmentedControl;

    
    
    
    self.arrCatList = [self loadCatForCatOneId];
    
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkDotaCatChanged];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
    [MobClick beginLogPageView:kUmeng_videopage];
}


- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:kUmeng_videopage];
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark SPSegmentedControl

- (void)dota2Select:(id)sender{
    BqsLog(@"dota2Select");
    [MobClick endEvent:kUmeng_video_cateChange label:kUmeng_video_dota2];
    self.arrCatList = [self loadCatForCatTwoId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
}

- (void)dota1Select:(id)sender{
    BqsLog(@"dota1Select");
    [MobClick endEvent:kUmeng_video_cateChange label:kUmeng_video_dota1];
    self.arrCatList = [self loadCatForCatOneId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
}


#pragma mark -
#pragma mark NSNotificationCenter

- (void)oneVideoChanged{
    BqsLog(@"oneVideoChanged _videoCase:%d",_videoCase);
    if (_videoCase != VIDEOONE)  return;
    self.arrCatList = [self loadCatForCatOneId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
    
    
    
    
}

- (void)twoVideoChanged{
    BqsLog(@"twoVideoChanged _videoCase:%d",_videoCase);\
    if (_videoCase != VIDEOTWO)  return;
    self.arrCatList = [self loadCatForCatTwoId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
}






#pragma mark
#pragma mark private method


-(NSArray *)loadCatForCatOneId{
    NSArray *arry = [[HumDotaDataMgr instance] readDotaOneVieoCategory];
    
    NSMutableArray *cateOneTmp = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *cateTwoTmp = [NSMutableArray arrayWithCapacity:10];
    
    for (HMCategory *cat in arry) {
        [cateOneTmp addObject:cat.name];
        NSMutableArray *cateTwoSubTmp = [NSMutableArray arrayWithCapacity:10];
        
        for (HMCategory *suCat in  cat.arrSubCat) {
            [cateTwoSubTmp addObject:suCat.name];
        }
        [cateTwoTmp addObject:cateTwoSubTmp];
    }
    
    self.arrCateOne = cateOneTmp;
    self.arrCateTwo = cateTwoTmp;
    
    return arry;
    
}

-(NSArray *)loadCatForCatTwoId{
    NSArray *arry = [[HumDotaDataMgr instance] readDotaTwoVieoCategory];
    
    NSMutableArray *cateOneTmp = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *cateTwoTmp = [NSMutableArray arrayWithCapacity:10];
    
    for (HMCategory *cat in arry) {
        [cateOneTmp addObject:cat.name];
        NSMutableArray *cateTwoSubTmp = [NSMutableArray arrayWithCapacity:10];
        
        for (HMCategory *suCat in  cat.arrSubCat) {
            [cateTwoSubTmp addObject:suCat.name];
        }
        [cateTwoTmp addObject:cateTwoSubTmp];
    }
    
    self.arrCateOne = cateOneTmp;
    self.arrCateTwo = cateTwoTmp;
    
    return arry;
    
}


-(void)checkDotaCatChanged {  //can no change category posith ,do not need
    
    NSArray *arry = [[HumDotaDataMgr instance] readDotaOneVieoCategory];
    
    NSUInteger arryHash = [self calcCatTwoHash:arry];
    
    if(arryHash == self.nCatHash) {
        return;
    }
    
}


- (NSString *)allCatIdFor:(HMCategory *)cat{
    NSMutableString *sCat =[NSMutableString stringWithCapacity:1024];
    [sCat appendString:cat.catId];
    [sCat appendString:@","];
    
    for (HMCategory *sub in cat.arrSubCat) {
        [sCat appendString:[self allCatIdFor:sub]];
    }
    
    BqsLog(@"allCatIdFor cat:@ sCat :%@ ",cat,sCat);
    return sCat;
    
}

-(NSUInteger)calcCatTwoHash:(NSArray*)arr {
    if (!arr) {
        return 0;
    }
    
    NSMutableString *s = [NSMutableString stringWithCapacity:1024];
    
    for(HMCategory *cat in arr) {
        [s appendString:[self allCatIdFor:cat]];
        [s appendString:@","];
    }
    BqsLog(@"calcCatTwoHash s:@",s);
    
    return s.hash;
}

#pragma mark
#pragma mark private method

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView{ // must be rewrite
    if (!self.catTwo) {
        BqsLog(@"self.catTwo = nil");
        return 0;
    }
    BqsLog(@"numberOfItemForScrollView :%d",[self.catTwo.arrSubCat count]);
    return [self.catTwo.arrSubCat count];
}

- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index{
    static NSString *identifier = @"cell";
    HumDotaVideCateTwoView *cell = (HumDotaVideCateTwoView *)[scrollView dequeueCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[HumDotaVideCateTwoView alloc] initWithFrame:frame withIdentifier:identifier withController:self] autorelease];
    }
    
    if (self.catTwo.arrSubCat.count <= index) {
        BqsLog(@"viewForCatWwoIdx:%d > cat.arrSubCat.count%d",index,self.catTwo.arrSubCat.count);
        return nil;
    }
    
    HMCategory *subCat = [self.catTwo.arrSubCat objectAtIndex:index];
    cell.videoCatId = subCat.catId;
   
    return cell;
    
}


@end
