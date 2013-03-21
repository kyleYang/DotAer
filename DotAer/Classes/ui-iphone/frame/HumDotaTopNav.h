//
//  HumDotaTopNav.h
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumDotaTopNavDelegate;

@interface HumDotaTopNav : UIView

@property (nonatomic, assign) id<HumDotaTopNavDelegate>delegate;

-(void)setTitle:(NSString*)title Show:(BOOL)value;

@end



@protocol HumDotaTopNavDelegate <NSObject>

- (void)HumDotaTopNav:(HumDotaTopNav *)topNav didClickLeft:(id)sender;
- (void)HumDotaTopNav:(HumDotaTopNav *)topNav didClickRight:(id)sender;


@end
