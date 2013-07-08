//
//  HumStrategyTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumStrategyTableCell.h"
#import "Env.h"

#define kTitleColor [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
#define kTimeColor [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
#define kTypeColor [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]




@implementation HumStrategyTableCell
@synthesize title;
@synthesize timeLeb;
@synthesize summary;
@synthesize favButton;
@synthesize delegate;

- (void)dealloc{

    self.title = nil;
    self.timeLeb = nil;
    self.favButton = nil;
    self.summary = nil;
    self.delegate = nil;
    [super dealloc];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *bg  = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.image = [[Env sharedEnv] cacheScretchableImage:@"image_Cell_bg.png" X:15 Y:15];
        [self addSubview:bg];
        [bg release];
        
        UIButton *cellSelct = [[UIButton alloc] initWithFrame:self.bounds];
        cellSelct.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [cellSelct setBackgroundImage:[[Env sharedEnv] cacheImage:@"dota_cell_select.png"] forState:UIControlEventTouchDown];
        [cellSelct addTarget:self action:@selector(cellSelct:) forControlEvents:UIControlEventTouchUpInside];
        cellSelct.backgroundColor = [UIColor clearColor];
        [self addSubview:cellSelct];
        [cellSelct release];
        
        CGRect frame = CGRectMake(kOrgX, 14, CGRectGetWidth(self.bounds)-2*10, 0);
        self.title = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.title.font = [UIFont systemFontOfSize:17.0f];
        self.title.numberOfLines = 0;
        self.title.textColor = kTitleColor;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        self.summary = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.title.frame), CGRectGetMaxY(self.title.frame)+kTSGap, CGRectGetWidth(self.bounds)-2*kOrgX , 0)] autorelease];
        self.summary.font = [UIFont systemFontOfSize:13.0f];
        self.summary.numberOfLines = 0;
        self.summary.textColor = kTimeColor;
        self.summary.backgroundColor = [UIColor clearColor];
        [self addSubview:self.summary];
        
        self.favButton = [[[UIButton alloc] initWithFrame:CGRectMake(20, 2, 22, 20)] autorelease];
        [self addSubview:self.favButton];
        [self.favButton addTarget:self action:@selector(addFavVideo:) forControlEvents:UIControlEventTouchUpInside];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav.png"] forState:UIControlStateNormal];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav_did.png"] forState:UIControlStateSelected];
        
        frame = CGRectMake(CGRectGetWidth(self.bounds)-kTimeWidth - 30, 0, kTimeWidth, 20);
        self.timeLeb = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.timeLeb.textColor = kTimeColor;
        self.timeLeb.backgroundColor = [UIColor clearColor];
        self.timeLeb.font = [UIFont systemFontOfSize:13.0f];
        self.timeLeb.textAlignment = UITextAlignmentRight;
        [self addSubview:self.timeLeb];

        
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(humNewsStrategyCell:addFavAtIndex:)]) {
       BOOL value =  [self.delegate humNewsStrategyCell:self addFavAtIndex:index];
        if (value) {
            self.favButton.selected = !self.favButton.selected;
        }
    }
}
@end