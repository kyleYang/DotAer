//
//  HumDotaCateTwoTableView.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCateTwoTableView.h"
#import "HumDotaBaseViewController.h"
#import "Env.h"



@interface HumDotaCateTwoTableView()<UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate,UISearchBarDelegate,pgFootViewDelegate>


@end


@implementation HumDotaCateTwoTableView

@synthesize dataArray = _dataArray;
@synthesize tableView;
@synthesize pullView;
@synthesize loadingMoreFootView;
@synthesize viewSearchbar;
@synthesize nTotalNum;
@synthesize bLoadingMore;
@synthesize nTaskId;
@synthesize dateLastRefreshTm;

- (void)dealloc{
    [_dataArray release]; _dataArray = nil;
    self.tableView = nil;
    self.pullView.delegate = nil;
    self.pullView = nil;
    self.loadingMoreFootView = nil;
    self.viewSearchbar = nil;
    self.dateLastRefreshTm = nil;
    [super dealloc];
}

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame
{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (nil == self) return nil;
    
   
    
    // create subview
    self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    // pull refresh
    {
        self.pullView = [[[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, -CGRectGetHeight(self.tableView.frame), CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.frame))] autorelease];
        self.pullView.delegate = self;
        [self.tableView addSubview:self.pullView];
    }
    
    // loading more footer
    {
        self.loadingMoreFootView = [[[PgLoadingFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds),kPgLoadingFooterView_H)] autorelease];
        self.loadingMoreFootView.backgroundColor = [UIColor clearColor];
        self.loadingMoreFootView.delegate = self;
        self.tableView.tableFooterView = self.loadingMoreFootView;;
    }
    
    // serach bar
//    {
//        self.viewSearchbar.backgroundColor = [UIColor clearColor];
//        self.viewSearchbar.placeholder = NSLocalizedString(@"guide.search.searchbox.channel.tip", nil);
//        //        self.viewSearchbar.showsCancelButton = YES;
//        self.viewSearchbar.backgroundColor = [UIColor clearColor];
//        self.viewSearchbar.delegate = self;
//        for ( UIView * subview in self.viewSearchbar.subviews )
//        {
//            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground") ] )
//                subview.alpha = 0.0;
//            
//            else if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] )
//                subview.alpha = 0.0;
//            
//        }
//        
//        self.viewSearchbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        self.tableView.tableHeaderView = self.viewSearchbar;
//
//    }
    
    _hasMore = YES;
    _curPage = 0;
    // create downloade
    self.nTotalNum = -1;
    self.nTaskId = -1;
    return self;
}
#pragma 
#pragma mark instance method

- (void)viewWillAppear{
    [super viewWillAppear];
    if(! [self loadLocalDataNeedFresh])
        return;
    [self performSelector:@selector(tableContentFrsh) withObject:nil afterDelay:0.5];
    
    
}

- (void)tableContentFrsh{
    CGPoint tableOffset = self.tableView.contentOffset;
    if (tableOffset.y > 40) {
        return;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, kFreshOffSet) animated:YES];
}

-(void)viewDidAppear {
    
    [super viewDidAppear];
    
}



-(void)onViewWillDisappear {
        
    [self.viewSearchbar resignFirstResponder];
    [self.viewSearchbar setShowsCancelButton:NO animated:YES];
    self.nTotalNum = -1;
    [self.downloader cancelAll];
    [super viewWillDisappear];
}
#pragma mark
#pragma mark - network ops
- (BOOL)loadLocalDataNeedFresh{
    return TRUE;
}

-(void)loadNetworkData:(BOOL)bLoadMore {
    
}

-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    
}


#pragma mark
#pragma mark property
- (void)setDataArray:(NSArray *)dataArray{
    [_dataArray release]; _dataArray = nil;
    _dataArray = [dataArray retain];
    [self.tableView reloadData];
    _loadMore = NO;
    if (!_hasMore) {
        [self.loadingMoreFootView setState:PgFootRefreshAllDown];
    }else{
        [self.loadingMoreFootView setState:PgFootRefreshNormal];
    }
    
    [self doneLoadingTableViewData]; 

}


#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}
#pragma mark
#pragma mark PgFootMore
- (void)footLoadMore
{
    if (self.loadingMoreFootView.state == PgFootRefreshAllDown) {
        return;
    }
    [self loadMoreData];
    
}

- (void)loadMoreData{
 
    if(self.loadingMoreFootView.state == PgFootRefreshAllDown){
        return;
    }
    
    _loadMore = YES;
    
    [self.loadingMoreFootView setState:PgFootRefreshLoading];
    
    [self loadNetworkData:YES];
}

#pragma mark
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_loadMore) {
        float maxoffset = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)+50;
        if(maxoffset > 0 && scrollView.contentOffset.y >= maxoffset) {
            BqsLog(@"trigger load more!, offsety: %.1f, contentsize.h: %.1f, maxoffset:%.1f", scrollView.contentOffset.y, scrollView.contentSize.height, maxoffset);
            [self loadMoreData];
        }
        
    }    
    [self.pullView egoRefreshScrollViewDidScroll:scrollView];
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pullView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}


#pragma mark - BqsRefreshTableHeaderView_Callback
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
    [self loadNetworkData:NO];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:4.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[self.pullView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}



#pragma mark pgFootViewDelegate
- (NSString *)messageTxtForState:(PgFootRefreshState)state
{
    int itemNum = [self.dataArray count];
    
    if (state == PgFootRefreshNormal) {
        if (itemNum == 0) {
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.noresult", nil)];
        }else{
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.normal", nil),itemNum];
        }
    }else if(state == PgFootRefreshLoading){
        return NSLocalizedString(@"dota.more.loading", nil);
    }else if(state ==  PgFootRefreshAllDown){
        if (itemNum == 0) {
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.noresult", nil)];
        }else{
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.done", nil),itemNum];
        }
    }
    return @"";
}

- (void)loadingFootViewDidClickMore:(PgLoadingFooterView *)foot{
    
}



#pragma mark - MptGuideSearchbarView_Callback

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{

}


@end
