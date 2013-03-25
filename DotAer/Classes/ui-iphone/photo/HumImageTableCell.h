//
//  HumImageTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

enum ImagePositon {
    ImagePositonLeft = 100,
    ImagePositonRight = 101,
};

@protocol HumImageTableCellDelegate;
@interface HumImageTableCell : UITableViewCell<humWebImageDelegae>

@property (nonatomic, assign) id<HumImageTableCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) HumWebImageView *leftImage;
@property (nonatomic, retain) HumWebImageView *rightImage;


@end


@protocol HumImageTableCellDelegate <NSObject>

- (void)humVideoCell:(HumImageTableCell *)cell didLeftAtSelectIndex:(NSIndexPath *)index;
- (void)humVideoCell:(HumImageTableCell *)cell didRightAtSelectIndex:(NSIndexPath *)index;

@end
