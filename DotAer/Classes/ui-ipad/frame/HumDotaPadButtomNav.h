//
//  HumDotaButtomNav.h
//  DotAer
//
//  Created by Kyle on 13-1-22.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumDotaPadButtomNavDelgate;

@interface HumDotaPadButtomNav : UIView


@property (nonatomic, copy) NSString *curCatId;
@property (nonatomic, assign) id<HumDotaPadButtomNavDelgate> delegate;


@end


@protocol  HumDotaPadButtomNavDelgate <NSObject>

@optional
-(void)HumDotaButtomNav:(HumDotaPadButtomNav*)view DidSelect:(NSString*)catId;


@end

