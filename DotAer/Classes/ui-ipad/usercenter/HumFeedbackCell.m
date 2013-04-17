//
//  HumFeedbackCell.m
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumFeedbackCell.h"

@implementation HumFeedbackCell
@synthesize questSign;
@synthesize questionLb;
@synthesize answerSign;
@synthesize answerLb;
@synthesize userLb;
@synthesize timeLb;

- (void)dealloc{
    self.questSign = nil;
    self.questionLb = nil;
    self.answerSign = nil;
    self.answerLb = nil;
    self.userLb = nil;
    self.timeLb = nil;
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.questSign = [[[UILabel alloc] initWithFrame:CGRectMake(kOrgX, kOrgY, 50, 20)] autorelease];
        self.questSign.backgroundColor = [UIColor clearColor];
        self.questSign.font = [UIFont systemFontOfSize:17.0f];
        self.questSign.textColor = [UIColor whiteColor];
        self.questSign.text = NSLocalizedString(@"setting.feeback.question.head", nil);
        [self addSubview:self.questSign];

        
        self.questionLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.questSign.frame), CGRectGetMinY(self.questSign.frame), kWidht, 0)] autorelease];
        self.questionLb.backgroundColor = [UIColor clearColor];
        self.questionLb.font = kQuestFont;
        self.questionLb.numberOfLines = 0;
        self.questionLb.textColor = [UIColor whiteColor];
        [self addSubview:self.questionLb];
        
        self.answerSign = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.questSign.frame), kOrgY, 50, 20)] autorelease];
        self.answerSign.backgroundColor = [UIColor clearColor];
        self.answerSign.font = [UIFont systemFontOfSize:17.0f];
        self.answerSign.text = NSLocalizedString(@"setting.feeback.answer.head", nil);
        self.answerSign.textColor = [UIColor whiteColor];
        [self addSubview:self.answerSign];
        
        self.answerLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.questionLb.frame), CGRectGetMaxY(self.questionLb.frame), CGRectGetWidth(self.questionLb.frame), 0)] autorelease];
        self.answerLb.backgroundColor = [UIColor clearColor];
        self.answerLb.font = kAnswerFont;
        self.answerLb.numberOfLines = 0;
        self.answerLb.textColor = [UIColor whiteColor];
        [self addSubview:self.answerLb];
        
        self.userLb = [[[UILabel alloc] initWithFrame:CGRectMake(kOrgX, CGRectGetMaxY(self.answerLb.frame), 140, kNameHeigh)] autorelease];
        self.userLb.backgroundColor = [UIColor clearColor];
        self.userLb.font = [UIFont systemFontOfSize:13.0f];
        self.userLb.numberOfLines = 0;
        self.userLb.textColor = [UIColor whiteColor];
        [self addSubview:self.userLb];
        
        self.timeLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userLb.frame), CGRectGetMinY(self.answerLb.frame), 200, kNameHeigh)] autorelease];
        self.timeLb.backgroundColor = [UIColor clearColor];
        self.timeLb.font = [UIFont systemFontOfSize:13.0f];
        self.timeLb.numberOfLines = 0;
        self.timeLb.textColor = [UIColor whiteColor];
        [self addSubview:self.timeLb];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
