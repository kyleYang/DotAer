//
//  HumDotaFavoritBaseTableView.h
//  DotAer
//
//  Created by Kyle on 13-6-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCateTowBaseView.h"
#import "PgLoadingFooterView.h"

@interface HumDotaFavoritBaseTableView : HumDotaCateTowBaseView<UITableViewDataSource,UITableViewDelegate>{
}

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, assign) int nTotalNum;


@end
