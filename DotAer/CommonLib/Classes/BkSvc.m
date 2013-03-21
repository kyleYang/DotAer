//
//  BkSvc.m
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BkSvc.h"
#import "Downloader.h"
#import "Env.h"
#import "UserMgr.h"
#import "SysNetOps.h"

#define kServicesUpdateIntervalS (8.0 * 60.0 * 60.0)
#define kGetSysNoticeIntervalS (8.0 * 60.0 * 60.0)


#define kCfgServiceUpdateTS @"bksvc.se.update.ts"
#define kCfgGetSysNoticeTS @"bksvc.sysnotice.get.ts"

@interface BkSvc()
-(void)appTermNtf:(NSNotification*)ntf;
-(void)appResumeNtf:(NSNotification*)ntf;

@end

@implementation BkSvc
@synthesize downloader=_downloader;
@synthesize userMgr=_userMgr;
@synthesize sysNetOps=_sysNetOps;

-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    _downloader = [[Downloader alloc] init];
    _userMgr = [[UserMgr alloc] initWithDownloader:_downloader];
    _sysNetOps = [[SysNetOps alloc] initWithDownloader:_downloader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appTermNtf:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResumeNtf:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_downloader release];
    [_userMgr release];
    [_sysNetOps release];
    
    [super dealloc];
}

-(void)appTermNtf:(NSNotification*)ntf {
    BqsLog(@"appTermNtf");
}

-(void)appResumeNtf:(NSNotification*)ntf {
    BqsLog(@"appResumeNtf");
    
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    double now = [NSDate timeIntervalSinceReferenceDate];

    // check service entry
    {
        double seFetchTs = [defs doubleForKey:kCfgServiceUpdateTS];
        
        if(now - seFetchTs > kServicesUpdateIntervalS) {
            [defs setDouble:now forKey:kCfgServiceUpdateTS];
            [_sysNetOps fetchServiceEntry];
        }
    }
    
    // check notice
    {
        if(![_userMgr.userInfo isValidUser]) {
            
            BqsLog(@"Invalid user, cancel load notice.");
        } else {
            double tsNotice = [defs doubleForKey:kCfgGetSysNoticeTS];
            if(now - tsNotice > kGetSysNoticeIntervalS) {
                [defs setDouble:now forKey:kCfgGetSysNoticeTS];
                [_sysNetOps getSysNotice];
            }
        }
    }
    
    // check app version
    {
        [_sysNetOps checkSysUpdateFromItunes];
    }
    
    // check upload/download purchase no ad
    {
        [_sysNetOps checkSendGetPurchaseNoAdInfoToServer];
    }
    
}


@end
