//
//  HumDotaSplitViewController.h
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaRevealBaseViewController.h"
#import "Downloader.h"
#import "HumDotaCatTwoSelView.h"
#import "HMCategory.h"

@interface HumDotaSplitViewController : HumDotaRevealBaseViewController<HumDotaCatTwoSelViewDelegate>{
    NSInteger _nOneCurIdx;
    NSInteger _nTwoCurIdx;
}

@property (nonatomic, retain) NSArray *arrCatList; // allList
@property (nonatomic, retain) HMCategory *catTwo;;

@property (nonatomic, retain) NSArray *arrCateOne; // one category name
@property (nonatomic, retain) NSArray *arrCateTwo; // tow category name
@property (nonatomic, retain) HumDotaCatTwoSelView *cateScroll;

@end
