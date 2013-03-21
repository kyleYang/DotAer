//
//  PanguPhotoWallView.h
//  pangu
//
//  Created by yang zhiyun on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HumDotaCateTwoTableView.h"

@protocol PanguPhotoWallDelegate;

typedef enum {
    PhotoWallImageStyleDefault,
    PhotoWallImageStyleGuoup,    
    PhotoWallImageStyleWall,  
} PhotoWallImageStyle;

@interface HumDotaImageCateTwoView  : HumDotaCateTwoTableView

-(id)initWithDotaCatFrameViewCtl:(HumDotaBaseViewController*)ctl Frame:(CGRect)frame CategoryId:(NSString *)catId;

@end




