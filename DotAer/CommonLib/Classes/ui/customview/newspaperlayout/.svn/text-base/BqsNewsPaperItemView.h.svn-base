//
//  BqsNewsPaperItemView.h
//  iMobeeNews
//
//  Created by ellison on 11-9-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BqsNewsPaperItemView : UIControl {
    
}
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) UIView *contentView;

// for internal use
@property (nonatomic, assign) id callback;

- (id)initWithFrame:(CGRect)frame Identifier:(NSString*)aIdentifier;

@end

@protocol BqsNewsPaperItemView_Callback <NSObject>

@optional
-(void)bqsNewsPaperItemViewDidTap:(BqsNewsPaperItemView*)itemView;

@end