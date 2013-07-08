//
//  HumDotaFavoritBaseTableView.m
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaFavoritBaseTableView.h"
#import "Env.h"



@interface HumDotaFavoritBaseTableView()


@end


@implementation HumDotaFavoritBaseTableView

@synthesize dataArray = _dataArray;
@synthesize tableView;
@synthesize nTotalNum;

- (void)dealloc{
    [_dataArray release]; _dataArray = nil;
    self.tableView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident withController:(UIViewController *)ctrl
{
    self = [super initWithFrame:frame withIdentifier:ident withController:ctrl];
    if (nil == self) return nil;
    
    
    
    // create subview
    self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollsToTop = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    
    {
    UIView *foodView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds),kPgLoadingFooterView_H)] autorelease];
    foodView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = foodView;
    }

    
    // create downloade
    self.nTotalNum = -1;
    return self;
}
#pragma
#pragma mark instance method

- (void)viewWillAppear{
    [super viewWillAppear];
    if(! [self loadLocalDataNeedFresh])
        return;
    
}


-(void)viewDidAppear {
    
    [super viewDidAppear];
    
}



-(void)onViewWillDisappear {
    
    self.nTotalNum = -1;
    [super viewWillDisappear];
}


- (void)mainViewOnFont:(BOOL)value{
    if (value) {
        self.tableView.scrollsToTop = YES;
    }else{
        self.tableView.scrollsToTop = NO;
    }
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
#pragma mark
#pragma mark - UIScrollViewDelegate Methods
// called on start of dragging (may require some time and or distance to move)


#pragma mark - BqsRefreshTableHeaderView_Callback



#pragma mark pgFootViewDelegate





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
