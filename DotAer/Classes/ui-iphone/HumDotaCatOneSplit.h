//
//  HumDotaCatOneSplit.h
//  DotAer
//
//  Created by Kyle on 13-1-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCatOneBaseView.h"
#import "HumDotaCatTwoSelView.h"
#import "HumDotaCateTowBaseView.h"

@interface HumDotaCatOneSplit : HumDotaCatOneBaseView{
    NSInteger _nOneCurIdx;
    NSInteger _nTwoCurIdx;
}

@property (nonatomic, retain) NSArray *arrCateOne;
@property (nonatomic, retain) NSArray *arrCateTwo;

@property (nonatomic, retain) HumDotaCatTwoSelView *cateScroll;

-(HumDotaCateTowBaseView *)viewForCatOneIdx:(int)oneIdx TwoIdx:(int)twoIdx VCtl:(HumDotaBaseViewController *)vctl Frame:(CGRect)frm;

@end
