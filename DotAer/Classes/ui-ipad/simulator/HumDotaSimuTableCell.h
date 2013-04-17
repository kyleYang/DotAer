//
//  HumDotaSimuTableCell.h
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HumDotaSimuTableCell : UITableViewCell

#define kSillWidth 250
#define kNameFont [UIFont systemFontOfSize:17.0f]
#define kIntroFont [UIFont systemFontOfSize:16.0f]
#define kNoteFont [UIFont systemFontOfSize:14.0f]
#define kLevel1Font [UIFont systemFontOfSize:14.0f]
#define kLevel2Font [UIFont systemFontOfSize:14.0f]
#define kLevel3Font [UIFont systemFontOfSize:14.0f]
#define kLevel4Font [UIFont systemFontOfSize:14.0f]


@property (nonatomic, retain) UIImageView *skillImg;
@property (nonatomic, retain) UILabel *skillName;
@property (nonatomic, retain) UILabel *skillIntro;
@property (nonatomic, retain) UILabel *skillNote;
@property (nonatomic, retain) UILabel *skillLev1;
@property (nonatomic, retain) UILabel *skillLev2;
@property (nonatomic, retain) UILabel *skillLev3;
@property (nonatomic, retain) UILabel *skillLev4;

@end
