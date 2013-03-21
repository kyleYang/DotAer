//
//  PopMsgViews.h
//  iMobeeNews
//
//  Created by ellison on 11-6-14.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PopMsgViews : NSObject {
    
}

-(id)initWithViewController:(UIViewController*)ctl;
-(id)initWithParentView:(UIView*)view;
-(void)layoutSubviews;

-(void)showProgress;
-(void)showProgress:(UIActivityIndicatorViewStyle)style;
-(BOOL)isShowingProgress;
-(void)hideProgress;
+(NSString*)formatErrMsg:(NSError*)err;
+(void)showErrorAlert:(NSError*)err Msg:(NSString*)msg Delegate:(id)target;
+(void)showErrorAlertErrStr:(NSString*)err Msg:(NSString*)msg Delegate:(id)target;
+(void)showErrorAlertMsg:(NSString*)msg RetMsg: (NSString*)retMsg RetStatus: (NSString*)retStatus;
+(void)showInfoAlert:(NSString*)msg;
+(void)showInfoAlert:(NSString*)msg Delegate:(id)target;
+(void)showInfoAlert:(NSString*)msg Title:(NSString*)title;

-(void)showPopMsg:(NSString*)msg;

#define kBqsPopMsgViewRemainS 1.0

#define kBqsPopMsgPosTop 1
#define kBqsPopMsgPosCenter 2
#define kBqsPopMsgPosBottom 3
-(void)showPopMsg:(NSString*)msg Remain:(float)seconds Position:(int)pos;
-(void)showPopMsg:(NSString*)msg Remain:(float)seconds Position:(int)pos View:(UIView*)v;

-(void)updatePopMsgText:(NSString*)newTxt;
@end
