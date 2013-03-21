//
//  FullScrAdMgr.m
//  iMobeeBook
//
//  Created by ellison on 11-11-25.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import "FullScrAdMgr.h"
#import "Env.h"
#import "BqsUtils.h"
#import "Downloader.h"
#import "PopupWebviewController.h"
#import "AnimatedGif.h"

#define kDirName @"bqs_fullscr_ad"
#define kFileNameCfgXml @"list.xml"

#define kCfgRefreshCfgXmlTime @"bqs.fullscr.xml.refresh.ts"
#define kCfgRefreshCfgXmlIntervalS (8.0 * 60.0 * 60.0)

#define kCfgCfgXmlETag @"bqs.fullscr.xml.refresh.etag"
#define kCfgCfgXmlLastModified @"bqs.fullscr.xml.refresh.lastmodified"

#define kCfgPosponeDisplayTs @"bqs.fullscr.posponeDisplayTs"
#define kCfgLastShowTs  @"bqs.fullscr.lastshowTs"

#define kDetailButtonHideIntervalS 1.0
//#define kCloseButtonHideIntervalS 3.0

#pragma mark BqsFullScrLoadingView
@interface BqsFullScrLoadingView : UIView {
    double _dShowTs;
    BOOL _bAutoHide;
}
@property (nonatomic, assign) id callback;

-(id)initWithViewController:(UIViewController*)ctl;

-(BOOL)canShow;
-(void)show:(BOOL)bIgnoreInterval;
-(void)hide:(BOOL)bForceRemove;

@end

@protocol BqsFullScrLoadingView_Callback <NSObject>

@optional
-(void)bqsFullScrLoadingViewDidHide:(BqsFullScrLoadingView*)v;

@end

@interface BqsFullScrLoadingView()
@property (nonatomic, assign) UIViewController *vctl;
@property (nonatomic, retain) FullScrAdItem *curFullScrItem;
@property (nonatomic, retain) NSData *imgDataVer;
@property (nonatomic, retain) NSData *imgDataHori;
@property (nonatomic, assign) BOOL isGifHori;
@property (nonatomic, assign) BOOL isGifVer;

@property (nonatomic, retain) UIImageView *ivImageHori;
@property (nonatomic, retain) UIImageView *ivImageVer;
@property (nonatomic, retain) UIButton *btnClose;
@property (nonatomic, retain) UIButton *btnDetail;
@property (nonatomic, retain) UIButton *btnDetailMask;

-(void)onClickClose;
-(void)onClickDetail;

-(void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer;

-(BOOL)hasAction;

-(void)setWebViewImage;
-(void)doShowDetailBtn;
-(void)doShowCloseBtn;
-(void)doAutoHide;
-(void)doHide;
-(void)didHide;
@end

@implementation BqsFullScrLoadingView
@synthesize callback,vctl;
@synthesize curFullScrItem, imgDataVer, imgDataHori, isGifVer, isGifHori;
@synthesize ivImageHori, ivImageVer, btnClose, btnDetail, btnDetailMask;

-(id)initWithViewController:(UIViewController*)ctl
{
    CGSize szParent = ctl.view.frame.size;
    
    self = [super initWithFrame:CGRectMake(0, 0, MAX(szParent.width, 320), MAX(szParent.height, 480))];
    if (nil == self) return nil;
    
    Env *env = [Env sharedEnv];
    
    self.vctl = ctl;
    
    self.backgroundColor = [UIColor blackColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // create sub views
    //    {
    //        self.ivImage = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    //        self.ivImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //        self.ivImage.contentMode = UIViewContentModeCenter;
    //        [self addSubview:self.ivImage];
    //    }
//    {
//        self.webview = [[[UIWebView alloc] initWithFrame:self.bounds] autorelease];
//        self.webview.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        self.webview.backgroundColor = [UIColor blackColor];
//        self.webview.opaque = NO;
//        self.webview.userInteractionEnabled = NO;
//        [self addSubview:self.webview];
//    }
    
    {
        UIImage *imgClose = [env cacheImage:@"fullscr_loading_btn_back.png"];
        
        self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnClose.frame = CGRectMake(CGRectGetWidth(self.bounds) - imgClose.size.width, CGRectGetMidY(self.bounds) - imgClose.size.height / 2.0, imgClose.size.width, imgClose.size.height);
        self.btnClose.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.btnClose.showsTouchWhenHighlighted = YES;
        [self.btnClose setBackgroundImage:imgClose forState:UIControlStateNormal];
        [self.btnClose addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnClose];
    }
    {
        self.btnDetail = [UIButton buttonWithType:UIButtonTypeInfoLight];
        
        [self.btnDetail sizeToFit];
        self.btnDetail.center = CGPointMake(CGRectGetWidth(self.bounds)-CGRectGetWidth(self.btnDetail.frame)/2.0 - 20.0, CGRectGetHeight(self.btnDetail.frame)/2.0 + 20.0);
        self.btnDetail.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.btnDetail.showsTouchWhenHighlighted = NO;
        self.btnDetail.userInteractionEnabled = NO;
        [self addSubview:self.btnDetail];
        
        
        self.btnDetailMask = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDetailMask.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.btnDetailMask.frame = CGRectInset(self.btnDetail.frame, -20.0, -20.0);
        self.btnDetailMask.showsTouchWhenHighlighted = YES;
        [self.btnDetailMask addTarget:self action:@selector(onClickDetail) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnDetailMask];
    }
    
    // guesture recognize
    if([BqsUtils getOsVer] >= 3.2) 
    {
        // -----------------------------
        // One finger, swipe left
        // -----------------------------
        UISwipeGestureRecognizer *oneFingerSwipeLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)] autorelease];
        [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:oneFingerSwipeLeft];
    }
    
    return self;
}

-(void)dealloc {
    self.callback = nil;
    self.vctl = nil;
    
    self.curFullScrItem = nil;
    self.imgDataVer = nil;
    self.imgDataHori = nil;
    
    self.ivImageHori = nil;
    self.ivImageVer = nil;
//    self.webview = nil;
    self.btnClose = nil;
    self.btnDetail = nil;
    self.btnDetailMask = nil;
    
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)layoutSubviews {
    [super layoutSubviews];

    self.btnDetailMask.center = self.btnDetail.center;
    [self setWebViewImage];
}

-(void)setWebViewImage {
    BqsLog(@"setWebviewImage");
    
    BOOL isVer = (CGRectGetHeight(self.bounds) > CGRectGetWidth(self.bounds));
    
    NSData *imgData = nil;
    
    if(isVer) {
        imgData = self.imgDataVer;
        if(nil == imgData) imgData = self.imgDataHori;
    } else {
        imgData = self.imgDataHori;
        if(nil == imgData) imgData = self.imgDataVer;
    }
    
    UIImage *img = nil;
    if(nil != imgData) {
        img = [UIImage imageWithData:imgData];
    }
    
    if(nil == img) return;
    
    if(isVer) {
        if(nil == self.ivImageVer) {
            if(self.isGifVer) {
                @try {
                    AnimatedGif *gif = [[[AnimatedGif alloc] init] autorelease];
                    
                    UIImageView *imgv = nil;
                    [gif decodeGIF:imgData];
                    UIImageView *tempImageView = [gif getAnimation];
                    if(nil != tempImageView) {
                        imgv = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
                        [imgv setImage: [tempImageView image]];
                        [imgv sizeToFit];
                        [imgv setAnimationImages:[tempImageView animationImages]];
                        [imgv startAnimating];
                    }
                    
                    self.ivImageVer = imgv;
                    if(nil != self.ivImageVer) {
                        self.ivImageVer.frame = self.bounds;
                        self.ivImageVer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                        self.ivImageVer.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
            }
            if(nil == self.ivImageVer) {
                self.ivImageVer = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
                self.ivImageVer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                self.ivImageVer.contentMode = UIViewContentModeScaleAspectFill;
                [self.ivImageVer setImage:img];
            }
        }
        
        if(nil != self.ivImageVer) {
            if(![self.subviews containsObject:self.ivImageVer]) [self insertSubview:self.ivImageVer atIndex:0];
            self.ivImageVer.hidden = NO;
        }
        if(nil != self.ivImageHori) self.ivImageHori.hidden = YES;
    } else {
        if(nil == self.ivImageHori) {
            if(self.isGifHori) {
                @try {
                    AnimatedGif *gif = [[[AnimatedGif alloc] init] autorelease];
                    UIImageView *imgv = nil;
                    [gif decodeGIF:imgData];
                    UIImageView *tempImageView = [gif getAnimation];
                    if(nil != tempImageView) {
                        imgv = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
                        [imgv setImage: [tempImageView image]];
                        [imgv sizeToFit];
                        [imgv setAnimationImages: [tempImageView animationImages]];
                        [imgv startAnimating];
                    }
                    
                    self.ivImageHori = imgv;

                    if(nil != self.ivImageHori) {
                        self.ivImageHori.frame = self.bounds;
                        self.ivImageHori.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                        self.ivImageHori.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
            }
            if(nil == self.ivImageHori) {
                self.ivImageHori = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
                self.ivImageHori.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                self.ivImageHori.contentMode = UIViewContentModeScaleAspectFill;
                [self.ivImageHori setImage:img];
            }
        }
        
        if(nil != ivImageHori) {
            if(![self.subviews containsObject:self.ivImageHori]) [self insertSubview:self.ivImageHori atIndex:0];
            self.ivImageHori.hidden = NO;
        }
        if(nil != self.ivImageVer) self.ivImageVer.hidden = YES;
    }
    
//    if(nil != img) {
//        Env *env = [Env sharedEnv];
//        float scale = env.screenScale;
//        if(scale < 1.0) scale = 1.0;
//        
////        NSString *sBuf = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=%.0f;height=%.0f;user-scalable=no;initial-scale=%.1f;\"></head><body>", env.screenSize.width, env.screenSize.height, 1.0/scale];
//        
//        float w = env.screenSize.width;
//        float h = img.size.height * env.screenSize.width / MAX(img.size.width, 1.0);
//        
//        NSString *sBuf = [NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"%.0f\" height=\"%.0f\"/>", 
//                          [BqsUtils base64StringFromData:imgData],
//                          w, h];
//        
////        BqsLog(@"sBuf: %@", sBuf);
//        [self.webview loadHTMLString:sBuf baseURL:[NSURL URLWithString:@"http://www.mobeehome.com"]];
////        [self.webview loadData:imgData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"http://www.mobeehome.com"]];
//    } else {
//        [self.webview loadHTMLString:@"" baseURL:nil];
//    }
}
#pragma mark - public methods
-(BOOL)canShow {
    if(nil != self.curFullScrItem) return YES;
//    self.curFullScrItem = [[Env sharedEnv].bkSvc.fullScrAdMgr getDisplayItem];
    
    return (nil != self.curFullScrItem);
}

-(void)show:(BOOL)bIgnoreInterval {
    UIView *rootWindow = self.vctl.view;
    if(nil == rootWindow) {
        BqsLog(@"can't get root window");
        return;
    }
    
    if([[rootWindow subviews] containsObject:self]) {
        BqsLog(@"already showing");
        return ;
    }
    
//    FullScrAdMgr *mgr = [Env sharedEnv].bkSvc.fullScrAdMgr;
//    
//    if(nil == self.curFullScrItem) {
//        self.curFullScrItem = [mgr getDisplayItem];
//    }
//    if(bIgnoreInterval) {
//        self.curFullScrItem = [[self.curFullScrItem copy] autorelease];
//        self.curFullScrItem.minIntervalS = .01f;
//    }
//    
//    if(nil == self.curFullScrItem) {
//        BqsLog(@"No fullscr img to show");
//        return;
//    }
//    
//    self.imgDataVer = [mgr getItemImageData:self.curFullScrItem.imgUrlVer];
//    self.imgDataHori = [mgr getItemImageData:self.curFullScrItem.imgUrlHori];
//    
//    if(nil != self.imgDataVer && [[self.curFullScrItem.imgUrlVer lowercaseString] hasSuffix:@".gif"]) {
//        self.isGifVer = YES;
//    } else {
//        self.isGifVer = NO;
//    }
//    if(nil != self.imgDataHori && [[self.curFullScrItem.imgUrlHori lowercaseString] hasSuffix:@".gif"]) {
//        self.isGifHori = YES;
//    } else {
//        self.isGifHori = NO;
//    }
//
//    [self.ivImageVer removeFromSuperview]; self.ivImageVer = nil;
//    [self.ivImageHori removeFromSuperview]; self.ivImageHori = nil;
//    
//    [self setWebViewImage];
//    
//    self.frame = CGRectOffset(rootWindow.bounds, -CGRectGetWidth(rootWindow.bounds), 0.0);
//    
//    _dShowTs = [NSDate timeIntervalSinceReferenceDate];
//    _bAutoHide = self.curFullScrItem.bAutoRemove;
//    self.btnClose.hidden = YES;
//    self.btnDetail.hidden = YES;
//    [self performSelector:@selector(doShowDetailBtn) withObject:nil afterDelay:MAX(.5, kDetailButtonHideIntervalS)];
//    [self performSelector:@selector(doShowCloseBtn) withObject:nil afterDelay:MAX(1.0, self.curFullScrItem.minIntervalS)];
//    
//    
//    [rootWindow addSubview:self];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.3];
//    self.frame = rootWindow.bounds;
//    [UIView commitAnimations];
    
}

-(void)hide:(BOOL)bForceRemove {
    [self.ivImageVer stopAnimating];
    [self.ivImageHori stopAnimating];

    if(bForceRemove) {
        if(self.isGifVer || self.isGifHori) {
            [self performSelector:@selector(doHide) withObject:nil afterDelay:0.1f];
        } else {
            [self doHide];
        }
    } else if(_bAutoHide) {
        double now = [NSDate timeIntervalSinceReferenceDate];
//        BqsLog(@"now: %.0f, showTs: %.0f, interval: %.0f", now, _dShowTs, (double)self.curFullScrItem.minIntervalS);
        if(now - _dShowTs > (double)self.curFullScrItem.minIntervalS) {
            BqsLog(@"doHide");
            if(self.isGifVer || self.isGifHori) {
                [self performSelector:@selector(doHide) withObject:nil afterDelay:0.1f];
            } else {
                [self doHide];
            }
        } else {
            float delay = MAX((double)self.curFullScrItem.minIntervalS - (now - _dShowTs), 1.0);
            BqsLog(@"doHide after: %.1f", delay);
            [self performSelector:@selector(doAutoHide) withObject:nil afterDelay:delay];
        }
    } else {
        BqsLog(@"not auto remove, ignore hide");
    }
}
-(void)doAutoHide {
    if(_bAutoHide) {
        [self doHide];
    }
}
-(void)doHide {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    self.frame = CGRectOffset(self.frame, -CGRectGetWidth(self.frame), 0.0);
    [UIView commitAnimations];
    
    [self performSelector:@selector(didHide) withObject:nil afterDelay:.4];
}

-(void)didHide {
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsFullScrLoadingViewDidHide)]) {
        [self.callback performSelector:@selector(bqsFullScrLoadingViewDidHide)];
    }
    
//    [self.webview loadHTMLString:@"" baseURL:nil];
    
    self.curFullScrItem = nil;
    self.imgDataVer = nil;
    self.imgDataHori = nil;
    self.isGifHori = NO;
    self.isGifVer = NO;
    [self.ivImageVer removeFromSuperview]; self.ivImageVer = nil;
    [self.ivImageHori removeFromSuperview]; self.ivImageHori = nil;

    [self removeFromSuperview];
}
-(void)doShowDetailBtn {
    BqsLog(@"doShowDetailBtn");
    if(![self hasAction]) return;
    
    if(self.btnDetail.hidden) {
        self.btnDetail.hidden = NO;
        self.btnDetail.alpha = .2;
    }
        
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    if(self.btnDetail.alpha < .2001) {
        self.btnDetail.alpha = 1.0;
    } else {
        self.btnDetail.alpha = .2;
    }
    
    [UIView commitAnimations];
    
    if(nil != self.curFullScrItem) {
        [self performSelector:@selector(doShowDetailBtn) withObject:nil afterDelay:2.0];
    }
}

-(void)doShowCloseBtn {
    self.btnClose.alpha = .0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];

    self.btnClose.hidden = NO;
    self.btnClose.alpha = 1.0;
    
    [UIView commitAnimations];
}

#pragma mark - ui handler
-(void)onClickClose {
    [self doHide];
}

-(void)onClickDetail {
    if(nil != self.curFullScrItem) {
        switch(self.curFullScrItem.actionOpType) {
            case 1:
                if(nil != self.curFullScrItem.actionOpData && [self.curFullScrItem.actionOpData length] > 0) {
                    // disable auto hide
                    _bAutoHide = NO; 
                    
//                    [PopupWebviewController presentPopWebviewParent:self.vctl Title:nil Url:self.curFullScrItem.actionOpData PopType:kTagPopWebView];
                }
                break;
            case 2:
            {
                NSURL *url = nil;
                if(nil != self.curFullScrItem.actionOpData && [self.curFullScrItem.actionOpData length] > 0) {
                    
                    url = [NSURL URLWithString:self.curFullScrItem.actionOpData];
                }
                if(nil != url) {
                    // hide before call sys browser
                    [self didHide];
                    
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
                break;
            default:
                break;
        }
    }
}

-(BOOL)hasAction {
    if(nil == self.curFullScrItem) return NO;
    return (self.curFullScrItem.actionOpType >= kFullScrActionOpType_MIN && self.curFullScrItem.actionOpType <= kFullScrActionOpType_MAX);
}

-(void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    if(!self.btnClose.hidden){
        [self doHide];
    }
}


@end

#pragma mark - FullScrAdMgr

@interface FullScrAdMgr()
@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, copy) NSString* rootPath;
@property (nonatomic, assign, readwrite) double lastShowTS;

@property (nonatomic, retain) NSMutableArray *arrItems;

@property (nonatomic, retain) NSMutableSet *setLoadingImagesUrls;

@property (nonatomic, retain) BqsFullScrLoadingView *viewFullscr;

+(NSString*)imageFileName:(NSString*)url;
-(NSString*)xmlFilePath;

-(void)loadLocalList;
-(void)synchronizeItemList:(NSArray*)newItemList;
-(void)checkLoadImages;
-(void)fixWeights:(NSArray*)arr;


-(void)getCfgXmlFromNetwork;
-(void)onFinishGetCfgXmlFromNetwork:(DownloaderCallbackObj*)cb;

-(void)getImageFromNetwork:(NSString*)url;
-(void)onFinishGetImageFromNetwork:(DownloaderCallbackObj*)cb;


@end

@implementation FullScrAdMgr
@synthesize lastShowTS;
@synthesize downloader;
@synthesize rootPath;
@synthesize arrItems;
@synthesize setLoadingImagesUrls;
@synthesize viewFullscr;

+(NSString*)imageFileName:(NSString*)url {
    if(nil == url || [url length] < 1) return nil;
    
    return [NSString stringWithFormat:@"img_%x", [url hash]];
}
-(NSString*)xmlFilePath {
    return [self.rootPath stringByAppendingPathComponent:kFileNameCfgXml];
}

-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
        
    // buile root path
    self.rootPath = [NSTemporaryDirectory() stringByAppendingPathComponent:kDirName];
    
    BqsLog(@"fullscr loading rootpath: %@", self.rootPath);
    
    self.lastShowTS = [[NSUserDefaults standardUserDefaults] doubleForKey:kCfgLastShowTs];
    
    return self;
}

-(void)dealloc {
    [self.downloader cancelAll];
    self.downloader = nil;
    self.rootPath = nil;
    self.arrItems = nil;
    self.setLoadingImagesUrls = nil;
    
    [self.viewFullscr removeFromSuperview];
    self.viewFullscr = nil;
    
    [super dealloc];
}


#pragma mark - public methods
-(BOOL)canShow {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    float t = [defs floatForKey:kCfgPosponeDisplayTs];
    if(t > 0.0) {
        BqsLog(@"FullScr pospone.........");
        
        [defs removeObjectForKey:kCfgPosponeDisplayTs];
        [defs synchronize];
        
        return NO;
    }

    if(nil != self.viewFullscr) return YES;
    
    FullScrAdItem *it = [self getDisplayItem];
    if(nil == it) return NO;
    
    UIViewController *vc = [Env getRootViewController];
    if(nil == vc) {
        BqsLog(@"no root view controller");
        return NO;
    }
    
    self.viewFullscr = [[[BqsFullScrLoadingView alloc] initWithViewController:vc] autorelease];
    self.viewFullscr.callback = self;
    
    return YES;
}

-(void)show:(BOOL)bIgnoreInterval {
    if(![self canShow]) return;
    
    if(nil == self.viewFullscr) return;
    
    self.lastShowTS = [NSDate timeIntervalSinceReferenceDate];
    [[NSUserDefaults standardUserDefaults] setDouble:self.lastShowTS forKey:kCfgLastShowTs];
    
    
    [self.viewFullscr show:bIgnoreInterval];
}

-(void)hide:(BOOL)bForceRemove {
    
    if(nil == self.viewFullscr) return;
    [self.viewFullscr hide:bForceRemove];
}

-(void)bqsFullScrLoadingViewDidHide {
    self.viewFullscr = nil;
}


-(void)checkServerCfg {
    float fLast = [[NSUserDefaults standardUserDefaults] floatForKey:kCfgRefreshCfgXmlTime];
	double now = [NSDate timeIntervalSinceReferenceDate];
	if(now - fLast > kCfgRefreshCfgXmlIntervalS/* || [BqsUtils fileSize:[self xmlFilePath]] < 10*/) {
        [[NSUserDefaults standardUserDefaults] setFloat:(float)now forKey:kCfgRefreshCfgXmlTime];
        
        [self getCfgXmlFromNetwork];
	} else {
        [self checkLoadImages];
    }
}

-(FullScrAdItem*)getDisplayItem {
    if(nil == self.arrItems) {
        [self loadLocalList];
    }
    
    // get items with imaged downloaded
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[self.arrItems count]];
    for(FullScrAdItem *nit in self.arrItems) {
        BOOL bVerOK = NO, bHoriOK = NO, bHasImg = NO;
        
        if(nil == nit.imgUrlVer || [nit.imgUrlVer length] < 1) bVerOK = YES;
        else {
            NSString *imgName = [FullScrAdMgr imageFileName:nit.imgUrlVer];
            NSString *path = [self.rootPath stringByAppendingPathComponent:imgName];
            if([BqsUtils fileSize:path] >= 10) {
                bVerOK = YES;
                bHasImg = YES;
            }
        }
        
        if(nil == nit.imgUrlHori || [nit.imgUrlHori length] < 1) bHoriOK = YES;
        else {
            NSString *imgName = [FullScrAdMgr imageFileName:nit.imgUrlHori];
            NSString *path = [self.rootPath stringByAppendingPathComponent:imgName];
            if([BqsUtils fileSize:path] >= 10) {
                bHoriOK = YES;
                bHasImg = YES;
            }
        }
        
        if(bVerOK && bHoriOK && bHasImg) {
            [arr addObject:[[nit copy] autorelease]];
        }
    }
    
    if([arr count] < 1) return nil;
    if([arr count] < 2) return [arr objectAtIndex:0];

    [self fixWeights:arr];
    
    // gen one item
    int rprg = [BqsUtils randLimit:100];
    int idx = -1;
    int cnt = [arr count];
    int prg = 0;
    for(int i = 0; i < cnt; i ++) {
        FullScrAdItem *it = [arr objectAtIndex:i];
        int iw = it.ratio;
        
        if(iw <= 0) continue;
        
        if(idx < 0) idx = i;
        
        int nextPrg = prg + iw;
        if(rprg >= prg && rprg < nextPrg) {
            idx = i;
            break;
        }
        
        prg = nextPrg;
    }
    
    if(idx < cnt && idx >= 0) {
        return [arr objectAtIndex:idx];
    }

    return [arr objectAtIndex:0];
}

-(NSData*)getItemImageData:(NSString*)url {
    if(nil == url || [url length] < 1) return nil;
    
    NSString *imgName = [FullScrAdMgr imageFileName:url];
    NSString *path = [self.rootPath stringByAppendingPathComponent:imgName];
    
    return [NSData dataWithContentsOfFile:path];
}

-(void)postponeDisplayFullScrAd {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    [defs setFloat:[NSDate timeIntervalSinceReferenceDate] forKey:kCfgPosponeDisplayTs];
    [defs synchronize];
}

#pragma mark - private methods
-(void)loadLocalList {
    
    self.arrItems = [NSMutableArray arrayWithCapacity:20];
    
    NSString *path = [self xmlFilePath];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if(nil != data) {
        NSArray *arr = [FullScrAdItem parseXmlData:data];
        if(nil != arr) {
            [self.arrItems addObjectsFromArray:arr];
        }
    }
}

-(void)synchronizeItemList:(NSArray*)newItemList {
    if(nil == self.arrItems) {
        [self loadLocalList];
    }
    
    if(nil == newItemList) {
        BqsLog(@"Invalid param. newItemList: %@", newItemList);
        return;
    }
    
    // build old image file set
    NSMutableSet *setOldImages = [[[NSMutableSet alloc] initWithCapacity:[self.arrItems count]] autorelease];
    for(FullScrAdItem *it in self.arrItems) {
        NSString *imgName = [FullScrAdMgr imageFileName:it.imgUrlVer];
        if(nil != imgName) [setOldImages addObject:imgName];
        
        imgName = [FullScrAdMgr imageFileName:it.imgUrlHori];
        if(nil != imgName) [setOldImages addObject:imgName];
    }
    
    for(FullScrAdItem *nit in newItemList) {
        NSString *imgName = [FullScrAdMgr imageFileName:nit.imgUrlVer];
        if(nil != imgName) {
            [setOldImages removeObject:imgName];
        }
        imgName = [FullScrAdMgr imageFileName:nit.imgUrlHori];
        if(nil != imgName) {
            [setOldImages removeObject:imgName];
        }
    }
    
    // delete un-used image
    for(NSString *s in setOldImages) {
        [BqsUtils deletePath:[self.rootPath stringByAppendingPathComponent:s]];
    }
    
    // replace list
    [self.arrItems removeAllObjects];
    [self.arrItems addObjectsFromArray:newItemList];
    [self fixWeights:self.arrItems];
    [FullScrAdItem saveToFile:[self xmlFilePath] Data:self.arrItems];
}
-(void)checkLoadImages {
    if(nil == self.arrItems) {
        [self loadLocalList];
    }
    
    for(FullScrAdItem *nit in self.arrItems) {
        NSString *imgName = [FullScrAdMgr imageFileName:nit.imgUrlVer];
        NSString *path = [self.rootPath stringByAppendingPathComponent:imgName];
        if([BqsUtils fileSize:path] < 10) {
            [self getImageFromNetwork:nit.imgUrlVer];
        }
        
        imgName = [FullScrAdMgr imageFileName:nit.imgUrlHori];
        path = [self.rootPath stringByAppendingPathComponent:imgName];
        if([BqsUtils fileSize:path] < 10) {
            [self getImageFromNetwork:nit.imgUrlHori];
        }
    }

}

-(void)fixWeights:(NSArray*)arr {
    
    if([arr count] < 1) {
        return;
    }
    
    int total = 0;
    for(FullScrAdItem *nit in arr) {
        int w = nit.ratio;
        
        total += w;
        
    }
    
    if(100 == total) return;
    
    if(total <= 0) {
        BqsLog(@"total ratio <=0 : %d!!!", total);
        return;
    }
    
    for(FullScrAdItem *nit in arr) {
        
        nit.ratio = (nit.ratio * 100) / total;
    }
}

#pragma mark - network ops
-(void)getCfgXmlFromNetwork {
    Env *env = [Env sharedEnv];
    
	NSString *url = [NSString stringWithFormat:@"/loading_screen/iphone_%@.xml", env.swType];
    if(env.bIsPad) {
        url = [NSString stringWithFormat:@"/loading_screen/ipad_%@.xml", env.swType];
    }
	url = [BqsUtils fixURLHost:url];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if([BqsUtils fileSize:[self xmlFilePath]] > 10) {
        NSString *s = [defs objectForKey:kCfgCfgXmlETag];
        if(nil != s && [s length] > 0) [dic setObject:s forKey:kHttpHeader_ReqETag];
        s = [defs objectForKey:kCfgCfgXmlLastModified];
        if(nil != s && [s length] > 0) [dic setObject:s forKey:kHttpHeader_ReqLastModifed];
    }
    
	
    [self.downloader cancelAll];
    [self.setLoadingImagesUrls removeAllObjects];
    
	[self.downloader addTask:url Target:self Callback:@selector(onFinishGetCfgXmlFromNetwork:) Attached:nil AppendHeaders:dic];
}

-(void)onFinishGetCfgXmlFromNetwork:(DownloaderCallbackObj*)cb {
    BqsLog(@"onFinishGetCfgXmlFromNetwork: %@", cb);
	
	if(nil == cb) return;
	
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    if(404 == cb.httpStatus) {
        BqsLog(@"server return 404, indicating the cfg has been removed from server");
        [BqsUtils trashPath:self.rootPath];
        [self.arrItems removeAllObjects];
        
        [defs removeObjectForKey:kCfgCfgXmlETag];
        [defs removeObjectForKey:kCfgCfgXmlLastModified];
        return;
    }
    
    if(200 != cb.httpStatus && 304 != cb.httpStatus) return;
    
    {
        // save etag and last-modified   
        NSString *s = cb.httpETag;
        if(nil != s && [s length] > 0) [defs setObject:s forKey:kCfgCfgXmlETag];
        else [defs removeObjectForKey:kCfgCfgXmlETag];
        
        s = cb.httpLastModified;
        if(nil != s && [s length] > 0) [defs setObject:s forKey:kCfgCfgXmlLastModified];
        else [defs removeObjectForKey:kCfgCfgXmlLastModified];
    }
    
    if(304 == cb.httpStatus) {
        [self checkLoadImages];
        return;
    }
    
    if(nil == cb.rspData || [cb.rspData length] < 10) {
		BqsLog(@"server return error. http: %d, data:%@", cb.httpStatus, cb.rspData);
		return;
	}

//    BqsLog(@"rspData: %@", [BqsUtils stringFromData:cb.rspData Encoding:nil]);
    
    // parse xml
    NSArray *arr = [FullScrAdItem parseXmlData:cb.rspData];
    
//    BqsLog(@"arr: %@", arr);
    [self synchronizeItemList:arr];
//    BqsLog(@"arr2: %@", self.arrItems);
    [self checkLoadImages];
}

-(void)getImageFromNetwork:(NSString*)url {
    if(nil == url || [url length] < 1) {
        BqsLog(@"Invalid param. url: %@", url);
        return;
    }
    
    if(nil == self.setLoadingImagesUrls) {
        self.setLoadingImagesUrls = [NSMutableSet setWithCapacity:10];
    }
    
    if([self.setLoadingImagesUrls containsObject:url]) {
        BqsLog(@"Already loading: %@", url);
        return;
    }
    
    [self.setLoadingImagesUrls addObject:url];
    [self.downloader addTask:url Target:self Callback:@selector(onFinishGetImageFromNetwork:) Attached:url];
}

-(void)onFinishGetImageFromNetwork:(DownloaderCallbackObj*)cb {
    if(nil == cb) return ;
    
    NSString *surl = nil;
    if(nil != cb.attached && [cb.attached isKindOfClass:[NSString class]]) {
        surl = (NSString*)cb.attached;
        [[surl retain] autorelease];
        [self.setLoadingImagesUrls removeObject:surl];
    }
    
    if(nil == surl) return;
    
    if(200 != cb.httpStatus || nil == cb.rspData || [cb.rspData length] < 10) return;
    
    
    NSString *imgName = [FullScrAdMgr imageFileName:surl];
    NSString *path = [self.rootPath stringByAppendingPathComponent:imgName];
    [cb.rspData writeToFile:path atomically:NO];
}


@end
