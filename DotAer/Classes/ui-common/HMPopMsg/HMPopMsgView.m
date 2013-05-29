//
//  PanguAlterView.m
//  pangu
//
//  Created by yang zhiyun on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMPopMsgView.h"
#import "BqsUtils.h"
#import "HMNoticeView.h"
#import "KGModal.h"

#define kErrMsgKey @"msg"

@implementation HMPopMsgView

+(void)showPopMsg:(NSString *)msg
{
    if (!msg || msg.length ==0) {
        return;
    }
    
    [[msg retain] autorelease];
    HMNoticeView *notic = [HMNoticeView sharedInstance ];
    notic.message = msg;
    
    KGModal *kgModel = [KGModal sharedInstance];
    [kgModel showWithContentView:notic andAnimated:YES];
    
    
}

+(void)showPopMsgError:(NSError*)err Msg:(NSString*)msg RetMsg: (NSString*)retMsg RetStatus: (NSString*)retStatus
{
    
    if (!msg || msg.length ==0) {
        return;
    }
    
    [[msg retain] autorelease];
    HMNoticeView *notic = [HMNoticeView sharedInstance ];
    notic.message = msg;
    
    KGModal *kgModel = [KGModal sharedInstance];
    [kgModel showWithContentView:notic andAnimated:YES];
}



+(void)showPopMsgError:(NSError*)err Msg:(NSString*)msg Delegate:(id)target {
    NSString *errStr = nil;
    if(nil != err) {
		if(NSURLErrorCancelled == [err code]) {
			BqsLog(@"error cancel");
			return;
		}
		errStr = [[err userInfo] objectForKey:kErrMsgKey];
		if(nil == errStr) {
			errStr = [err localizedDescription];
		}
	}
    
     return [self showPopMsgString:errStr Msg:msg Delegate:target];

}

+(void)showPopMsgString:(NSString*)err Msg:(NSString*)msg Delegate:(id)target {

    
    if ((!err||err.length==0)&&(!msg || msg.length ==0)) {
        return;
    }

    
    NSMutableString *errMsg = [[NSMutableString alloc] initWithCapacity:128];
	
	if(nil != msg) {
		[errMsg appendString:msg];
	}
	
	if([err length] > 0) {
//        [errMsg appendString:@":"];
        [errMsg appendString:err];
	}
    
	
	if(nil == errMsg) return;
	
    HMNoticeView *notic = [HMNoticeView sharedInstance ];
    notic.message = errMsg;
    
    KGModal *kgModel = [KGModal sharedInstance];
    [kgModel showWithContentView:notic andAnimated:YES];
    
    [errMsg release];


}


+(void)showErrorAlert:(NSError*)err Msg:(NSString*)msg Delegate:(id)target {
    
    NSString *errStr = nil;
    if(nil != err) {
		if(NSURLErrorCancelled == [err code]) {
			BqsLog(@"error cancel");
			return;
		}
		errStr = [[err userInfo] objectForKey:kErrMsgKey];
		if(nil == errStr) {
			errStr = [err localizedDescription];
		}
	}
    
    return [self showAlterError:errStr Msg:msg Delegate:target];
}


+(void)showAlterError:(NSString*)err Msg:(NSString*)msg Delegate:(id)target {
	NSMutableString *errMsg = [[NSMutableString alloc] initWithCapacity:128];
	
	if(nil != msg) {
		[errMsg appendString:msg];
	}
	
	if([err length] > 0) {
        [errMsg appendString:@":"];
        [errMsg appendString:err];
	}
    
	
	if(nil == errMsg) return;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errMsg
                                                   delegate:target 
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 										  otherButtonTitles: nil];
    [errMsg release];
    [alert show];
    [alert release];
}





+(void)showAlertError:(NSError*)err Msg:(NSString*)msg RetMsg: (NSString*)retMsg RetStatus: (NSString*)retStatus {
	NSMutableString *errMsg = [[NSMutableString alloc] initWithCapacity:128];
	
	if(nil != msg) {
		[errMsg appendString:msg];
	}
	
	if(nil != err) {
		if(NSURLErrorCancelled == [err code]) {
			BqsLog(@"error cancel");
			[errMsg release];
			return;
		}
        NSString *m = [err localizedDescription];
		if(nil != m) {
			[errMsg appendString:@":"];
			[errMsg appendString:m];
		}
	}
    
    if(nil != retMsg) {
        if([errMsg length] > 0) [errMsg appendString:@":"];
        [errMsg appendString:retMsg];
        if([retStatus length] > 0) {
            [errMsg appendFormat:@"(%@)", retStatus];
        }
    }
	
	
	if(nil == errMsg) return;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errMsg
                                                   delegate:self 
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 
										  otherButtonTitles: nil];
    [errMsg release];
	
    [alert show];
    [alert release];
}


+(UIAlertView *)showChaoseAlertError:(NSError*)err Msg:(NSString*)msg delegate:(id)delegate{
    NSMutableString *errMsg = [[NSMutableString alloc] initWithCapacity:128];

    if(nil != msg) {
		[errMsg appendString:msg];
	}
	
	if(nil != err) {
		if(NSURLErrorCancelled == [err code]) {
			BqsLog(@"error cancel");
			[errMsg release];
			return nil;
		}
        NSString *m = [err localizedDescription];
		if(nil != m) {
			[errMsg appendString:@":"];
			[errMsg appendString:m];
		}
	}
    
	if(nil == errMsg) return nil;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errMsg
                                                   delegate:delegate
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.no", @"commonlib", nil)
										  otherButtonTitles:NSLocalizedStringFromTable(@"button.yes", @"commonlib", nil),nil];
    [errMsg release];
	
    [alert show];
    
    return [alert autorelease];

    
}


@end
