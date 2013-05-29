//
//  MptTouchScrollView.h
//  TVGontrol
//
//  Created by Kyle on 13-5-10.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MptTouchScrollView : UIScrollView{
CGPoint touchBeganPoint;
UITouch *_touch;
}
@property (nonatomic, assign) id callback;
@property (nonatomic, assign) id attached;

@end


@protocol MptTouchScrollViewCallback <NSObject>
@optional
-(void)scrollView:(MptTouchScrollView*)iv didTapped:(CGPoint)pt;
-(void)scrollView:(MptTouchScrollView*)sv didDoubleTapped:(CGPoint)pt;
@end