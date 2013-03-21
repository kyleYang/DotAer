//
//  BqsTextView.h
//  iMobeeNews
//
//  Created by ellison on 11-6-13.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineBreaker.h"


@interface BqsTextView : UIView {
    NSString *_strContent;
    
    t_PAGE_LINES *_pPageLines;
    NSMutableData *_arrLineInfo;
    
    CGPoint touchBeganPoint;
    UITouch *_touch;
}
@property (nonatomic, retain) NSString* strContent;
@property (nonatomic, assign) t_PAGE_LINES* pPageLines;
@property (nonatomic, assign) float fMarginHori;
@property (nonatomic, assign) float fMarginVer;
@property (nonatomic, assign) float fLineGap;
@property (nonatomic, assign) float fParaGap;
@property (nonatomic, retain) UIFont *txtFont;
@property (nonatomic, retain) UIColor *txtColor;

@property (nonatomic, assign) BOOL bAdjTextHoriCenter; // default NO

@property (nonatomic, assign) id callback;
@property (nonatomic, assign) id attached;

-(float)getPageHeight;
-(void)calcTextLines;

@end

@protocol BqsTextViewCallback <NSObject>
@optional
-(void)bqsTextView:(BqsTextView*)iv didTapped:(CGPoint)pt;

@end