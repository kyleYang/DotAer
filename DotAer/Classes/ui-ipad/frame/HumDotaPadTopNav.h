//
//  HumDotaTopNav.h
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumDotaPadTopNavDelegate;

@interface HumDotaPadTopNav : UIView

@property (nonatomic, assign) id<HumDotaPadTopNavDelegate>delegate;

@property (nonatomic, retain) UIImageView *ivLeft;
@property (nonatomic, retain) UIButton *btnLeft;
@property (nonatomic, retain) UIImageView *ivRight;
@property (nonatomic, retain) UIButton *btnRight;
@property (nonatomic, retain) UILabel *lblTitle;

-(void)setTitle:(NSString*)title Show:(BOOL)value;

@end



@protocol HumDotaPadTopNavDelegate <NSObject>

- (void)HumDotaTopNav:(HumDotaPadTopNav *)topNav didClickLeft:(id)sender;
- (void)HumDotaTopNav:(HumDotaPadTopNav *)topNav didClickRight:(id)sender;


@end
