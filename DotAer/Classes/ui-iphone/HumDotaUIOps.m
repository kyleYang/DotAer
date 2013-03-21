//
//  HumDotaUIOps.m
//  DotAer
//
//  Created by Kyle on 13-2-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaUIOps.h"
#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>


@implementation HumDotaUIOps


+(void)slideShowModalViewControler:(UIViewController*)vctl ParentVCtl:(UIViewController*)pvctl {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    UIView *containerView = pvctl.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [pvctl presentModalViewController:vctl animated:NO];
}

+(void)slideShowModalViewInNavControler:(UIViewController *)vctl ParentVCtl:(UIViewController *)pvctl {
    if(nil == vctl || nil == pvctl) return;
    
    CustomNavigationController *nav = [[[CustomNavigationController alloc] initWithRootViewController:vctl] autorelease];
    nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    [self slideShowModalViewControler:nav ParentVCtl:pvctl];
    
}

+(void)slideDismissModalViewController:(UIViewController*)vctl {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
    UIView *containerView = vctl.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [vctl dismissModalViewControllerAnimated:NO];
}


@end
