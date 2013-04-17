//
//  HumDotaCatOneSplit.h
//  DotAer
//
//  Created by Kyle on 13-1-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadCatOneBaseView.h"
#import "HumDotaCatTwoSelView.h"
#import "HumDotaPadCateTowBaseView.h"

@interface HumDotaPadCatOneSplit : HumDotaPadCatOneBaseView{
    NSInteger _nOneCurIdx;
    NSInteger _nTwoCurIdx;
}

@property (nonatomic, retain) NSArray *arrCateOne;
@property (nonatomic, retain) NSArray *arrCateTwo;

@property (nonatomic, retain) HumDotaCatTwoSelView *cateScroll;

-(HumDotaPadCateTowBaseView *)viewForCatOneIdx:(int)oneIdx TwoIdx:(int)twoIdx VCtl:(HumPadDotaBaseViewController *)vctl Frame:(CGRect)frm;

@end
