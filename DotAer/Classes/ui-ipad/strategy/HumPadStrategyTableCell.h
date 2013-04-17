//
//  HumStrategyTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOrgX 20
#define kOrgY 15

#define kTimeWidth 120
#define kTimeHeigh 20

#define kTSGap 10
#define kSTGap 10

#define kTitleFont [UIFont systemFontOfSize:20.0f]
#define kSummaryFont [UIFont systemFontOfSize:17.0f]

@protocol HumPadStrategyCellDelegate;

@interface HumPadStrategyTableCell : UITableViewCell

@property (nonatomic, assign) id<HumPadStrategyCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UILabel *summary;

@end

@protocol HumPadStrategyCellDelegate <NSObject>

- (void)humNewsCell:(HumPadStrategyTableCell *)cell didSelectIndex:(NSIndexPath *)index;

@end