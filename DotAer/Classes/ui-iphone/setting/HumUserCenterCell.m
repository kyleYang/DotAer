//
//  HumUserCenterCell.m
//  DotAer
//
//  Created by Kyle on 13-6-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumUserCenterCell.h"
#import "Env.h"

@interface HumUserCenterCell()


@property (nonatomic, retain) UIImageView *iconView;

@end


@implementation HumUserCenterCell
@synthesize cellType = _cellType;
@synthesize titleLabel;
@synthesize detailLabel;
@synthesize iconView;



- (void)dealloc{
    self.titleLabel = nil;
    self.detailLabel = nil;
    self.iconView = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat fontSizeRight = 17.0f;
        self.backgroundView = nil;
        
        self.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.titleLabel.font = [UIFont systemFontOfSize:fontSizeRight];
        self.titleLabel.adjustsFontSizeToFitWidth = NO;
        self.titleLabel.textColor = [UIColor blackColor];
        //    self.lblRight.textColor = RGBA(0xff, 0xcc, 0x2f, 1);
        [self addSubview:self.titleLabel];
        
        self.detailLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.detailLabel.font = [UIFont systemFontOfSize:fontSizeRight];
        self.detailLabel.adjustsFontSizeToFitWidth = NO;
        self.detailLabel.textColor = [UIColor blackColor];
        //    self.lblRight.textColor = RGBA(0xff, 0xcc, 0x2f, 1);
        [self addSubview:self.detailLabel];
        
        self.iconView = [[[UIImageView alloc] initWithImage:[[Env sharedEnv] cacheImage:@"cell_select.png"]] autorelease];\
        self.iconView.hidden = YES;
        [self addSubview:self.iconView];


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellType:(USCellType)cellType{
    if (_cellType == cellType) return;
    _cellType = cellType;
    
}

- (void)setShowIcon:(BOOL)showIcon{
    if (_showIcon == showIcon) return;
    _showIcon = showIcon;
    if(_cellType != USCellTypeSelected)
        return;
    if(_showIcon)
        self.iconView.hidden = NO;
    else
        self.iconView.hidden = YES;
}

- (void)layoutSubviews{
    if (_cellType == USCellTypeLeft) {
        self.titleLabel.frame = self.bounds;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.detailLabel.frame = CGRectZero;
    }else if(_cellType == USCellTypeBoth){
        self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2-10, CGRectGetHeight(self.bounds));
        self.titleLabel.textAlignment = UITextAlignmentRight;
        
        self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
        self.detailLabel.textAlignment = UITextAlignmentLeft;
    }else if(_cellType == USCellTypeSelected){
        self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2-10, CGRectGetHeight(self.bounds));
        self.titleLabel.textAlignment = UITextAlignmentRight;
        
        self.iconView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+40, 0, 60, CGRectGetHeight(self.bounds));
    }

}

@end
