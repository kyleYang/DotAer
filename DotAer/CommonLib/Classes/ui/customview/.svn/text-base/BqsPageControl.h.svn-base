//
//  BqsPageControl.h
//  iMobeeBook
//
//  Created by ellison on 11-7-4.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BqsPageControl_Callback;
@interface BqsPageControl : UIView {
    UIImage* mImageNormal;
	UIImage* mImageCurrent;
	
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    NSObject<BqsPageControl_Callback> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic, readwrite, retain) UIImage* imageNormal;
@property (nonatomic, readwrite, retain) UIImage* imageCurrent;


// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;
@property (nonatomic, assign) float dotWidth;
@property (nonatomic, assign) float dotSpace;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, assign) NSObject<BqsPageControl_Callback> *delegate;

@end

@protocol BqsPageControl_Callback <NSObject> 

@optional
- (void)bqsPageControlDidChangePage:(BqsPageControl *)pageControl;
@end


