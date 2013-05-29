//
//  PanguRegistVC.m
//  pangu
//
//  Created by yang zhiyun on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMRegistVC.h"
#import "Downloader.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "HMPopMsgView.h"
#import "Status.h"
#import "BqsUtils.h"
#import "MBProgressHUD.h"
#import "Env.h"
#import "CustomUIBarButtonItem.h"
#import "HumDotaUserCenterOps.h"
#import "Status.h"

#define kLinkColor [UIColor colorWithRed:92.0f/255.0f green:92.0f/255.0f blue:254.0f/255.0f alpha:1.0f]

#define kPointArc 80

@interface HMRegistVC ()<UIAlertViewDelegate>
{
    
    BOOL _keyboardVisible;
    CGPoint _contentOffset; // save to restore content view location
    float _contentHeight;// save to restore c
    Downloader *_downloader;
}

@property (nonatomic, retain) UIScrollView *contentView;
@property (nonatomic, retain) UIButton *registBT;

@property (nonatomic, retain) MBProgressHUD *activityView;


@end

@implementation HMRegistVC

@synthesize contentView;
@synthesize phoneNumTF;
@synthesize passwordTF;
@synthesize surewordTF;
@synthesize emailTF;
@synthesize registBT;
@synthesize activityView;


- (void)dealloc
{
    self.contentView = nil;
    self.registBT = nil;
    self.activityView = nil;
    _downloader = nil;
    [passwordTF release];
    [surewordTF release];
    [phoneNumTF release];
    [emailTF release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    Env *env = [Env sharedEnv];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = NSLocalizedString(@"pg.register.title", nil);
    
    NSString *leftBarName = NSLocalizedString(@"pg.button.return", nil);
    NSUInteger index =  [self.navigationController.viewControllers indexOfObject:self];
    if (index!=0) {
        UIViewController *upCtr = [self.navigationController.viewControllers objectAtIndex:index-1];
        NSString *upName =  upCtr.navigationItem.title;
        if (upName) {
            leftBarName = upName;
        }
    }
    
    self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_back.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_backdown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(cancelBT:)];
    
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [env cacheImage:@"mypangu_bg.jpg"];
    [self.view addSubview:bgImgView];
    [bgImgView release];
    
    self.contentView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    
    
    phoneNumTF = [[HMTextField alloc] initWithFrame:CGRectMake(15, 25, 275, 40)];
    phoneNumTF.backgroundColor = [UIColor clearColor];
    phoneNumTF.textField.font = [UIFont systemFontOfSize:17.0f];
    phoneNumTF.textField.placeholder = NSLocalizedString(@"user.acount.register.username", nil);
    phoneNumTF.textField.delegate = self;
    phoneNumTF.textField.returnKeyType = UIReturnKeyNext;
    [phoneNumTF.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    phoneNumTF.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    
    
    [self.contentView addSubview:phoneNumTF];
    
    
    passwordTF = [[HMTextField alloc] initWithFrame:CGRectMake(phoneNumTF.frame.origin.x, phoneNumTF.frame.origin.y+phoneNumTF.frame.size.height + 15,phoneNumTF.frame.size.width, phoneNumTF.frame.size.height)];
    passwordTF.backgroundColor = [UIColor clearColor];
    passwordTF.textField.font = [UIFont systemFontOfSize:17.0f];
    passwordTF.textField.placeholder = NSLocalizedString(@"pg.register.newpassowrd", nil);
    passwordTF.textField.delegate = self;
    passwordTF.textField.returnKeyType = UIReturnKeyNext;
    passwordTF.textField.keyboardType = UIKeyboardTypeDefault;
    passwordTF.textField.secureTextEntry = YES;
    [passwordTF.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:passwordTF];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(passwordTF.frame.origin.x, passwordTF.frame.origin.y+passwordTF.frame.size.height + 5,passwordTF.frame.size.width, 25)];
    noticeLabel.font = [UIFont systemFontOfSize:13.0f];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.lineBreakMode = UILineBreakModeWordWrap;
    noticeLabel.numberOfLines = 2;
    noticeLabel.text =  NSLocalizedString(@"pg.passwore.rule", nil);
    [self.contentView addSubview:noticeLabel];
    [noticeLabel release];
    
    surewordTF = [[HMTextField alloc] initWithFrame:CGRectMake(noticeLabel.frame.origin.x, noticeLabel.frame.origin.y+noticeLabel.frame.size.height + 5,passwordTF.frame.size.width, passwordTF.frame.size.height)];
    surewordTF.backgroundColor = [UIColor clearColor];
    surewordTF.textField.font = [UIFont systemFontOfSize:17.0f];
    surewordTF.textField.placeholder = NSLocalizedString(@"pg.register.passowrd.ensure", nil);
    surewordTF.textField.delegate = self;
    surewordTF.textField.returnKeyType = UIReturnKeyNext;
    surewordTF.textField.keyboardType = UIKeyboardTypeDefault;
    surewordTF.textField.secureTextEntry = YES;
    [surewordTF.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:surewordTF];
    
    
    emailTF = [[HMTextField alloc] initWithFrame:CGRectMake(surewordTF.frame.origin.x, surewordTF.frame.origin.y+surewordTF.frame.size.height + 15,surewordTF.frame.size.width, surewordTF.frame.size.height)];
    emailTF.backgroundColor = [UIColor clearColor];
    emailTF.textField.font = [UIFont systemFontOfSize:17.0f];
    emailTF.textField.placeholder = NSLocalizedString(@"pg.input.insureword", nil);
    emailTF.textField.delegate = self;
    emailTF.textField.returnKeyType = UIReturnKeyDone;
    emailTF.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [emailTF.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:emailTF];
    
    
    
    
    
    self.registBT =  [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumTF.frame),CGRectGetMaxY(emailTF.frame)+20,CGRectGetWidth(phoneNumTF.frame),60)] autorelease];
    self.registBT.backgroundColor =[UIColor clearColor];
    [self.registBT setTitle:NSLocalizedString(@"pg.user.register", nil) forState:UIControlStateNormal];
    [self.registBT setBackgroundImage:[env cacheScretchableImage:@"button_touch.png" X:20 Y:20] forState:UIControlEventTouchDown];
    [self.registBT setBackgroundImage:[env cacheScretchableImage:@"button_select.png" X:20 Y:20] forState:UIControlStateNormal];
    [self.registBT addTarget:self action:@selector(registUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.registBT];
    
    
    
    self.activityView = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    self.activityView.mode = MBProgressHUDModeIndeterminate;
    self.activityView.animationType = MBProgressHUDAnimationFade;
    self.activityView.opacity = 0.5;
    self.activityView.labelText = NSLocalizedString(@"user.acount.logoin.register", nil);
    [self.view addSubview:self.activityView];
    [self.activityView hide:YES];
    
    
    _downloader = [[Downloader alloc] init];
    
    
}

- (void)viewDidUnload
{
    [_downloader cancelAll];
    [_downloader release];
    _downloader = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_downloader cancelAll];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [super viewWillDisappear:animated];
}


- (void)cancelBT:(id)sender
{
    UIViewController *root = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    if (root == self) {
        [self dismissModalViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)onKeyboardShow:(NSNotification*)ntf {
    BqsLog(@"onKeyboardShow");
    if(_keyboardVisible) {
        BqsLog(@"keyboard already visible");
        return;
    }
    _keyboardVisible = YES;
    
    CGRect keyboardRect = [[[ntf userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[ntf userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // get size of keyboard
    NSDictionary *dic = [ntf userInfo];
    NSValue *val = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    if(nil == val) {
        //        val = [dic objectForKey:UIKeyboardBoundsUserInfoKey];
    }
    
    CGSize keyboardSize = keyboardRect.size;
    
    float fKeyboardHeight = keyboardSize.height;
    if(!UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        fKeyboardHeight = keyboardSize.width;
    }
    
    _contentOffset = self.contentView.contentOffset;
    _contentHeight = self.contentView.contentSize.height;
    
    // resize scroll view to make room for the keyboard
    //    CGRect viewFrame = self.contentView.frame;
    //    viewFrame.size.height -= keyboardSize.height;
    //    self.contentView.frame = viewFrame;
    CGSize ctSize = self.contentView.contentSize;
    ctSize.height = fKeyboardHeight + self.contentView.frame.size.height;
    //    self.contentView.contentSize = ctSize;
    
    
    HMTextField *tf = nil;
    if([self.phoneNumTF.textField isFirstResponder]) tf = self.phoneNumTF;
    else if([self.passwordTF.textField isFirstResponder]) tf = self.passwordTF;
    else if([self.surewordTF.textField isFirstResponder]) tf = self.surewordTF;
    else if([self.emailTF.textField isFirstResponder]) tf = self.emailTF;
    
    CGRect rcScr = [self.contentView convertRect:tf.frame toView:self.view];
    //    CGRect rcVisible = self.view.bounds;
    //
    //    if(rcVisible.size.height > fKeyboardHeight) rcVisible.size.height -= fKeyboardHeight;
    //
    //    if(CGRectContainsRect(rcVisible, rcScr)) return;
    //
    //    float h = 0.0;
    //
    //    if(rcScr.origin.y + rcScr.size.height > rcVisible.size.height) h = (rcScr.origin.y + rcScr.size.height)-rcVisible.size.height;
    //    else if(rcScr.origin.y < 0) h = - rcScr.origin.y;
    //
    //    CGPoint pt = CGPointMake(0, tf.frame.origin.y - h);
    //    //[self.contentView scrollRectToVisible:tf.frame animated:NO];
    //    [self.contentView setContentOffset:pt animated:YES];
    float h = 0.0;
    h = MAX((rcScr.origin.y - kPointArc), 0);
    CGRect frame = self.contentView.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    frame.origin.y = frame.origin.y - h;
    self.contentView.frame = frame;
    //    activityNotice.frame = activityFram;
    [UIView commitAnimations];
    
}

-(void)onKeyboardHide:(NSNotification*)aNotification {
    BqsLog(@"onKeyboardHide");
    if(!_keyboardVisible) {
        BqsLog(@"keyboard is not visible");
        return;
    }
    _keyboardVisible = NO;
    
    //    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.contentView.frame;
    
    //    CGRect activityFram = activityNotice.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    frame.origin.y =0;
    self.contentView.frame = frame;
    [UIView commitAnimations];
    
}


- (void)keyboardFrameChange:(NSNotification *)aNotification
{
    
    //    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat chHeight = keyboardRect.size.height - _keyHeight;
    //    CGRect frame = self.contentView.frame;
    //    frame.size.height -= chHeight;
    //    self.contentView.frame = frame;
    //
    //    _keyHeight = keyboardRect.size.height;
    
    
}


#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    HMTextField *pgTxt = nil;
    
    if (textField == phoneNumTF.textField) {
        pgTxt = phoneNumTF;
        
    }else if(textField == passwordTF.textField){
        pgTxt = passwordTF;
    }else if(textField == surewordTF.textField){
        pgTxt = surewordTF;
    }else if(textField == emailTF.textField){
        pgTxt = emailTF;
    }
    if(_keyboardVisible){
        [self actitvFieldChange:pgTxt];
    }
    
    if (!textField.text || textField.text.length == 0) {
        return;
    }
    
    pgTxt.clean.hidden = NO;
    
    
    
    
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *) sender;
    HMTextField *pgTxt = nil;
    
    if (textField == phoneNumTF.textField) {
        pgTxt = phoneNumTF;
    }else if(textField == passwordTF.textField){
        pgTxt = passwordTF;
    }else if(textField == surewordTF.textField){
        pgTxt = surewordTF;
    }else if(textField == emailTF.textField){
        pgTxt = emailTF;
    }
    
    if (!textField.text || textField.text.length == 0) {
        pgTxt.clean.hidden = YES;
    }else{
        pgTxt.clean.hidden = NO;
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == phoneNumTF.textField) {
        phoneNumTF.clean.hidden = YES;
        
    }else if(textField == passwordTF.textField){
        passwordTF.clean.hidden = YES;
    }else if(textField == surewordTF.textField){
        surewordTF.clean.hidden = YES;
    }else if(textField == emailTF.textField){
        emailTF.clean.hidden = YES;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == phoneNumTF.textField) {
        [passwordTF.textField becomeFirstResponder];
        [self actitvFieldChange:passwordTF];
    }else if(textField == passwordTF.textField){
        [surewordTF.textField becomeFirstResponder];
        [self actitvFieldChange:surewordTF];
    }else if(textField == surewordTF.textField){
        [emailTF.textField becomeFirstResponder];
        [self actitvFieldChange:emailTF];
    }
    
    [textField resignFirstResponder];
    
    return YES;
    
}


- (void)actitvFieldChange:(HMTextField *)textField{
    CGRect rcScr = textField.frame;
    float h = 0.0;
    h = MAX((rcScr.origin.y - kPointArc), 0);
    CGRect frame = self.contentView.bounds;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    frame.origin.y = frame.origin.y - h;
    self.contentView.frame = frame;
    [UIView commitAnimations];
    
    
}





- (void)registUser:(id)sender
{
    [phoneNumTF.textField resignFirstResponder];
    [passwordTF.textField resignFirstResponder];
    [surewordTF.textField resignFirstResponder];
    [emailTF.textField resignFirstResponder];
    
    
    
    NSString *phoneNum = self.phoneNumTF.textField.text;
    if (!phoneNum || [phoneNum isEqualToString:@""]) {
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.input.mobilenumber", nil)];
        return;
    }
    
    NSString * regex1        = @"([^`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]{4,11}$)";
    NSPredicate * pred1     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch1            = [pred1 evaluateWithObject:phoneNum];
    
    
    
    if (!isMatch1) {
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.input.mobilenumber", nil)];
        return;
    }
    
    
    
    NSString *newpwd = passwordTF.textField.text;
    if(!newpwd||[newpwd isEqualToString:@""]){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.input.mobilenumber", nil)];
        return;
    }
    
    NSString * regex        = @"(.{6,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:newpwd];
    if(!isMatch){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.input.mobilenumber", nil)];
        
        return;
    }
    
    
    NSString *surepwd = surewordTF.textField.text;
    if(!surepwd||[surepwd isEqualToString:@""]){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.input.mobilenumber", nil)];
        return;
    }
    
    if (![newpwd isEqualToString:surepwd]) {
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.input.mobilenumber", nil)];
        return;
    }
    
    NSString *email = self.emailTF.textField.text;
    
    NSString * regex2        = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * pred2      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL isMatch2            = [pred2 evaluateWithObject:email];
    
    if (!isMatch2) {
        email = nil;
    }
    
    
    
    
    [HumDotaNetOps registerDownloader:_downloader username:phoneNum password:newpwd eMail:email PkgFile:nil Target:self Sel:@selector(userRegistCB:) Attached:nil];
    [self.activityView show:YES];
    [HumDotaUserCenterOps setObjectValue:phoneNum forKey:kDftUserName];
    [HumDotaUserCenterOps setObjectValue:newpwd forKey:kDftUserPassword];
    
    
}

- (void)userRegistCB:(DownloaderCallbackObj *)cb
{
    
    [self.activityView hide:YES];
    [HumDotaUserCenterOps saveBoolVaule:FALSE forKye:kDftUserLogoinStatus];
    
	if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
       [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
		return;
	}
    
	// parse xml
	Status  *info = [Status parseXmlData:cb.rspData];
    
    if (!info.code) {
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"news.error.networkfailed", nil) Delegate:nil];
        return;
    }
    
    [HumDotaUserCenterOps setObjectValue:info.passport forKey:kDftUserReallyPassport];
    [HumDotaUserCenterOps saveBoolVaule:TRUE forKye:kDftUserLogoinStatus];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:info.msg
                                                   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"pangu.all.sure", nil)
										  otherButtonTitles: nil];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
