//
//  NGSpeedUpView.m
//  NGMoviePlayer
//
//  Created by Kyle on 13-6-30.
//  Copyright (c) 2013年 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGSpeedUpView.h"

@interface NGSpeedUpView()

@property (nonatomic, strong) UIImageView *imageIcon;

@end


@implementation NGSpeedUpView
@synthesize speedUp = _speedUp;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.imageIcon];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:20.0f];
        self.timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.timeLabel];
        

        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageIcon.frame = CGRectMake(10, 18, 60, 45);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.imageIcon.frame)+30, CGRectGetMinY(self.imageIcon.frame), CGRectGetWidth(self.bounds)-CGRectGetMaxX(self.imageIcon.frame)-40, CGRectGetHeight(self.imageIcon.frame));
    
}

- (void)setSpeedUp:(BOOL)speedUp{
    if (speedUp) {
        self.imageIcon.image =  [UIImage imageNamed:@"NGMoviePlayer.bundle/forward"];
    }else{
        self.imageIcon.image =  [UIImage imageNamed:@"NGMoviePlayer.bundle/rewind"];
    }
}

@end
