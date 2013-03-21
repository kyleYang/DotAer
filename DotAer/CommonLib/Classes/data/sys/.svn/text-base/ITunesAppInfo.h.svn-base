//
//  ITunesAppInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-11-14.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define kNtfSysItuneAppVersionInfoGot @"sys.ntf.got.itunes.app.version"
//#define kNtfSysItunesAppVersionInfo @"versioninfo"

@interface ITunesAppInfo : NSObject {
    
}
@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, copy, readonly) NSString *releaseNotes;
@property (nonatomic, copy, readonly) NSString *downloadUrl;

+(ITunesAppInfo*)parseJSONData:(NSString*)str;

@end
