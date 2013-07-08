//
//  HumDotaDownloadCell.h
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

#define kedImageOrgX 10
#define kedImageOrgy 10
#define kedImageWidth 70
#define kedImageHeigh 45

#define kedImgTiteGap 15
#define kedTitleWidth 220
#define kedTitleHeigh 35

#define kedTitTypeGap 15
#define kedTypeWidth 40
#define kedTypeHeigh 20

#define kedSizeWidth 150

#define kedPrecentWidht 20

#define kedStopeBtnOrgX 10
#define kedStopeBtnWidht 80
#define kedStopBtnHeigh 80

@protocol HumDotaDownloadCellDelegate;

@interface HumDotaDownloadCell : UITableViewCell


@property (nonatomic, assign) id<HumDotaDownloadCellDelegate> delegate;
@property (nonatomic, retain) HumWebImageView *imgLog;
@property (nonatomic, retain) UILabel *titel;
@property (nonatomic, retain) UILabel *sceenType;
@property (nonatomic, retain) UILabel *precent;
@property (nonatomic, retain) UIButton *stopBtn;


@end


@protocol HumDotaDownloadCellDelegate <NSObject>

- (void)HumDotaDownloadCell:(HumDotaDownloadCell *)cell didSelectAtIndex:(NSIndexPath *)path;

@end
