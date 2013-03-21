//
//  MpAVPlayerPlaceholderView.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MptAVPlayerPlaceholderView : UIView


@property (nonatomic, retain, readonly) UIButton *backButton;
@property (nonatomic, retain, readonly) UIButton *playButton;
@property (nonatomic, retain, readonly) UILabel *infoLabel;
@property (nonatomic, retain, readonly) UIImageView *imageView;

/** Defaults to NO */
@property (nonatomic, assign) BOOL playButtonHidden;
/** Defaults to nil */
@property (nonatomic, copy) NSString *infoText;
/** Defaults to nil */
@property (nonatomic, retain) UIImage *image;


- (void)resetToInitialState;
- (void)addPlayButtonTarget:(id)target action:(SEL)action;
- (void)addBackButtonTarget:(id)target action:(SEL)action;


@end


