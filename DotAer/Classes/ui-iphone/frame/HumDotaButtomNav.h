//
//  HumDotaButtomNav.h
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumDotaButtomNavDelgate;

@interface HumDotaButtomNav : UIView


@property (nonatomic, copy) NSString *curCatId;
@property (nonatomic, assign) id<HumDotaButtomNavDelgate> delegate;


@end


@protocol  HumDotaButtomNavDelgate <NSObject>

@optional
-(void)HumDotaButtomNav:(HumDotaButtomNav*)view DidSelect:(NSString*)catId;


@end

