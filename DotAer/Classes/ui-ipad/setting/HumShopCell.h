//
//  HumShopCell.h
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumShopCellDelegate;

#define kLogoWidth 50
#define kLogoHeigh 50

@interface HumShopCell : UIView

@property (nonatomic, assign) NSUInteger cellTag;
@property (nonatomic, assign) id<HumShopCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *logo;
@property (nonatomic, retain) UILabel *title;

@end



@protocol HumShopCellDelegate <NSObject>

- (void)HumShopCellDidClick:(HumShopCell *)cell;

@end
