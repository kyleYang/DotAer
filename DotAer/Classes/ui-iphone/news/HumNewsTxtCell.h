//
//  HumNewsTxtCell.h
//  DotAer
//
//  Created by Kyle on 13-3-3.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

@protocol HumNewsCellDelegate;

@interface HumNewsTxtCell : UITableViewCell

@property (nonatomic, assign) id<HumNewsCellDelegate> delegate;

@property (nonatomic, retain) UIImageView *bgImg;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *timeLeb;
@property (nonatomic, retain) UIImageView *typeImg;
@property (nonatomic, retain) UILabel *typeLeb;
@property (nonatomic, retain) HumWebImageView *contImage;


@end

@protocol HumNewsCellDelegate <NSObject>

- (void)humNewsCell:(HumNewsTxtCell *)cell didSelectIndex:(NSIndexPath *)index;

@end
