//
//  HumDotaVideoCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-1-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadVideoCateOneView.h"
#import "HumDotaPadVideCateTwoView.h"
#import "HumDotaUIOps.h"
#import "HumDotaDataMgr.h"
#import "HMCategory.h"
#import "SVSegmentedControl.h"

enum VIDEOCASE {
    VIDEOONE = 0,
    VIDEOTWO = 1,
};


@interface HumDotaPadVideoCateOneView(){
    NSUInteger _videoCase;
}

@property (nonatomic, retain) NSArray *arrCatList; // allList
@property (nonatomic, assign) NSUInteger nCatHash;

-(NSArray *)loadCatForCatOneId; //one for dota1
-(NSArray *)loadCatForCatTwoId; //two for dota2
- (NSString *)allCatIdFor:(HMCategory *)cat;
-(NSUInteger)calcCatTwoHash:(NSArray *)arr;
-(void)checkDotaCatChanged;
@end


@implementation HumDotaPadVideoCateOneView
@synthesize arrCatList;
@synthesize nCatHash;

- (void)dealloc{
    self.arrCatList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNtfDotaOneVideoChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNtfDotaTwoVideoChanged object:nil];
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
        
        _videoCase = VIDEOONE;
        
        SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"DotA 1", @"DotA 2", nil]];
        navSC.backgroundImage = [[Env sharedEnv] cacheImage:@"dota_seg_bg.png"];
        [self.topNav addSubview:navSC];
        
        navSC.center = CGPointMake(CGRectGetMidX(self.topNav.frame), CGRectGetMidY(self.topNav.bounds));
        [navSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [navSC release];
       
        self.arrCatList = [self loadCatForCatOneId];
        
        self.nCatHash = [self calcCatTwoHash:self.arrCatList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneVideoChanged) name:kNtfDotaOneVideoChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twoVideoChanged) name:kNtfDotaTwoVideoChanged object:nil];
       
        return self;
    }
       

    return self;
}


-(void)viewWillAppear {
    [super viewWillAppear];
    self.topNav.ivRight.hidden = YES;
    self.topNav.btnRight.hidden = YES;
    [self checkDotaCatChanged];
    [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];
}

-(HumDotaPadCateTowBaseView *)viewForCatOneIdx:(int)oneIdx TwoIdx:(int)twoIdx VCtl:(HumPadDotaBaseViewController *)vctl Frame:(CGRect)frm {
    if ([self.arrCatList count] <= oneIdx) {
        BqsLog(@"viewForCatOneIdx:%d > self.arrCatList.count%d",oneIdx,[self.arrCatList count]);
        return nil;
    }
    
    HMCategory *cat = [self.arrCatList objectAtIndex:oneIdx];
    if (cat.arrSubCat.count <= twoIdx) {
        BqsLog(@"viewForCatWwoIdx:%d > cat.arrSubCat.count%d",twoIdx,cat.arrSubCat.count);
        return nil;
    }
    
    HMCategory *subCat = [cat.arrSubCat objectAtIndex:twoIdx];
    
    HumDotaPadVideCateTwoView *video = [[[HumDotaPadVideCateTwoView alloc] initWithDotaCatFrameViewCtl:vctl Frame:frm CategoryId:subCat.catId] autorelease];
    return video;
    
}
#pragma mark -
#pragma mark SPSegmentedControl

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedIndex);
    
    if (segmentedControl.selectedIndex == VIDEOONE) {
        _videoCase = VIDEOONE;
        
        self.arrCatList = [self loadCatForCatOneId];
        self.nCatHash = [self calcCatTwoHash:self.arrCatList];
        [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];
        
    }else if(segmentedControl.selectedIndex == VIDEOTWO){
         _videoCase = VIDEOTWO;
        
        self.arrCatList = [self loadCatForCatTwoId];
        self.nCatHash = [self calcCatTwoHash:self.arrCatList];
        [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];

    }
    
}


#pragma mark - 
#pragma mark NSNotificationCenter

- (void)oneVideoChanged{
    BqsLog(@"oneVideoChanged _videoCase:%d",_videoCase);
    if (_videoCase != VIDEOONE)  return;
    self.arrCatList = [self loadCatForCatOneId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];


    
    
}

- (void)twoVideoChanged{
    BqsLog(@"twoVideoChanged _videoCase:%d",_videoCase);\
    if (_videoCase != VIDEOTWO)  return;
    self.arrCatList = [self loadCatForCatTwoId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];
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








@end
