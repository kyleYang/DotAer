//
//  HumShopCell.m
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumShopCell.h"

@implementation HumShopCell

@synthesize delegate;
@synthesize cellTag;
@synthesize logo;
@synthesize title;

- (void)dealloc{
    self.delegate = nil;
    self.logo = nil;
    self.title = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        button.backgroundColor = [UIColor clearColor];
        [self addSubview:button];
        [button release];
        
        self.logo = [[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-kLogoWidth)/2, 5, kLogoWidth, kLogoHeigh)] autorelease];
//        self.logo.userInteractionEnabled = YES;
        [self addSubview:self.logo];
        
        self.title = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logo.frame)+5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-kLogoHeigh-20)] autorelease];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = UITextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:14.0f];
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        
    }
    return self;
}


- (void)buttonTouch:(id)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(HumShopCellDidClick:)]){
        [self.delegate HumShopCellDidClick:self];
    }
    
}

@end
