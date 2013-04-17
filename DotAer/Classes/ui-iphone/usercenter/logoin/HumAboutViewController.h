//
//  MptAboutViewController.h
//  TVGuide
//
//  Created by Zhanggq on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HumAboutViewController : UIViewController{
    
    //introduceView;
    UIView *_introduceView;
    UIImageView *_thumbView;
    UILabel *_versionLabel;
    UIButton *_maskWebButton;
    UIButton *_maskEmailButton;
    UIButton *_maskPhoneButton;
    UIScrollView *_introduceSrcollView;
    
    //agreementView;
    UIScrollView *_srcollView;
}

@end
