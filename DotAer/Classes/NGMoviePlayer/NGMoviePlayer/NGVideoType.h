//
//  NGVideoType.h
//  DotAer
//
//  Created by Kyle on 13-7-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGWeak.h"

@protocol NGVideoTypeDelegate;

@interface NGVideoType : UIView

@property (nonatomic, ng_weak) id<NGVideoTypeDelegate> delegate;
@end


@protocol NGVideoTypeDelegate <NSObject>


- (void)NGVideoType:(NGVideoType *)type didSelectAtIndex:(NSUInteger)index;

@end