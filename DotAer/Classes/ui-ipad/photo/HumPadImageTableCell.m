//
//  HumImageTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumPadImageTableCell.h"



@implementation HumPadImageTableCell
@synthesize bgImg;
@synthesize leftImage;
@synthesize rightImage;

- (void)dealloc{
    self.bgImg = nil;
    self.leftImage = nil;
    self.rightImage = nil;
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
        
        self.leftImage = [[[HumWebImageView alloc] initWithFrame:CGRectMake(kOrgX, kOrgY, (CGRectGetWidth(self.bounds)-3*kOrgX)/2, CGRectGetHeight(self.bounds)-2*kOrgY)] autorelease];
//        self.leftImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.leftImage.style = HUMWebImageStyleTopCentre;
        self.leftImage.imgDelegate = self;
        self.leftImage.imgTag = ImagePadPositonLeft;
        [self addSubview:self.leftImage];
        
        self.rightImage = [[[HumWebImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImage.frame)+kOrgX,CGRectGetMinY(self.leftImage.frame),CGRectGetWidth(self.leftImage.frame),CGRectGetHeight(self.leftImage.frame))] autorelease];
//        self.rightImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.rightImage.style = HUMWebImageStyleTopCentre;
        self.rightImage.imgDelegate = self;
        self.rightImage.imgTag = ImagePadPositonRight;
        [self addSubview:self.rightImage];
        
        
    }
    return self;
}


- (void)photoViewDidSingleTap:(HumWebImageView *)photoView{
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    if (photoView.imgTag == ImagePadPositonLeft) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didLeftAtSelectIndex:)]) {
            [self.delegate humVideoCell:self didLeftAtSelectIndex:index];
        }
    }else if(photoView.imgTag == ImagePadPositonRight){
        if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didRightAtSelectIndex:)]) {
            [self.delegate humVideoCell:self didRightAtSelectIndex:index];
        }
    }

}


@end
