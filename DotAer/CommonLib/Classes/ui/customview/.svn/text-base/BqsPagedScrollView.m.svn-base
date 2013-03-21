//
//  BqsPagedScrollView.m
//  iMobeeBook
//
//  Created by ellison on 11-9-6.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsPagedScrollView.h"
#import "BqsUtils.h"
#import "BqsTouchScrollView.h"

@interface BqsPagedScrollView()<UIScrollViewDelegate>
-(void)reLocatePages;
- (void)loadPages;
-(void)loadPage:(int)pageId;

-(void)resetImageZoomingSize;

@end

@implementation BqsPagedScrollView
@synthesize callback;
@synthesize bEnableZoom;
@synthesize fMaxZoomScale;
@synthesize fMinZoomScale;
@synthesize totalPages = _totalPages;
@synthesize curPageId = _curPageId;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.bEnableZoom = NO;
    self.fMaxZoomScale = 10.0;
    self.fMinZoomScale = .5;
    
    _totalPages = 0;
    _curPageId = 0;
    _viewCache = [[NSMutableDictionary alloc] initWithCapacity:9];
    
    // scroll view
    {
        BqsTouchScrollView *tsv = [[BqsTouchScrollView alloc] initWithFrame:frame];
        tsv.callback = self;
        
        _scrollView = tsv;
        // a page is the width of the scroll view
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        
        //zooming
        _scrollView.maximumZoomScale = self.fMaxZoomScale;
        _scrollView.minimumZoomScale = self.fMinZoomScale;
        _scrollView.zoomScale = 1.0;
        _scrollView.bouncesZoom = YES;

        
        [self addSubview:_scrollView];
    }
    
    return self;
}

- (void)dealloc
{
    self.callback = nil;
    _scrollView.delegate = nil;
    [_scrollView release];
    [_viewCache release];
    
    [super dealloc];
}

- (void) layoutSubviews {
	[super layoutSubviews];
    
    CGSize desiredPageSize = self.bounds.size;
    
	if (!CGSizeEqualToSize(_scrollView.bounds.size, desiredPageSize)) {
        
        _scrollView.frame = self.bounds;
        
        if(_bZooming) {
            [self resetImageZoomingSize];
        } else {
            // relocate pages
            [self reLocatePages];
        }
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
    UIView *ivC = [_viewCache objectForKey:[NSNumber numberWithInt:(int)_curPageId]];
    UIView *ivP = [_viewCache objectForKey:[NSNumber numberWithInt:(int)_curPageId-1]]; 
    UIView *ivN = [_viewCache objectForKey:[NSNumber numberWithInt:(int)_curPageId+1]];
    
    
    int pageCnt = 0;
    int pageId = _curPageId % 3;
    
    if(0 == _curPageId) {
        pageId = 0;
        pageCnt = 1;
        
        if(_totalPages > 1) {
            pageCnt ++;
        }
    } else if(_curPageId == _totalPages - 1) {
        pageId = 1;
        
        pageCnt = 2;
    } else {
        pageId = 1;
        pageCnt = 3;
    }
    
    CGRect rc = _scrollView.frame;
    float pageWidth = CGRectGetWidth(rc);
    
    _scrollView.contentSize = CGSizeMake(pageWidth * pageCnt, CGRectGetHeight(rc));
    _scrollView.contentOffset = CGPointMake(pageWidth * pageId, 0);
    
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
    for (NSNumber *key in [_viewCache allKeys]) {
        if (ABS([key intValue] - (int)_curPageId) > 1) {
            UIView *pageView = [_viewCache objectForKey:key];
            
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollView:DidUnloadPage:View:)]) {
                [self.callback bqsPagedScrollView:self DidUnloadPage:[key intValue] View: pageView];
            }
            
            [pageView removeFromSuperview];
            
            [_viewCache removeObjectForKey:key];
        }
    }
    
    [self loadPage:_curPageId];
    [self loadPage:_curPageId + 1];
    [self loadPage:_curPageId - 1];    
}

-(void)loadPage:(int)pageId {
    if(pageId >= _totalPages || pageId < 0) return;
	
	NSNumber *key = [NSNumber numberWithInt:(int)pageId];
	UIView *page = [_viewCache objectForKey:key];
	if(nil != page) return;

//    BqsLog(@"callback: %@", self.callback);
    
    page = [self.callback bqsPagedScrollView:self ViewForPage:pageId];
	// create sub views
	if(nil == page) {
        BqsLog(@"Can't load page: %d", pageId);
        return;
	}
    
	[_viewCache setObject:page forKey:[NSNumber numberWithInt:pageId]];
	
	CGRect rc = _scrollView.bounds;
	rc.origin.x = -CGRectGetWidth(rc);
	rc.origin.y = 0;
	page.frame = rc;
    [_scrollView addSubview:page];
    
}

#pragma mark - public methods
-(void)showPage:(int)aPageid Animate:(BOOL)bAni {
    if(!bAni) {
        _curPageId = aPageid;
    } else {
        if(_curPageId < aPageid) _curPageId = MAX(0, aPageid - 1);
        else if(_curPageId > aPageid) _curPageId = MIN(_totalPages - 1, aPageid + 1);
    }
	
    if(_bZooming) {
        [self resetImageZoomingSize];
    } else {
        [self loadPages];
        [self reLocatePages];
    }
    
    if(bAni && _curPageId != aPageid) {
        int pageId = 2;
        if(_curPageId < aPageid) {
            if(0 == _curPageId) {
                pageId = 1;
            } else {
                pageId = 2;
            }
            
        }
        else if(_curPageId > aPageid) pageId = 0;
        
        // update the scroll view to the appropriate page
        CGRect rc = _scrollView.frame;
        rc.origin.x = rc.size.width * pageId;
        rc.origin.y = 0;
        [_scrollView scrollRectToVisible:rc animated:bAni];
    }
    
}

-(void)reloadData {
    [self reloadData:_curPageId];
}
-(void)reloadData:(int)aPageId {
    
    // clear all visible pages
    for (NSNumber *key in [_viewCache allKeys]) {
        UIView *pageView = [_viewCache objectForKey:key];
        
        if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollView:DidUnloadPage:View:)]) {
            [self.callback bqsPagedScrollView:self DidUnloadPage:[key intValue] View: pageView];
        }
        
        [pageView removeFromSuperview];
        
        [_viewCache removeObjectForKey:key];
    }
    
    // reload
    _totalPages = [self.callback bqsPagedScrollViewGetPageCnt:self];
        	
    int pageId = MAX(MIN(_totalPages - 1, aPageId), 0);
    
    [self showPage:pageId Animate:NO];
	
//	BqsLog(@"totalPage: %d, w=%f", _totalPages, _scrollView.contentSize.width);
    
}


-(UIView*)viewOfPage:(int)idx {
    
    UIView *page = [_viewCache objectForKey:[NSNumber numberWithInt:idx]];
    return page;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    _beginDecelerateX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if(_bBlockScrollEvent || _bZooming || _scrollView.zooming || _scrollView.zoomBouncing) {
        return;
    }
    
    if(scrollView.contentOffset.x == _beginDecelerateX) {
        if(0 == _curPageId && 0 == _beginDecelerateX) {
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollViewDidSwipeRightOnFirstPage:)]) {
                [self.callback bqsPagedScrollViewDidSwipeRightOnFirstPage:self];
            }
        } else if(_curPageId == _totalPages - 1 && scrollView.contentSize.width - scrollView.frame.size.width == _beginDecelerateX) {
            if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollViewDidSwipeLeftOnLastPage:)]) {
                [self.callback bqsPagedScrollViewDidSwipeLeftOnLastPage:self];
            }
        }
    }


//	BqsLog(@"scrollViewDidEndDecelerating contentSize: %.1fx%.1f, offset.x: %.1f", _scrollView.contentSize.width, _scrollView.contentSize.height, _scrollView.contentOffset.x);
    
	CGFloat pageWidth = _scrollView.frame.size.width;
    
	int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    int newPageId = _curPageId;
    
    if(_totalPages <= 1) return;
    if(1 == page && _curPageId == 0) {
        newPageId = 1;
    } else if(0 == page && _curPageId > 0) {
        newPageId = _curPageId - 1;
    } else if(2 == page && _curPageId < _totalPages - 1) {
        newPageId = _curPageId + 1;
    }
    
    //    BqsLog(@"newPageId: %d", newPageId);
    
    if(newPageId == _curPageId) return;
    
	_curPageId = newPageId;
	
    if ([self.callback respondsToSelector:@selector(bqsPagedScrollView:WillTurnToPage:)])
		[self.callback bqsPagedScrollView:self WillTurnToPage:_curPageId];

    [self loadPages];
	[self reLocatePages];
    
	if ([self.callback respondsToSelector:@selector(bqsPagedScrollView:DidTurnToPage:)])
		[self.callback bqsPagedScrollView:self DidTurnToPage:_curPageId];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView {
//	BqsLog(@"scrollViewDidEndScrollingAnimation");
    [self scrollViewDidEndDecelerating:aScrollView];
}

#pragma mark - scroll view zooming
-(void)resetImageZoomingSize {
    if(_curPageId < 0 || _curPageId >= _totalPages) {
        return;
    }
    
    int cnt = [_viewCache count];
    if(cnt < 1) return;
    
    _bBlockScrollEvent = YES;
    
    
    // reset zooming scale
    _scrollView.maximumZoomScale = self.fMaxZoomScale;
    _scrollView.minimumZoomScale = self.fMinZoomScale;
    _scrollView.zoomScale = 1.0;
    _scrollView.bouncesZoom = YES;
    _scrollView.pagingEnabled = YES;
    _bZooming = NO;
    
    
    // reset content size
    [self loadPages];
    [self reLocatePages];
    
    _bBlockScrollEvent = NO;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)sV {
    
    if(!self.bEnableZoom) return nil;
    
    int cnt = [_viewCache count];
    if(cnt < 1) return nil;
    if(_curPageId < 0 || _curPageId >= _totalPages) {
        return nil;
    }
    
    // remove all other views when zooming
    NSArray *keys = [_viewCache allKeys];
    if([keys count] < 1) return nil;
    
    for(NSNumber *key in keys) {
        int pageId = [key intValue];
        if(_curPageId == pageId) continue;
        
        UIView *pageView = [_viewCache objectForKey:key];
        if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollView:DidUnloadPage:View:)]) {
            [self.callback bqsPagedScrollView:self DidUnloadPage:[key intValue] View: pageView];
        }
        
        [pageView removeFromSuperview];
        
        [_viewCache removeObjectForKey:key];
    }    
    
    UIView *tvi = [_viewCache objectForKey:[NSNumber numberWithInt:_curPageId]];
    
    if(!_bZooming) {
        _bZooming = YES;
        _scrollView.pagingEnabled = NO;
        
        // set pic pos
        CGRect rc = tvi.frame;
        rc.origin.x = 0;
        rc.origin.y = 0;
        tvi.frame = rc;
        
        // set content size
        _bBlockScrollEvent = YES;
        _scrollView.contentSize = _scrollView.frame.size;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _bBlockScrollEvent = NO;
    }
    return tvi;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)sV withView:(UIView *)view atScale:(float)scale {
    BqsLog(@"scrollViewDidEndZooming: %.1f, %.1f", scale, _scrollView.zoomScale);
    [view setNeedsLayout];
    
    if(scale < 1.01) {
        [self resetImageZoomingSize];
    }
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollView:EndZoomAtScale:)]) {
        [self.callback bqsPagedScrollView:self EndZoomAtScale:_scrollView.zoomScale];
    }

}


#pragma mark - BqsTouchScrollViewCallback
-(void)scrollView:(BqsTouchScrollView*)iv didTapped:(CGPoint)pt {
    BqsLog(@"didTap: %.1fx%.1f", pt.x, pt.y);
    
    if(_bZooming) {
        [self resetImageZoomingSize];
        return;
    }
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollView:DidTap:)]) {
        [self.callback bqsPagedScrollView:self DidTap:[iv convertPoint:pt toView:self]];
    }
}

-(void)scrollView:(BqsTouchScrollView*)iv didDoubleTapped:(CGPoint)pt {
    BqsLog(@"didDoubleTap: %.1fx%.1f", pt.x, pt.y);
    
    if(_bZooming) {
        [self resetImageZoomingSize];
        return;
    }
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsPagedScrollView:DidDoubleTap:)]) {
        [self.callback bqsPagedScrollView:self DidDoubleTap:[iv convertPoint:pt toView:self]];
    }
}

@end
