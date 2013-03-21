//
//  BqsLauncherButton.h
//  iMobeeNews
//
//  Created by ellison on 11-6-9.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BqsCloseButton;
@protocol BqsLauncherButton_Callback;

@interface BqsLauncherButton : UIControl {

    BOOL _dragging;
    BOOL _editing;
    NSString *_badage;
    
    CGSize _savedDragSize;
    
}

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, copy) NSString *badage;

// for internal use
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, retain, readonly) BqsCloseButton* btnClose;
@property (nonatomic, assign) id<BqsLauncherButton_Callback> callback;

- (id)initWithFrame:(CGRect)frame Identifier:(NSString*)aIdentifier;

@end

@protocol BqsLauncherButton_Callback <NSObject>

@optional
-(void)bqsLauncherButtonDidClickCloseButton:(BqsLauncherButton*)btn;

@end