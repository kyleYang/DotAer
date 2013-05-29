//
//  PanguPasswordChangeVC.m
//  pangu
//
//  Created by yang zhiyun on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMPasswordChangeVC.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "Downloader.h"
#import "BqsUtils.h"
#import "Status.h"
#import "HMPopMsgView.h"
#import "Env.h"
#import "MBProgressHUD.h"
#import "CustomUIBarButtonItem.h"
#import "HMTextField.h"
#import "HumDotaUserCenterOps.h"

#define kPointArc 100


@interface HMPasswordChangeVC ()<UIAlertViewDelegate>
{
    UIActivityIndicatorView *_activityView;
    BOOL _keyboardVisible;
    CGPoint _contentOffset; // save to restore content view location
    float _contentHeight;// save to restore content view location

    HMTextField *phoneNumTF;
    HMTextField *oldPsField;
    HMTextField *thenewPasField;
    HMTextField *surePsField;
    Downloader *_downloader;
    MBProgressHUD * activityNotice;
}
@property (nonatomic, retain) UIScrollView *contentView;
@property (nonatomic, retain) HMTextField *phoneNumTF; 
@property (nonatomic, retain) HMTextField *oldPsField;
@property (nonatomic, retain) HMTextField *thenewPasField;
@property (nonatomic, retain) HMTextField *surePsField;
@end


@implementation HMPasswordChangeVC
@synthesize contentView;
@synthesize phoneNumTF;
@synthesize oldPsField;
@synthesize thenewPasField;
@synthesize surePsField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [oldPsField release];
    [thenewPasField release];
    [surePsField release];
    [phoneNumTF release];
    self.contentView = nil;
    [_activityView release];
    _activityView = nil;
    _downloader = nil;
    [activityNotice release];
    activityNotice = nil;
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Env *env = [Env sharedEnv];
    
    
    NSString *leftBarName = NSLocalizedString(@"pg.button.return", nil);
    NSUInteger index =  [self.navigationController.viewControllers indexOfObject:self];
    if (index!=0) {
        UIViewController *upCtr = [self.navigationController.viewControllers objectAtIndex:index-1];
        NSString *upName =  upCtr.navigationItem.title;
        if (upName) {
            leftBarName = upName;
        }
    }
    
    self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_back.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_backdown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(returnHomePage)];

    self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_done.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_donedown.png" X:kBarStrePosX Y:kBarStrePosY]  title:NSLocalizedString(@"pg.password.alter", nil) target:self action:@selector(changePassword)];

   
    self.navigationItem.title = NSLocalizedString(@"pg.password.title", nil);
    
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

    
 
    oldPsField = [[HMTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumTF.frame),CGRectGetMaxY(phoneNumTF.frame)+10,CGRectGetWidth(phoneNumTF.frame),CGRectGetHeight(phoneNumTF.frame))];
    oldPsField.backgroundColor = [ UIColor clearColor];
    oldPsField.textField.placeholder = NSLocalizedString(@"pg.password.old", nil);
    oldPsField.textField.delegate = self;
    oldPsField.textField.keyboardType = UIKeyboardTypeDefault;
    oldPsField.textField.returnKeyType = UIReturnKeyNext;
    oldPsField.textField.secureTextEntry = YES;
    [oldPsField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:oldPsField];
    
    thenewPasField = [[HMTextField alloc] initWithFrame:CGRectMake(oldPsField.frame.origin.x, oldPsField.frame.origin.y+oldPsField.frame.size.height + 10,oldPsField.frame.size.width, oldPsField.frame.size.height)];
    thenewPasField.backgroundColor = [UIColor clearColor];
    thenewPasField.textField.placeholder = NSLocalizedString(@"pg.password.new", nil);
    thenewPasField.textField.delegate = self;
    thenewPasField.textField.keyboardType = UIKeyboardTypeDefault;
    thenewPasField.textField.returnKeyType = UIReturnKeyNext;
    thenewPasField.textField.secureTextEntry = YES;
    [thenewPasField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:thenewPasField];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(thenewPasField.frame.origin.x, thenewPasField.frame.origin.y+thenewPasField.frame.size.height + 5,thenewPasField.frame.size.width, 40)];
    noticeLabel.font = [UIFont systemFontOfSize:15.0f];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.lineBreakMode = UILineBreakModeWordWrap;
    noticeLabel.numberOfLines = 2;
    noticeLabel.text =  NSLocalizedString(@"pg.passwore.rule", nil);
    [self.contentView addSubview:noticeLabel];
    [noticeLabel release];

    
    surePsField = [[HMTextField alloc] initWithFrame:CGRectMake(noticeLabel.frame.origin.x, noticeLabel.frame.origin.y+noticeLabel.frame.size.height + 5,oldPsField.frame.size.width, oldPsField.frame.size.height)];
    surePsField.backgroundColor = [UIColor clearColor];
    surePsField.textField.placeholder = NSLocalizedString(@"pg.password.new.alt", nil);
    surePsField.textField.delegate = self;
    surePsField.textField.keyboardType = UIKeyboardTypeDefault;
    surePsField.textField.returnKeyType = UIReturnKeyDone;
    surePsField.textField.secureTextEntry = YES;
    [surePsField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:surePsField];
    
    
    
    
    activityNotice = [[MBProgressHUD alloc] initWithView:self.view];
    activityNotice.mode = MBProgressHUDModeIndeterminate;
    activityNotice.animationType = MBProgressHUDAnimationFade;
    activityNotice.opacity = 0.5;
    activityNotice.labelText = NSLocalizedString(@"pg.loading.more", nil);
    [self.view addSubview:activityNotice];
    [activityNotice hide:YES];


    _downloader = [[Downloader alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
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
    if([phoneNumTF.textField isFirstResponder]) tf = phoneNumTF;
    else if([oldPsField.textField isFirstResponder]) tf = oldPsField;
    else if([thenewPasField.textField isFirstResponder]) tf = thenewPasField;
    else if([surePsField.textField isFirstResponder]) tf = surePsField;
    
    
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
    
    if (textField == oldPsField.textField) {
        pgTxt = oldPsField;
        
    }else if(textField == thenewPasField.textField){
        pgTxt = thenewPasField;
    }else if(textField == surePsField.textField){
        pgTxt = surePsField;
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
    
    if (textField == oldPsField.textField) {
        pgTxt = oldPsField;
    }else if(textField == thenewPasField.textField){
        pgTxt = thenewPasField;
    }else if(textField == surePsField.textField){
        pgTxt = surePsField;
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
    }else if (textField == oldPsField.textField) {
        oldPsField.clean.hidden = YES;
    }else if(textField == thenewPasField.textField){
        thenewPasField.clean.hidden = YES;
    }else if(textField == surePsField.textField){
        surePsField.clean.hidden = YES;
    }    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == phoneNumTF.textField) {
        [oldPsField.textField becomeFirstResponder];
        [self actitvFieldChange:thenewPasField];
    } else if (textField == oldPsField.textField) {
        [thenewPasField.textField becomeFirstResponder];
        [self actitvFieldChange:thenewPasField];
    }else if(textField == thenewPasField.textField){
        [surePsField.textField becomeFirstResponder];
        [self actitvFieldChange:surePsField];
    }else if(textField == surePsField.textField){
        [self changePassword];
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




- (void)returnHomePage
{
    UIViewController *root = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    if (root == self) {
        [self dismissModalViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changePassword
{
    
    [phoneNumTF.textField resignFirstResponder];
    [oldPsField.textField resignFirstResponder];
    [thenewPasField.textField resignFirstResponder];
    [surePsField.textField resignFirstResponder];
    
    
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

    
    NSString *oldpwd = oldPsField.textField.text;
    if(!oldpwd||[oldpwd isEqualToString:@""]){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.passwrod.old.input", nil)];
        return;
    }
    
    NSString *email = oldPsField.textField.text;
    
    NSString * regex2        = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * pred2      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL isMatch2            = [pred2 evaluateWithObject:email];
    
   
    
    NSString *newpwd = thenewPasField.textField.text;
    if(!newpwd||[newpwd isEqualToString:@""]){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.passwrod.old.input", nil)];
        return;
    }
    
    NSString * regex        = @"(.{6,16}$)";  
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
    BOOL isMatch            = [pred evaluateWithObject:newpwd];
    if(!isMatch){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.passwrod.old.input", nil)];
        return;
    }
    
    NSString *surepwd = surePsField.textField.text;
    if(!surepwd||[surepwd isEqualToString:@""]){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.passwrod.old.input", nil)];
        return;
    }

    if (![newpwd isEqualToString:surepwd]) {
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.passwrod.old.input", nil)];
        return;
    }
    
    if (isMatch2) {
        [HumDotaNetOps changePasswordDownloader:_downloader username:phoneNum newPassword:newpwd eMail:email PkgFile:nil Target:self Sel:@selector(changePwdCB:) Attached:nil];
    }else{
          [HumDotaNetOps changePasswordDownloader:_downloader username:phoneNum newPassword:newpwd oldPassword:email PkgFile:nil Target:self Sel:@selector(changePwdCB:) Attached:nil];
    }
    
    [activityNotice show:YES];
    [HumDotaUserCenterOps setObjectValue:phoneNum forKey:kDftUserName];
    [HumDotaUserCenterOps setObjectValue:newpwd forKey:kDftUserPassword];
}


#pragma mark dowloader callback

- (void)changePwdCB:(DownloaderCallbackObj *)cb
{
    [activityNotice hide:YES];    
     [HumDotaUserCenterOps saveBoolVaule:FALSE forKye:kDftUserLogoinStatus];
	if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
		return;
	}
    
	// parse xml
    Status *info = [Status parseXmlData:cb.rspData];
    
    if (!info.code) {
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
        return;
    }
    
    [HumDotaUserCenterOps setObjectValue:info.passport forKey:kDftUserReallyPassport];
    [HumDotaUserCenterOps saveBoolVaule:TRUE forKye:kDftUserLogoinStatus];       
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"pg.password.newword.success", nil)
                                                   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"pangu.all.sure", nil)
										  otherButtonTitles: nil];	
    [alert show];
    [alert release];

    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
