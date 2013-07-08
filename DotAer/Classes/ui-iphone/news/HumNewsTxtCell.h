//
//  HumNewsTxtCell.h
//  DotAer
//
//  Created by Kyle on 13-3-3.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

#define kOrgX 14
#define kTimeWidth 120

#define kTxtCellImageWidth 70
#define kTxtCellImageHeigh 50

#define kTitleFont [UIFont boldSystemFontOfSize:17.0f];

@protocol HumNewsCellDelegate;

@interface HumNewsTxtCell : UITableViewCell

@property (nonatomic, assign) id<HumNewsCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UIImageView *typeImg;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UIButton *favButton;
@property (nonatomic, retain) UIButton *downButton;
@property (nonatomic, retain) HumWebImageView *contImage;


@end

@protocol HumNewsCellDelegate <NSObject>

- (void)humNewsCell:(HumNewsTxtCell *)cell didSelectIndex:(NSIndexPath *)index;
- (BOOL)humNewsCell:(HumNewsTxtCell *)cell addFavNewsAtIndex:(NSIndexPath *)index;
- (void)humNewsCell:(HumNewsTxtCell *)cell addDownNewsAtIndex:(NSIndexPath *)index;


@end
