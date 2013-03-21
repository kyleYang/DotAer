//
//  FullScrAdMgr.h
//  iMobeeBook
//
//  Created by ellison on 11-11-25.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FullScrAdItem.h"
#import "Downloader.h"

@interface FullScrAdMgr : NSObject {
}

@property (nonatomic, assign, readonly) double lastShowTS;

-(void)checkServerCfg;

-(FullScrAdItem*)getDisplayItem;
-(NSData*)getItemImageData:(NSString*)url;
-(void)postponeDisplayFullScrAd;

// ui ops
-(BOOL)canShow;
-(void)show:(BOOL)bIgnoreInterval;
-(void)hide:(BOOL)bForceRemove;

@end