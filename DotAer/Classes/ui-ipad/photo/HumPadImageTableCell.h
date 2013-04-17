//
//  HumImageTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

#define kOrgX 13
#define kOrgY 5

#define kGapW 14
#define kWdith 140

enum ImagePadPositon {
    ImagePadPositonLeft = 100,
    ImagePadPositonRight = 101,
};

@protocol HumImagePadTableCellDelegate;
@interface HumPadImageTableCell : UITableViewCell<humWebImageDelegae>

@property (nonatomic, assign) id<HumImagePadTableCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) HumWebImageView *leftImage;
@property (nonatomic, retain) HumWebImageView *rightImage;


@end


@protocol HumImagePadTableCellDelegate <NSObject>

- (void)humVideoCell:(HumPadImageTableCell *)cell didLeftAtSelectIndex:(NSIndexPath *)index;
- (void)humVideoCell:(HumPadImageTableCell *)cell didRightAtSelectIndex:(NSIndexPath *)index;

@end
