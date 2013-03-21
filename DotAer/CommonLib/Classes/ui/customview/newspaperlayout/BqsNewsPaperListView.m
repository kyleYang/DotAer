//
//  BqsNewsPaperListView.m
//  iMobeeNews
//
//  Created by ellison on 11-9-1.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsNewsPaperListView.h"
#import "BqsNewsPaperPageView.h"
#import "BqsUtils.h"

@interface BqsNewsPaperListView() <UIScrollViewDelegate,BqsNewsPaperPageView_Callback>
@property (nonatomic, retain) BqsNewsPaperPageLayout *pageLayout;
@property (nonatomic, assign, readwrite) int curPageId;
@property (nonatomic, assign, readwrite) int totalPage;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *arrCachedPageView;
@property (nonatomic, retain) NSMutableDictionary *dicPageViewCache;
@property (nonatomic, retain) NSMutableArray *arrCachedItemView;


-(void)reLocatePages;
-(void)loadPages;
-(void)loadPage:(int)pageId;

-(void)recycleItemView:(BqsNewsPaperItemView*)itemView;
@end

@implementation BqsNewsPaperListView
@synthesize callback;

@synthesize pageLayout;
@synthesize curPageId;
@synthesize totalPage;
@synthesize totalItemCnt;

@synthesize fPaddingHor;
@synthesize fPaddingVer;
@synthesize fGap;
@synthesize bDrawGapLine;
@synthesize fGapLineWidth;
@synthesize gapLineColor;

@synthesize scrollView;
@synthesize arrCachedPageView;
@synthesize dicPageViewCache;
@synthesize arrCachedItemView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    // vars
    self.arrCachedPageView = [NSMutableArray arrayWithCapacity:5];
    self.dicPageViewCache = [NSMutableDictionary dictionaryWithCapacity:5];
    
    // sub views
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scrollView];

    return self;
}

- (void)dealloc
{
    self.callback = nil;
    self.pageLayout = nil;
    self.gapLineColor = nil;
    
    self.scrollView.delegate = nil;
    self.scrollView = nil;
    self.arrCachedPageView = nil;
    self.dicPageViewCache = nil;
    self.arrCachedItemView = nil;
    [super dealloc];
}

- (void) layoutSubviews {
	[super layoutSubviews];
    
    CGSize desiredPageSize = self.bounds.size;
    
	if (!CGSizeEqualToSize(self.scrollView.bounds.size, desiredPageSize)) {

        self.scrollView.frame = self.bounds;
        
        // relocate pages
        [self reLocatePages];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)reLocatePages {
    UIView *ivC = [self.dicPageViewCache objectForKey:[NSNumber numberWithInt:(int)self.curPageId]];
    UIView *ivP = [self.dicPageViewCache objectForKey:[NSNumber numberWithInt:(int)self.curPageId-1]]; 
    UIView *ivN = [self.dicPageViewCache objectForKey:[NSNumber numberWithInt:(int)self.curPageId+1]];
    
    
    int pageCnt = 0;
    int pageId = self.curPageId % 3;
    
    if(0 == self.curPageId) {
        pageId = 0;
        pageCnt = 1;
        
        if(self.totalPage > 1) {
            pageCnt ++;
        }
    } else if(self.curPageId == self.totalPage - 1) {
        pageId = 1;
        
        pageCnt = 2;
    } else {
        pageId = 1;
        pageCnt = 3;
    }
    
    CGRect rc = self.scrollView.frame;
    float pageWidth = CGRectGetWidth(rc);
    
    self.scrollView.contentSize = CGSizeMake(pageWidth * pageCnt, CGRectGetHeight(rc));
    self.scrollView.contentOffset = CGPointMake(pageWidth * pageId, 0);
    
    rc.origin.x = pageWidth * pageId;
    rc.origin.y = 0;
    
    if(nil != ivC) {
        ivC.frame = rc;
    }
    
    if(pageId > 0 && nil != ivP) {
        rc.origin.x = pageWidth * (pageId - 1);
        ivP.frame = rc;
    }
    
    if(pageId < 2 && nil != ivN) {
        rc.origin.x = pageWidth * (pageId + 1);
        ivN.frame = rc;
    }
    
}

- (void)loadPages {
	
	// remove unused cache
    for (NSNumber *key in [self.dicPageViewCache allKeys]) {
        if (ABS([key intValue] - (int)self.curPageId) > 1) {
            BqsNewsPaperPageView *pageView = [self.dicPageViewCache objectForKey:key];
            
            [pageView unloadPage];
            [self.arrCachedPageView addObject:pageView];
            [pageView removeFromSuperview];
            
            [self.dicPageViewCache removeObjectForKey:key];
        }
    }
    
    [self loadPage:self.curPageId];
    [self loadPage:self.curPageId + 1];
    [self loadPage:self.curPageId - 1];    
}

-(void)loadPage:(int)pageId {
    if(pageId >= self.totalPage || pageId < 0) return;
	
	NSNumber *key = [NSNumber numberWithInt:(int)pageId];
	BqsNewsPaperPageView *page = [self.dicPageViewCache objectForKey:key];
	if(nil != page) return;

    if(nil != self.arrCachedPageView && [self.arrCachedPageView count] > 0) {
        page = [self.arrCachedPageView objectAtIndex:0];
        [[page retain] autorelease];
        [self.arrCachedPageView removeObjectAtIndex:0];
    }
    
	// create sub views
	if(nil == page) {
        page = [[[BqsNewsPaperPageView alloc] initWithFrame: self.scrollView.bounds] autorelease];
	}
    page.callback = self;
    page.fPaddingHor = self.fPaddingHor;
    page.fPaddingVer = self.fPaddingVer;
    page.fGap = self.fGap;
    page.bDrawGapLine = self.bDrawGapLine;
    page.fGapLineWidth = self.fGapLineWidth;
    page.gapLineColor = self.gapLineColor;
    
    page.pageId = pageId;
    page.pageLayout = self.pageLayout;
    
    [page loadPage];

	[self.dicPageViewCache setObject:page forKey:[NSNumber numberWithInt:pageId]];
	
	CGRect rc = self.scrollView.bounds;
	rc.origin.x = -CGRectGetWidth(rc);
	rc.origin.y = 0;
	page.frame = rc;
    [self.scrollView addSubview:page];

}

-(BqsNewsPaperItemView*)cachedItemView:(NSString*)identifier {
    if(nil == identifier) return nil;
    
    int cnt = [self.arrCachedItemView count];
    if(cnt < 1) return nil;
    
    for(cnt --; cnt >= 0; cnt --) {
        BqsNewsPaperItemView* v = [self.arrCachedItemView objectAtIndex:cnt];
        
        if([identifier isEqualToString:v.identifier]) {
            [[v retain] autorelease];
            [self.arrCachedItemView removeObjectAtIndex:cnt];
            return v;
        }
    }
    return nil;
}

-(void)recycleItemView:(BqsNewsPaperItemView*)itemView {
    if(nil == itemView) return;
    
    [[itemView retain] autorelease];
    
    [itemView removeFromSuperview];
    
    itemView.callback = nil;
    itemView.alpha = 1;
    itemView.transform = CGAffineTransformIdentity;
    
    if(nil == self.arrCachedItemView) self.arrCachedItemView = [NSMutableArray arrayWithCapacity:32];
    [self.arrCachedItemView addObject:itemView];

}

#pragma mark - public methods
-(void)showPage:(int)aPageid Animate:(BOOL)bAni {
    if(!bAni) {
        self.curPageId = aPageid;
    } else {
        if(self.curPageId < aPageid) self.curPageId = MAX(0, aPageid - 1);
        else if(self.curPageId > aPageid) self.curPageId = MIN(self.totalPage - 1, aPageid + 1);
    }
	
	[self loadPages];
    [self reLocatePages];
    
    if(bAni && self.curPageId != aPageid) {
        int pageId = 2;
        if(self.curPageId < aPageid) {
            if(0 == self.curPageId) {
                pageId = 1;
            } else {
                pageId = 2;
            }
            
        }
        else if(self.curPageId > aPageid) pageId = 0;
        
        // update the scroll view to the appropriate page
        CGRect rc = self.scrollView.frame;
        rc.origin.x = rc.size.width * pageId;
        rc.origin.y = 0;
        [self.scrollView scrollRectToVisible:rc animated:bAni];
    }

}

-(void)reloadData {
    [self reloadData:self.curPageId];
}

-(void)reloadData:(int)aPageIdx {    
    // clear all visible pages
    for (NSNumber *key in [self.dicPageViewCache allKeys]) {
        BqsNewsPaperPageView *pageView = [self.dicPageViewCache objectForKey:key];
        
        [pageView unloadPage];
        [self.arrCachedPageView addObject:pageView];
        [pageView removeFromSuperview];
        
        [self.dicPageViewCache removeObjectForKey:key];
    }

    // reload
    self.pageLayout = [self.callback bqsNewsPaperListViewGetPageLayout:self];
    
    if(nil == self.pageLayout) {
        BqsLog(@"Invalid pageLayout");
        return;
    }
    
    self.totalPage = [self.pageLayout getPageCnt];
	
    int pageId = MIN(self.totalPage - 1, aPageIdx);
    pageId = MAX(pageId, 0);
    
    [self showPage:pageId Animate:NO];
	
	BqsLog(@"totalPage: %d, w=%f", self.totalPage, self.scrollView.contentSize.width);

}


-(UIView*)viewOfIndex:(int)idx {
    int pageid = [self.pageLayout getPageIdForItemId:idx];
    BqsNewsPaperPageView *page = [self.dicPageViewCache objectForKey:[NSNumber numberWithInt:pageid]];
    return [page viewOfIndex:idx];
}

-(int)totalItemCnt {
    if(nil == self.pageLayout) return 0;
    
    return [self.pageLayout getTotalItemCnt];
}

#pragma mark - BqsNewsPaperPageView_Callback

-(BqsNewsPaperItemView*)bqsNewsPaperPageView:(BqsNewsPaperPageView*)view GetViewForItem:(int)itemId {
    return [self.callback bqsNewsPaperListView:self GetViewForItem:itemId];
}
-(void)bqsNewsPaperPageView:(BqsNewsPaperPageView*)view RecycleItemView:(BqsNewsPaperItemView*)itemView ItemIdx:(int)itemIdx {
    [[itemView retain] autorelease];
    [self recycleItemView:itemView];
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNewsPaperListView:DidUnloadItem:)]) {
        [self.callback bqsNewsPaperListView:self DidUnloadItem:itemView Idx:itemIdx];
    }

}

-(void)bqsNewsPaperPageView:(BqsNewsPaperPageView*)view DidSelectItem:(int)itemId {
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNewsPaperListView:DidSelectItem:)]) {
        [self.callback bqsNewsPaperListView:self DidSelectItem:itemId];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollV {
    _beginDecelerateX = scrollV.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV {
    //pageControlUsed = NO;
	BqsLog(@"scrollViewDidEndDecelerating contentSize: %.1fx%.1f, offset.x: %.1f", self.scrollView.contentSize.width, self.scrollView.contentSize.height, self.scrollView.contentOffset.x);
    
    if(scrollV.contentOffset.x == _beginDecelerateX) {
        if(0 == self.curPageId && 0 == _beginDecelerateX) {
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNewsPaperListViewDidSwipeRightOnFirstPage:)]) {
                [self.callback bqsNewsPaperListViewDidSwipeRightOnFirstPage:self];
            }
        } else if(self.curPageId == self.totalPage - 1 && scrollV.contentSize.width - scrollV.frame.size.width == _beginDecelerateX) {
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNewsPaperListViewDidSwipeLeftOnLastPage:)]) {
                [self.callback bqsNewsPaperListViewDidSwipeLeftOnLastPage:self];
            }
        }
    }

    
	CGFloat pageWidth = self.scrollView.frame.size.width;
    
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    int newPageId = self.curPageId;
    
    if(self.totalPage <= 1) return;
    if(1 == page && self.curPageId == 0) {
        newPageId = 1;
    } else if(0 == page && self.curPageId > 0) {
        newPageId = self.curPageId - 1;
    } else if(2 == page && self.curPageId < self.totalPage - 1) {
        newPageId = self.curPageId + 1;
    }

//    BqsLog(@"newPageId: %d", newPageId);
    
    if(newPageId == self.curPageId) return;
    
	self.curPageId = newPageId;
	
    [self loadPages];
	[self reLocatePages];
    
	if ([self.callback respondsToSelector:@selector(bqsNewsPaperListView:DidTurnToPage:)])
		[self.callback bqsNewsPaperListView:self DidTurnToPage:self.curPageId];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView {
	BqsLog(@"scrollViewDidEndScrollingAnimation");
    [self scrollViewDidEndDecelerating:aScrollView];
}


@end
