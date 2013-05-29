//
//  MptAboutViewController.m
//  TVGuide
//
//  Created by Zhanggq on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HumAboutViewController.h"
#import "Env.h"
#import "BqsUtils.h"
#import "HumDotaUIOps.h"
#import "BqsTextView.h"
#import <MessageUI/MessageUI.h>
#import "BqsRoundLeftArrowButton.h"
#import "CustomUIBarButtonItem.h"
#import "PKRevealController.h"

#pragma mark - SetButtonView Class
@interface SegButtonView : UIControl{
    UIImageView *_backgrouView;
    UIImage *_norImage;
    UIImage *_selectImage;
    UILabel *_btnTitle;
}

- (void)setTitle:(NSString *)aTitle;
@end

@implementation SegButtonView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        _norImage = [[[Env sharedEnv] cacheImage:@"about_button_normal.png"] retain];
        _selectImage = [[[Env sharedEnv] cacheImage:@"about_button_selected.png"] retain];
        _backgrouView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backgrouView.contentStretch = CGRectMake(0, 0, _norImage.size.width / frame.size.width, _norImage.size.height / frame.size.height);
        [self addSubview:_backgrouView];
        
        _btnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _btnTitle.backgroundColor = [UIColor clearColor];
        _btnTitle.textColor = [UIColor whiteColor];
        _btnTitle.textAlignment = UITextAlignmentCenter;
        [self addSubview:_btnTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected){
        _backgrouView.image = _selectImage;
    }else {
        _backgrouView.image = _norImage;
    }
    [super setSelected:selected];
}

- (void)setTitle:(NSString *)aTitle{
    if (_btnTitle == nil){
        return;
    }
    _btnTitle.text = aTitle;
}

- (void)dealloc{
    [_norImage release];
    [_selectImage release];
    [_backgrouView release];
    [_btnTitle release];
    [super dealloc];
}
@end


#pragma mark - CustomLabel Class
@interface CustomLabel : UIView{
    UILabel *_promptLabel;
    UILabel *_contentLabel;
}
- (void) setPromptTitle:(NSString *)value1 contentTitle:(NSString *)value2;
@end

@implementation CustomLabel
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
        _promptLabel.textAlignment = UITextAlignmentLeft;
        _promptLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_promptLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
        _contentLabel.textAlignment = UITextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void) setPromptTitle:(NSString *)value1 contentTitle:(NSString *)value2{
    if (value1 == nil || value2 == nil){
        return;
    }
    _promptLabel.text = value1;
    [_promptLabel sizeToFit];
    
    CGRect rect = _promptLabel.frame;
    rect.origin.x = CGRectGetMaxX(_promptLabel.frame);
    rect.size.width = CGRectGetWidth(self.frame) - CGRectGetWidth(_promptLabel.frame);
    _contentLabel.frame = rect;
    
    _contentLabel.text = value2;
}

- (void)dealloc{
    [_promptLabel release];
    [_contentLabel release];
    [super dealloc];
}

@end

#pragma mark - MptAboutViewController Class
@interface HumAboutViewController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic, copy) NSString *strWebDisplay;
@property (nonatomic, copy) NSString *strWebClick;
@property (nonatomic, copy) NSString *strPhone;
@property (nonatomic, copy) NSString *strEmail;


@property (nonatomic, retain) SegButtonView *introduceButton;
@property (nonatomic, retain) SegButtonView *agreementButton;
@property (nonatomic, retain) CustomLabel *webLabel;
@property (nonatomic, retain) CustomLabel *phoneLabel;
@property (nonatomic, retain) CustomLabel *emailLabel;
@property (nonatomic, retain) CustomLabel *copyrightLabel;
@property (nonatomic, retain) BqsTextView *introduceContentLabel;
@property (nonatomic, retain) BqsTextView *agreeContentLabel;

- (void)onLeftBackButtonClick;
- (void)onIntroduceButtonClick;
- (void)onAgreementButtonClick;
- (void)onMaskWebButtonClick;
- (void)onMaskPhoneButtonClick;
- (void)onMaskEmailButtonClick;

@end

@implementation HumAboutViewController
@synthesize introduceButton;
@synthesize agreementButton;
@synthesize webLabel;
@synthesize emailLabel;
@synthesize phoneLabel;
@synthesize copyrightLabel;
@synthesize introduceContentLabel;
@synthesize agreeContentLabel;

@synthesize strWebDisplay;
@synthesize strWebClick;
@synthesize strPhone;
@synthesize strEmail;


- (void)loadView{
    [super loadView];
    
    Env *env = [Env sharedEnv];
    // navView
    {
        self.navigationItem.title = NSLocalizedString(@"about.view.title", nil);
        
         NSString *leftBarName = NSLocalizedString(@"button.back", nil);
        //LeftBack Button;
        self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:[env cacheScretchableImage:@"pg_bar_back.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[env cacheScretchableImage:@"pg_bar_backdown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(onLeftBackButtonClick)];

        

//        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"button.goback", @"commonlib",nil)  style:UIBarButtonItemStylePlain target:self action:@selector(onLeftBackButtonClick)];
//        self.navigationItem.leftBarButtonItem = leftButton;
//        [leftButton release];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    CGRect rect = CGRectZero;
    
    
    // load values
    // get default host from property.plist
	NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:
								[[NSBundle mainBundle] pathForResource:@"property" ofType:@"plist"]];
	if(nil != properties) {
        self.strWebDisplay = [properties objectForKey:@"about_website"];
        self.strWebClick = [properties objectForKey:@"about_website_click"];
		self.strPhone = [properties objectForKey:@"about_phone"];
        self.strEmail = [properties objectForKey:@"about_mail"];
	}

    // buttons
    {
        rect.origin.x = 10;
        rect.origin.y = 10;
        rect.size.width = (CGRectGetWidth(self.view.frame) - 2 * rect.origin.x) / 2;
        rect.size.height = 34;
        self.introduceButton = [[[SegButtonView alloc] initWithFrame:rect] autorelease];
        self.introduceButton.selected = YES;
        [self.introduceButton setTitle:NSLocalizedString(@"about.segbtn.introduce.title", nil)];
        [self.introduceButton addTarget:self action:@selector(onIntroduceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.introduceButton];
        
        rect = self.introduceButton.frame;
        rect.origin.x = CGRectGetMaxX(self.introduceButton.frame);
        self.agreementButton = [[[SegButtonView alloc] initWithFrame:rect] autorelease];
        self.agreementButton.selected = NO;
        [self.agreementButton setTitle:NSLocalizedString(@"about.segbtn.agreement.title", nil)];
        [self.agreementButton addTarget:self action:@selector(onAgreementButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.agreementButton];
    }
    
    // introduceView
    {
        rect.origin.x = 0;
        rect.origin.y = CGRectGetMaxY(self.introduceButton.frame) + 10;
        rect.size.width = CGRectGetWidth(self.view.frame);
        rect.size.height = CGRectGetHeight(self.view.frame) - rect.origin.y - CGRectGetHeight(self.navigationController.navigationBar.frame);
        _introduceView = [[UIView alloc] initWithFrame:rect];
        _introduceView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_introduceView];
    }
    
    // thumbView;
//    {
//        rect.origin.x = 0;
//        rect.origin.y = 0;
//        rect.size.width = CGRectGetWidth(self.view.frame);
//        rect.size.height = 112;
//        _thumbView = [[UIImageView alloc] initWithFrame:rect];
//        _thumbView.backgroundColor = [UIColor clearColor];
//        _thumbView.image = [ev cacheImage:@"about_conent_bg.png"];
//        [_introduceView addSubview:_thumbView];
//        
//        //versionView
//        {
//            rect.origin.x = 140;
//            rect.origin.y = 75;
//            UILabel *versionTitle = [[UILabel alloc] initWithFrame:CGRectMake(140, 75, 35, 12)];
//            versionTitle.backgroundColor = [UIColor clearColor];
//            versionTitle.textColor = [UIColor whiteColor];
//            versionTitle.textAlignment = UITextAlignmentLeft;
//            versionTitle.font = [UIFont systemFontOfSize:12];
//            versionTitle.text = NSLocalizedString(@"about.version.title", nil);
//            [versionTitle sizeToFit];
//            [_thumbView addSubview:versionTitle];
//            [versionTitle release];
//            
//            
//            _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(versionTitle.frame) + 5, 75, 143, 14)];
//            _versionLabel.backgroundColor = [UIColor clearColor];
//            _versionLabel.textAlignment = UITextAlignmentLeft;
//            _versionLabel.textColor = [UIColor whiteColor];
//            _versionLabel.font = [UIFont systemFontOfSize:14];
//            _versionLabel.text = [Env sharedEnv].swVersion;
//            [_thumbView addSubview:_versionLabel];
//        }
//    }
    
    // introduce
    {
        CGFloat introduceMaxHeight = CGRectGetHeight(_introduceView.frame) - CGRectGetMaxY(_thumbView.frame) - 10 - 4 * 14 - 4 * 12;
        
        rect.origin.x = 0;
        rect.origin.y =  10;
        rect.size.width = CGRectGetWidth(self.view.frame);
        rect.size.height = introduceMaxHeight;
        _introduceSrcollView = [[UIScrollView alloc] initWithFrame:rect];
        _introduceSrcollView.showsVerticalScrollIndicator = YES;
        _introduceSrcollView.showsHorizontalScrollIndicator = NO;
        _introduceSrcollView.backgroundColor = [UIColor clearColor];
        _introduceSrcollView.contentOffset = CGPointMake(0, 0);
        
        
        rect.origin.x = 20;
        rect.origin.y = 0;
        rect.size.width = CGRectGetWidth(_introduceSrcollView.frame) - rect.origin.x - 10;
        rect.size.height = 1024;
        self.introduceContentLabel = [[[BqsTextView alloc] initWithFrame:rect] autorelease];
        self.introduceContentLabel.backgroundColor = [UIColor clearColor];
        self.introduceContentLabel.txtColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
        self.introduceContentLabel.txtFont = [UIFont systemFontOfSize:14];
        self.introduceContentLabel.fMarginHori = 0;
        self.introduceContentLabel.fMarginVer = 0;
        self.introduceContentLabel.fLineGap = 5;
        self.introduceContentLabel.strContent = NSLocalizedString(@"about.product.introduce", nil);
        
        CGFloat viewHeight = [self.introduceContentLabel getPageHeight];
        if (viewHeight <= introduceMaxHeight){
            rect.size.height = viewHeight;
            self.introduceContentLabel.frame = rect;
            [_introduceSrcollView addSubview:self.introduceContentLabel];
            
            rect = _introduceSrcollView.frame;
            rect.size.height = viewHeight;
            _introduceSrcollView.frame = rect;
            _introduceSrcollView.contentSize = CGSizeMake(rect.size.width, rect.size.height);
            [_introduceView addSubview:_introduceSrcollView];
            
        }else {
            rect.size.height = viewHeight;
            self.introduceContentLabel.frame = rect;
            [_introduceSrcollView addSubview:self.introduceContentLabel];
            
            rect = _introduceSrcollView.frame;
            rect.size.height = introduceMaxHeight;
            _introduceSrcollView.frame = rect;
            _introduceSrcollView.contentSize = CGSizeMake(rect.size.width, viewHeight);
            [_introduceView addSubview:_introduceSrcollView];
        }
    }
    
    //web
    {
        rect.origin.x = 20;
        rect.origin.y = CGRectGetMaxY(_introduceSrcollView.frame) + 10;
        rect.size.width = CGRectGetWidth(self.view.frame) - rect.origin.x;
        rect.size.height = 14;
        self.webLabel = [[[CustomLabel alloc] initWithFrame:rect] autorelease];
        self.webLabel.backgroundColor = [UIColor clearColor];
        [self.webLabel setPromptTitle:NSLocalizedString(@"about.web.key", nil)
                         contentTitle:self.strWebDisplay];
        [_introduceView addSubview:self.webLabel];
        
        //webbutton
        {
            _maskWebButton = [[UIButton alloc] initWithFrame:rect];
            _maskWebButton.backgroundColor = [UIColor clearColor];
            [_maskWebButton addTarget:self action:@selector(onMaskWebButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_introduceView addSubview:_maskWebButton];
        }
    }
    
    // Phone
    {
        rect = self.webLabel.frame;
        rect.origin.y = CGRectGetMaxY(self.webLabel.frame) + 10;
        self.phoneLabel = [[[CustomLabel alloc] initWithFrame:rect] autorelease];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        [self.phoneLabel setPromptTitle:NSLocalizedString(@"about.phone.key", nil)
                           contentTitle:self.strPhone];
        [_introduceView addSubview:self.phoneLabel];
        
        //phoneButton
        {
            _maskPhoneButton = [[UIButton alloc] initWithFrame:rect];
            _maskPhoneButton.backgroundColor = [UIColor clearColor];
            [_maskPhoneButton addTarget:self action:@selector(onMaskPhoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_introduceView addSubview:_maskPhoneButton];
        }
    }
    
    // Email
    {
        rect = self.phoneLabel.frame;
        rect.origin.y = CGRectGetMaxY(self.phoneLabel.frame) + 10 ;
        self.emailLabel = [[[CustomLabel alloc] initWithFrame:rect] autorelease];
        self.emailLabel.backgroundColor = [UIColor clearColor];
        [self.emailLabel setPromptTitle:NSLocalizedString(@"about.email.key", nil) 
                           contentTitle:self.strEmail];
        [_introduceView addSubview:self.emailLabel];
        
        //emialbutton
        {
            _maskEmailButton = [[UIButton alloc] initWithFrame:rect];
            _maskEmailButton.backgroundColor = [UIColor clearColor];
            [_maskEmailButton addTarget:self action:@selector(onMaskEmailButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_introduceView addSubview:_maskEmailButton];
        }
    }
    
    // copyRight
    {
        rect = self.emailLabel.frame;
        rect.origin.y = CGRectGetMaxY(self.emailLabel.frame) + 10 ;
        self.copyrightLabel = [[[CustomLabel alloc] initWithFrame:rect] autorelease];
        self.copyrightLabel.backgroundColor = [UIColor clearColor];
        [self.copyrightLabel setPromptTitle:NSLocalizedString(@"about.copyright.key", nil) 
                               contentTitle:NSLocalizedString(@"about.copyright.value", nil)];
        [_introduceView addSubview:self.copyrightLabel];
        
    }
    
    // agreementView
    {
        //srollview;
        {
            rect = _introduceView.frame;
            rect.origin.y = CGRectGetMaxY(self.introduceButton.frame) + 22;
            rect.size.height = CGRectGetHeight(self.view.frame) - rect.origin.y - CGRectGetHeight(self.navigationController.navigationBar.frame);
            _srcollView = [[UIScrollView alloc] initWithFrame:rect];
            _srcollView.contentOffset = CGPointMake(0, 0);
            _srcollView.showsVerticalScrollIndicator = YES;
            _srcollView.showsHorizontalScrollIndicator = NO;
        }
        
        //agreementTextView;
        {
            rect.origin.x = 18;
            rect.origin.y = 0;
            rect.size.width = CGRectGetWidth(self.view.frame) - rect.origin.x - 18;
            rect.size.height = _srcollView.contentSize.height;
            self.agreeContentLabel = [[[BqsTextView alloc] initWithFrame:rect] autorelease];
            self.agreeContentLabel.backgroundColor = [UIColor clearColor];
            self.agreeContentLabel.txtColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
            self.agreeContentLabel.txtFont = [UIFont systemFontOfSize:14];
            self.agreeContentLabel.fMarginHori = 0;
            self.agreeContentLabel.fMarginVer = 0;
            self.agreeContentLabel.fLineGap = 8;
            self.agreeContentLabel.fParaGap = 12;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement_cn" ofType:@"txt"];
            NSError *err = nil;
            NSString *context = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
            if (context == nil){
                BqsLog(@"%@", err.description);
            }
            self.agreeContentLabel.strContent = context;
            CGFloat aHeight = [self.agreeContentLabel getPageHeight];
            _srcollView.contentSize = CGSizeMake(rect.size.width, aHeight);
            rect.size.height = aHeight;
            self.agreeContentLabel.frame = rect;
            [context release];
            [_srcollView addSubview:self.agreeContentLabel];
            
        }
    }
    
    // guesture recognize
//    if([BqsUtils getOsVer] >= 3.2)
//    {
//        UITapGestureRecognizer *trippleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTrippleTapView)] autorelease];
//        [trippleTap setNumberOfTapsRequired:3];
//        [self.view addGestureRecognizer:trippleTap];
//    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_introduceView release]; _introduceView = nil;
    [_thumbView release]; _thumbView = nil;
    [_versionLabel release]; _versionLabel = nil;
    [_maskWebButton release]; _maskWebButton = nil;
    [_maskEmailButton release]; _maskEmailButton = nil;
    [_maskPhoneButton release]; _maskPhoneButton = nil;
    [_srcollView release]; _srcollView = nil;
    [_introduceSrcollView release];  _introduceSrcollView = nil;
    self.introduceButton = nil;
    self.agreementButton = nil;
    self.webLabel = nil;
    self.phoneLabel = nil;
    self.emailLabel = nil;
    self.copyrightLabel = nil;
    self.introduceContentLabel = nil;
    self.agreeContentLabel = nil;
}

#pragma mark IOS < 6

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IOS 6

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;  // 可以修改为任何方向
}

-(BOOL)shouldAutorotate{
    
    return YES;
}


- (void)dealloc{
    [_introduceView release];
    [_thumbView release];
    [_versionLabel release];
    [_maskWebButton release];
    [_maskEmailButton release];
    [_maskPhoneButton release];
    [_srcollView release];
    [_introduceSrcollView release];
    self.introduceButton = nil;
    self.agreementButton = nil;
    self.webLabel = nil;
    self.phoneLabel = nil;
    self.emailLabel = nil;
    self.copyrightLabel = nil;
    self.introduceContentLabel = nil;
    self.agreeContentLabel = nil;
    
    self.strWebDisplay = nil;
    self.strWebClick = nil;
    self.strPhone = nil;
    self.strEmail = nil;


    [super dealloc];
}

#pragma mark -
#pragma mark My Methods
- (void)onLeftBackButtonClick{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }

}

- (void)onIntroduceButtonClick{
    self.introduceButton.selected = YES;
    self.agreementButton.selected = NO;
    if(_introduceView.superview == nil){
        [self.view addSubview:_introduceView];
    }
    if (_srcollView.superview != nil){
        [_srcollView removeFromSuperview];
    }
    _srcollView.contentOffset = CGPointMake(0, 0);
}

- (void)onAgreementButtonClick{
    self.introduceButton.selected = NO;
    self.agreementButton.selected = YES;
    if (_srcollView.superview == nil){
        [self.view addSubview:_srcollView];
    }
    if (_introduceView.superview != nil){
        [_introduceView removeFromSuperview];
    }
}

- (void)onMaskWebButtonClick{
    NSString *s = self.strWebClick;
    if(s.length < 1) s = self.strWebDisplay;
    if(![[s lowercaseString] hasPrefix:@"http"]) s = [@"http://" stringByAppendingString:self.strWebClick];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

- (void)onMaskPhoneButtonClick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.strPhone]]];
}

- (void)onMaskEmailButtonClick{
    if (![MFMailComposeViewController canSendMail] || self.strEmail.length < 1){
        return;
    }
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    vc.mailComposeDelegate = self;
    [vc setSubject:@""];
    [vc setToRecipients:[NSArray arrayWithObject:self.strEmail]];
    [vc setMessageBody:@"" isHTML:NO];
    [self presentModalViewController:vc animated:YES];
    [vc release];
}


//-(void)onTrippleTapView {
//    MptBihuListViewController *vc = [[[MptBihuListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark -
#pragma mark Mail Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}
@end
