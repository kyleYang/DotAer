//
//  PanguLogoinViewController.m
//  pangu
//
//  Created by yang zhiyun on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMLogoinViewController.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "Downloader.h"
#import "HMRegistVC.h"
#import "HMPasswordChangeVC.h"
#import "HMPopMsgView.h"
#import "CustomUIBarButtonItem.h"
#import "BqsUtils.h"
#import "Env.h"
#import "MTStatusBarOverlay.h"
#import "HMTextField.h"
#import "MBProgressHUD.h"
#import "Status.h"
#import "HumDotaUserCenterOps.h"



#define kPointArc 60


@interface HMLogoinViewController ()<MTStatusBarOverlayDelegate>
{
    int _logoinTask;
    BOOL _keyboardVisible;
    MTStatusBarOverlay *_overlay;
}

@property (nonatomic, retain) Downloader *download;
@property (nonatomic, retain) HMTextField *usernameField;
@property (nonatomic, retain) HMTextField *passwordField;

@property (nonatomic, retain) MBProgressHUD *activityView;

@end

@implementation HMLogoinViewController
@synthesize download;
@synthesize usernameField;
@synthesize passwordField;
@synthesize myDelegate;
@synthesize isRoot;
@synthesize action;
@synthesize contentView;
@synthesize activityView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isRoot = FALSE;
    }
    return self;
}

- (void)dealloc
{
    BqsLog(@"dealloc");
    self.download = nil;
    self.usernameField = nil;
    self.passwordField = nil;
    self.myDelegate = nil;
    self.contentView = nil;
    self.activityView = nil;
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Env *env = [Env sharedEnv];
    
    self.navigationItem.title = NSLocalizedString(@"user.acount.logoin.title", nil);
    
    NSString *leftBarName = NSLocalizedString(@"button.back", nil);
    
    
    self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_back.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_backdown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(returnHomePage)];
    
    self.navigationItem.rightBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_done.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_donedown.png" X:kBarStrePosX Y:kBarStrePosY] title:NSLocalizedString(@"pg.forget.password", nil) target:self action:@selector(forgetPwd)];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [env cacheImage:@"mypangu_bg.jpg"];
    [self.view addSubview:bgImgView];
    [bgImgView release];
    
    self.contentView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    [self.view addSubview:self.contentView];
    
    
    
    
    self.usernameField = [[[HMTextField alloc] initWithFrame:CGRectMake(20, 25, 270, 40)] autorelease];
    self.usernameField.backgroundColor = [UIColor clearColor];
    self.usernameField.textField.placeholder = NSLocalizedString(@"user.acount.logoin.name", nil);
    self.usernameField.textField.returnKeyType = UIReturnKeyNext;
    self.usernameField.textField.font = [UIFont systemFontOfSize:17.0f];
    self.usernameField.textField.delegate = self;
    [self.usernameField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.contentView addSubview:self.usernameField];
    
    self.passwordField = [[[HMTextField alloc] initWithFrame:CGRectMake(self.usernameField.frame.origin.x, self.usernameField.frame.origin.y+self.usernameField.frame.size.height+15, self.usernameField.frame.size.width, self.usernameField.frame.size.height)] autorelease];
    self.passwordField.textField.placeholder = NSLocalizedString(@"user.acount.logoin.passowrd", nil);
    self.passwordField.textField.delegate = self;
    self.passwordField.backgroundColor = [UIColor clearColor];
    self.passwordField.textField.returnKeyType = UIReturnKeyDone;
    self.passwordField.textField.font = [UIFont systemFontOfSize:17.0f];
    self.passwordField.textField.secureTextEntry = YES;
    [self.passwordField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.contentView addSubview:self.passwordField];
    
    
    
    UIButton *logoButton = [[UIButton alloc] initWithFrame:CGRectMake(self.passwordField.frame.origin.x, CGRectGetMaxY(self.passwordField.frame)+20, CGRectGetWidth(self.passwordField.frame),40)];
    logoButton.backgroundColor = [UIColor clearColor];
    [logoButton setTitle:NSLocalizedString(@"user.acount.logoin.btn", nil) forState:UIControlStateNormal];
    [logoButton setBackgroundImage:[env cacheScretchableImage:@"button_touch.png" X:20 Y:20] forState:UIControlEventTouchDown];
    [logoButton setBackgroundImage:[env cacheScretchableImage:@"button_select.png"  X:20 Y:20] forState:UIControlStateNormal];
    [logoButton addTarget:self action:@selector(userLogoin) forControlEvents:UIControlEventTouchUpInside];
     logoButton.selected = NO;
    [self.contentView addSubview:logoButton];
    [logoButton release];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(logoButton.frame),  CGRectGetMaxY(logoButton.frame)+20,CGRectGetWidth(logoButton.frame),CGRectGetHeight(logoButton.frame))];
    registerButton.backgroundColor = [UIColor clearColor];
    [registerButton setBackgroundImage:[env cacheScretchableImage:@"button_touch.png" X:20 Y:20] forState:UIControlEventTouchDown];
    [registerButton setBackgroundImage:[env cacheScretchableImage:@"button_normal.png" X:20 Y:20] forState:UIControlStateNormal];
    [registerButton setTitle:NSLocalizedString(@"user.acount.logoin.register", nil) forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.selected = NO;
    [self.contentView addSubview:registerButton];
    [registerButton release];
    
    
    self.activityView = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.activityView.mode = MBProgressHUDModeIndeterminate;
    self.activityView.animationType = MBProgressHUDAnimationZoom;
    self.activityView.opacity = 0.5;
    self.activityView.labelText = NSLocalizedString(@"user.acount.logoin.logoining", nil);
    [self.view  addSubview:self.activityView];
    [self.activityView hide:YES];
    
    
    self.download = [[[Downloader alloc] init]autorelease];
    _logoinTask = -1;
}

- (void)viewDidUnload
{
    BqsLog(@"viewDidUnload");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.download cancelAll];
    self.download = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    BqsLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardDidShowNotification object:nil];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    BqsLog(@"viewWillDisappear");
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
    
    
    // resize scroll view to make room for the keyboard
    //    CGRect viewFrame = self.contentView.frame;
    //    viewFrame.size.height -= keyboardSize.height;
    //    self.contentView.frame = viewFrame;
    CGSize ctSize = self.contentView.contentSize;
    ctSize.height = fKeyboardHeight + self.contentView.frame.size.height;
    //    self.contentView.contentSize = ctSize;
    
    
    HMTextField *tf = nil;
    if([self.passwordField.textField isFirstResponder]) tf = self.passwordField;
    else if([self.passwordField.textField isFirstResponder]) tf = self.passwordField;
    
    
    
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
    
    if (textField == self.usernameField.textField) {
        pgTxt = self.usernameField;
        
    }else if(textField == self.passwordField.textField){
        pgTxt = self.passwordField;
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
    HMTextField *pgText = nil;
    
    if (textField == self.usernameField.textField) {
        pgText = self.usernameField;
        
    }else if(textField == self.passwordField.textField){
        pgText = self.passwordField;
    }
    
    if (!textField.text || textField.text.length == 0) {
        pgText.clean.hidden = YES;
    }else{
        pgText.clean.hidden = NO;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.usernameField.textField) {
        self.usernameField.clean.hidden = YES;
        
    }else if(textField == self.passwordField.textField){
        self.passwordField.clean.hidden = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameField.textField) {
        [self.passwordField.textField becomeFirstResponder];
        [self actitvFieldChange:self.passwordField];
    }else if(textField == self.passwordField.textField){
        [self userLogoin];
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
    [[self retain] autorelease];
    UIViewController *root = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    if (root == self) {
        [self dismissModalViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([myDelegate respondsToSelector:@selector(logoin:action:)])
        [myDelegate logoin:FALSE action:action];
    return;
    
    //    if(self.isRoot){
    //         [self dismissModalViewControllerAnimated:YES];
    //
    //    }else
    //        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark My Method
- (void)userRegister:(id)sender
{
    [self.usernameField.textField resignFirstResponder];
    [self.passwordField.textField resignFirstResponder];
    HMRegistVC *resgistVC = [[HMRegistVC alloc] init];
    [self.navigationController pushViewController:resgistVC animated:YES];
    [resgistVC release];
}

- (void)forgetPwd
{
    [self.usernameField.textField resignFirstResponder];
    [self.passwordField.textField resignFirstResponder];
    
    HMPasswordChangeVC *getPwdVC = [[HMPasswordChangeVC alloc] init];
    [self.navigationController pushViewController:getPwdVC animated:YES];
    [getPwdVC release];
}



- (void)userLogoin
{
    [self.usernameField.textField resignFirstResponder];
    [self.passwordField.textField resignFirstResponder];
    NSString *username = self.usernameField.textField.text;
    if (!username) {
        
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.logoin.input.username", nil)];
        return;
        
    }
    
    NSString *password = self.passwordField.textField.text;
    if(!password){
        [HMPopMsgView showPopMsg:NSLocalizedString(@"pg.logoin.inputpassord", nil)];
        return;
    }
    
    _logoinTask = [HumDotaNetOps logoinDownloader:self.download username:self.usernameField.textField.text password:self.passwordField.textField.text PkgFile:nil Target:self Sel:@selector(logoStateCheck:) Attached:nil]; // test username 13751126612  password 4045191
    [self.activityView show:YES];
    [HumDotaUserCenterOps setObjectValue:self.usernameField.textField.text forKey:kDftUserName];
    [HumDotaUserCenterOps setObjectValue:self.passwordField.textField.text forKey:kDftUserPassword];
    BqsLog(@"logoin username : %@, password :%@",self.usernameField.textField.text,self.passwordField.textField.text);
}

#pragma mark 网络回调
- (void)logoStateCheck:(DownloaderCallbackObj*)cb
{
    [HumDotaUserCenterOps saveBoolVaule:FALSE forKye:kDftUserLogoinStatus];

    [self.activityView hide:YES];
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"news.error.networkfailed", nil) Delegate:nil];
		return;
	}
    
    
    
    Status  *logoInfo = [Status parseXmlData:cb.rspData];
    if (!logoInfo.code) {
        [HMPopMsgView showPopMsg:logoInfo.msg];
        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
        overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
        overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
        _overlay = overlay;
        overlay.progress = 0.0;
        overlay.screenType = MTStatusBarRightScreen;
        [overlay postErrorMessage:NSLocalizedString(@"pg.logoin.failed", nil) duration:3 animated:YES];
        return;
    }
    
    
    [HumDotaUserCenterOps saveBoolVaule:TRUE forKye:kDftUserLogoinStatus];

    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    _overlay = overlay;
    overlay.progress = 0.0;
    overlay.screenType = MTStatusBarRightScreen;
    [overlay postFinishMessage:NSLocalizedString(@"pg.logoin.success", nil) duration:3 animated:YES];
    
    [HumDotaUserCenterOps setObjectValue:logoInfo.passport forKey:kDftUserReallyPassport];
    
    
    BqsLog(@"login success in PanguLogoinViewController");
    UIViewController *root = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    [[self retain] autorelease];
    
    if(self == root){
        [self.navigationController dismissModalViewControllerAnimated:NO];
    }else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
    if([myDelegate respondsToSelector:@selector(logoin:action:)])
        [myDelegate logoin:TRUE action:action];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}




@end
