//
//  HumDotaDownloadingCell.h
//  DotAer
//
//  Created by Kyle on 13-5-31.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

#define kImageOrgX 10
#define kImageOrgy 20
#define kImageWidth 70
#define kImageHeigh 45

#define kImgTiteGap 15
#define kTitleWidth 220
#define kTitleHeigh 30

#define kTitTypeGap 12
#define kTypeWidth 40
#define kTypeHeigh 14

#define kPrecentWidht 80

#define kStopeBtnOrgX 15
#define kStopeBtnWidht 60
#define kStopBtnHeigh 40

@protocol HumDotaDownloadingCellDelegate;

typedef enum {
    
    VideoButtonStope = 0,
    VideoButtonResum = 1
    
}VideoButtonState;

typedef VideoButtonState ButtonState;

@interface HumDotaDownloadingCell : UITableViewCell
@property (nonatomic, assign) id<HumDotaDownloadingCellDelegate> delegate;
@property (nonatomic, assign) ButtonState buttonState;
@property (nonatomic, retain) HumWebImageView *imgLog;
@property (nonatomic, retain) UILabel *titel;
@property (nonatomic, retain) UILabel *sceenType;
@property (nonatomic, retain) UILabel *precent;
@property (nonatomic, retain) UIProgressView *progress;
@property (nonatomic, retain) UIButton *stopBtn;

@end


@protocol HumDotaDownloadingCellDelegate <NSObject>

- (void)HumDotaDownloadingCell:(HumDotaDownloadingCell *)cell didCilicType:(ButtonState)state atIndex:(NSIndexPath *)path;

@end