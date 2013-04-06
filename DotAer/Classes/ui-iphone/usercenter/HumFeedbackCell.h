//
//  HumFeedbackCell.h
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOrgX 10
#define kOrgY 5

#define kWidht 250

#define kNameHeigh 20

#define kQAGap 5
#define kAUGap 5

#define kQuestFont [UIFont systemFontOfSize:15.0f]
#define kAnswerFont [UIFont systemFontOfSize:14.0f]

@interface HumFeedbackCell : UITableViewCell

@property (nonatomic, retain) UILabel *questSign;
@property (nonatomic, retain) UILabel *questionLb;
@property (nonatomic, retain) UILabel *answerSign;
@property (nonatomic, retain) UILabel *answerLb;
@property (nonatomic, retain) UILabel *userLb;
@property (nonatomic, retain) UILabel *timeLb;

@end
