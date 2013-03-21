//
//  BqsNumberedPageCtrl.h
//  iMobeeNews
//
//  Created by ellison on 11-9-4.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsNumberedPageCtrl : UIView {
    int _curPage;
    int _numOfPages;
}
@property (nonatomic, assign) id callback;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, retain) UIFont *txtFont;
@property (nonatomic, retain) UIColor *txtColor;


- (id)initWithFrame:(CGRect)frame LeftArrowImg:(UIImage*)imgLeft RightArrowImg:(UIImage*)imgRight;
@end

@protocol BqsNumberedPageCtrl_Callback <NSObject> 

@optional
- (void)bqsNumberedPageCtrl:(BqsNumberedPageCtrl*)pageCtl DidTurnToPage:(int)newPageId;
@end
