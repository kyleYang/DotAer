//
//  MptContentScrollView.m
//  TVGontrol
//
//  Created by Kyle on 13-4-26.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import "MptContentScrollView.h"
#import "Env.h"
#import "BqsUtils.h"
#import "MptTouchScrollView.h"

#define kExistNum 1


@interface MptContentScrollView()


@property (nonatomic, strong) NSMutableArray *onScreenCells;
@property (nonatomic, strong) NSMutableDictionary *saveCells;

- (void)loadViews;
- (void)queueContentCell:(MptCotentCell *)cell;

@end




@implementation MptContentScrollView
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize onScreenCells = _onScreenCells;
@synthesize saveCells = _saveCells;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.onScreenCells = [NSMutableArray arrayWithCapacity:10];
        
        self.scrollView = [[MptTouchScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.BackgroundColor = [UIColor clearColor];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.exclusiveTouch = YES;
        self.scrollView.bouncesZoom = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.scrollView.bounces = NO;
        [self.scrollView setContentOffset:CGPointZero];
        self.scrollView.showsHorizontalScrollIndicator = FALSE;
        self.scrollView.showsVerticalScrollIndicator = FALSE;
        [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.bounds)*3, CGRectGetHeight(self.bounds))];
        [self addSubview:self.scrollView];

    }
    return self;
}



#pragma mark
#pragma mark datasource


- (void)setDataSource:(id<scrollDataSource>)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    
    [self reloadDataInitOffset:YES];
}


#pragma mark
#pragma mark cell reuse

- (MptCotentCell *)dequeueCellWithIdentifier:(NSString *)identifier{
    
	if(self.saveCells){
		//找到了重用的
        NSMutableArray *arys = [self.saveCells objectForKey:identifier];
        if (arys && arys.count != 0) {
            BqsLog(@"find dequeueReusableCellWithIdentifier:%@",identifier);
            MptCotentCell *cell = [arys lastObject];
            [arys removeLastObject];
            return cell;
        }
        return nil;
	}
	return nil;
}


- (void)queueContentCell:(MptCotentCell *)cell{
    if (!self.saveCells) {
        BqsLog(@"self.saveCells : nil");
        self.saveCells = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    NSString *identifier = cell.identifier;
    NSMutableArray *ary = [self.saveCells objectForKey:identifier];
    if (!ary) {
        ary = [NSMutableArray arrayWithCapacity:10];
    }
    [ary addObject:cell];
    [self.saveCells setObject:ary forKey:identifier];
    
}



#pragma mark
#pragma mark private method


- (void)reloadDataInitOffset:(BOOL)value{
    
    if (value) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    for (MptCotentCell *cell in self.onScreenCells) {
        [cell viewWillDisappear];
        [cell removeFromSuperview];
        [cell viewDidDisappear];
        [self queueContentCell:cell];
    }
    
    [self.onScreenCells removeAllObjects];
        
    _total = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfItemFor:)]) {
        _total = [_dataSource numberOfItemFor:self];
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame)*_total, CGRectGetHeight(self.scrollView.frame));
    int curPage = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
    BqsLog(@"scrollView contentOffset curPage :%d",curPage);
    
    for (int i= -1; i<kExistNum ; i++) {
        int loadPage = curPage+i;
       
        if (loadPage <0 ) {
            continue;
        }else if(loadPage >= _total)
            break;
        
        CGRect frame = CGRectMake(0, 0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame));
        
        MptCotentCell *cell = nil;
        if(_dataSource && [_dataSource respondsToSelector:@selector(cellViewForScrollView:frame:AtIndex:)]){
            cell = [_dataSource cellViewForScrollView:self frame:frame AtIndex:loadPage];
        }
        if (!cell)
            cell = [[MptCotentCell alloc] initWithFrame:frame];
        frame.origin = CGPointMake(CGRectGetWidth(self.scrollView.bounds)*loadPage, 0);
        cell.frame = frame;
        cell.cellTag = loadPage;
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [cell viewWillAppear];
        [self.scrollView addSubview:cell];
        [cell viewDidAppear];
        
        [self.onScreenCells addObject:cell];
        
    }

    
}


- (void)loadViews{
    CGPoint offset = self.scrollView.contentOffset;
    
    //移掉划出屏幕外的图片 保存3个
    NSMutableArray *readyToRemove = [NSMutableArray array];
    for (MptCotentCell *view in self.onScreenCells) {
        if(view.frame.origin.x + 2*view.frame.size.width  < offset.x || view.frame.origin.x - 2*view.frame.size.width > offset.x ){
            [readyToRemove addObject:view];
        }
    }
    for (MptCotentCell *cell in readyToRemove) {
        [cell viewWillDisappear];
        
        [self.onScreenCells removeObject:cell];
        [cell removeFromSuperview];
        [cell viewDidDisappear];
        
        [self queueContentCell:cell];
    }
    //遍历图片数组
    
    for (int i = 0;i<_total;i++) {
        
        BOOL OnScreen = FALSE;
        BOOL onFront = FALSE;
        
        
        if (i*CGRectGetWidth(self.scrollView.frame)>=offset.x&& i*CGRectGetWidth(self.scrollView.frame) < offset.x + kExistNum*CGRectGetWidth(self.scrollView.frame) ){
            
            OnScreen = TRUE;
            onFront = TRUE;
            
        }else if(i*CGRectGetWidth(self.scrollView.frame)>=offset.x-kExistNum*CGRectGetWidth(self.scrollView.frame)&& i*CGRectGetWidth(self.scrollView.frame) < offset.x ){
            OnScreen = TRUE;
            onFront = FALSE;

            
        }
        
        //在屏幕范围内的创建添加
        if (OnScreen) {
            BOOL HasOnScreen = FALSE;
            for (MptCotentCell *vi in self.onScreenCells) {
                if (i == vi.cellTag) {
                    HasOnScreen = TRUE;
                    [vi mainViewOnFont:onFront];
                    break;
                }
            }
            if (!HasOnScreen) {
                CGRect frame = CGRectMake(0,0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
                MptCotentCell *cell = nil;
                if(_dataSource && [_dataSource respondsToSelector:@selector(cellViewForScrollView:frame:AtIndex:)]){
                    cell = [_dataSource cellViewForScrollView:self frame:frame AtIndex:i];
                }
                if (!cell)
                    cell = [[MptCotentCell alloc] initWithFrame:frame];
                
                frame.origin = CGPointMake(CGRectGetWidth(self.scrollView.bounds)*i, 0);
                cell.frame = frame;
                cell.cellTag = i;
                cell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                
                [cell viewWillAppear];
                [self.scrollView addSubview:cell];
                [cell viewDidAppear];
                
                [self.onScreenCells addObject:cell];
                
                [cell mainViewOnFont:onFront];
            }
            
            
            
        }
    }
    
}


- (void)setCurrentDisplayItemIndex:(NSUInteger)index{
    if (index >= _total){
        BqsLog(@"setCurrentDisplayItemIndex > _total ,index :%d",index);
        return;
    }
    CGFloat off = index * CGRectGetWidth(self.scrollView.frame);
    CGPoint offPoint = CGPointMake(off, 0);
    [self.scrollView setContentOffset:offPoint animated:YES];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadViews];
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollView:curOffsetPercent:)]) {
        CGFloat offset = scrollView.contentOffset.x/scrollView.contentSize.width;
        BqsLog(@"scrollViewDidScroll offset percent :%.1f",offset);
        [_delegate scrollView:self curOffsetPercent:offset];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadViews];
    CGPoint off = self.scrollView.contentOffset;
    NSUInteger index =  off.x/CGRectGetWidth(self.scrollView.frame);
    BqsLog(@"MptContentScrollView current index : %d",index);
    if (_delegate && [_delegate respondsToSelector:@selector(scrollView:curIndex:)]) {
        [_delegate scrollView:self curIndex:index];
    }
    
}




@end
