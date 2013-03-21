//
//  PanguImgPopView.h
//  pangu
//
//  Created by yang zhiyun on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"



@interface HMImagePopView : UIView
{
    
}


@property (nonatomic, assign) CGRect imgRect;
@property (nonatomic, copy) NSString *urlString;


- (id)initWithFrame:(CGRect)frame image:(UIImage*)popImage imageFrame:(CGRect)rect;

- (void)popDisappear;
- (void)popViewAnimation;
@end

