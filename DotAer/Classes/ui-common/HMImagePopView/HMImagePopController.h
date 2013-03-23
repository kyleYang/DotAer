//
//  ASMediaFocusViewController.h
//  ASMediaFocusManager
//
//  Created by Philippe Converset on 21/12/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HumWebImageView.h"

@interface HMImagePopController : UIViewController

@property (retain, nonatomic) HumWebImageView *scrollView;
@property (retain, nonatomic) UIImageView *mainImageView;
@property (retain, nonatomic) UIView *contentView;

- (void)updateOrientationAnimated:(BOOL)animated;

@end
