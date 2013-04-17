//
//  HumNewsTxtCell.h
//  DotAer
//
//  Created by Kyle on 13-3-3.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"


#define kOrgX 30
#define kOrgY 25


#define kTimeWidth 200

#define kTimeHeigh 30

#define kTxtCellImageWidth 420
#define kTxtCellImageHeigh 200

#define kTIGap 8
#define kTTGap 8
#define kITGap 8

#define kTitleFont [UIFont systemFontOfSize:18.0f]

@protocol HumPadNewsCellDelegate;

@interface HumPadNewsTxtCell : UITableViewCell

@property (nonatomic, assign) id<HumPadNewsCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UIImageView *typeImg;
@property (nonatomic, retain) UILabel *typeLeb;
@property (nonatomic, retain) HumWebImageView *contImage;


@end

@protocol HumPadNewsCellDelegate <NSObject>

- (void)humNewsCell:(HumPadNewsTxtCell *)cell didSelectIndex:(NSIndexPath *)index;

@end
