//
//  HumDotaImageCateOneView.m
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaImageCateOneView.h"
#import "HumDotaUIOps.h"
#import "HumDotaDataMgr.h"
#import "HMCategory.h"
#import "HumDotaImageCateTwoView.h"

@interface HumDotaImageCateOneView()

@property (nonatomic, retain) NSArray *arrCatList; // allList
@property (nonatomic, assign) NSUInteger nCatHash;

-(NSArray *)loadCatForCatOneId; //one for dota1
-(NSArray *)loadCatForCatTwoId; //two for dota2
-(NSString *)allCatIdFor:(HMCategory *)cat;
-(NSUInteger)calcCatTwoHash:(NSArray *)arr;
-(void)checkDotaCatChanged;
@end



@implementation HumDotaImageCateOneView
@synthesize arrCatList;
@synthesize nCatHash;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNtfDotaOneImageChanged object:nil];
    self.arrCatList = nil;
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
    
        self.arrCatList = [self loadCatForCatOneId];
        self.nCatHash = [self calcCatTwoHash:self.arrCatList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneImageChange) name:kNtfDotaOneImageChanged object:nil];
        
    }

    return self;
}


-(void)viewWillAppear {
    [super viewWillAppear];
    [self.topNav setTitle:NSLocalizedString(@"dota.image.title", nil) Show:YES];
    [self checkDotaCatChanged];
    [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];
}

-(HumDotaCateTowBaseView *)viewForCatOneIdx:(int)oneIdx TwoIdx:(int)twoIdx VCtl:(HumDotaBaseViewController *)vctl Frame:(CGRect)frm {
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
    
    HumDotaImageCateTwoView *image = [[[HumDotaImageCateTwoView alloc] initWithDotaCatFrameViewCtl:vctl Frame:frm CategoryId:subCat.catId] autorelease];
    return image;
    
}

#pragma mark -
#pragma mark NSNotificationCenter

- (void)oneImageChange{
    BqsLog(@"oneImageChange");
    self.arrCatList = [self loadCatForCatOneId];
    self.nCatHash = [self calcCatTwoHash:self.arrCatList];
    [self.cateScroll humDotaCateTwoSetCatArr:self.arrCateOne itemArr:self.arrCateTwo];
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
