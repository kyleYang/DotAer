//
//  BkSvc.h
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Downloader;
@class UserMgr;
@class SysNetOps;

@interface BkSvc : NSObject {
    Downloader *_downloader;
    UserMgr *_userMgr;
    SysNetOps *_sysNetOps;
}

@property (nonatomic, retain, readonly) Downloader *downloader;
@property (nonatomic, retain, readonly) UserMgr *userMgr;
@property (nonatomic, retain, readonly) SysNetOps *sysNetOps;

@end
