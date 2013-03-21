//
//  SysNetOps.h
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
// for itunes app version check
#define kSEItunesAppInfo @"itunes_appinfo"
#define kSEITunesAppInfoDef @"http://itunes.apple.com/lookup" /// id=xxxx

@class Downloader;
@interface SysNetOps : NSObject {
    Downloader *_downloader;
}

-(id)initWithDownloader:(Downloader*)dl;

-(void)fetchServiceEntry;

-(void)getSysNotice;

-(void)checkSysUpdateFromItunes;

#define kBqsPushNotificationAppId_News @"0"
#define kBqsPushNotificationAppId_Book @"1"

-(void)sendPushNotifitationTokenToServer:(NSData*)token AppType:(NSString*)appType;

#define kBqsOneYearNoAdMarketApple @"1"
#define kBqsOneYearNoAdMarketTaobao @"2"
-(void)sendPurchaseNoAdToServerPurchaseTime:(NSDate*)tm TransactionId:(NSString*)transactionId PurchaseMarket:(NSString*)marketId Receipt:(NSString*)receipt;
-(void)checkSendGetPurchaseNoAdInfoToServer;

@end
