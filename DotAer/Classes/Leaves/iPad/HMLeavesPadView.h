//
//  HMLeavesPadViewController.h
//  CoreTextDemo
//
//  Created by Kyle on 12-8-31.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//
#import "LeavesPadViewController.h"
#import "OHAttributedLabel.h"

#import "HumLeavesControlView.h"
#import "HumLeavesControlStyle.h"

@protocol HumLeavesDelegate;
@interface HMLeavesPadView : UIView
{
    CGFloat _offsetX;
    CGFloat _offsetY;
    CGFloat _bottomX;
    CGFloat _bottomY;
    
    CGFloat _characterSpacing;
    CGFloat _linesSpacing;
    CGFloat _paragraphSpacing;
    
    CGFloat _fontAdd;
    
    UIColor *_bgColor;
    UIColor *_characterColor;
    CGFloat _characterSize;
    NSString *_characterFont;
    UIColor *_linkerColor;
    
    NSString *_content;
    
    NSMutableDictionary *_imgDic; //存放下载的图片信息,图片下载异步
    
    
    
}

@property (nonatomic, assign) UIViewController *parentController;
@property (nonatomic, assign) id<HumLeavesDelegate> delegate;
/** The view that contains the controls and fades in/out */
@property (nonatomic, retain, readonly) HumLeavesControlView *controlsView;

@property (nonatomic, assign) HumLeavesControlStyle controlStyle;

/** flag that indicates whether the player controls are currently visible. changes are made non-animated */
@property (nonatomic, assign) BOOL controlsVisible;


@property (nonatomic, assign) CGFloat offsetX; //边框X偏移值
@property (nonatomic, assign) CGFloat offsetY; //边框Y偏移值
@property (nonatomic, assign) CGFloat bottomX; //边框底部X偏移值
@property (nonatomic, assign) CGFloat bottomY; //边框底部Y偏移值

@property (nonatomic, assign) CGFloat characterSpacing; //字间距离
@property (nonatomic, assign) CGFloat linesSpacing;//行间距离
@property (nonatomic, assign) CGFloat paragraphSpacing;//段字间距离

@property (nonatomic, assign) CGFloat fontAdd;

@property (nonatomic, retain) UIColor *bgColor; //背景颜色
@property (nonatomic, retain) UIColor *characterColor;//文字颜色
@property (nonatomic, assign) CGFloat characterSize;
@property (nonatomic, copy) NSString *characterFont;//文字字体
@property (nonatomic, retain) UIColor *linkerColor;//连接颜色

@property (nonatomic, copy) NSString *content; //显示的文字,未处理过的
@property (nonatomic, retain) NSMutableArray *paraseImges;//解析过后当前页的imageviews
@property (nonatomic, retain) NSMutableDictionary *paraImagesDictory;
@property (nonatomic, retain) NSMutableDictionary *imgDic;



@end
