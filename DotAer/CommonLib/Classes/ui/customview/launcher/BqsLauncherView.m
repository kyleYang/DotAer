//
//  BqsLauncherView.m
//  iMobeeBook
//
//  Created by ellison on 11-8-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsLauncherView.h"

// UI
#import "BqsLauncherButton.h"

#import "BqsUtils.h"
#import "BqsAttachedInfoItem.h"
#import "BqsCloseButton.h"
#import "BqsTouchScrollView.h"

@interface __BqsLauncherScrollView : BqsTouchScrollView
@end
@implementation __BqsLauncherScrollView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return !self.delaysContentTouches;
}
@end

static const CGFloat kMargin = 0;
static const CGFloat kPadding = 0;
static const CGFloat kPromptMargin = 40;
static const CGFloat kPagerHeight = 0;
static const CGFloat kWobbleRadians = 1.5;
static const CGFloat kSpringLoadFraction = 0.18;

static const NSTimeInterval kEditHoldTimeInterval = 1;
static const NSTimeInterval kSpringLoadTimeInterval = 0.5;
static const NSTimeInterval kWobbleTime = 0.07;


static const NSInteger kDefaultColumnCount = 3;


@interface BqsLauncherView() <BqsLauncherButton_Callback,BqsTouchScrollViewCallback>
@property (nonatomic, retain) NSMutableArray *arrCachedButtons;
@property (nonatomic, retain) NSMutableArray *arrShowButtons;
@property (nonatomic, retain) NSMutableArray *arrPages;

@property (nonatomic, retain) __BqsLauncherScrollView* vScroll;
@property (nonatomic, retain) UIPageControl* vPager;


-(void)recycleButton:(BqsLauncherButton*)btn;

-(int)calcRowCnt;
- (int)calcColumnCnt: (CGFloat)fWidth;
- (CGFloat)calcRowHeight;

- (NSIndexPath*)indexPathOfItem:(BqsLauncherButton*)item;
- (int)indexOfItem:(BqsLauncherButton*)item;

- (void)removeItem:(BqsLauncherButton*)item animated:(BOOL)animated;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BqsLauncherView

@synthesize nPageCnt;

@synthesize fPaddingHori;
@synthesize fPaddingVert;
@synthesize fColumnGap;
@synthesize fRowGap;
@synthesize szItemSize;


@synthesize columnCount = _columnCount;
@synthesize rowCount = _rowCount;
@synthesize editing = _editing;
@synthesize callback = _callback;

@synthesize arrCachedButtons;
@synthesize arrShowButtons;
@synthesize arrPages;

@synthesize vScroll;
@synthesize vPager;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(nil == self) return nil;
    
    self.vScroll = [[[__BqsLauncherScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kPagerHeight)] autorelease];
    self.vScroll.delegate = self;
    self.vScroll.callback = self;
    self.vScroll.scrollsToTop = NO;
    self.vScroll.showsVerticalScrollIndicator = NO;
    self.vScroll.showsHorizontalScrollIndicator = NO;
//    self.vScroll.alwaysBounceHorizontal = YES;
    self.vScroll.bounces = NO;
    self.vScroll.pagingEnabled = YES;
    self.vScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.vScroll.delaysContentTouches = NO;
    self.vScroll.multipleTouchEnabled = NO;
    [self addSubview:self.vScroll];
    
    self.vPager = [[[UIPageControl alloc] init] autorelease];
    self.vPager.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.vPager addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.vPager];
    
    self.autoresizesSubviews = YES;
    self.columnCount = kDefaultColumnCount;
    
    self.fPaddingHori = 0;
    self.fPaddingVert = 0;
    self.fColumnGap = 10;
    self.fRowGap = 10;
    self.szItemSize = CGSizeMake(80, 80);
    _columnCount = [self calcColumnCnt:CGRectGetWidth(self.vScroll.frame)];
    _rowCount = [self calcRowCnt];
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    self.arrCachedButtons = nil;
    self.arrShowButtons = nil;
    self.arrPages = nil;
    self.vScroll.delegate = nil;
    self.vScroll = nil;
    self.vPager = nil;
    
    [_editHoldTimer release];
    _editHoldTimer = nil;
    
    [_springLoadTimer release];
    _springLoadTimer = nil;
        
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)calcRowHeight {
    
    float viewHeight = CGRectGetHeight(self.vScroll.frame) - self.fPaddingVert * 2;
    float rowH = self.szItemSize.height + self.fRowGap;
    
    if(rowH < 1) return roundf(viewHeight / 3.0);
    
    float rowCnt = floor(viewHeight / rowH);
    
    return roundf(viewHeight / rowCnt);
}

-(int)calcRowCnt {
    float viewHeight = CGRectGetHeight(self.vScroll.frame) - self.fPaddingVert * 2;
    float rowH = self.szItemSize.height + self.fRowGap;
    
    if(rowH < 1) return 3;
    
    float rowCnt = floor(viewHeight / rowH);
    return rowCnt;
}

- (int)calcColumnCnt: (CGFloat)fWidth {
    if(fWidth < 1) return 1;
    
    float viewWidth = fWidth - self.fPaddingHori * 2;
    float itemW = self.szItemSize.width + self.fColumnGap;
    
    if(itemW < 1) return kDefaultColumnCount;
    
    return floor(viewWidth / itemW);
}

-(BqsLauncherButton*)cachedLauncherButton:(NSString*)identifier {
    if(nil == identifier) return nil;
    
    int cnt = [self.arrCachedButtons count];
    if(cnt < 1) return nil;
    
    for(cnt --; cnt >= 0; cnt --) {
        BqsLauncherButton* btn = [self.arrCachedButtons objectAtIndex:cnt];
        
        if([identifier isEqualToString:btn.identifier]) {
            [[btn retain] autorelease];
            [self.arrCachedButtons removeObjectAtIndex:cnt];
            return btn;
        }
    }
    return nil;
}

-(void)recycleButton:(BqsLauncherButton*)btn {
    if(nil == btn) return;
    [btn removeFromSuperview];
    btn.callback = nil;
    [btn removeTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn removeTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btn removeTarget:self action:@selector(buttonTouchedDown:withEvent:) forControlEvents:UIControlEventTouchDown];

    btn.editing = NO;
    btn.dragging = NO;
    btn.alpha = 1;
    btn.transform = CGAffineTransformIdentity;
    
    if(nil == self.arrCachedButtons) self.arrCachedButtons = [NSMutableArray arrayWithCapacity:32];
    [self.arrCachedButtons addObject:btn];
}


- (NSIndexPath*)indexPathOfItem:(BqsLauncherButton*)item {
    for (NSUInteger pageIndex = 0; pageIndex < self.arrPages.count; ++pageIndex) {
        NSArray* page = [self.arrPages objectAtIndex:pageIndex];
        NSUInteger itemIndex = [page indexOfObject:item];
        if (itemIndex != NSNotFound) {
            NSUInteger path[] = {pageIndex, itemIndex};
            return [NSIndexPath indexPathWithIndexes:path length:2];
        }
    }
    return nil;
}
- (int)indexOfItem:(BqsLauncherButton*)item {
    
    NSUInteger itemIndex = [self.arrShowButtons indexOfObject:item];
    if(NSNotFound == itemIndex) return -1;
    
    return itemIndex;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)pageOfItem:(BqsLauncherButton*)item {
    NSIndexPath* path = [self indexPathOfItem:item];
    if (nil != path) {
        NSInteger pageIndex = [path indexAtPosition:0];
        return [self.arrPages objectAtIndex:pageIndex];
        
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateContentSize:(NSInteger)numberOfPages {
    self.vScroll.contentSize = CGSizeMake(numberOfPages*CGRectGetWidth(self.vScroll.frame), CGRectGetHeight(self.vScroll.frame));
    if (numberOfPages != self.vPager.numberOfPages) {
        self.vPager.numberOfPages = numberOfPages;
    }
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherView:DidTurnToPage:TotalPage:)]) {
        [self.callback bqsLauncherView:self DidTurnToPage:self.currentPageIndex TotalPage:numberOfPages];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updatePagerWithContentOffset:(CGPoint)contentOffset {
    CGFloat pageWidth = CGRectGetWidth(self.vScroll.frame);
    int pageId = floor((contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(pageId == self.vPager.currentPage) {
        [self.vScroll setContentOffset: CGPointMake(CGRectGetWidth(self.vScroll.frame)*pageId, 0)  animated:YES];
        return;
    }
    self.vPager.currentPage = pageId;
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherView:DidTurnToPage:TotalPage:)]) {
        [self.callback bqsLauncherView:self DidTurnToPage:pageId TotalPage:self.nPageCnt];
    }

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutButtons {
    [self layoutIfNeeded];
    
    CGFloat buttonWidth = self.szItemSize.width;
    CGFloat buttonHeight = self.szItemSize.height;
    CGFloat pageWidth = CGRectGetWidth(self.vScroll.frame);// - 2 * self.fPaddingHori;
    CGFloat columnWidth = (pageWidth - 2 * self.fPaddingHori) / MAX(_columnCount, 1.0);
    CGFloat rowHeight = [self calcRowHeight];
    
    CGFloat itemWidthAdj = 0.0;
    if(columnWidth > buttonWidth) itemWidthAdj = roundf((columnWidth - buttonWidth)/2.0);
    
    CGFloat itemHeightAdj = 0.0;
    {
        if(rowHeight > buttonHeight) itemHeightAdj = roundf((rowHeight - buttonHeight)/2.0); 
    }
    
//    BqsLog(@"vh: %.1f, rowH: %.1f, btnh: %.1f hadj: %.1f", CGRectGetHeight(self.vScroll.frame), rowHeight, buttonHeight, itemHeightAdj);
    
    CGFloat minX = self.fPaddingHori + itemWidthAdj;
    CGFloat pageContentWidth = CGRectGetWidth(self.vScroll.frame) - minX - self.fPaddingHori;
    CGFloat x = minX;
    
    for (NSMutableArray* buttonPage in self.arrPages) {        
    
        CGFloat y = self.fPaddingVert + itemHeightAdj;

        for (BqsLauncherButton* button in buttonPage) {
            CGRect frame = CGRectMake(x, y, buttonWidth, buttonHeight);
            if (!button.dragging) {
                button.transform = CGAffineTransformIdentity;
                button.frame = button == _dragButton ? [self.vScroll convertRect:frame toView:self] : frame;
            }
            x += columnWidth;
            if (x >= minX+pageContentWidth) {
                y += rowHeight;
                x = minX;
            }
        }
        
        minX += pageWidth;
        x = minX;
    }
    
    int pageId = self.vPager.currentPage;
    NSInteger numberOfPages = self.arrPages.count;
    
    pageId = MAX(0, MIN(pageId, numberOfPages-1));
    self.vScroll.contentOffset = CGPointMake(CGRectGetWidth(self.vScroll.frame)*pageId, 0);
    
    [self updateContentSize:numberOfPages];
}

-(void)reLocateButtons {
    
    _rowCount = [self calcRowCnt];
    _columnCount = [self calcColumnCnt:CGRectGetWidth(self.vScroll.frame)];
    
    BqsLog(@"reLocateButtons: row: %d, column: %d", _rowCount, _columnCount);
    
    int itemCnt = [self.arrShowButtons count];
    int pageItemCnt = MAX(self.columnCount * self.rowCount, 1);
    int pageCnt = itemCnt / pageItemCnt;
    if(pageCnt * pageItemCnt < itemCnt) pageCnt ++;
    
    self.arrPages = [[[NSMutableArray alloc] initWithCapacity:pageCnt] autorelease];
    
    int i = 0;
    for (int page = 0; page < pageCnt && i < itemCnt; page ++) {
        NSMutableArray* buttonPage = [NSMutableArray arrayWithCapacity:pageItemCnt];
        [self.arrPages addObject:buttonPage];
        
        for(int item = 0; item < pageItemCnt && i < itemCnt; item ++, i ++) {
            BqsLauncherButton *btn = [self.arrShowButtons objectAtIndex:i];
            
            [buttonPage addObject:btn];
        }
    }
    
    [self layoutButtons];

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)recreateButtons {
    [self layoutIfNeeded];
    
    if(nil != self.arrShowButtons) {
        for(BqsLauncherButton *btn in self.arrShowButtons) {
            [self recycleButton:btn];
        }
    }
    
    int itemCnt = [self.callback bqsLauncherViewNumberOfItem:self];
    self.arrShowButtons = [NSMutableArray arrayWithCapacity:itemCnt];
    BqsLog(@"number of items: %d", itemCnt);
    
    for(int i = 0; i < itemCnt; i ++) {
        BqsLauncherButton *btn = [self.callback bqsLauncherView:self buttonForItem:i];
        btn.callback = self;
        btn.editing = self.editing;
        [btn addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(buttonTouchedDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        
        [self.vScroll addSubview:btn];
        [self.arrShowButtons addObject:btn];
    }
    
    [self reLocateButtons];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)checkButtonOverflow:(NSInteger)pageIndex {
    NSMutableArray* buttonPage = [self.arrPages objectAtIndex:pageIndex];
    NSInteger maxButtonsPerPage = self.columnCount*self.rowCount;
    if (buttonPage.count > maxButtonsPerPage) {
        BOOL isLastPage = (pageIndex == self.arrPages.count-1);
        
        NSMutableArray* nextButtonPage = nil;
        if (isLastPage) {
            nextButtonPage = [NSMutableArray array];
            [self.arrPages addObject:nextButtonPage];
            
        } else {
            nextButtonPage = [self.arrPages objectAtIndex:pageIndex+1];
        }
        
        while (buttonPage.count > maxButtonsPerPage) {
            [nextButtonPage insertObject:[buttonPage lastObject] atIndex:0];
            [buttonPage removeLastObject];
        }
        
        if (pageIndex+1 < self.arrPages.count) {
            [self checkButtonOverflow:pageIndex+1];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)startDraggingButton:(BqsLauncherButton*)button withEvent:(UIEvent*)event {
    [_springLoadTimer invalidate];
    _springLoadTimer = nil;
    
    if (button) {
        button.transform = CGAffineTransformIdentity;
        [self addSubview:button];
        button.center = [self.vScroll convertPoint:button.center toView:self];
        [button layoutIfNeeded];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    
    if (_dragButton) {
        _dragButton.selected = NO;
        _dragButton.highlighted = NO;
        _dragButton.dragging = NO;
        [self layoutButtons];
    }
    
    if (button) {
        _dragButton = button;
        
        NSIndexPath* indexPath = [self indexPathOfItem:button];
        _positionOrigin = [indexPath indexAtPosition:1];
        
        UITouch* touch = [[event allTouches] anyObject];
        _touchOrigin = [touch locationInView:self.vScroll];
        _dragOrigin = button.center;
        _dragTouch = touch;
        
        button.dragging = YES;
        
        self.vScroll.scrollEnabled = NO;
        
    } else {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(releaseButtonDidStop)];
        self.vScroll.scrollEnabled = YES;
    }
    
    [UIView commitAnimations];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeButtonAnimationDidStop:(NSString*)animationID finished:(NSNumber*)finished
                             context:(void*)context {
    BqsLauncherButton* button = context;
    [self recycleButton:button];
    [button removeFromSuperview];
    [self.arrShowButtons removeObject:button];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)springLoadTimer:(NSTimer*)timer {
    _springLoadTimer = nil;
    
    if ([(NSNumber*)timer.userInfo boolValue]) {
        CGFloat newX = self.vScroll.contentOffset.x - CGRectGetWidth(self.vScroll.frame);
        if (newX >= 0) {
            CGPoint offset = CGPointMake(newX, 0);
            [self.vScroll setContentOffset:offset animated:YES];
            [self updatePagerWithContentOffset:offset];
            _dragOrigin.x += CGRectGetWidth(self.vScroll.frame);
            _positionOrigin = -1;
            _springing = YES;
            [self performSelector:@selector(springingDidStop) withObject:nil afterDelay:0.3];
        }
        
    } else {
        CGFloat newX = self.vScroll.contentOffset.x + CGRectGetWidth(self.vScroll.frame);
        if (newX <= self.vScroll.contentSize.width - CGRectGetWidth(self.vScroll.frame)) {
            CGPoint offset = CGPointMake(newX, 0);
            [self.vScroll setContentOffset:offset animated:YES];
            [self updatePagerWithContentOffset:offset];
            _dragOrigin.x -= CGRectGetWidth(self.vScroll.frame);
            _positionOrigin = -1;
            _springing = YES;
            [self performSelector:@selector(springingDidStop) withObject:nil afterDelay:0.3];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)springingDidStop {
    _springing = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)releaseButtonDidStop {
    [self.vScroll addSubview:_dragButton];
    _dragButton.center = [self convertPoint:_dragButton.center toView:self.vScroll];
    _dragButton = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)buttonTouchedUpInside:(BqsLauncherButton*)button {
//    BqsLog(@"buttonTouchedUpInside");
    if (_editing) {
        if (button == _dragButton) {
            [self startDraggingButton:nil withEvent:nil];
        }
        
    } else {
        [_editHoldTimer invalidate];
        _editHoldTimer = nil;

        [button setSelected:YES];
        [self performSelector:@selector(deselectButton:) withObject:button
                   afterDelay:.3];

        if ([_callback respondsToSelector:@selector(bqsLauncherView:didSelectItem:)]) {
            [_callback bqsLauncherView:self didSelectItem:[self indexOfItem:button]];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)buttonTouchedUpOutside:(BqsLauncherButton*)button {
//    BqsLog(@"buttonTouchedUpOutside");
    if (_editing) {
        if (button == _dragButton) {
            [self startDraggingButton:nil withEvent:nil];
        }
        
    } else {
        [_editHoldTimer invalidate];
        _editHoldTimer = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)buttonTouchedDown:(BqsLauncherButton*)button withEvent:(UIEvent*)event {
//    BqsLog(@"buttonTouchedDown:withEvent:");
    if (_editing) {
        if (!_dragButton) {
            
            BOOL bCanMove = YES;
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherView:canMoveItem:)]) {
                bCanMove = [self.callback bqsLauncherView:self canMoveItem:[self indexOfItem:button]];
            }
            
            if(bCanMove) {
                [self startDraggingButton:button withEvent:event];
            }
        }
        
    } else {
        [_editHoldTimer invalidate];
        _editHoldTimer = nil;
        
        _editHoldTimer = [NSTimer scheduledTimerWithTimeInterval:kEditHoldTimeInterval
                                                          target:self selector:@selector(editHoldTimer:)
                                                        userInfo:[BqsAttachedInfoItem topic:nil strongRef:event weakRef:button]
                                                         repeats:NO];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)bqsLauncherButtonDidClickCloseButton:(BqsLauncherButton*)btn {
    [self removeItem:btn animated:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)wobble {
//    static BOOL wobblesLeft = NO;
//    
//    if (_editing) {
//        CGFloat rotation = (kWobbleRadians * M_PI) / 180.0;
//        CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
//        CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(-rotation);
//        
//        [UIView beginAnimations:nil context:nil];
//        
//        NSInteger i = 0;
//        NSInteger nWobblyButtons = 0;
//        for (NSArray* buttonPage in _buttons) {
//            for (BqsLauncherButton* button in buttonPage) {
//                if (button != _dragButton) {
//                    ++nWobblyButtons;
//                    if (i % 2) {
//                        button.transform = wobblesLeft ? wobbleRight : wobbleLeft;
//                        
//                    } else {
//                        button.transform = wobblesLeft ? wobbleLeft : wobbleRight;
//                    }
//                }
//                ++i;
//            }
//        }
//        
//        if (nWobblyButtons >= 1) {
//            [UIView setAnimationDuration:kWobbleTime];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDidStopSelector:@selector(wobble)];
//            wobblesLeft = !wobblesLeft;
//            
//        } else {
//            [NSObject cancelPreviousPerformRequestsWithTarget:self];
//            [self performSelector:@selector(wobble) withObject:nil afterDelay:kWobbleTime];
//        }
//        
//        [UIView commitAnimations];
//    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)editHoldTimer:(NSTimer*)timer {
    _editHoldTimer = nil;
    
    BqsAttachedInfoItem* info = timer.userInfo;
    BqsLauncherButton* button = info.weakRef;
    UIEvent* event = info.strongRef;
    
//    button.selected = NO;
//    button.highlighted = NO;
    
    BOOL bCanMove = YES;
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherView:canMoveItem:)]) {
        bCanMove = [self.callback bqsLauncherView:self canMoveItem:[self indexOfItem:button]];
    }
    
    if(bCanMove) {
        [self beginEditingAnimate:YES];

        [self startDraggingButton:button withEvent:event];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deselectButton:(BqsLauncherButton*)button {
    [button setSelected:NO];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)endEditingAnimationDidStop:(NSString*)animationID finished:(NSNumber*)finished
//                           context:(void*)context {
//    for (NSArray* buttonPage in self.arrPages) {
//        for (BqsLauncherButton* button in buttonPage) {
//            button.editing = NO;
//        }
//    }
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTouch {
    CGPoint origin = [_dragTouch locationInView:self.vScroll];
    _dragButton.center = CGPointMake(_dragOrigin.x + (origin.x - _touchOrigin.x),
                                     _dragOrigin.y + (origin.y - _touchOrigin.y));
    
    CGFloat x = origin.x - self.vScroll.contentOffset.x;
    float columnWidth = (CGRectGetWidth(self.vScroll.frame) - 2 * self.fPaddingHori) / MAX((float)self.columnCount, 1.0);
    NSInteger column = floor((x - self.fPaddingHori)/MAX(columnWidth, 1.0));
    NSInteger row = floor((origin.y - self.fPaddingVert)/MAX([self calcRowHeight], 1.0));
    NSInteger itemIndex = (row * self.columnCount) + column;
    NSInteger pageIndex = floor(self.vScroll.contentOffset.x/MAX(CGRectGetWidth(self.vScroll.frame), 1.0));
    
//    BqsLog(@"column: %d, row: %d, pt:%.1f,%.1f, columnWidth: %.1f", column, row, origin.x, origin.y, columnWidth);
    if (itemIndex != _positionOrigin) {
        NSMutableArray* currentButtonPage = [self.arrPages objectAtIndex:pageIndex];
        if (itemIndex > currentButtonPage.count) {
            itemIndex = currentButtonPage.count;
        }
        
        if (itemIndex != _positionOrigin) {
            [[_dragButton retain] autorelease];
            
            NSMutableArray* buttonPage = [self pageOfItem:_dragButton];
            [buttonPage removeObject:_dragButton];
            
            if (itemIndex > currentButtonPage.count) {
                itemIndex = currentButtonPage.count;
            }
            
            BOOL didMove = (itemIndex != _positionOrigin);
            
            [currentButtonPage insertObject:_dragButton atIndex:itemIndex];
            
            _positionOrigin = itemIndex;
            
            [self checkButtonOverflow:pageIndex];
            if (didMove) {
                int originPos = [self.arrShowButtons indexOfObject:_dragButton];
                int newPos = 0;
                BOOL bFound = NO;
                for (NSArray* buttonPage in self.arrPages) {
                    for (BqsLauncherButton* button in buttonPage) {
                        if(button == _dragButton) {
                            bFound = YES;
                            break;
                        }
                        newPos ++;
                    }
                    if(bFound) break;
                }
                
                int cnt = [self.arrShowButtons count];
                if(originPos >= 0 && originPos < cnt && 
                   newPos >= 0 && newPos < cnt) {
                    id obj = [self.arrShowButtons objectAtIndex:originPos];
                    [[obj retain] autorelease];
                    [self.arrShowButtons removeObjectAtIndex:originPos];
                    [self.arrShowButtons insertObject:obj atIndex:newPos];
                }

                if ([_callback respondsToSelector:@selector(bqsLauncherView:didMoveItemFrom:To:)]) {
                    [_callback bqsLauncherView:self didMoveItemFrom:originPos To:newPos];
                }
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.3];
                [self layoutButtons];
                [UIView commitAnimations];
            }
        }
    }
    
    CGFloat springLoadDistance = CGRectGetWidth(_dragButton.frame)*kSpringLoadFraction;
//    TTDCONDITIONLOG(TTDFLAG_LAUNCHERVIEW, @"%f < %f", springLoadDistance, _dragButton.center.x);
    BOOL goToPreviousPage = _dragButton.center.x - springLoadDistance < 0;
    BOOL goToNextPage = ((CGRectGetWidth(self.vScroll.frame) - _dragButton.center.x) - springLoadDistance) < 0;
    if (goToPreviousPage || goToNextPage) {
        if (!_springLoadTimer) {
            _springLoadTimer = [NSTimer scheduledTimerWithTimeInterval:kSpringLoadTimeInterval
                                                                target:self selector:@selector(springLoadTimer:)
                                                              userInfo:[NSNumber numberWithBool:goToPreviousPage] repeats:NO];
        }
        
    } else {
        [_springLoadTimer invalidate];
        _springLoadTimer = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIResponder


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (_dragButton && !_springing) {
        for (UITouch* touch in touches) {
            if (touch == _dragTouch) {
                [self updateTouch];
                break;
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (_dragTouch) {
        for (UITouch* touch in touches) {
            if (touch == _dragTouch) {
                
                // New delegate method
                if ([_callback respondsToSelector:@selector(bqsLauncherViewDidEndDragging:)]) {
                    [_callback bqsLauncherViewDidEndDragging:self];
                }
                
                _dragTouch = nil;
                break;
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
//    
//    [self reLocateButtons];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rc = self.bounds;
    
    self.vScroll.frame = CGRectMake(0, 0, rc.size.width, rc.size.height - kPagerHeight);
    self.vPager.frame = CGRectMake(0, CGRectGetHeight(rc), CGRectGetWidth(rc), kPagerHeight);

    int rowCnt = [self calcRowCnt];
    int columnCnt = [self columnCount];
    
    if(_rowCount != rowCnt || _columnCount != columnCnt) {
        [self reLocateButtons];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    [_editHoldTimer invalidate];
    _editHoldTimer = nil;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    _beginDecelerateX = scrollView.contentOffset.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x == _beginDecelerateX && nil != self.vPager) {
        if(0 == self.vPager.currentPage && 0 == _beginDecelerateX) {
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherViewDidSwipeRightOnFirstPage:)]) {
                [self.callback bqsLauncherViewDidSwipeRightOnFirstPage:self];
            }
        } else if(self.vPager.currentPage == self.vPager.numberOfPages - 1 && scrollView.contentSize.width - scrollView.frame.size.width == _beginDecelerateX) {
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherViewDidSwipeLeftOnLastPage:)]) {
                [self.callback bqsLauncherViewDidSwipeLeftOnLastPage:self];
            }
        }
    }

    
    [self updatePagerWithContentOffset:self.vScroll.contentOffset];
}

-(void)scrollView:(BqsTouchScrollView*)iv didTapped:(CGPoint)pt {
//    if(_editing) {
//        [self endEditingAnimate:YES];
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIPageControlDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pageChanged {
    self.vScroll.contentOffset = CGPointMake(self.vPager.currentPage * CGRectGetWidth(self.vScroll.frame), 0);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

-(void)reloadData {
    [self recreateButtons];
    [self setNeedsLayout];
}

-(BqsLauncherButton*)buttonOfIndex:(int)idx {
    if(idx < 0 || idx > [self.arrShowButtons count]) return nil;
    return [self.arrShowButtons objectAtIndex:idx];
}

-(void)removeButtonAtIndex:(int)idx {
    if(idx < 0 || idx > [self.arrShowButtons count]) return;
    
    BqsLauncherButton *btn = [self.arrShowButtons objectAtIndex:idx];
    [[btn retain] autorelease];

    [self removeItem:btn animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setColumnCount:(NSInteger)columnCount {
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        _rowCount = 0;
        
        self.arrPages = nil;
        [self setNeedsLayout];
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)currentPageIndex {
    return floor(self.vScroll.contentOffset.x/MAX(1.0,CGRectGetWidth(self.vScroll.frame)));
}
-(int)nPageCnt {
    return [self.arrPages count];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCurrentPageIndex:(NSInteger)pageIndex {
    self.vScroll.contentOffset = CGPointMake(CGRectGetWidth(self.vScroll.frame)*pageIndex, 0);
}
-(void)setCurrentPageIndex:(int)pageId Animate:(BOOL)bAni {
    [self.vScroll setContentOffset: CGPointMake(CGRectGetWidth(self.vScroll.frame)*pageId, 0)  animated:bAni];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeItem:(BqsLauncherButton*)item animated:(BOOL)animated {
    
    int idxOfItem = [self indexOfItem:item];
    
    NSMutableArray* itemPage = [self pageOfItem:item];
    if (itemPage) {
        [itemPage removeObject:item];
        if (animated) {
            [UIView beginAnimations:nil context:item];
            [UIView setAnimationDuration:.2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeButtonAnimationDidStop:finished:context:)];
            [self layoutButtons];
            item.transform = CGAffineTransformMakeScale(0.01, 0.01);
            item.alpha = 0;
            [UIView commitAnimations];
            
        } else {
            [self recycleButton:item];
            [self.arrShowButtons removeObject:item];
            [self layoutButtons];
        }
        
        if ([_callback respondsToSelector:@selector(bqsLauncherView:didRemoveItem:)]) {
            [_callback bqsLauncherView:self didRemoveItem:idxOfItem];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToItem:(BqsLauncherButton*)item animated:(BOOL)animated {
    NSIndexPath* path = [self indexPathOfItem:item];
    if (path) {
        NSUInteger page = [path indexAtPosition:0];
        CGFloat x = page * CGRectGetWidth(self.vScroll.frame);
        [self.vScroll setContentOffset:CGPointMake(x, 0) animated:animated];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beginEditingAnimate:(BOOL)bAnimate {
    
    if ([_callback respondsToSelector:@selector(bqsLauncherViewWillBeginEditing:)]) {
        [_callback bqsLauncherViewWillBeginEditing:self];
    }

    _editing = YES;
    self.vScroll.delaysContentTouches = YES;

    if(bAnimate) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
    }
    
    int idx = 0;
    for (NSArray* buttonPage in self.arrPages) {
        for (BqsLauncherButton* button in buttonPage) {
            BOOL bCanDelete = YES;
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherView:canDeleteItem:)]) {
                bCanDelete = [self.callback bqsLauncherView:self canDeleteItem:idx];
            }
            if(bCanDelete) {
                button.editing = YES;
            }
            
            idx ++;

        }
    }
    if(bAnimate) {
        [UIView commitAnimations];
    }
    
//    // Add a page at the end
//    [_pages addObject:[NSMutableArray array]];
//    [_buttons addObject:[NSMutableArray array]];
//    [self updateContentSize:_pages.count];
    
    [self wobble];
    
    if ([_callback respondsToSelector:@selector(bqsLauncherViewDidBeginEditing:)]) {
        [_callback bqsLauncherViewDidBeginEditing:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)endEditingAnimate:(BOOL)bAnimate {
    _editing = NO;
    self.vScroll.delaysContentTouches = NO;
    
    if(bAnimate) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(endEditingAnimationDidStop:finished:context:)];
    }
    
    for (NSArray* buttonPage in self.arrPages) {
        for (BqsLauncherButton* button in buttonPage) {
//            button.transform = CGAffineTransformIdentity;
//            button.btnClose.alpha = 0;
            
            button.editing = NO;
        }
    }
    
    if(bAnimate) {
        [UIView commitAnimations];
//    } else {
//        [self endEditingAnimationDidStop:nil finished:nil context:nil];
    }
    
//    for (NSInteger i = 0; i < _pages.count; ++i) {
//        NSArray* page = [_pages objectAtIndex:i];
//        if (!page.count) {
//            [_pages removeObjectAtIndex:i];
//            [_buttons removeObjectAtIndex:i];
//            --i;
//        }
//    }

    [self reLocateButtons];
//    [self layoutButtons];
    
    if ([_callback respondsToSelector:@selector(bqsLauncherViewDidEndEditing:)]) {
        [_callback bqsLauncherViewDidEndEditing:self];
    }
}


@end
