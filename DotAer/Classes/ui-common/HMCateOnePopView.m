//
//  HMCateOnePopView.m
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HMCateOnePopView.h"
#import "Env.h"
#import "BqsUtils.h"
#import <QuartzCore/QuartzCore.h>

#define kOneWidth 80
@protocol HMCateOneTableCellDelegate;

@interface HMCateOneTableCell : UITableViewCell

@property (nonatomic, assign) id<HMCateOneTableCellDelegate>delegate;
@property (nonatomic, retain) UILabel *itemName;


@end

@protocol HMCateOneTableCellDelegate <NSObject>

- (void)hmCateOneTableCell:(HMCateOneTableCell *)cell didSelectIndex:(NSIndexPath *)index;

@end


@implementation HMCateOneTableCell
@synthesize itemName;
@synthesize delegate;

- (void)dealloc{
    self.itemName = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *cellSelct = [[UIButton alloc] initWithFrame:self.bounds];
        cellSelct.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [cellSelct addTarget:self action:@selector(cellSelct:) forControlEvents:UIControlEventTouchUpInside];
        cellSelct.backgroundColor = [UIColor clearColor];
        [self addSubview:cellSelct];
        [cellSelct release];
        
        self.itemName = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
        self.itemName.font = [UIFont systemFontOfSize:12.f];
        self.itemName.textColor = [UIColor whiteColor];
        self.itemName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.itemName];
    }
    return self;
}

- (void)cellSelct:(id)sender{
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hmCateOneTableCell:didSelectIndex:)]) {
        [self.delegate hmCateOneTableCell:self didSelectIndex:index];
    }
    
}


@end




@interface HMCateOnePopView()<UITableViewDataSource,UITableViewDelegate,HMCateOneTableCellDelegate>

@property (nonatomic, retain) UIImageView *tableBg;
@property (nonatomic, retain) UITableView *table;

@end


@implementation HMCateOnePopView
@synthesize delegate;
@synthesize arrItem;
@synthesize tableBg;
@synthesize table;
@synthesize popPoint;

- (void)dealloc{
    
    self.tableBg = nil;
    self.arrItem = nil;
    self.table = nil;
    [super dealloc];
    
}





- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)arr popAt:(CGPoint)point{
    self = [super initWithFrame:frame];
    if (self ) {
        self.arrItem = arr;
        self.popPoint = point;
        
        CGRect sFrame = CGRectMake(point.x - kOneWidth/2, point.y+40, kOneWidth, 200);
        self.tableBg = [[[UIImageView alloc] initWithFrame:sFrame] autorelease];
        self.tableBg.image = [[Env sharedEnv] cacheImage:@"dota_video_cate_one_bg.png"];
        self.tableBg.userInteractionEnabled = YES;
        [self addSubview:self.tableBg];
        
        self.table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(sFrame), CGRectGetHeight(sFrame) - 12)] autorelease];
        self.table.dataSource = self;
        self.table.delegate = self;
        self.table.backgroundColor = [UIColor clearColor];
        [self.tableBg addSubview:self.table];
        

    }
    return self;
}


#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BqsLog(@"arrItem count :%d",[arrItem count]);
    return [arrItem count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIden = @"cellId";
    HMCateOneTableCell *cell = (HMCateOneTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[HMCateOneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    cell.delegate = self;
    
    if ([arrItem count] <= indexPath.row) {
        BqsLog(@"tableview cell > arrItem count");
        return nil;
    }
    
    cell.itemName.text = [arrItem objectAtIndex:indexPath.row];
    return cell;
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark
#pragma makr HMCateOneTableCellDelegate
- (void)hmCateOneTableCell:(HMCateOneTableCell *)cell didSelectIndex:(NSIndexPath *)index{
    BqsLog(@"HMCateOneTable did select at section:%d, row:%d",index.section,index.row);
    if (self.delegate && [self.delegate respondsToSelector:@selector(hmCateOnePopView:didSelectAt:)]) {
        [self.delegate hmCateOnePopView:self didSelectAt:index];
    }
    
    [self selfDimss];
}

#pragma mark
#pragma makr Animation method

- (void)popViewAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableBg.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableBg.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
                   );
    
    
}

- (void)selfDimss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.tableBg.alpha = 0.0f;
        } completion:^(BOOL finished2){
            [self removeFromSuperview];
        }];
    });
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1) {
        CGPoint p = [aTouch locationInView:self];
        if (!CGRectContainsPoint(self.tableBg.frame, p)) {
            [self selfDimss];
        }
    }
}


@end
