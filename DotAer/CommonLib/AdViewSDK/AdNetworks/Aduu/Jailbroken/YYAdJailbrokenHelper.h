//
//  YYAdJailbrokenHelper.h
//  ASIRequest
//
//  Created by apple on 12-11-8.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
@interface YYAdJailbrokenHelper : NSObject<ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
}
+(YYAdJailbrokenHelper *)sharedInstance;
-(void)downloadApp:(NSString *)appURL;
@end
