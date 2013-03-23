//
//  HumStrategyTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOrgX 10
#define kOrgY 10

#define kTimeWidth 120



#define kTimeHeigh 20


#define kTSGap 5
#define kSTGap 5

@protocol HumStrategyCellDelegate;

@interface HumStrategyTableCell : UITableViewCell

@property (nonatomic, assign) id<HumStrategyCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UILabel *summary;

@end

@protocol HumStrategyCellDelegate <NSObject>

- (void)humNewsCell:(HumStrategyTableCell *)cell didSelectIndex:(NSIndexPath *)index;

@end