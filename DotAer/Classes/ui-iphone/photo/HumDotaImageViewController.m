//
//  HumDotaImageViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-26.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaImageViewController.h"
#import "HumDotaUIOps.h"
#import "HumDotaDataMgr.h"
#import "HMCategory.h"
#import "HumDotaImageCateTwoView.h"

@interface HumDotaImageViewController ()

@property (nonatomic, assign) NSUInteger nCatHash;

-(NSArray *)loadCatForCatOneId; //one for dota1
-(NSArray *)loadCatForCatTwoId; //two for dota2
-(NSString *)allCatIdFor:(HMCategory *)cat;
-(NSUInteger)calcCatTwoHash:(NSArray *)arr;
-(void)checkDotaCatChanged;

@end

@implementation HumDotaImageViewController

@synthesize nCatHash;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNtfDotaOneImageChanged object:nil];
    self.arrCatList = nil;
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
    
    self.title = NSLocalizedString(@"dota.image.title", nil);
    
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneImageChange) name:kNtfDotaOneImageChanged object:nil];
    self.arrCatList = [self loadCatForCatOneId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkDotaCatChanged];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
    [MobClick beginLogPageView:kUmeng_imagepage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:kUmeng_imagepage];
    [super viewWillDisappear:animated];
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
    HumDotaImageCateTwoView *cell = (HumDotaImageCateTwoView *)[scrollView dequeueCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[HumDotaImageCateTwoView alloc] initWithFrame:frame withIdentifier:identifier withController:self] autorelease];
    }
    
    if (self.catTwo.arrSubCat.count <= index) {
        BqsLog(@"viewForCatWwoIdx:%d > cat.arrSubCat.count%d",index,self.catTwo.arrSubCat.count);
        return nil;
    }
    
    HMCategory *subCat = [self.catTwo.arrSubCat objectAtIndex:index];
    cell.imageCatId = subCat.catId;
    
    return cell;
    
}




#pragma mark -
#pragma mark NSNotificationCenter

- (void)oneImageChange{
    BqsLog(@"oneImageChange");
    self.arrCatList = [self loadCatForCatOneId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateOneSetCatArr:self.arrCateOne];
}




#pragma mark
#pragma mark private method


-(NSArray *)loadCatForCatOneId{
    NSArray *arry = [[HumDotaDataMgr instance] readDotaOneImageCategory];
    
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
    NSArray *arry = [[HumDotaDataMgr instance] readDotaOneImageCategory];
    
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
    
    NSArray *arry = [[HumDotaDataMgr instance] readDotaOneImageCategory];
    
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



@end
