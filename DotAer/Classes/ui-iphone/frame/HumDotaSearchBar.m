//
//  HumDotaSearchBar.m
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSearchBar.h"
#import "Env.h"

@implementation HumDotaSearchBar

- (void)layoutSubviews {
	UITextField *searchField = nil;
	NSUInteger numViews = [self.subviews count];
	for(int i = 0; i < numViews; i++) {
        UIView *subview = [self.subviews objectAtIndex:i];
		if([subview isKindOfClass:[UITextField class]]) { //conform?
			searchField = [self.subviews objectAtIndex:i];
		}else if([subview isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)subview;
            [btn setBackgroundImage:[[Env sharedEnv] cacheImage:@"search_btn_bg.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[[Env sharedEnv] cacheImage:@"search_btn_bg.png"] forState:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[[Env sharedEnv] cacheImage:@"search_btn_bg.png"] forState:UIControlStateHighlighted];
            btn.showsTouchWhenHighlighted = YES;
            
        }
    }
	if(!(searchField == nil)) {
		searchField.textColor = [UIColor whiteColor];
        [searchField setBackground: [[Env sharedEnv] cacheScretchableImage:@"search_txt_bg.png" X:40 Y:10]];
		UIImage *image = [[Env sharedEnv] cacheImage:@"search_logo.png"];
		UIImageView *iView = [[UIImageView alloc] initWithImage:image];
		searchField.leftView = iView;
		[iView release];
        
	}
    
	[super layoutSubviews];
}




@end
