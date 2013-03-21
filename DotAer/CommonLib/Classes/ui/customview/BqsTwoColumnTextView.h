//
//  BqsTwoColumnTextView.h
//  iMobeeBook
//
//  Created by ellison on 11-9-3.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsTwoColumnTextView : UIControl {
    NSString *_strContent;
}
@property (nonatomic, retain) NSString* strContent;
@property (nonatomic, assign) float fPaddingHori;
@property (nonatomic, assign) float fPaddingVer;
@property (nonatomic, assign) float fMinColumnWidth;
@property (nonatomic, assign) float fColumnGap;
@property (nonatomic, assign) float fLineGap;
@property (nonatomic, assign) float fParaGap;
@property (nonatomic, retain) UIFont *txtFont;
@property (nonatomic, retain) UIColor *txtColor;
@end
