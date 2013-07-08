//
//  HumFeedbackCell.m
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumFeedbackCell.h"
#import "Env.h"

@implementation HumFeedbackCell
@synthesize questSign;
@synthesize questionLb;
@synthesize answerSign;
@synthesize answerLb;
@synthesize userLb;
@synthesize timeLb;
@synthesize userImage;
@synthesize answerImage;
@synthesize adminImage;

- (void)dealloc{
    self.questSign = nil;
    self.questionLb = nil;
    self.answerSign = nil;
    self.answerLb = nil;
    self.userLb = nil;
    self.timeLb = nil;
    self.userImage = nil;
    self.answerImage = nil;
    self.adminImage = nil;
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *bg  = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.image = [[Env sharedEnv] cacheScretchableImage:@"image_Cell_bg.png" X:15 Y:15];
        [self addSubview:bg];
        [bg release];
        
        self.userImage= [[[UIImageView alloc] initWithImage:[[Env sharedEnv] cacheImage:@"feedback_user.png"]] autorelease];
        CGRect frame = self.userImage.frame;
        frame.origin.x = kOrgX;
        frame.origin.y = kOrgY;
        self.userImage.frame = frame;
        [self addSubview:self.userImage];
        
        self.userLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userImage.frame), CGRectGetMinY(self.userImage.frame), 120, kNameHeigh)] autorelease];
        self.userLb.backgroundColor = [UIColor clearColor];
        self.userLb.font = [UIFont systemFontOfSize:13.0f];
        self.userLb.numberOfLines = 0;
        self.userLb.textColor = [UIColor blackColor];
        [self addSubview:self.userLb];
        
        self.timeLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userLb.frame), CGRectGetMinY(self.answerLb.frame), 200, kNameHeigh)] autorelease];
        self.timeLb.backgroundColor = [UIColor clearColor];
        self.timeLb.font = [UIFont systemFontOfSize:13.0f];
        self.timeLb.numberOfLines = 0;
        self.timeLb.textColor = [UIColor blackColor];
        [self addSubview:self.timeLb];

        self.answerImage= [[[UIImageView alloc] initWithImage:[[Env sharedEnv] cacheImage:@"feedback_answer.png"]] autorelease];
        frame = self.answerImage.frame;
        frame.origin.x = kOrgX;
        self.answerImage.frame = frame;

        [self addSubview:self.answerImage];
        
        
        self.questSign = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.answerImage.frame), CGRectGetMinY(self.answerImage.frame), 50, 20)] autorelease];
        self.questSign.backgroundColor = [UIColor clearColor];
        self.questSign.font = [UIFont systemFontOfSize:17.0f];
        self.questSign.textColor = [UIColor blackColor];
        self.questSign.text = NSLocalizedString(@"setting.feeback.question.head", nil);
        [self addSubview:self.questSign];

        
        self.questionLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.questSign.frame), CGRectGetMinY(self.questSign.frame), kWidht, 0)] autorelease];
        self.questionLb.backgroundColor = [UIColor clearColor];
        self.questionLb.font = kQuestFont;
        self.questionLb.numberOfLines = 0;
        self.questionLb.textColor = [UIColor blackColor];
        [self addSubview:self.questionLb];
        
        
        self.adminImage =[[[UIImageView alloc] initWithImage:[[Env sharedEnv] cacheImage:@"feedback_admin.png"]] autorelease];
        frame = self.adminImage.frame;
        frame.origin.x = kOrgX;
        self.adminImage.frame = frame;
        [self addSubview:self.adminImage];
        
        self.answerSign = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.adminImage.frame), kOrgY, 50, 20)] autorelease];
        self.answerSign.backgroundColor = [UIColor clearColor];
        self.answerSign.font = [UIFont systemFontOfSize:17.0f];
        self.answerSign.text = NSLocalizedString(@"setting.feeback.answer.head", nil);
        self.answerSign.textColor = [UIColor blackColor];
        [self addSubview:self.answerSign];
        
        self.answerLb = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.questionLb.frame), CGRectGetMaxY(self.questionLb.frame), CGRectGetWidth(self.questionLb.frame), 0)] autorelease];
        self.answerLb.backgroundColor = [UIColor clearColor];
        self.answerLb.font = kAnswerFont;
        self.answerLb.numberOfLines = 0;
        self.answerLb.textColor = [UIColor blackColor];
        [self addSubview:self.answerLb];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
