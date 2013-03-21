//
//  SysNoticeInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-5-27.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNtfSysNoticeGot @"sys.ntf.gotnotice"
#define kNtfSysNoticeInfo @"notice"

@interface SysNoticeInfo : NSObject {
    
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *date;

+(SysNoticeInfo*)parseXmlData:(NSData*)data;

@end
