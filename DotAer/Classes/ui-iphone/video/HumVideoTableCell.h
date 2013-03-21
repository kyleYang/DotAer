//
//  HumVideoTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

#define kOrgX 10
#define kOrgY 10
#define kTimeWidth 120

#define kCoverWidth 100
#define kCoverHeigh 65

#define kTimeHeigh 20

#define kVTGap 5
#define kVSGap 5
#define kSTGap 5

@protocol HumVideoTableCellDelegate;

@interface HumVideoTableCell : UITableViewCell

@property (nonatomic, assign) id<HumVideoTableCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UILabel *summary;
@property (nonatomic, retain) HumWebImageView *videoCover;

@end

@protocol HumVideoTableCellDelegate <NSObject>

- (void)humVideoCell:(HumVideoTableCell *)cell didSelectIndex:(NSIndexPath *)index;

@end

