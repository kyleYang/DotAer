//
//  HumDotaCateTwoTableView.h
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaPadCateTowBaseView.h"
#import "PgLoadingFooterView.h"
#import "Downloader.h"
#import "HumDotaSearchBar.h"
#import "EGORefreshTableHeaderView.h"

#define kFreshOffSet -80

@interface HumDotaPadCateTwoTableView : HumDotaPadCateTowBaseView{
    BOOL _reloading;
    BOOL _loadMore;
    BOOL _hasMore;
    int _curPage;
}

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) EGORefreshTableHeaderView *pullView;
@property (nonatomic, retain) PgLoadingFooterView *loadingMoreFootView;
@property (nonatomic, retain) HumDotaSearchBar *viewSearchbar;

@property (nonatomic, assign) int nTotalNum;
@property (nonatomic, assign) BOOL bLoadingMore;
@property (nonatomic, assign) int nTaskId;
@property (nonatomic, retain) NSDate *dateLastRefreshTm;


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;




@end
