//
//  HumImageTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumImageTableCell.h"

#define kOrgX 13
#define kOrgY 10

#define kGapW 14
#define kWdith 140

@implementation HumImageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftImage = [[[HumWebImageView alloc] initWithFrame:CGRectMake(kOrgX, kOrgY, kWdith, CGRectGetHeight(self.bounds)-kOrgY)] autorelease];
        self.leftImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.leftImage.style = HUMWebImageStyleTopCentre;
        self.leftImage.delegate = self;
        self.leftImage.imgTag = ImagePositonLeft;
        [self addSubview:self.leftImage];
        
        self.rightImage = [[[HumWebImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImage.frame)+kGapW,CGRectGetMinY(self.leftImage.frame),CGRectGetWidth(self.leftImage.frame),CGRectGetHeight(self.leftImage.frame))] autorelease];
        self.rightImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.rightImage.style = HUMWebImageStyleTopCentre;
        self.rightImage.delegate = self;
        self.rightImage.imgTag = ImagePositonRight;
        [self addSubview:self.rightImage];
        
        
    }
    return self;
}

- (void)tapDetectingImageView:(HumWebImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint{
    NSIndexPath *index = [(UITableView *)self.superview indexPathForCell:self];
    
    if (view.imgTag == ImagePositonLeft) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didLeftAtSelectIndex:)]) {
            [self.delegate humVideoCell:self didLeftAtSelectIndex:index];
        }
    }else if(view.imgTag == ImagePositonRight){
        if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didRightAtSelectIndex:)]) {
            [self.delegate humVideoCell:self didRightAtSelectIndex:index];
        }
    }

}





@end
