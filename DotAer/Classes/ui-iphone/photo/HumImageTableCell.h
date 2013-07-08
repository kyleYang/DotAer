//
//  HumImageTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"
#import "Photo.h"

enum ImagePositon {
    ImagePositonLeft = 100,
    ImagePositonRight = 101,
};


#define kMptImageCell_iconPaddingVert 14
#define kMptImageCell_nameHeigh 30
#define kMptImageCell_iconHeith 87
#define kMptImageCell_Heigh 115

@protocol HumDotaImage_ItemView_delegate;

@interface HumDotaImage_ItemView : UIView {
    
@private
    id<HumDotaImage_ItemView_delegate>  _delegate;
    Photo *_imageItem;
    HumWebImageView *_icon;
    
}
@property (nonatomic, assign) id<HumDotaImage_ItemView_delegate> delegate;
@property (nonatomic, retain) HumWebImageView *icon;
@property (nonatomic, retain) Photo *imageItem;
@property (nonatomic, retain) UIButton *favButton;


@end


@protocol HumDotaImage_ItemView_delegate <NSObject>

- (void)humImageItemCell:(HumDotaImage_ItemView *)cell didPlayImage:(Photo *)photo;
- (BOOL)humImageItemCell:(HumDotaImage_ItemView *)cell addFavImage:(Photo *)photo;


@end


@protocol HumImageTableCellDelegate;
@interface HumImageTableCell : UITableViewCell<humWebImageDelegae>

@property (nonatomic, assign) id<HumImageTableCellDelegate> delegate;


-(void)setItemArr:(NSArray*)arr Row:(NSInteger)rowid;
-(NSArray*)getItemViews;

//for calculate the row number and every cell number of item
+(int)rowCntForItemCnt:(int)itemCnt ColumnCnt:(int)columnCnt;

+(int)columnCntForWidth:(float)tableWidth;

+(int)rowIdForIndex:(int)idx ColumnCnt:(int)columnCnt;



@end


@protocol HumImageTableCellDelegate <NSObject>

- (void)humItemCell:(HumImageTableCell *)cell didPlayImage:(Photo *)photo;
- (BOOL)humItemCell:(HumImageTableCell *)cell addFavImage:(Photo *)photo;


@end
