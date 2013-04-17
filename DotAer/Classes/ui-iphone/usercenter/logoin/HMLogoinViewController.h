//
//  PanguLogoinViewController.h
//  pangu
//
//  Created by yang zhiyun on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HMLogoinDelegate;


@interface HMLogoinViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    id <HMLogoinDelegate> myDelegate;
}

@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) id<HMLogoinDelegate> myDelegate;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, retain) UIScrollView *contentView;
 
@end

@protocol HMLogoinDelegate <NSObject>

@optional
- (void)logoin:(BOOL)isSuccess action:(SEL)action;

- (void)popBackParent;
- (void)returnToParaent;

@end
