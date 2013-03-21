//
//  HumDotaTopNav.m
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaTopNav.h"
#import "Env.h"
#import "BqsUtils.h"

@interface HumDotaTopNav()
@property (nonatomic, retain) UIImageView *bgImage;
@property (nonatomic, retain) UIImageView *ivLeft;
@property (nonatomic, retain) UIButton *btnLeft;
@property (nonatomic, retain) UIImageView *ivRight;
@property (nonatomic, retain) UIButton *btnRight;
@property (nonatomic, retain) UILabel *lblTitle;


-(void)onClickBtnLeft:(id)sender;
-(void)onClickBtnControl:(id)sender;

@end


@implementation HumDotaTopNav
@synthesize delegate;
@synthesize bgImage;
@synthesize ivLeft,btnLeft;
@synthesize ivRight,btnRight;
@synthesize lblTitle;

- (void)dealloc{
    self.delegate = nil;
    self.bgImage = nil;
    self.ivLeft = nil;
    self.btnLeft = nil;
    self.ivRight = nil;
    self.btnRight = nil;
    self.lblTitle = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         Env *env = [Env sharedEnv];
    
        // background imageview
        self.bgImage = [[[UIImageView alloc] initWithFrame: self.bounds] autorelease];
        self.bgImage.image = [env cacheImage:@"dota_frame_title_bg.jpg"];
        self.bgImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.bgImage];
        
        
        // left button
        self.ivLeft = [[[UIImageView alloc] initWithImage:[env cacheImage:@"dota_frame_setting.png"]] autorelease];
        [self addSubview:self.ivLeft];
        
        self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnLeft.showsTouchWhenHighlighted = YES;
        self.btnLeft.backgroundColor = [UIColor clearColor];
        [self.btnLeft addTarget:self action:@selector(onClickBtnLeft:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnLeft];
        
        // right button
        self.ivRight = [[[UIImageView alloc] initWithImage:[env cacheImage:@"dota_frame_control.png"]] autorelease];
        [self addSubview:self.ivRight];
        
        self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnRight.showsTouchWhenHighlighted = YES;
        self.btnRight.backgroundColor = [UIColor clearColor];
        [self.btnRight addTarget:self action:@selector(onClickBtnRight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnRight];
        
        // navigation title
        self.lblTitle = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.lblTitle.font = [UIFont boldSystemFontOfSize:22];
        self.lblTitle.textColor = RGBA(0xff, 0xff, 0xff, 1);
        self.lblTitle.backgroundColor = [UIColor clearColor];
        self.lblTitle.adjustsFontSizeToFitWidth = NO;
        self.lblTitle.hidden = YES;
        [self addSubview:self.lblTitle];

        

    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [super layoutSubviews];
    
    float kPaddingHori = 12;
    float kGapHori = 10;
    
    float centerY = 20;
    float contentH = 44;
    
    self.ivLeft.center = CGPointMake(kPaddingHori + CGRectGetMidX(self.ivLeft.bounds), centerY);
    self.btnLeft.frame = CGRectInset(self.ivLeft.frame, -kPaddingHori, CGRectGetHeight(self.ivLeft.frame)-contentH);
    
    self.ivRight.center = CGPointMake(CGRectGetMaxX(self.bounds) - kPaddingHori - CGRectGetMidX(self.ivRight.bounds), centerY);
    self.btnRight.frame = CGRectInset(self.ivRight.frame, -kPaddingHori, CGRectGetHeight(self.ivRight.frame)-contentH);
    
    float centerW = CGRectGetMinX(self.ivRight.frame) - CGRectGetMaxX(self.ivLeft.frame) - 2 * kGapHori;
    
    CGSize szTitle = [self.lblTitle.text sizeWithFont:self.lblTitle.font];
    if(szTitle.width > centerW) {
        szTitle.width = centerW;
    }
    
    self.lblTitle.frame = CGRectMake(floor(CGRectGetMidX(self.bounds) - szTitle.width/2.0), floor(centerY - szTitle.height/2.0), szTitle.width, szTitle.height);
    
}


#pragma mark 
#pragma mark private method

-(void)onClickBtnLeft:(id)sender{
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(HumDotaTopNav:didClickLeft:)]) {
        [self.delegate HumDotaTopNav:self didClickLeft:sender];
    }
}

-(void)onClickBtnRight:(id)sender{
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(HumDotaTopNav:didClickRight:)]) {
        [self.delegate HumDotaTopNav:self didClickRight:sender];
    }
}

#pragma mark
#pragma mark user interface method
#pragma mark - ifc methods
-(void)setTitle:(NSString*)title Show:(BOOL)value {
    self.lblTitle.text = title;
    self.lblTitle.hidden = !value;
    [self setNeedsLayout];
}

-(void)replaceLeftButtonWith:(UIImage*)v {
    if (v == nil) {
        self.ivLeft.hidden = YES;
        self.btnLeft.hidden = YES;
        return;
    }
    self.ivLeft.image = v;
       
    [self setNeedsLayout];
    
}

-(void)replaceRightButtonWith:(UIImage*)v {
    if (v == nil) {
        self.ivRight.hidden = YES;
        self.btnRight.hidden = YES;
        return;
    }
    self.ivRight.image = v;
    [self setNeedsLayout];

}






@end
