//
//  UserOpResultInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-5-26.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserOpResultSuccess @"0"

@interface UserOpResultInfo : NSObject {
    
}
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;

+(UserOpResultInfo*)parseXmlData:(NSData*)data;

@end
