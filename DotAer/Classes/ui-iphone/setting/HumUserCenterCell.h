//
//  HumUserCenterCell.h
//  DotAer
//
//  Created by Kyle on 13-6-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, USCellType) {
    USCellTypeNone = 0,
    USCellTypeLeft = 1,
    USCellTypeRight = 2,
    USCellTypeBoth = 3,
    USCellTypeSelected = 4,
};


@interface HumUserCenterCell : UITableViewCell{
    USCellType _cellType;
    BOOL _showIcon;
}

@property (nonatomic, assign) BOOL showIcon;
@property (nonatomic, assign) USCellType cellType;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *detailLabel;

@end
