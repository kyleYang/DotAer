//
//  HumVideoTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"
#import "Video.h"

#define kOrgX 10
#define kOrgY 10
#define kTimeWidth 120

#define kCoverWidth 100
#define kCoverHeigh 65

#define kTimeHeigh 30

#define kFavBtnWidth 50
#define kDownBtnWidht 50
#define kFavDownGap 10

#define kMptRecommoCell_iconPaddingVert 5
#define kMptRecommnCell_nameHeigh 30
#define kMptRcommonCell_iconHeith 85

#define kVTGap 5
#define kVSGap 5
#define kSTGap 5

@protocol HumDotaVideo_ItemView_delegate;

@interface HumDotaVideo_ItemView : UIView {
    
@private
    id<HumDotaVideo_ItemView_delegate>  _delegate;
    Video *_videoItem;
    HumWebImageView *_icon;
    UILabel *_name;
    //    BOOL _editing;
    BOOL _bWobbleLeft;
    BOOL _bIsHot;
    BOOL _bIsNew;
    BOOL _bIsLive;
}
@property (nonatomic, assign) id<HumDotaVideo_ItemView_delegate> delegate;
@property (nonatomic, retain) Video *videoItem;
@property (nonatomic, retain) HumWebImageView *icon;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *timeLab;
@property (nonatomic, retain) UIButton *downButton;
@property (nonatomic, retain) UIButton *favButton;


@end


@protocol HumDotaVideo_ItemView_delegate <NSObject>

- (void)humVideoCell:(HumDotaVideo_ItemView *)cell didPlayVideo:(Video *)video;
- (void)humVideoCell:(HumDotaVideo_ItemView *)cell downloadVideo:(Video *)video;
- (BOOL)humVideoCell:(HumDotaVideo_ItemView *)cell addFavVideo:(Video *)video;


@end




@protocol HumVideoTableCellDelegate;

@interface HumVideoTableCell : UITableViewCell

@property (nonatomic, assign) id<HumVideoTableCellDelegate> delegate;

-(void)setItemArr:(NSArray*)arr Row:(NSInteger)rowid;
-(NSArray*)getItemViews;

//for calculate the row number and every cell number of item
+(int)rowCntForItemCnt:(int)itemCnt ColumnCnt:(int)columnCnt;

+(int)columnCntForWidth:(float)tableWidth;

+(int)rowIdForIndex:(int)idx ColumnCnt:(int)columnCnt;


@end

@protocol HumVideoTableCellDelegate <NSObject>

- (void)humVideoCell:(HumVideoTableCell *)cell didPlayVideo:(Video *)video;
- (void)humVideoCell:(HumVideoTableCell *)cell downloadVideo:(Video *)video;
- (BOOL)humVideoCell:(HumVideoTableCell *)cell addFavVideo:(Video *)video;
@end

