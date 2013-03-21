//
//  ModifyUserResultInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-5-26.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kModifyUserResultSuccess @"0"

@interface ModifyUserResultInfo : NSObject {
    
}
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) BOOL support;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

+(ModifyUserResultInfo*)parseXmlData:(NSData*)data;

@end
