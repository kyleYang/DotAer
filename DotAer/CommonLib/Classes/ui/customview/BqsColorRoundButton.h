//
//  BqsColorRoundButton.h
//  iMobeeBook
//
//  Created by ellison on 11-7-6.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsColorRoundButton : UIControl {
//    id _cbTarget;
//    SEL _cbSel;
    
    BOOL _bPressed;
}

@property (nonatomic, assign) BOOL bShining;
@property (nonatomic, assign) BOOL bShadow;
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *bgColorPress;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *textColorPress;
@property (nonatomic, retain) UIImage *img;

//-(void)setCallbackTarget:(id)target Sel:(SEL)sel;

@end
