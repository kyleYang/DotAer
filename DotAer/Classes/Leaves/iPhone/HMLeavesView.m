//
//  HMLeavesViewController.m
//  CoreTextDemo
//
//  Created by Kyle on 12-8-27.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "HMLeavesView.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+Attributes.h"
#import "HMImageViewController.h"
#import "RegexKitLite.h"
#import "MarkupParser.h"
#import "AsyncImageView.h"
#import "HumWebImageView.h"
#import "Utilities.h"
#import "LeavesView.h"
#import "HumLeavesControlActionDelegate.h"
#import "HumLeavesLayout.h"
#import "HMImagePopManager.h"
#import "MBProgressHUD.h"
#import "BqsUtils.h"
#import "Env.h"
#import "HumDotaUserCenterOps.h"


@interface HMLeavesView ()<humWebImageDelegae,HumLeavesDelegate,LeavesViewDataSource, LeavesViewDelegate,OHAttributedLabelDelegate,UIGestureRecognizerDelegate,HumLeavesControlActionDelegate>
{
    NSMutableArray *_images;
    NSMutableArray *_linkes;
    NSUInteger _totalPageNum;
    
    BOOL _statusBarVisible;
    UIStatusBarStyle _statusBarStyle;
    BOOL _shouldHideControls;
    
    BOOL _controlsVisible;
    struct {
        unsigned int didBack:1;
        
    } _delegateFlags;
    
}

@property (nonatomic, retain) LeavesView *leavesView;

@property (nonatomic, retain) HumLeavesLayout *layout;
@property (nonatomic, retain, readwrite) HumLeavesControlView *controlsView;

@property (nonatomic, retain) NSString *transmitText; // 存放转换好的数据
@property (nonatomic, retain) NSMutableArray *frames; //存放解析好的分页数据
@property (nonatomic, retain) NSMutableArray *attributes; //存放解析好的分页数据
@property (nonatomic, retain) NSMutableAttributedString *attString;
@property (retain, nonatomic) NSMutableArray* images;
@property (nonatomic, retain) NSMutableArray *linkes;
@property (nonatomic, retain) NSMutableDictionary *asyImgViews; // 存放imaviews;

@property (nonatomic, retain) MBProgressHUD *activityView;

@end

@implementation HMLeavesView

@synthesize parentController;
@synthesize leavesView;
@synthesize delegate = _delegate;
@synthesize controlsView = _controlsView;
@synthesize controlStyle = _controlStyle;
@synthesize controlsVisible = _controlsVisible;
@synthesize layout = _layout;

@synthesize offsetX = _offsetX,offsetY = _offsetY,bottomX = _bottomX,bottomY = _bottomY;
@synthesize characterSpacing = _characterSpacing , linesSpacing = _linesSpacing , paragraphSpacing = _paragraphSpacing;
@synthesize fontAdd = _fontAdd;
@synthesize bgColor = _bgColor, characterColor = _characterColor,characterSize = _characterSize, characterFont = _characterFont, linkerColor = _linkerColor;
@synthesize content = _content;
@synthesize attString = _attString;
@synthesize images = _images;
@synthesize linkes = _linkes;
@synthesize frames;
@synthesize attributes;
@synthesize transmitText;
@synthesize asyImgViews;
@synthesize imgDic = _imgDic;
@synthesize paraseImges;
@synthesize paraImagesDictory;
@synthesize activityView;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
    
    self.leavesView = nil;
    self.parentController = nil;
    _delegate =nil;
    [_bgColor release]; _bgColor= nil;
    [_characterColor release]; _characterColor = nil;
    [_characterFont release]; _characterFont = nil;
    [_linkerColor release]; _linkerColor = nil;
    [_controlsView release]; _controlsView = nil;
    [_layout release]; _layout = nil;
    
    NSArray*keys = [self.asyImgViews allKeys];
    
    if ([keys count]) {
        for (id key in keys) {
            NSArray *imgViewAry = [self.asyImgViews objectForKey:key];
            if ([imgViewAry count]) {
                for (AsyncImageView *img in imgViewAry) {
                    img.delegate = nil;
                    [img release];
                    
                }
            }
        }
        
    }
    self.asyImgViews = nil;
   
    self.imgDic = nil;
    self.paraseImges = nil;
    self.paraImagesDictory = nil;
    self.attributes = nil;
    self.activityView = nil;
    [_content release]; _content = nil;
      
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self parameterInit];
    }
    return self;
}




- (void)parameterInit
{
    _offsetX = 0.0f;
    _offsetY = 0.0f;
    _bottomX = 0.0f;
    _bottomY = 0.0f;
    
    _characterSpacing = 2.0f;
    _linesSpacing = 4.50f;
    _paragraphSpacing = 8.0f;
    
    _fontAdd = 0.0f;
    
    _bgColor = [[UIColor whiteColor] retain];
    _characterColor = [[UIColor blackColor] retain];
    _linkerColor = [[UIColor blueColor] retain];
    _characterFont = [@"Arial" retain];
    
    _characterSize = [HumDotaUserCenterOps floatValueReadForKey:kReadFontSize];
    if (_characterSize ==0) {
        _characterSize = 18.0f;
        [HumDotaUserCenterOps floatVaule:_characterSize saveForKey:kReadFontSize];
    }
    
    self.asyImgViews = [NSMutableDictionary dictionary];
    self.imgDic = [NSMutableDictionary dictionary];
    self.paraImagesDictory = [NSMutableDictionary dictionary];
    
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.bounds)+20.f-_offsetY-_bottomY);

    CGRect rec = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)+20);
    UIImageView *bg = [[UIImageView alloc] initWithFrame:rec];
    bg.image = [[Env sharedEnv] cacheImage:@"dota_read_bg.png"];
    [self addSubview:bg];
    [bg release];
    
    self.leavesView = [[[LeavesView alloc] initWithFrame:labFrame] autorelease];
	self.leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.leavesView.dataSource = self;
	self.leavesView.delegate = self;
	[self addSubview:self.leavesView];
    
    self.controlStyle = HumLeavesControlStyleFullscreen;
    _controlsVisible = NO;
   
    // Controls
    _controlsView = [[HumLeavesControlView alloc] initWithFrame:self.bounds];
    _controlsView.delegate = self;
    [self addSubview:_controlsView];
    
    _controlsView.alpha = 0.0f;
    [self sendSubviewToBack:_controlsView];
    
    
    _layout = [[HumLeavesLayout alloc] init];
    _layout.controlsView = _controlsView;
    [_layout updateControlStyle:HumLeavesControlStyleFullscreen];
    
    
    self.activityView = [[[MBProgressHUD alloc] initWithView:self] autorelease];
    self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.activityView.mode = MBProgressHUDModeIndeterminate;
    self.activityView.animationType = MBProgressHUDAnimationZoom;
    self.activityView.screenType = MBProgressHUDSectionScreen;
    self.activityView.opacity = 0.5;
    self.activityView.labelText = NSLocalizedStringFromTable(@"player.loading.more", @"mptplayer",nil);
    [self  addSubview:self.activityView];
    [self.activityView hide:YES];
    
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.delegate = self;
    [self.controlsView addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_layout layoutTopControlsViewWithControlStyle:self.controlStyle];
    [_layout layoutBottomControlsViewWithControlStyle:self.controlStyle];
    [_layout layoutControlsWithControlStyle:self.controlStyle];
}


////////////////////////////////////////////////////////////////////////
#pragma makr property setting
////////////////////////////////////////////////////////////////////////
- (void)setDelegate:(id<HumLeavesDelegate>)delegate {
    if (delegate != _delegate) {
        _delegate = delegate;
        
        _delegateFlags.didBack = [delegate respondsToSelector:@selector(humLeavesBack:)];
        
    }
}


- (void)contentReadForRead{
    [self.activityView show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 原代码块二
        BOOL finish = [self stringParaseAgain];
        if (finish) {
            // 原代码块三
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL done = [self buildFrames];
                if (done) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activityView hide:YES];
                        [self.leavesView reloadData];
                    });
                }else{
                    NSLog(@"error when buildFrames");
                }
                
            });
        } else {
            NSLog(@"error when stringParaseAgain");
        }
    });

}

- (void)contentSettingAgain{
    [self.activityView show:YES];
    
    self.frames = nil;
    self.attributes = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 原代码块二
        BOOL finish = [self stringParaseAgain];
        if (finish) {
            // 原代码块三
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                CTFrameRef curframe = [self.leavesView getCurentFrame];
                CFRange curRange = CTFrameGetVisibleStringRange(curframe); //得到没有变化时候的字体的frame
                
                for (id temp in self.frames) {
                    CFRelease((CTFrameRef)temp);
                    temp = NULL;
                }

                BOOL finish = [self buildFrames];
 
                if (finish) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activityView hide:YES];
                        int curPage = 0;
                        for (id temp in self.frames) {  //重新计算原来的页面在新的参数下属于哪一页
                            CTFrameRef frame = (CTFrameRef)temp;
                            CFRange frameRange = CTFrameGetVisibleStringRange(frame);
                            if (curRange.location+curRange.length/2>=frameRange.location && curRange.location+curRange.length/2<frameRange.location+frameRange.length) {
                                break;
                            }
                            curPage++;
                        }
                        if (curPage >= self.attributes.count) {
                            curPage = self.attributes.count - 1;
                        }
                        [self.leavesView flush];
                        [self.leavesView setCurrentPageIndex:curPage];
                        
                    });
                }else{
                    NSLog(@"error when buildFrames");
                }
            });
        } else {
            NSLog(@"error when stringParaseAgain");
        }
    });


}





- (void)setContent:(NSString *)acontent
{
    if (!acontent || acontent.length == 0) {
        return;
    }
    
  
    
    [_content release];
    _content = [acontent copy];
    NSArray*keys = [self.asyImgViews allKeys];
    
    if ([keys count]) {
        for (id key in keys) {
            NSArray *imgViewAry = [self.asyImgViews objectForKey:key];
            if ([imgViewAry count]) {
                for (AsyncImageView *img in imgViewAry) {
                    img.delegate = nil;
                    [img release];

                }
            }
        }
        self.asyImgViews = nil;
        self.asyImgViews = [NSMutableDictionary dictionary];
    }
    
    _shouldHideControls = TRUE;
    
    [self setControlsVisible:!self.controlsVisible animated:YES];
 
    
    self.transmitText = [self transformString:_content];
    [self contentReadForRead];
       
}

- (void)setOffsetX:(CGFloat)aoffsetX
{
    _offsetX = aoffsetX;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;

//    [self propertySetAgain];
}

- (void)setOffsetY:(CGFloat)aoffsetY
{
    _offsetY = aoffsetY;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;

//    [self propertySetAgain];
}

- (void)setBottomX:(CGFloat)abottomX
{
    _bottomX = abottomX;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;

//    [self propertySetAgain];
}

- (void)setBottomY:(CGFloat)abottomY
{
    _bottomY = abottomY;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;
//    [self propertySetAgain];
}

- (void)setCharacterSpacing:(CGFloat)acharacterSpacing
{
    _characterSpacing = acharacterSpacing;
    if (!_content || _content.length == 0) {
        return;
    }
   [self contentSettingAgain];
}

- (void)setLinesSpacing:(CGFloat)alinesSpacing
{
    _linesSpacing = alinesSpacing;
    if (!_content || _content.length == 0) {
        return;
    }
    [self contentSettingAgain];}

- (void)setParagraphSpacing:(CGFloat)aparagraphSpacing
{
    _paragraphSpacing = aparagraphSpacing;
    if (!_content || _content.length == 0) {
        return;
    }
     [self contentSettingAgain];
}

- (void)setFontAdd:(CGFloat)afontAdd
{
    
    _characterSize += afontAdd;
    [HumDotaUserCenterOps floatVaule:_characterSize saveForKey:kReadFontSize];
    if (!_content || _content.length == 0) {
        return;
    }
    [self contentSettingAgain];

}

- (void)setBgColor:(UIColor *)abgColor
{
    [_bgColor release];
    _bgColor = [abgColor retain];
    if (!_content || _content.length == 0) {
        return;
    }
    self.leavesView.backgroundColor = _bgColor;
}


- (void)setCharacterColor:(UIColor *)acharacterColor
{
    [_characterColor release];
    _characterColor = [acharacterColor retain];
    if (!_content || _content.length == 0) {
        return;
    }
    [self contentSettingAgain];
}

- (void)setCharacterSize:(CGFloat)aSize
{
    _characterSize = aSize;
    if (!_content || _content.length == 0) {
        return;
    }
    [self contentSettingAgain];
}

- (void)setCharacterFont:(NSString *)acharacterFont
{
    [_characterFont release];
    _characterFont = [acharacterFont copy];
    if (!_content || _content.length == 0) {
        return;
    }
    [self contentSettingAgain];
}


//control view control method

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if ((tap.state & UIGestureRecognizerStateRecognized) == UIGestureRecognizerStateRecognized) {
        
        [self setControlsVisible:!self.controlsVisible animated:YES];
        
    }
}



- (void)setControlsVisible:(BOOL)controlsVisible {
    [self setControlsVisible:controlsVisible animated:NO];
}

- (void)setControlsVisible:(BOOL)controlsVisible animated:(BOOL)animated {
    if (controlsVisible) {
        [self bringSubviewToFront:self.controlsView];
    } else {
        //        [self.controlsView.volumeControl setExpanded:NO animated:YES];
    }
    
    if (controlsVisible != _controlsVisible) {
        _controlsVisible = controlsVisible;
        
        NSTimeInterval duration = animated ? kHumFadeDuration : 0.;
        HumLeavesControlAction willAction = controlsVisible ? HumLeavesControlActionWillShowControls : HumLeavesControlActionWillHideControls;
        HumLeavesControlAction didAction = controlsVisible ? HumLeavesControlActionDidShowControls : HumLeavesControlActionDidHideControls;
        
       [self humLeavesControl:self.controlsView didPerformAction:willAction];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
        
        __block HMLeavesView *weakSelf = self;
        [UIView animateWithDuration:duration
                              delay:0.
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf->_controlsView.alpha = controlsVisible ? 1.f : 0.f;
                         } completion:^(BOOL finished) {
                             [weakSelf restartFadeOutControlsViewTimer];
                             [weakSelf humLeavesControl:weakSelf->_controlsView didPerformAction:didAction];
                             
                             if (!controlsVisible) {
                                 [self sendSubviewToBack:self.controlsView];
                            }
                             
                             //self.controlsView.scrubberControl.layer.shouldRasterize = NO;
                         }];
        
        if (self.controlStyle == HumLeavesControlStyleFullscreen) {
            [[UIApplication sharedApplication] setStatusBarHidden:(!controlsVisible) withAnimation:UIStatusBarAnimationFade];
        }
    }
}

- (void)fadeOutControls {
    if (_shouldHideControls) {
        [self setControlsVisible:NO animated:YES];
    }
}


- (void)setControlStyle:(HumLeavesControlStyle)controlStyle {
    if (controlStyle != self.controlsView.controlStyle) {
        self.controlsView.controlStyle = controlStyle;
        
        BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        // hide status bar in fullscreen, restore to previous state
        if (controlStyle == HumLeavesControlStyleFullscreen) {
            [[UIApplication sharedApplication] setStatusBarStyle: (isIPad ? UIStatusBarStyleBlackOpaque : UIStatusBarStyleBlackTranslucent)];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
            [[UIApplication sharedApplication] setStatusBarHidden:!_statusBarVisible withAnimation:UIStatusBarAnimationFade];
        }
    }
    
    self.controlsVisible = NO;
}




////////////////////////////////////////////////////////////////////////
#pragma mark - HumLeavesControlActionDelegate
////////////////////////////////////////////////////////////////////////

- (void)humLeavesControl:(id)control didPerformAction:(HumLeavesControlAction)action {
    [self stopFadeOutControlsViewTimer];
    
    switch (action) {
            case HumLeavesControlActionBack:{
            if (_delegateFlags.didBack) {
                _shouldHideControls = FALSE;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
                    [self.delegate humLeavesBack:self];
                }
                break;
                
        }
        case HumLeavesControlActionFontAdd:{
            
            _shouldHideControls = FALSE;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
            self.fontAdd = 0.5f;
            break;
        }

        case HumLeavesControlActionFontCut:{
            
            _shouldHideControls = FALSE;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
             self.fontAdd = -0.5f;
            break;
        }

            
            
        case HumLeavesControlActionWillShowControls: {
            [self leavesWillShowControlsWithDuration:kHumFadeDuration];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
        case HumLeavesControlActionDidShowControls: {
            [self leavesDidShowControls];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
        case HumLeavesControlActionWillHideControls: {
            [self leavesWillHideControlsWithDuration:kHumFadeDuration];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
        case HumLeavesControlActionDidHideControls: {
            [self leavesDidHideControls];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
            
        default:
            // do nothing
            break;
            
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - MptAVPlayer Subclass Hooks
////////////////////////////////////////////////////////////////////////


- (void)leavesWillShowControlsWithDuration:(NSTimeInterval)duration {
    // do nothing here
}

- (void)leavesDidShowControls {
    // do nothing here
}

- (void)leavesWillHideControlsWithDuration:(NSTimeInterval)duration {
    // do nothing here
}

- (void)leavesDidHideControls {
    // do nothing here
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Controls
////////////////////////////////////////////////////////////////////////

- (void)stopFadeOutControlsViewTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
}

- (void)restartFadeOutControlsViewTimer {
    [self stopFadeOutControlsViewTimer];
    
    [self performSelector:@selector(fadeOutControls) withObject:nil afterDelay:kHumControlVisibilityDuration];
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Core Text
////////////////////////////////////////////////////////////////////////

- (BOOL)buildFrames //创建分页信息
{
    
    self.frames = [NSMutableArray array];
    self.attributes = [NSMutableArray array];
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.bounds, _offsetX, _offsetY);
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attString);
    CFRelease(path);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    BqsLog(@"All attString leng : %d",[self.attString length]);
    
    while (textPos < [self.attString length]) { //4
        CGRect colRect;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            colRect = CGRectMake(0, 0 , textFrame.size.width/2-10, textFrame.size.height-40);
        }else {
            colRect = CGRectMake(_offsetX, _offsetY , textFrame.size.width-_offsetX-_bottomX, textFrame.size.height-_offsetY-_bottomY);
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        //        [self attachImagesWithFrame:frame inColumnView: content];
        NSRange subRange = NSMakeRange(frameRange.location, frameRange.length);
        NSAttributedString *subString = [self.attString  attributedSubstringFromRange:subRange];
        
        [self.attributes addObject:subString];
        [self.frames addObject: (id)frame];
        
        if (frameRange.length == 0) {
            BqsLog(@"Error When frameRange == 0");
            break;
        }
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        CFRelease(frame);
        
        columnIndex++;
    }
    CFRelease(framesetter);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _totalPageNum = (columnIndex+1) / 2;
    }else {
        _totalPageNum = columnIndex;
    }
    
    return TRUE;
}


- (BOOL)stringParaseAgain
{
    if (!_content || _content.length == 0) {
        return FALSE;
    }
    self.attString = nil;
    self.images = nil;
    
    
    MarkupParser* p = [[[MarkupParser alloc] init] autorelease];
    p.fontAdd = _fontAdd;
    p.setColor = _characterColor;
    p.setFont = _characterFont;
    p.setFontSize = _characterSize;
    
    self.attString = [p attrStringFromMarkup:self.transmitText]; //解析数据
    self.images = p.images;
    self.linkes = p.linkeres; //链接
    
    self.attString = [NSMutableAttributedString attributedStringWithAttributedString:self.attString];
    
   return [self ParagraphStyleAttributeSetting:self.attString];
    
    
}








- (BOOL)ParagraphStyleAttributeSetting:(NSMutableAttributedString *)attributeSting // 设置文章间隔距离
{
    /*****设置字间距离*********/
    long number = _characterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributeSting addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0, [attributeSting length])];
    CFRelease(num);
    
    /*****设置对齐方式*********/
    CTParagraphStyleSetting alignmentStyle;
    CTTextAlignment alignment = kCTLeftTextAlignment;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    
    /*****设置行间距离*********/
    CGFloat lineSpace = _linesSpacing;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
    
    
    //设置文本段间距
    CGFloat paragraphSpacing = _paragraphSpacing;
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    paragraphSpaceStyle.value = &paragraphSpacing;
    
    CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
    //给文本添加设置
    [attributeSting addAttribute:(id)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0 , [attributeSting length])];
    
    return TRUE;
}



-(void)attachImagesWithFrame:(CTFrameRef)f withImages:(NSMutableArray *)imags withContext:(CGContextRef) ctx inIndex:(NSUInteger)index//inColumnView:(OHAttributedLabel*)col
{
    
    CTFrameDraw(f, ctx);//CTFrmeDraw in CGContextRef
    
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    
    NSMutableArray *imgFrams  = [NSMutableArray array];
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [imags objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:kCTLocation] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[imags count]) return; //quit if no images for this column
        nextImage = [imags objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:kCTLocation] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds;
	            CGFloat ascent;//height above the baseline
	            CGFloat descent;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
	            runBounds.origin.x = origins[lineIndex].x  + xOffset;
	            runBounds.origin.y = origins[lineIndex].y;
	            runBounds.origin.y -= descent;
                //NSLog(@"name %@",[nextImage objectForKey:@"fileName"]);
                //                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                NSString *imgStr = [nextImage objectForKey:kCTFileName];
                //NSLog(@"img %@",img);
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                
                //-->
                NSString *type = [nextImage objectForKey:kCTType];
                [imgFrams  addObject: //11
                 [NSArray arrayWithObjects:imgStr, NSStringFromCGRect(imgBounds), type, nil]
                 ];
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: kCTLocation] intValue];
                }
                
            }
        }
        lineIndex++;
    }
    
    [self.paraImagesDictory setObject:imgFrams forKey:[NSNumber numberWithInt:index]];
    
    NSMutableArray *imgViewAry = [self.asyImgViews objectForKey:[NSNumber numberWithInt:index]]; //case for load the async view more than one time in the same page
    if (imgViewAry) {
        for (HumWebImageView *img in imgViewAry) {
            img.delegate = nil;
            [img release];
        }
        [imgViewAry removeAllObjects];
    }
    imgViewAry = nil;
    imgViewAry = [NSMutableArray array];
    
    for (NSArray* imageData in imgFrams )
    {
        
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        NSString *type = [imageData objectAtIndex:2];
       
        
        //        CGContextDrawImage(ctx, imgBounds, img.CGImage);
        //哥添加的代码
        CGRect rect = CGRectMake(imgBounds.origin.x, self.frame.size.height-imgBounds.origin.y-imgBounds.size.height, imgBounds.size.width, imgBounds.size.height);
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        //        imageView.image = img;
        
       
        if ([type isEqualToString:kCTImgDefaultType]) {
            UIImage* img = [self.imgDic objectForKey:[imageData objectAtIndex:0]];
            if (!img) {
                HumWebImageView *imageView = [[HumWebImageView alloc] initWithFrame:rect];
                imageView.imgDelegate = self;
                imageView.style = HUMWebImageStyleTopCentre;
                imageView.imgTag = index;
                imageView.imgUrl = [imageData objectAtIndex:0];
                [imgViewAry addObject:imageView];
                
            }
//            img = [UIImage imageNamed:[imageData objectAtIndex:0]];//default img
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
            UIImage* img = [UIImage imageNamed:[imageData objectAtIndex:0]];
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickEmojiImage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self.asyImgViews setObject:imgViewAry forKey:[NSNumber numberWithInt:index]];

    
}


-(void)redrawImagesWithFrame:(CTFrameRef)f withImages:(NSMutableArray *)imags withContext:(CGContextRef) ctx inIndex:(NSUInteger)index//inColumnView:(OHAttributedLabel*)col
{
    
    CTFrameDraw(f, ctx);//CTFrmeDraw in CGContextRef
    
    
    NSMutableArray *imgFrams = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:index]];
    
    for (NSArray* imageData in imgFrams)
    {
        
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        NSString *type = [imageData objectAtIndex:2];
        
        //        CGContextDrawImage(ctx, imgBounds, img.CGImage);
        //
//        CGRect rect = CGRectMake(imgBounds.origin.x, self.view.frame.size.height-imgBounds.origin.y-imgBounds.size.height, imgBounds.size.width, imgBounds.size.height);
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        //        imageView.image = img;
        
        
        if ([type isEqualToString:kCTImgDefaultType]) {
            UIImage* img = [self.imgDic objectForKey:[imageData objectAtIndex:0]];
            if (!img) {
                
            }
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
            UIImage* img = [UIImage imageNamed:[imageData objectAtIndex:0]];
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickEmojiImage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}


-(void)leafAddLinker:(LeavesView *)leaf withLines:(NSMutableArray *)allLinkes withFrame:(CTFrameRef)frame
{
    //     NSString *string = attribstring.string;
    
    int linkIndex = 0; //3
    if ([self.linkes count] == 0) {
        return;
    }
    NSDictionary* nextLink = [self.linkes objectAtIndex:linkIndex];
    int linkLocation = [[nextLink objectForKey:kCTLocation] intValue];
    int linkLength = [[nextLink objectForKey:kCTLength] intValue];
    
    
    
    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    while ( linkLocation < frameRange.location ) {
        linkIndex++;
        if (linkIndex>=[self.linkes count]) return; //quit if no images for this column
        nextLink = [self.linkes objectAtIndex:linkIndex];
        linkLocation = [[nextLink objectForKey:kCTLocation] intValue];
        linkLength = [[nextLink objectForKey:kCTLength] intValue];
    }
    while (linkLocation + linkLength < frameRange.location + frameRange.length) {
        NSString *linkUrl = [nextLink objectForKey:kCTHyperlink];
        [leaf addCustomLink:[NSURL URLWithString:linkUrl] inRange:NSMakeRange(linkLocation, linkLength)];
        linkIndex++;
        if (linkIndex>=[self.linkes count]) return;
        nextLink = [self.linkes objectAtIndex:linkIndex];
        linkLocation = [[nextLink objectForKey:kCTLocation] intValue];
        linkLength = [[nextLink objectForKey:kCTLength] intValue];
    }
    
}



- (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //    NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='16' height='16'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    [m_EmojiDic release];
    return text;
}





#pragma mark AsyncImageView Delegate
- (void)imgDownload:(AsyncImageView *)sender img:(UIImage *)img
{
    int index = [sender.index intValue];
    [self.imgDic setObject:img forKey:sender.urlString];
    [self.leavesView reloadCurrentPage:index];
    
}

- (void)humWebImageDidDownloader:(HumWebImageView *)view image:(UIImage *)image{
    int index = view.imgTag;
    [self.imgDic setObject:image forKey:view.imgUrl];
    [self.leavesView reloadCurrentPage:index];
}




#pragma mark  LeavesViewDelegate methods

- (void)leavef:(LeavesView *)leaf showController:(BOOL)visiale{
    [self setControlsVisible:!self.controlsVisible animated:YES];
}

- (BOOL)leavef:(LeavesView *)leaf shouldFollowLink:(NSTextCheckingResult *)active
{
    [[UIApplication sharedApplication] openURL:active.URL];
    return FALSE;
}

- (int) eventTouchAtPoint:(CGPoint)point atPageIndex:(NSUInteger)pageIndex
{
    CGPoint framPoint = CGPointMake(point.x, self.frame.size.height - point.y);
    NSMutableArray *imgFrams = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:pageIndex]];
    int findIndex = 0;
    for (NSArray* imageData in imgFrams)
    {
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        if (CGRectContainsPoint(imgBounds, framPoint)) {
            return findIndex;
        }
        findIndex++;
    }
    return -1;
    
}
- (void) excuteEventAtIndex:(int)index atPageIndex:(NSUInteger)pageIndex
{
    NSLog(@"excuteEventAtIndex index: %d,pageIndex = %d",index,pageIndex);
    NSMutableArray *imgViews = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:pageIndex]];
    if ([imgViews count] > index) {
        NSArray *imgInfo = [imgViews objectAtIndex:index];
        UIImage *img = [self.imgDic objectForKey:[imgInfo objectAtIndex:0]];

        
        CGRect imgBounds = CGRectFromString([imgInfo objectAtIndex:1]);
    
        CGRect rect = CGRectMake(imgBounds.origin.x, self.frame.size.height-imgBounds.origin.y-imgBounds.size.height+18, imgBounds.size.width, imgBounds.size.height);
        
        

        HMImagePopManager *popView = [[HMImagePopManager alloc] initWithParentConroller:self.parentController DefaultImg:img imageUrl:[imgInfo objectAtIndex:0] imageFrame:rect];
        [popView handleFocusGesture:nil];
    
    }
}


- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex {
    
}

- (void) leavesView:(LeavesView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex {
//    if (pageIndex >= self.attributes.count) {
//        pageIndex = self.attributes.count - 1;
//    }
//    
//    id subString = [self.attributes objectAtIndex:pageIndex];
//    if (![subString isKindOfClass:[NSAttributedString class]]) {
//        return;
//    }
//    id subCTFrame = [self.frames objectAtIndex:pageIndex];
    
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
   
	return _totalPageNum;
}

- (CTFrameRef) getTextFrameAtPage:(NSUInteger)index
{
    if (index >= self.frames.count) {
        return nil;
    }
     id subCTFrame = [self.frames objectAtIndex:index];
    return (CTFrameRef)subCTFrame;
}

- (NSMutableAttributedString *)getAttributedTextAtPage:(NSUInteger)index
{
    if (index >= self.attributes.count) {
        return nil;
    }
    id subString = [self.attributes objectAtIndex:index];
    return (NSMutableAttributedString *)subString;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {

    if (index >= self.attributes.count) {
        index = self.attributes.count - 1;
    }
    
    id subString = [self.attributes objectAtIndex:index];
    if (![subString isKindOfClass:[NSAttributedString class]]) {
        return;
    }
    id subCTFrame = [self.frames objectAtIndex:index];
    
    CGRect rc = CGContextGetClipBoundingBox(ctx);
    
    UIImage *img = [[Env sharedEnv] cacheImage:@"dota_read_bg.png"];
    if(nil != img) {
         CGContextDrawImage(ctx, rc, img.CGImage);
    }


    [self attachImagesWithFrame:(CTFrameRef)subCTFrame withImages:self.images withContext:ctx inIndex:index];
    
}

- (void) asyRenderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx
{
    if (index >= self.attributes.count) {
        index = self.attributes.count - 1;
    }
    
    id subString = [self.attributes objectAtIndex:index];
    if (![subString isKindOfClass:[NSAttributedString class]]) {
        return;
    }
    id subCTFrame = [self.frames objectAtIndex:index];
    
    CGRect rc = CGContextGetClipBoundingBox(ctx);
    
    UIImage *img = [[Env sharedEnv] cacheImage:@"dota_read_bg.png"];
    if(nil != img) {
        CGContextDrawImage(ctx, rc, img.CGImage);
    }

    
    [self redrawImagesWithFrame:(CTFrameRef)subCTFrame withImages:self.images withContext:ctx inIndex:index];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
