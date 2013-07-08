//
//  HumDotaUIOps.h
//  DotAer
//
//  Created by Kyle on 13-2-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HumDotaUIOps : NSObject

+(void)slideShowModalViewControler:(UIViewController*)vctl ParentVCtl:(UIViewController*)pvctl;
+(void)slideShowModalViewInNavControler:(UIViewController *)vctl ParentVCtl:(UIViewController *)pvctl;
+(void)slideDismissModalViewController:(UIViewController*)vctl;

+(void)popUIViewControlInNavigationControl:(UIViewController *)control;
+(void)revealViewControl:(UIViewController *)left presentViewControlel:(UIViewController *)font;
+(void)revealLeftViewControl:(UIViewController *)left showNavigationFontViewControl:(UIViewController *)font wihtOtherViewControle:(UIViewController *)other;

+(void)revealRightViewControl:(UIViewController *)right showNavigationFontViewControl:(UIViewController *)font wihtOtherViewControle:(UIViewController *)other;
+(void)revealRightViewControl:(UIViewController *)right showNavigationFontViewControl:(UIViewController *)font;


@end
