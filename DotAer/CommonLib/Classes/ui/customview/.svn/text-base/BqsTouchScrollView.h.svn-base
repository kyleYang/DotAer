//
//  BqsTouchScrollView.h
//  iMobeeNews
//
//  Created by ellison on 11-6-21.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsTouchScrollView : UIScrollView {
    CGPoint touchBeganPoint;
    UITouch *_touch;
}
@property (nonatomic, assign) id callback;
@property (nonatomic, assign) id attached;

@end


@protocol BqsTouchScrollViewCallback <NSObject>
@optional
-(void)scrollView:(BqsTouchScrollView*)iv didTapped:(CGPoint)pt;
-(void)scrollView:(BqsTouchScrollView*)sv didDoubleTapped:(CGPoint)pt;
@end