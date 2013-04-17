//
//  HumVideoTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

#define kOrgX 15
#define kOrgY 15
#define kTimeWidth 120

#define kCoverWidth 200
#define kCoverHeigh 130

#define kTimeHeigh 30

#define kVTGap 8
#define kVSGap 8
#define kSTGap 8

#define kTitleFont [UIFont systemFontOfSize:19.0f]
#define kSumaryFont [UIFont systemFontOfSize:15.0f]

@protocol HumVideoPadTableCellDelegate;

@interface HumVideoPadTableCell : UITableViewCell

@property (nonatomic, assign) id<HumVideoPadTableCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UILabel *summary;
@property (nonatomic, retain) HumWebImageView *videoCover;

@end

@protocol HumVideoPadTableCellDelegate <NSObject>

- (void)humVideoCell:(HumVideoPadTableCell *)cell didSelectIndex:(NSIndexPath *)index;

@end

