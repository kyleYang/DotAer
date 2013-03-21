//
//  BqsTouchImageView.h
//  iMobeeNews
//
//  Created by ellison on 11-6-9.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BqsTouchImageViewCallback;
@interface BqsTouchImageView : UIImageView {
    CGPoint touchBeganPoint;
    UITouch *_touch;
}
@property (nonatomic, assign) id callback;
@property (nonatomic, assign) id attached;

@end

@protocol BqsTouchImageViewCallback <NSObject>
@optional
-(void)imageView:(BqsTouchImageView*)iv didTapped:(CGPoint)pt;

@end