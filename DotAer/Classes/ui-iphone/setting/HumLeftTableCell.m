//
//  HumLeftTableCell.m
//  DotAer
//
//  Created by Kyle on 13-6-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumLeftTableCell.h"
#import "Env.h"

@interface HumLeftTableCell()

@property (nonatomic, retain, readwrite) UIImageView *logoImage;
@property (nonatomic, retain, readwrite) UILabel *nameLabel;

@end

@implementation HumLeftTableCell
@synthesize nameLabel;
@synthesize logoImage;

-(void)dealloc{
    self.nameLabel = nil;
    self.logoImage = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (nil == self) return nil;
    
    
    // create subview
    float fontSizeRight = 18;
    
    // create subviews
    self.logoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 40, CGRectGetHeight(self.bounds))] autorelease];
    self.logoImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.logoImage];
    
    //    self.lblLeft.textColor = [UIColor whiteColor];//RGBA(0x9e, 0x9e, 0x9e, 1);
      
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImage.frame)+5, 0, CGRectGetWidth(self.bounds)-CGRectGetMaxX(self.logoImage.frame)-5, CGRectGetHeight(self.bounds))] autorelease];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:fontSizeRight];
    self.nameLabel.adjustsFontSizeToFitWidth = NO;
    self.nameLabel.textColor = [UIColor whiteColor];
    //    self.lblRight.textColor = RGBA(0xff, 0xcc, 0x2f, 1);
    [self addSubview:self.nameLabel];
    
      
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


@end
