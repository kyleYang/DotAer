//
//  HumDotaSimuTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSimuTableCell.h"

@implementation HumDotaSimuTableCell

@synthesize skillImg;
@synthesize skillName;
@synthesize skillIntro;
@synthesize skillNote;
@synthesize skillLev1;
@synthesize skillLev2;
@synthesize skillLev3;
@synthesize skillLev4;


- (void)dealloc{
    self.skillImg = nil;
    self.skillName = nil;
    self.skillIntro = nil;
    self.skillNote = nil;
    self.skillLev1 = nil;
    self.skillLev2 = nil;
    self.skillLev3 = nil;
    self.skillLev4 = nil;
    
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.skillImg = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)] autorelease];
        [self addSubview:self.skillImg];
        
        self.skillName = [[[UILabel alloc] initWithFrame:CGRectMake(60, 0, kSillWidth, 20)] autorelease];
        self.skillName.font = kNameFont;
        self.skillName.lineBreakMode = UILineBreakModeWordWrap;
        self.skillName.numberOfLines = 0;
        self.skillName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.skillName];
        
        self.skillIntro = [[[UILabel alloc] initWithFrame:self.skillName.frame] autorelease];
        self.skillIntro.lineBreakMode = UILineBreakModeWordWrap;
        self.skillIntro.numberOfLines = 0;
        self.skillIntro.backgroundColor = [UIColor clearColor];
        self.skillIntro.font = kIntroFont;
        
        [self addSubview:self.skillIntro];
        
        self.skillNote = [[[UILabel alloc] initWithFrame:self.skillName.frame] autorelease];
        self.skillNote.font = kNoteFont;
        self.skillNote.lineBreakMode = UILineBreakModeWordWrap;
        self.skillNote.numberOfLines = 0;
        self.skillNote.backgroundColor = [UIColor clearColor];
        [self addSubview:self.skillNote];
        
        
        self.skillLev1 = [[[UILabel alloc] initWithFrame:self.skillName.frame] autorelease];
        self.skillLev1.font = kLevel1Font;
        self.skillLev1.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev1.numberOfLines = 0;
        self.skillLev1.backgroundColor = [UIColor clearColor];
        [self addSubview:self.skillLev1];
        
        self.skillLev2 = [[[UILabel alloc] initWithFrame:self.skillName.frame] autorelease];
        self.skillLev2.font = kLevel2Font;
        self.skillLev2.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev2.numberOfLines = 0;
        self.skillLev2.backgroundColor = [UIColor clearColor];
        [self addSubview:self.skillLev2];
        
        self.skillLev3 = [[[UILabel alloc] initWithFrame:self.skillName.frame] autorelease];
        self.skillLev3.font = kLevel3Font;
        self.skillLev3.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev3.numberOfLines = 0;
        self.skillLev3.backgroundColor = [UIColor clearColor];
        [self addSubview:self.skillLev3];
        
        self.skillLev4 = [[[UILabel alloc] initWithFrame:self.skillName.frame] autorelease];
        self.skillLev4.font = kLevel4Font;
        self.skillLev4.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev4.numberOfLines = 0;
        self.skillLev4.backgroundColor = [UIColor clearColor];
        [self addSubview:self.skillLev4];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
