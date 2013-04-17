//
//  HumNewsTxtCell.m
//  DotAer
//
//  Created by Kyle on 13-3-3.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumPadNewsTxtCell.h"
#import "Env.h"

#define kTitleColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kTimeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kTypeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]



@implementation HumPadNewsTxtCell
@synthesize title;
@synthesize timeLeb;
@synthesize typeImg;
@synthesize typeLeb;
@synthesize contImage;
@synthesize delegate;
@synthesize bgImg;

- (void)dealloc{
    self.bgImg = nil;
    self.title = nil;
    self.timeLeb = nil;
    self.typeImg = nil;
    self.typeLeb = nil;
    self.contImage = nil;
    self.delegate = nil;
    [super dealloc];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImg = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        self.bgImg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.bgImg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgImg];
        
        UIButton *cellSelct = [[UIButton alloc] initWithFrame:self.bounds];
        cellSelct.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [cellSelct setBackgroundImage:[[Env sharedEnv] cacheImage:@"dota_cell_select.png"] forState:UIControlEventTouchDown];
        [cellSelct addTarget:self action:@selector(cellSelct:) forControlEvents:UIControlEventTouchUpInside];
        cellSelct.backgroundColor = [UIColor clearColor];
        [self addSubview:cellSelct];
        [cellSelct release];
        
        CGRect frame = CGRectMake(kOrgX, 10, CGRectGetWidth(self.bounds)-2*kOrgX, 0);
        self.title = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.title.font = kTitleFont;
        self.title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.title.numberOfLines = 0;
        self.title.textColor = kTitleColor;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        frame = CGRectMake(CGRectGetWidth(self.bounds) - 2*kOrgX - kTimeWidth, 0, kTimeWidth, kTimeHeigh);
        self.timeLeb = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.timeLeb.textColor = kTimeColor;
        self.timeLeb.backgroundColor = [UIColor clearColor];
        self.timeLeb.font = [UIFont systemFontOfSize:16.0f];
        self.timeLeb.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.timeLeb.textAlignment = UITextAlignmentRight;
        [self addSubview:self.timeLeb];
        
        frame = CGRectMake(CGRectGetMinX(self.title.frame), 0, 25, 25);
        self.typeImg = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        [self addSubview:self.typeImg];
        
        frame = CGRectMake(CGRectGetMaxX(self.typeImg.frame)+3, CGRectGetMinY(self.typeImg.frame), 120, kTimeHeigh);
        self.typeLeb = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.typeLeb.textColor = kTypeColor;
        self.typeLeb.backgroundColor = [UIColor clearColor];
        self.typeLeb.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.typeLeb];
        
        self.contImage = [[[HumWebImageView alloc] init] autorelease];
        self.contImage.style = HUMWebImageStyleTopCentre;
        [self addSubview:self.contImage];
        
        
        UIImageView *line =  [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, self.frame.size.width, 2)];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        line.image = [[Env sharedEnv] cacheImage:@"dota_cell_line.png"];
        [self addSubview:line];
        [line release];

    }
    return self;
}


- (void)cellSelct:(id)sender{
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(humNewsCell:didSelectIndex:)]) {
        [self.delegate humNewsCell:self didSelectIndex:index];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
