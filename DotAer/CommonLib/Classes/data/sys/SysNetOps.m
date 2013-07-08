//
//  SysNetOps.m
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "SysNetOps.h"
#import "Downloader.h"
#import "Env.h"
#import "BqsUtils.h"
#import "ITunesAppInfo.h"

#import "ServiceEntryParser.h"
#import "SysNoticeInfo.h"
#import "JSON.h"
#import "PopMsgViews.h"
#import "TBXML.h"
//#import "AdHandler.h"
#import "MobeeStatusMsg.h"

// for service entry
#define kCfgServiceEntryETag @"bqs.sys.se.etag"
#define kCfgServiceEntryLastModified @"bqs.sys.se.lastmodified"

// for notice
#define kSENotice @"notice"
#define kSENoticeDef @"/mservices/phone/s/notice.action"

// for push
#define kSEPushNotification @"enableNotification"
#define kSEPushNotificationDef @"/pushagent/enableNoti.action"

#define kCfgPushToken @"bqs.sys.push.token"
#define kCfgPushTokenUploadTs @"bqs.sys.push.tokenuploadts"
#define kPushTokenUploadIntervalS (24.0 * 60.0 * 60.0) // 24 hours


#define kCfgItunesVersionCheckTs @"bqs.sys.ituns.ver.checkts"
#define kItunesVersionCheckIntervalS (8.0 * 60.0 * 60.0) // 8 hours

// for buy no ad
#define kSEPurchaseNoAdAdd @"add_purchase_no_ad"
#define kSEPurchaseNoAdAddDef @"/mservices/adrecord/addRecord.action"
#define kSEPurchaseNoAdGet @"get_purchase_no_ad"
#define kSEPurchaseNoAdGetDef @"/mservices/adrecord/queryRecord.action"

#define kCfgPurchaseNoAd_PurchaseTime @"bqs.sys.noad.sendtoserver.purchasetime"
#define kCfgPurchaseNoAd_TransactionId @"bqs.sys.noad.sendtoserver.transactionid"
#define kCfgPurchaseNoAd_PurchaseMarket @"bqs.sys.noad.sendtoserver.purchasemarket"
#define kCfgPurchaseNoAd_receipt @"bqs.sys.noad.sendtoserver.receipt"

#define kCfgPurchaseNoAd_FetchInfoTs @"bqs.sys.noad.getfromserver.checkts"
#define kPurchaseNoAdCheckIntervalS (8.0 * 60.0 * 60.0) // 8 hours


@interface SysNetOps()<UIAlertViewDelegate>
@property (nonatomic, retain) ITunesAppInfo *itunesAppInfo;
@property (nonatomic, retain) UIAlertView *alertVersionInfo;

@property (nonatomic, retain) UIAlertView *alertNoAdPurchaseInfo;

@property (nonatomic, retain) PopMsgViews *popMsgViews;

-(void)onFetchServiceEntryFinished:(DownloaderCallbackObj*)cb;
-(void)onGetSysNoticeFinished:(DownloaderCallbackObj*)cb;

-(void)onFinishSendPushNotifitationTokenToServer:(DownloaderCallbackObj*)cb;

-(void)onFinishSendPurchaseNoAdToServer:(DownloaderCallbackObj*)cb;
@end

@implementation SysNetOps
@synthesize itunesAppInfo, alertVersionInfo;
@synthesize alertNoAdPurchaseInfo, popMsgViews;

-(id)initWithDownloader:(Downloader*)dl {
    self = [super init];
    if(nil == self) return nil;
    
    _downloader = [dl retain];
    
    self.popMsgViews = [[[PopMsgViews alloc] initWithViewController:[Env getRootViewController]] autorelease];
    
    return self;
}

-(void)dealloc {
    [_downloader release];
    self.itunesAppInfo = nil;
    [self.alertVersionInfo dismissWithClickedButtonIndex:0 animated:NO];
    self.alertVersionInfo = nil;
    
    [self.alertNoAdPurchaseInfo dismissWithClickedButtonIndex:0 animated:NO];
    self.alertNoAdPurchaseInfo = nil;
    
    self.popMsgViews = nil;
    
    [super dealloc];
}

-(void)fetchServiceEntry {
    NSString *url = [Env sharedEnv].sServiceEntryUrl;
    if(nil == url || [url length] < 1) {
        BqsLog(@"service_entry_url not configured !!!");
        return;
    }
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString *s = [defs objectForKey:kCfgServiceEntryETag];
    if(nil != s && [s length] > 0) [dic setObject:s forKey:kHttpHeader_ReqETag];
    s = [defs objectForKey:kCfgServiceEntryLastModified];
    if(nil != s && [s length] > 0) [dic setObject:s forKey:kHttpHeader_ReqLastModifed];
    
    [_downloader addTask:url Target:self Callback:@selector(onFetchServiceEntryFinished:) Attached:nil AppendHeaders:dic];
}
-(void)onFetchServiceEntryFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"onFetchServiceEntryFinished");
    if(nil == cb) {
		BqsLog(@"cb is nil");
		return;
	}
	
	if(nil != cb.error) {
		BqsLog(@"Error load services xml: %@", cb.error);
		return;
	}
    
    if(200 != cb.httpStatus && 304 != cb.httpStatus) return;

    {
        // save etag and last-modified
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        
        NSString *s = cb.httpETag;
        if(nil != s && [s length] > 0) [defs setObject:s forKey:kCfgServiceEntryETag];
        else [defs removeObjectForKey:kCfgServiceEntryETag];
        
        s = cb.httpLastModified;
        if(nil != s && [s length] > 0) [defs setObject:s forKey:kCfgServiceEntryLastModified];
        else [defs removeObjectForKey:kCfgServiceEntryLastModified];
    }
    
    if(304 == cb.httpStatus) return;
    
	// parse sns xml
	ServiceEntryParser *bp = [[ServiceEntryParser alloc] init];
	NSMutableDictionary *lst = [bp parseData:cb.rspData];
	if(nil == lst || [lst count] < 1) {
		BqsLog(@"Error parse services data");
		[bp release];
		return;
	}
	
	// save services
    [[Env sharedEnv] updateServerSE:lst];
	[bp release];
}

-(void)getSysNotice {
    NSString *url = [[Env sharedEnv] getSEKey:kSENotice Def:kSENoticeDef];
    [_downloader addTask:url Target:self Callback:@selector(onGetSysNoticeFinished:) Attached:nil];
}

-(void)onGetSysNoticeFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"onGetSysNoticeFinished");
    if(nil == cb) {
		BqsLog(@"cb is nil");
		return;
	}
	
	if(nil != cb.error) {
		BqsLog(@"Error get notices: %@", cb.error);
		return;
	}
    
	// parse
	SysNoticeInfo *bp = [SysNoticeInfo parseXmlData:cb.rspData];
    
    if(nil != bp) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:bp forKey:kNtfSysNoticeInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNtfSysNoticeGot object:nil userInfo:dic];
    }
    
}

-(void)checkSysUpdateFromItunes {
    
    return; //not use this for updata,use iVersion for updata
    
    NSString *sAppId = [Env sharedEnv].itunesAppId;
    if(nil == sAppId || [sAppId length] < 1) {
        BqsLog(@"no itunes_app_id defined, don't check version");
        return;
    }
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    double now = [NSDate timeIntervalSinceReferenceDate];
    double lastTs = [defs doubleForKey:kCfgItunesVersionCheckTs];
    
    if(now - lastTs < kItunesVersionCheckIntervalS) return;
    
    [defs setDouble:now forKey:kCfgItunesVersionCheckTs];

    NSString *url = [[Env sharedEnv] getSEKey:kSEItunesAppInfo Def:kSEITunesAppInfoDef];
    url = [BqsUtils setURL:url ParameterName:@"id" Value:sAppId];
    
    [_downloader addTask:url Target:self Callback:@selector(onCheckSysUpdateFromItunes:) Attached:nil];

}

-(void)onCheckSysUpdateFromItunes:(DownloaderCallbackObj*)cb {
    BqsLog(@"onCheckSysUpdateFromItunes");
    if(nil == cb) {
		BqsLog(@"cb is nil");
		return;
	}
	
	if(nil != cb.error) {
		BqsLog(@"Error get version info: %@", cb.error);
		return;
	}
    
    // dismiss previous alert
    if(nil != self.alertVersionInfo) {
        [self.alertVersionInfo dismissWithClickedButtonIndex:0 animated:NO];
        self.alertVersionInfo = nil;
    }

    
    ITunesAppInfo *info = [ITunesAppInfo parseJSONData:[BqsUtils stringFromData:cb.rspData Encoding:[BqsUtils parseCharsetInContentType:cb.httpContentType]]];
    
    if(nil != info) {
        NSString *ver = info.version;
        NSString *oldVer = [Env sharedEnv].swVersion;
        
        BqsLog(@"newVer: %@, oldVer: %@", ver, oldVer);
        if(nil != ver && nil != oldVer && nil != info.downloadUrl && [info.downloadUrl length] > 0 &&
           NSOrderedDescending == [ver compare:oldVer]) {
            
            self.itunesAppInfo = info;
            
            NSString *sTitle = NSLocalizedStringFromTable(@"sys.newversion.avaiable.title", @"commonlib", nil);
            NSString *sDesc = NSLocalizedStringFromTable(@"sys.newversion.avaiable.desc", @"commonlib", nil);
            
            sTitle = [NSString stringWithFormat:sTitle, ver];
            sDesc = [NSString stringWithFormat:sDesc, info.releaseNotes];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sTitle
                                                            message:sDesc
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"button.later", @"commonlib", nil) 
                                                  otherButtonTitles: NSLocalizedStringFromTable(@"button.upgrade", @"commonlib", nil),nil];
            // left adjust text
            if(nil != sDesc && sDesc.length > 0) {
                NSArray *subviews = [alert subviews];
                if(nil != subviews && [subviews count] > 1) {
                    for(id obj in subviews) {
                        if(nil != obj && [obj isKindOfClass:[UILabel class]]) {
                            UILabel *lbl = (UILabel*)obj;
                            NSString *txt = lbl.text;
                            if(nil != txt && txt.length > 0 && [txt isEqualToString:sDesc]) {
                                lbl.textAlignment = UITextAlignmentLeft;
                                break;
                            }
                        }
                    }
                }
            }
            
            [alert show];
            self.alertVersionInfo = alert;
            [alert release];    
        }
    }
}
#pragma alert delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView == self.alertVersionInfo) {
        NSString *url = [[[self.itunesAppInfo downloadUrl] copy] autorelease];
        BqsLog(@"url: %@", url);
        
        self.itunesAppInfo = nil;
        self.alertVersionInfo = nil;

        BqsLog(@"dismiss version info alert: %d", buttonIndex);
        if(1 == buttonIndex) {
            // ok
            if(nil != url && [url length] > 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
    } else if(alertView == self.alertNoAdPurchaseInfo) {
        self.alertNoAdPurchaseInfo = nil;
        
        BqsLog(@"dismiss purchase no ad sync info alert: %d", buttonIndex);
        if(1 == buttonIndex) {
            // ok
            [self checkSendGetPurchaseNoAdInfoToServer];
        }
    }
}


-(void)sendPushNotifitationTokenToServer:(NSData*)token AppType:(NSString*)appType {
    NSString *sToken = [BqsUtils base64StringFromData:token];
    if(nil == sToken || [sToken length] < 1) return;

    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    double now = [NSDate timeIntervalSinceReferenceDate];
    double lastTs = [defs doubleForKey:kCfgPushTokenUploadTs];
    
    NSString *sLastToken = [defs stringForKey:kCfgPushToken];
    if(nil != sLastToken && [sLastToken isEqualToString:sToken] && now - lastTs < kPushTokenUploadIntervalS) return;

    [defs setDouble:now forKey:kCfgPushTokenUploadTs];
    [defs setObject:sToken forKey:kCfgPushToken];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [dic setObject:@"0" forKey:@"type"];
    if(nil != appType) {
        [dic setObject:appType forKey:@"appid"];
    }
    [dic setObject:[Env sharedEnv].macUdid forKey:@"deviceid"];
    [dic setObject:sToken forKey:@"token"];
    
    NSString *sData = [dic JSONRepresentation];
    if(nil == sData || [sData length] < 1) return;
    
//    [PopMsgViews showInfoAlert:[NSString stringWithFormat:@"sendPushNotifitationTokenToServer. rsp: %@, token: %@", sData, sToken]];

    NSData *postData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    if(nil == postData || [postData length] < 1) return;
    
    NSString *url = [[Env sharedEnv] getSEKey:kSEPushNotification Def:kSEPushNotificationDef];
    
    [_downloader addPostTask:url Data:postData ContentType:@"text/json" Target:self Callback:@selector(onFinishSendPushNotifitationTokenToServer:) Attached:nil];
}

-(void)onFinishSendPushNotifitationTokenToServer:(DownloaderCallbackObj*)cb {
    BqsLog(@"onFinishSendPushNotifitationTokenToServer");
    
//    [PopMsgViews showInfoAlert:[NSString stringWithFormat:@"onFinishSendPushNotifitationTokenToServer. rsp: %d, %@", cb.httpStatus, [BqsUtils stringFromData:cb.rspData Encoding:nil]]];

}

-(void)checkSendGetPurchaseNoAdInfoToServer {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    // check post info to server
    NSString *sTransactionId = [defs stringForKey:kCfgPurchaseNoAd_TransactionId];
    NSDate *tm = (NSDate*)[defs objectForKey:kCfgPurchaseNoAd_PurchaseTime];
    NSString *sMarketId = [defs objectForKey:kCfgPurchaseNoAd_PurchaseMarket];
    NSString *sReceipt = [defs objectForKey:kCfgPurchaseNoAd_receipt];
    
    if(nil == sTransactionId || [sTransactionId length] < 1 ||
       nil == tm || nil == sMarketId || nil == sReceipt) {
        
    } else {
        [self sendPurchaseNoAdToServerPurchaseTime:tm TransactionId:sTransactionId PurchaseMarket:sMarketId Receipt:sReceipt];
    }
    
//    // check get info from server
//    double now = [NSDate timeIntervalSinceReferenceDate];
//    double lastTs = [defs doubleForKey:kCfgPurchaseNoAd_FetchInfoTs];
//    if(now - lastTs < kPurchaseNoAdCheckIntervalS) {
//        BqsLog(@"not yet need to check noad purchase state from server");
//        return;
//    }
//    
//    [defs setDouble:now forKey:kCfgPurchaseNoAd_FetchInfoTs];
//    [self fetchPurchNoAdFromServer];

}
-(void)sendPurchaseNoAdToServerPurchaseTime:(NSDate*)tm TransactionId:(NSString*)transactionId PurchaseMarket:(NSString*)marketId Receipt:(NSString*)receipt {
    
    if(nil == tm || nil == transactionId || nil == marketId || nil == receipt) {
        BqsLog(@"Invalid param. tm: %@, transactionId: %@, marketId: %@, receipt: %@", tm, transactionId, marketId, receipt);
        return;
    }
    
    // save info for error retry
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:tm forKey:kCfgPurchaseNoAd_PurchaseTime];
    [defs setObject:transactionId forKey:kCfgPurchaseNoAd_TransactionId];
    [defs setObject:marketId forKey:kCfgPurchaseNoAd_PurchaseMarket];
    [defs setObject:receipt forKey:kCfgPurchaseNoAd_receipt];
    [defs synchronize];
    
    Env *env = [Env sharedEnv];
    
    NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormater setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
//    [dateFormater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    NSString *sDevNum = [NSString stringWithFormat:@"%@_%@", env.sPhoneType, env.macUdid];
    NSString *sDate = [dateFormater stringFromDate:tm];
    
    NSString *url = [[Env sharedEnv] getSEKey:kSEPurchaseNoAdAdd Def:kSEPurchaseNoAdAddDef];
    NSString *params = @"?";
    params = [BqsUtils setURL:params ParameterName:@"deviceNum" Value:sDevNum];
    params = [BqsUtils setURL:params ParameterName:@"purchaseTime" Value:sDate];
    params = [BqsUtils setURL:params ParameterName:@"transactionId" Value:transactionId];
    params = [BqsUtils setURL:params ParameterName:@"purchaseMarket" Value:marketId];
    params = [BqsUtils setURL:params ParameterName:@"receipt" Value:receipt];
    
    if(nil != params && [params length] > 0 && '?' == [params characterAtIndex:0]) params = [params substringFromIndex:1];
    
    BqsLog(@"params: %@", params);
//    [_downloader addTask:url Target:self Callback:@selector(onFinishSendPurchaseNoAdToServer:) Attached:nil];
    
    [_downloader addPostTask:url Data:[params dataUsingEncoding:NSUTF8StringEncoding] ContentType:@"application/x-www-form-urlencoded" Target:self Callback:@selector(onFinishSendPurchaseNoAdToServer:) Attached:nil];

}

-(void)onFinishSendPurchaseNoAdToServer:(DownloaderCallbackObj*)cb {
    BqsLog(@"onFinishSendPurchaseNoAdToServer: %@", cb);
	
	if(nil == cb) return;
    
    BOOL bError = YES;
    NSString *errMsg = @"";
	
	if(200 == cb.httpStatus && nil != cb.rspData && [cb.rspData length] > 0) {
        

        MobeeStatusMsg *sm = [MobeeStatusMsg parseXmlData:cb.rspData];
        
        if(nil != sm.status && [kMobeeStatusResultSuccess isEqualToString:sm.status]) {
            BqsLog(@"purchase no ad upload success, clear local data");
            NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
            [defs removeObjectForKey:kCfgPurchaseNoAd_PurchaseTime];
            [defs removeObjectForKey:kCfgPurchaseNoAd_TransactionId];
            [defs removeObjectForKey:kCfgPurchaseNoAd_PurchaseMarket];
            [defs removeObjectForKey:kCfgPurchaseNoAd_receipt];
            [defs synchronize];
            
            bError = NO;
        } else {
            BqsLog(@"purchase no ad upload failed: %@, %@", sm.status, sm.msg);
            bError = YES;
            errMsg = [NSString stringWithFormat:@"%@(%@)", sm.msg, sm.status];
        }

	} else {
		BqsLog(@"purchase no ad upload failed: http:%d, error:%@", cb.httpStatus, cb.error);
        bError = YES;
        errMsg = [NSString stringWithFormat:@"%@(HTTP%d)", [cb.error localizedDescription], cb.httpStatus];
	}
    
    
//    if(bError) {
//        NSString *msg = NSLocalizedStringFromTable(@"info.ad.buy.noad.synctoserver.failed", @"commonlib", nil);
//        
//        msg = [NSString stringWithFormat:msg, errMsg];
//        
//        if(nil != self.alertNoAdPurchaseInfo) {
//            [self.alertNoAdPurchaseInfo dismissWithClickedButtonIndex:0 animated:NO];
//            self.alertNoAdPurchaseInfo = nil;
//        }
//        
//        self.alertNoAdPurchaseInfo = [[[UIAlertView alloc] initWithTitle:@""
//                                                                message:msg
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 
//                                                      otherButtonTitles: NSLocalizedStringFromTable(@"button.retrynow", @"commonlib", nil),nil] autorelease];
//        [self.alertNoAdPurchaseInfo show];
//        
//    } else {
////        [PopMsgViews showInfoAlert:NSLocalizedStringFromTable(@"info.ad.buy.noad.synctoserver.success", @"commonlib", nil)];
////        if(nil == self.popMsgViews) {
////            self.popMsgViews = [[[PopMsgViews alloc] initWithViewController:[Env getRootViewController]] autorelease];
////        }
//        
//        [self.popMsgViews showPopMsg:NSLocalizedStringFromTable(@"info.ad.buy.noad.synctoserver.success", @"commonlib", nil) Remain:12.0 Position:kBqsPopMsgPosBottom View:[Env getRootViewController].view];
//        [self fetchPurchNoAdFromServer];
//    }
}




@end
