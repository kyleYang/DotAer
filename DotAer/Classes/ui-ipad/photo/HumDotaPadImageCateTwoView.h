//
//  PanguPhotoWallView.h
//  pangu
//
//  Created by yang zhiyun on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HumDotaPadCateTwoTableView.h"

@protocol PanguPhotoWallDelegate;

typedef enum {
    PhotoWallImageStyleDefault,
    PhotoWallImageStyleGuoup,    
    PhotoWallImageStyleWall,  
} PhotoPadWallImageStyle;

@interface HumDotaPadImageCateTwoView  : HumDotaPadCateTwoTableView

-(id)initWithDotaCatFrameViewCtl:(HumPadDotaBaseViewController*)ctl Frame:(CGRect)frame CategoryId:(NSString *)catId;

@end




