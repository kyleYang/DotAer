//
//  HumDotaSimuTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSimuTableCell.h"
#import "Env.h"

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
        
        UIImageView *bgView  = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bgView.image = [[Env sharedEnv] cacheScretchableImage:@"image_Cell_bg.png" X:15 Y:15];
        [self addSubview:bgView];
        [bgView release];

        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(15, 10, kSillIntoWidht, kBgHeigh)];
        bg.backgroundColor = [UIColor clearColor];
        [self addSubview:bg];
        [bg release];
        
        self.skillImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, kBgHeigh)] autorelease];
        [bg addSubview:self.skillImg];
        
        self.skillName = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.skillImg.frame)+10, 0, kSillNameWidth, CGRectGetHeight(bg.frame))] autorelease];
        self.skillName.font = kNameFont;
        self.skillName.lineBreakMode = UILineBreakModeWordWrap;
        self.skillName.numberOfLines = 0;
        self.skillName.textColor = [UIColor blackColor];
        self.skillName.backgroundColor = [UIColor clearColor];
        [bg addSubview:self.skillName];
        
        self.skillIntro = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bg.frame), CGRectGetMaxY(bg.frame)+5, CGRectGetWidth(bg.frame), CGRectGetHeight(bg.frame))] autorelease];
        self.skillIntro.lineBreakMode = UILineBreakModeWordWrap;
        self.skillIntro.numberOfLines = 0;
        self.skillIntro.backgroundColor = [UIColor clearColor];
        self.skillIntro.font = kIntroFont;
        self.skillIntro.textColor = [UIColor blackColor];
        [self addSubview:self.skillIntro];
        
        self.skillNote = [[[UILabel alloc] initWithFrame:bg.frame] autorelease];
        self.skillNote.font = kNoteFont;
        self.skillNote.lineBreakMode = UILineBreakModeWordWrap;
        self.skillNote.numberOfLines = 0;
        self.skillNote.backgroundColor = [UIColor clearColor];
        self.skillNote.textColor = [UIColor blackColor];
        [self addSubview:self.skillNote];
        
        
        self.skillLev1 = [[[UILabel alloc] initWithFrame:bg.frame] autorelease];
        self.skillLev1.font = kLevel1Font;
        self.skillLev1.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev1.numberOfLines = 0;
        self.skillLev1.backgroundColor = [UIColor clearColor];
        self.skillLev1.textColor = [UIColor blackColor];
        [self addSubview:self.skillLev1];
        
        self.skillLev2 = [[[UILabel alloc] initWithFrame:bg.frame] autorelease];
        self.skillLev2.font = kLevel2Font;
        self.skillLev2.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev2.numberOfLines = 0;
        self.skillLev2.backgroundColor = [UIColor clearColor];
        self.skillLev2.textColor = [UIColor blackColor];
        [self addSubview:self.skillLev2];
        
        self.skillLev3 = [[[UILabel alloc] initWithFrame:bg.frame] autorelease];
        self.skillLev3.font = kLevel3Font;
        self.skillLev3.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev3.numberOfLines = 0;
        self.skillLev3.backgroundColor = [UIColor clearColor];
        self.skillLev3.textColor = [UIColor blackColor];
        [self addSubview:self.skillLev3];
        
        self.skillLev4 = [[[UILabel alloc] initWithFrame:bg.frame] autorelease];
        self.skillLev4.font = kLevel4Font;
        self.skillLev4.lineBreakMode = UILineBreakModeWordWrap;
        self.skillLev4.numberOfLines = 0;
        self.skillLev4.backgroundColor = [UIColor clearColor];
        self.skillLev4.textColor = [UIColor blackColor];
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
