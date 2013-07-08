//
//  HumNewsTxtCell.m
//  DotAer
//
//  Created by Kyle on 13-3-3.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumNewsTxtCell.h"
#import "Env.h"

#define kTitleColor [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
#define kTimeColor [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
#define kTypeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]



@implementation HumNewsTxtCell
@synthesize title;
@synthesize timeLeb;
@synthesize contImage;
@synthesize delegate;
@synthesize bgImg;
@synthesize typeImg;
@synthesize favButton;
@synthesize downButton;

- (void)dealloc{
    self.bgImg = nil;
    self.title = nil;
    self.timeLeb = nil;
    self.contImage = nil;
    self.delegate = nil;
    self.favButton = nil;
    self.downButton = nil;
    self.typeImg = nil;
    [super dealloc];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImg = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        self.bgImg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.bgImg.backgroundColor = [UIColor clearColor];
        self.bgImg.image = [[Env sharedEnv] cacheScretchableImage:@"news_cell_bg.png" X:40 Y:20];
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
        self.title.font = kTitleFont
        self.title.numberOfLines = 0;
        self.title.textColor = kTitleColor;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        self.typeImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 23)] autorelease];
        self.typeImg.backgroundColor = [UIColor clearColor];
        [self.title addSubview:self.typeImg];
        
        self.contImage = [[[HumWebImageView alloc] init] autorelease];
        self.contImage.style = HUMWebImageStyleTopCentre;
        [self addSubview:self.contImage];

        
        frame = CGRectMake(CGRectGetWidth(self.bounds) - 2*kOrgX - kTimeWidth, 0, kTimeWidth, 20);
        self.timeLeb = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.timeLeb.textColor = kTimeColor;
        self.timeLeb.backgroundColor = [UIColor clearColor];
        self.timeLeb.font = [UIFont systemFontOfSize:13.0f];
        self.timeLeb.textAlignment = UITextAlignmentRight;
        [self addSubview:self.timeLeb];
        
        
        self.favButton = [[[UIButton alloc] initWithFrame:CGRectMake(10, 2, 22, 20)] autorelease];
        [self.favButton addTarget:self action:@selector(addFavVideo:) forControlEvents:UIControlEventTouchUpInside];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav_did.png"] forState:UIControlStateSelected];
        [self.favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav.png"] forState:UIControlStateNormal];
        [self addSubview:self.favButton];
        
        
        
        self.downButton = [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.favButton.frame)+5, 2, 24, 20)] autorelease];
        [self.downButton addTarget:self action:@selector(downVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.downButton];
        [self.downButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_download.png"] forState:UIControlStateNormal];
        [self.downButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_download_down.png"] forState:UIControlEventTouchDown];
               
    
    }
    return self;
}


- (void)cellSelct:(id)sender{
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(humNewsCell:didSelectIndex:)]) {
        [self.delegate humNewsCell:self didSelectIndex:index];
    }
    
}


- (void)addFavVideo:(id)sender{
    
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(humNewsCell:addFavNewsAtIndex:)]) {
       BOOL value =  [self.delegate humNewsCell:self addFavNewsAtIndex:index];
        if (value) {
            self.favButton.selected = !self.favButton.selected;
        }
    }
    
}

- (void)downVideo:(id)sender{
    
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(humNewsCell:addDownNewsAtIndex:)]) {
        [self.delegate humNewsCell:self addDownNewsAtIndex:index];
    }

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
