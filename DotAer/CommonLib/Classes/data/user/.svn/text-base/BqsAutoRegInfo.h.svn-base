//
//  BqsAutoRegInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BqsUserInfo.h"

#define kAutoRegStatusSuccess @"0"

@interface BqsAutoRegInfo : NSObject {
    BqsUserInfo *_userInfo;
    
    NSString *_reqSpUrl;
    NSInteger _timeOut; // default 10, no use now
    NSString *_sid;
    NSString *_status;
    NSString *_msg;
    
//    BOOL _bInItem;
}
@property (nonatomic, retain) BqsUserInfo *userInfo;
@property (nonatomic, copy) NSString *reqSpUrl;
@property (nonatomic, assign) NSInteger timeOut;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;

+(BqsAutoRegInfo*)parseXmlData:(NSData*)data;

@end
