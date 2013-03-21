//
//  HumVideoTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumVideoTableCell.h"
#import "Env.h"

#define kTitleColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kTimeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kTypeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]

@interface HumVideoTableCell()
{
    UIButton *_cellSelct;
}

@end

@implementation HumVideoTableCell

@synthesize delegate;
@synthesize title;
@synthesize timeLeb;
@synthesize summary;
@synthesize videoCover;
@synthesize bgImg;

- (void)dealloc{
    self.bgImg = nil;
    self.delegate = nil;
    self.title = nil;
    self.timeLeb = nil;
    self.summary = nil;
    self.videoCover = nil;
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
        _cellSelct = cellSelct;
        [cellSelct release];
        
        CGRect frame = CGRectMake(kOrgX, kOrgY, kCoverWidth, kCoverHeigh);
        
        self.videoCover = [[[HumWebImageView alloc] initWithFrame:frame] autorelease];
        self.videoCover.style = HUMWebImageStyleTopCentre;
        [self addSubview:self.videoCover];
        
        UIImageView *playMask = [[UIImageView alloc] initWithFrame:self.videoCover.bounds];
        playMask.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        playMask.backgroundColor = [UIColor clearColor];
        playMask.image = [[Env sharedEnv] cacheImage:@"dota_video_play.png"];
        [self.videoCover addSubview:playMask];
        [playMask release];
        
        self.title = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.videoCover.frame)+kVTGap, CGRectGetMinY(self.videoCover.frame), CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.videoCover.frame) - kVTGap-kOrgY, 0)] autorelease];
        self.title.font = [UIFont systemFontOfSize:17.0f];
        self.title.numberOfLines = 0;
        self.title.textColor = kTitleColor;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        self.summary = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.videoCover.frame), CGRectGetMaxY(self.videoCover.frame)+kVSGap, CGRectGetWidth(self.bounds)-2*kOrgX , 0)] autorelease];
        self.summary.font = [UIFont systemFontOfSize:13.0f];
        self.summary.numberOfLines = 0;
        self.summary.textColor = kTimeColor;
        self.summary.backgroundColor = [UIColor clearColor];
        [self addSubview:self.summary];

        
        
        frame = CGRectMake(CGRectGetMinX(self.videoCover.frame),CGRectGetMaxY(self.summary.frame)+kSTGap, CGRectGetWidth(self.summary.frame) , kTimeHeigh);
        self.timeLeb = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.timeLeb.textColor = kTimeColor;
        self.timeLeb.backgroundColor = [UIColor clearColor];
        self.timeLeb.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:self.timeLeb];
        
        
        UIImageView *line =  [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, self.frame.size.width, 2)];
        line.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        line.image = [[Env sharedEnv] cacheImage:@"dota_cell_line.png"];
        [self addSubview:line];
        [line release];
        
       
    }
    return self;
}

- (void)cellSelct:(id)sender{
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didSelectIndex:)]) {
        [self.delegate humVideoCell:self didSelectIndex:index];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
