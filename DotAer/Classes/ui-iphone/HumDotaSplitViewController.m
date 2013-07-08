//
//  HumDotaSplitViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSplitViewController.h"

#define kCatScrollX 3
#define kCatScrollH 35
#define kCatScrollPaddY 0

@interface HumDotaSplitViewController ()

@end

@implementation HumDotaSplitViewController
@synthesize arrCatList;
@synthesize catTwo;
@synthesize arrCateOne;
@synthesize arrCateTwo;
@synthesize cateScroll;


- (void)dealloc{
    self.arrCatList = nil;
    self.catTwo = nil;
    self.cateScroll = nil;
    self.arrCateOne = nil;
    self.arrCateTwo = nil;
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
    
    self.cateScroll = [[[HumDotaCatTwoSelView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kCatScrollH)] autorelease];
    self.cateScroll.delegate = self;
    
    CGRect cframe = CGRectMake(0, CGRectGetMaxY(self.cateScroll.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.cateScroll.frame));
    self.contentView.frame = cframe;
    
    [self.view addSubview:cateScroll];

}

- (void)scrollView:(MptContentScrollView *)scrollView curIndex:(NSUInteger)index{
    [self.cateScroll setCateTwoCurSelectIndex:index];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark HumDotaCatTwoSelViewDelegate

- (void)humDotaCatTwoSelectView:(HumDotaCatTwoSelView *)v DidSelectCatOne:(int)onIdx{
    _nOneCurIdx = onIdx;
    
    if (onIdx <0 || onIdx>= [self.arrCateTwo count]) {
        BqsLog(@"self.arrCateTwo : %d < onIdex:%d",[self.arrCateTwo count],onIdx);
        return;
    }
    
       
    id obj = [self.arrCateTwo objectAtIndex:onIdx];
    if (![obj isKindOfClass:[NSArray class]]) {
        BqsLog(@"cateone not nil ,but catetwo obj is not NSArray");
        return;
    }
    
    [self.cateScroll humDotaCateTwoSetCatArr:(NSArray *)obj];

    if ([self.arrCatList count] <= _nOneCurIdx) {
        BqsLog(@"viewForCatOneIdx:%d > self.arrCatList.count%d",_nOneCurIdx,[self.arrCatList count]);
        return ;
    }
    self.catTwo = [self.arrCatList objectAtIndex:_nOneCurIdx];
    [self.contentView reloadDataInitOffset:YES];
    
}

- (void)humDotaCatTwoSelectView:(HumDotaCatTwoSelView *)v DidSelectCatTwo:(int)towIdx{
    
     _nTwoCurIdx = towIdx;
     [self.contentView setCurrentDisplayItemIndex:towIdx];
}






@end
