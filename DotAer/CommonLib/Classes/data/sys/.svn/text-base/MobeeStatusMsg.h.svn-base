//
//  MobeeStatusMsg.h
//  iMobeeBook
//
//  Created by ellison on 11-11-25.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMobeeStatusResultSuccess @"0"

@interface MobeeStatusMsg : NSObject {
    
}

@property (nonatomic, copy, readonly) NSString* status;
@property (nonatomic, copy, readonly) NSString* msg;
@property (nonatomic, assign, readonly) int total;


-(BOOL)isSuccess;

+(MobeeStatusMsg*)parseXmlData:(NSData*)data;

@end
