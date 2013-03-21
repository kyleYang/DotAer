//
//  BqsRegisterInfo.h
//  iMobeeNews
//
//  Created by ellison on 11-5-26.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRegisterStatusSuccess @"0"
#define kRegisterStatusSuccessNoNeedAct @"100"

@interface BqsRegisterInfo : NSObject {
    
}
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *sp;
@property (nonatomic, copy) NSString *cmd;

+(BqsRegisterInfo*)parseXmlData:(NSData*)data;

@end
