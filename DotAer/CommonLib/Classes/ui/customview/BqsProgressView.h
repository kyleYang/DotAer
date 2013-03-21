//
//  BqsProgressView.h
//  iMobeeBook
//
//  Created by ellison on 11-7-11.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsProgressView : UIView {
    float _fPercent;
}
@property (nonatomic, assign) float fPercent;

@property (nonatomic, assign) BOOL bContinuous;
@property (nonatomic, retain) UIImage *imgFg;
@property (nonatomic, retain) UIImage *imgBg;

@property (nonatomic, assign) int dotGap; // for non continual

@end
