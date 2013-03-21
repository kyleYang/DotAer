//
//  PopMsgViews.m
//  iMobeeNews
//
//  Created by ellison on 11-6-14.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "PopMsgViews.h"
#import "Env.h"
#import "BqsUtils.h"
#import "DownloadTask.h"

#define kPopMsgTxtLabelTag 1234

@interface PopMsgViews()
@property (nonatomic, assign) UIViewController *parentViewCtl;
@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, retain) UIView *popMsgView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@end


@implementation PopMsgViews
@synthesize parentViewCtl;
@synthesize parentView;
@synthesize popMsgView;
@synthesize activityView;

-(id)initWithViewController:(UIViewController*)ctl {
    self = [super init];
    
    if(nil == self) return nil;
    
    self.parentViewCtl = ctl;
    self.parentView = ctl.view;
    
    return self;
}
-(id)initWithParentView:(UIView*)view {
    self = [super init];
    
    if(nil == self) return nil;
    
    self.parentView = view;
    
    return self;
}

-(void)layoutSubviews {
    if(nil != self.activityView) {
        self.activityView.center = CGPointMake(CGRectGetMidX(self.parentView.bounds), CGRectGetMidY(self.parentView.bounds));
    }
}

-(void)dealloc {
    BqsLog(@"dealloc");
    
    self.parentViewCtl = nil;
    self.parentView = nil;
    [self.popMsgView removeFromSuperview];
    self.popMsgView = nil;
    
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    [super dealloc];
}

-(void)delayRemovePopMsg2:(UIView*)v {
    BqsLog(@"delayRemovePopMsg2");
    
    if(v != self.popMsgView) {
        BqsLog(@"not my view: %@", v);
        return;
    }
    [self.popMsgView removeFromSuperview];
    self.popMsgView = nil;
    
}

-(void)delayRemovePopMsg:(UIView*)v {
    BqsLog(@"delayRemovePopMsg");
    
    if(v != self.popMsgView) {
        BqsLog(@"not my view: %@", v);
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.popMsgView.alpha = 0.0f;    
    [UIView commitAnimations];
    [self performSelector:@selector(delayRemovePopMsg2:) withObject:self.popMsgView afterDelay:.5];
    
}
-(void)showPopMsg:(NSString*)msg {
    [self showPopMsg:msg Remain:kBqsPopMsgViewRemainS Position:kBqsPopMsgPosCenter];
}
-(void)showPopMsg:(NSString*)msg Remain:(float)seconds  Position:(int)pos {
    [self showPopMsg:msg Remain:seconds Position:pos View:self.parentView];
}
-(void)showPopMsg:(NSString*)msg Remain:(float)seconds Position:(int)pos View:(UIView*)parentV {

#define kTextPadding 10
    
    BqsLog(@"msg: %@", msg);
    
    if([msg length] < 1) return;
    
    if(nil != self.popMsgView) {
        [self.popMsgView removeFromSuperview];
        self.popMsgView = nil;
    }
    
    Env *env = [Env sharedEnv];
    
    CGRect rcParent = parentV.bounds;

    CGRect rc = rcParent;
    rc = CGRectInset(rc, 20, 20);
    
    UIFont *fnt = [UIFont systemFontOfSize:17];
    
    // calc text size
    CGSize sz = [msg sizeWithFont:fnt constrainedToSize:rc.size lineBreakMode:UILineBreakModeCharacterWrap];
    sz.width += 2*kTextPadding;
    sz.height += 2*kTextPadding;
    
    if(sz.height > rc.size.height) sz.height = rc.size.height;
    
    if(kBqsPopMsgPosTop == pos) {
        if(sz.width < 300) sz.width = MIN(300, rcParent.size.width);
        if(sz.height < 50) sz.height = MIN(50, rcParent.size.height);

        int left = (rcParent.size.width - sz.width) / 2;
        int top = MAX(0, MIN(10, (rcParent.size.height-sz.height)/2));
        rc = CGRectMake(left, top, sz.width, sz.height);
        
    } else if(kBqsPopMsgPosBottom == pos) {
        if(sz.width < 300) sz.width = MIN(300, rcParent.size.width);
        if(sz.height < 50) sz.height = MIN(50, rcParent.size.height);
        
        int left = (rcParent.size.width - sz.width) / 2;
        int top = MAX(0, rcParent.size.height - MAX(100, sz.height+50));
        rc = CGRectMake(left, top, sz.width, sz.height);
        
    } else {
        if(sz.width < 200) sz.width = MIN(200, rcParent.size.width);
        if(sz.height < 100) sz.height = MIN(100, rcParent.size.height);
        
        rc = parentV.bounds;
        rc = CGRectInset(rc, (rc.size.width - sz.width) / 2, (rc.size.height - sz.height) / 2);
    }
    
    BqsLog(@"rc: (%.1f,%.1f,%.1f,%.1f)", rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
    
    // create it
    self.popMsgView = [[[UIView alloc] initWithFrame: rc] autorelease];
    self.popMsgView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:];
    
    // subview position
    rc.origin.x = 0;
    rc.origin.y = 0;
    
    //bg image
    UIImageView *iv = [[UIImageView alloc] initWithFrame:rc];
    iv.image = [env cacheScretchableImage:@"popmsg_bg.png" X:21 Y:21];
    [self.popMsgView addSubview:iv];
    [iv release];

    // text
    CGRect rcTxt = CGRectMake((int)rc.origin.x + kTextPadding, (int)rc.origin.y+kTextPadding, (int)rc.size.width-2*kTextPadding, (int)rc.size.height-2*kTextPadding);
    UILabel *lbl = [[UILabel alloc] initWithFrame:rcTxt];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = fnt;
    lbl.minimumFontSize = 12.0;
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.text = msg;
    lbl.lineBreakMode = UILineBreakModeCharacterWrap;
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.numberOfLines = 0;
    lbl.tag = kPopMsgTxtLabelTag;
    [self.popMsgView addSubview:lbl];
    [lbl release];

    [parentV addSubview:self.popMsgView];
    
    if(MAXFLOAT != seconds) {
        [self performSelector:@selector(delayRemovePopMsg:) withObject:self.popMsgView afterDelay:seconds];
    }
    
}

-(void)updatePopMsgText:(NSString*)newTxt {
    if(nil == self.popMsgView) return;
    UILabel *lbl = (UILabel*)[self.popMsgView viewWithTag:kPopMsgTxtLabelTag];
    if(nil == lbl) return;
    lbl.text = newTxt;
}

-(void)showProgress {
    [self showProgress:UIActivityIndicatorViewStyleWhite];
}
-(void)showProgress:(UIActivityIndicatorViewStyle)style {

    if(nil == self.activityView) {
        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style] autorelease];
        [self.activityView startAnimating];
    }
    
	if(![self.parentView.subviews containsObject:self.activityView]) {
		self.activityView.center = CGPointMake(CGRectGetMidX(self.parentView.bounds), CGRectGetMidY(self.parentView.bounds));
		[self.parentView addSubview:self.activityView];
	}    
}
-(BOOL)isShowingProgress {
    return (nil != self.activityView);
}

-(void)hideProgress {
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

+(NSString*)formatErrMsg:(NSError*)err {
    NSString *errStr = [[err userInfo] objectForKey:kErrMsgKey];
    if(nil == errStr) {
        errStr = [err localizedDescription];
    }
    return errStr;
}

+(void)showErrorAlert:(NSError*)err Msg:(NSString*)msg Delegate:(id)target {
    
    NSString *errStr = nil;
    if(nil != err) {
		if(NSURLErrorCancelled == [err code]) {
			BqsLog(@"error cancel");
			return;
		}
        
        errStr = [PopMsgViews formatErrMsg:err];
	}

    return [self showErrorAlertErrStr:errStr Msg:msg Delegate:target];
}
+(void)showErrorAlertErrStr:(NSString*)err Msg:(NSString*)msg Delegate:(id)target {
	NSMutableString *errMsg = [[NSMutableString alloc] initWithCapacity:128];
	
	if(nil != msg) {
		[errMsg appendString:msg];
	}
	
	if([err length] > 0) {
        [errMsg appendString:@":"];
        [errMsg appendString:err];
	}
    
	
	if(nil == errMsg) return;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"title.error.general", @"commonlib", nil)
                                                    message:errMsg
                                                   delegate:target 
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 
										  otherButtonTitles: nil];
    [errMsg release];
    [alert show];
    [alert release];
}

+(void)showErrorAlertMsg:(NSString*)msg RetMsg: (NSString*)retMsg RetStatus: (NSString*)retStatus {
	NSMutableString *errMsg = [[NSMutableString alloc] initWithCapacity:128];
	
    [errMsg appendString:msg];
    [errMsg appendString:@":"];
	if(nil != retMsg || nil != retStatus) {
		if(nil != retMsg)[errMsg appendString:retMsg];
        if(nil != retStatus) {
            [errMsg appendFormat:@"(%@)",retStatus];
        }
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"title.error.general", @"commonlib", nil)
                                                    message:errMsg
                                                   delegate:nil 
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 
										  otherButtonTitles: nil];
    [errMsg release];
	
    [alert show];
    [alert release];
}


+(void)showInfoAlert:(NSString*)msg {
    return [PopMsgViews showInfoAlert:msg Delegate:nil];
}
+(void)showInfoAlert:(NSString*)msg Delegate:(id)target {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:target
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 
										  otherButtonTitles: nil];
    [alert show];
    [alert release];    
}
+(void)showInfoAlert:(NSString*)msg Title:(NSString*)title {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
										  cancelButtonTitle:NSLocalizedStringFromTable(@"button.ok", @"commonlib", nil) 
										  otherButtonTitles: nil];
    [alert show];
    [alert release];     
}
@end
