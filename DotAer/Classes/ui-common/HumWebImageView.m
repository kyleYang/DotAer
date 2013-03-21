//
//  HumWebImageView.m
//  DotAer
//
//  Created by Kyle on 13-3-5.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumWebImageView.h"
#import "HumDotaDataMgr.h"
#import "HumDotaNetOps.h"
#import "PackageFile.h"
#import "BqsUtils.h"
#import "Env.h"


#define DOUBLE_TAP_DELAY 0.35

#define kCircleProgWidth 177
#define kCircleProgHeigh 177

@interface  HumWebImageView()


@end


@implementation HumWebImageView
@synthesize downloader = _downloader;
@synthesize cacheFile = _cacheFile;
@synthesize delegate;
@synthesize imgTag;
@synthesize logoUrl = _logoUrl;
@synthesize style = _style;
@synthesize progressStyle = _progressStyle;
@synthesize downImage;
@synthesize ciclePrg;

- (void)dealloc
{
    [_acty release];_acty = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.cacheFile = nil;
    self.delegate = nil;
    self.downImage = nil;
    self.ciclePrg = nil;
    [_logoUrl release];
    [super dealloc];
}


- (void)loadCacheImage:(NSString *)urlPath
{
    NSData *imageDate = [self.cacheFile readDataName:urlPath];
    UIImage* image = [UIImage imageWithData:imageDate];
    CGSize size =  self.frame.size;
    switch (_style) {
        case HUMWebImageStyleNO:
            break;
        case HUMWebImageStyleScale:
            image = [image scaleImagetoSize:size];
            break;
        case HUMWebImageStyleCut:
            image = [image cutImagetoSize:size];
            break;
        case HUMWebImageStyleStretch:
            image = [image stretchImagetoSize:size];
            break;
        case HUMWebImageStyleTopLeft:
            image = [image topLeftImagetoSize:size];
            break;
        case HUMWebImageStyleTopCentre:
            image = [image centreImagetoSize:size];
            break;
        case HUMWeiImageStyleEqualHeight:
            image = [image topLeftImagetoSize:size];
            break;
        case HUMWebImageStyleEqualWidth:
            image = [image topLeftImagetoSize:size];
            break;
        default:
            break;
    }
    self.image = image;
    self.downImage = image;
    if (self.delegate && [self.delegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
        [self.delegate humWebImageDidDownloader:self image:image];
    }
    [_acty stopAnimating];
    
}
- (void)loadCacheImage:(NSString *)url Widht:(NSUInteger)widht Height:(NSUInteger)height
{
    NSString *smallURL = [HumDotaNetOps imageConvert:url width:[NSString stringWithFormat:@"%d",widht] heigh:[NSString stringWithFormat:@"%d",height]];
    NSData *imageDate = [self.cacheFile readDataName:smallURL];
    UIImage* image = [UIImage imageWithData:imageDate];
    CGSize size =  self.frame.size;
    switch (_style) {
        case HUMWebImageStyleNO:
            break;
        case HUMWebImageStyleScale:
            image = [image scaleImagetoSize:size];
            break;
        case HUMWebImageStyleCut:
            image = [image cutImagetoSize:size];
            break;
        case HUMWebImageStyleStretch:
            image = [image stretchImagetoSize:size];
            break;
        case HUMWebImageStyleTopLeft:
            image = [image topLeftImagetoSize:size];
            break;
        case HUMWebImageStyleTopCentre:
            image = [image centreImagetoSize:size];
            break;
        case HUMWeiImageStyleEqualHeight:
            image = [image topLeftImagetoSize:size];
            break;
        case HUMWebImageStyleEqualWidth:
            image = [image topLeftImagetoSize:size];
            break;
        default:
            break;
    }
    self.image = image;
    self.downImage = image;
    if (self.delegate && [self.delegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
        [self.delegate humWebImageDidDownloader:self image:image];
    }
    [_acty stopAnimating];
    
}

- (void)setProgressStyle:(HMProgressStyle)prgStyle{
    if (_progressStyle == prgStyle) {
        return;
    }
    _progressStyle = prgStyle;
}


-(void)setLogoUrl:(NSString *)_url
{
    [_downloader cancelAll];
    [_logoUrl release]; _logoUrl = nil;
    _logoUrl = [_url copy];
    if(_logoUrl && _logoUrl.length>0){
        [self loadImageWithUrl:_logoUrl];
    }
    
}
- (void)setStyle:(HUMWebImageStyle)astyle
{
    if(_style == astyle)
        return;
    _style = astyle;
    if(_logoUrl && _logoUrl.length>0)
        [self loadImageWithUrl:_logoUrl];
}

- (void)loadImageWithUrl:(NSString *)url
{
    NSData *imageDate = [self.cacheFile readDataName:url];
    if (imageDate) {
        UIImage* image = [UIImage imageWithData:imageDate];
        CGSize size =  self.frame.size;
        switch (_style) {
            case HUMWebImageStyleNO:
                break;
            case HUMWebImageStyleScale:
                image = [image scaleImagetoSize:size];
                break;
            case HUMWebImageStyleCut:
                image = [image cutImagetoSize:size];
                break;
            case HUMWebImageStyleStretch:
                image = [image stretchImagetoSize:size];
                break;
            case HUMWebImageStyleTopLeft:
                image = [image topLeftImagetoSize:size];
                break;
            case HUMWebImageStyleTopCentre:
                image = [image centreImagetoSize:size];
                break;
            case HUMWeiImageStyleEqualHeight:
                image = [image topLeftImagetoSize:size];
                break;
            case HUMWebImageStyleEqualWidth:
                image = [image topLeftImagetoSize:size];
                break;
            default:
                break;

        }
        [_acty stopAnimating];
        self.image = image;
        self.downImage = image;
        if (self.delegate && [self.delegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
            [self.delegate humWebImageDidDownloader:self image:image];
        }
        return;
    }
    if (_progressStyle == HMProgressNO) {
        [_acty startAnimating];
    }else if(_progressStyle == HMProgressCircle){
        self.ciclePrg.hidden = NO;
        [self.ciclePrg setPercent:0 animated:NO];
    }
    
    [self.downloader cancelAll];
    _netsTaskID = [_downloader addCachedTask:url PkgFile:self.cacheFile Target:self Callback:@selector(getImageCB:) Attached:nil];
    
}

- (void)cancelTask
{
    [_downloader cancelAll];
}

- (void)loadImageWithUrl:(NSString *)url Widht:(NSUInteger)widht Height:(NSUInteger)height
{
    NSString *smallURL = [HumDotaNetOps imageConvert:url width:[NSString stringWithFormat:@"%d",widht] heigh:[NSString stringWithFormat:@"%d",height]];
    [self loadImageWithUrl:smallURL];
}


#pragma mark
#pragma mark downlaoder callback
-(void)DownloadProgres:(CGFloat)percentage{
    
    if (_progressStyle == HMProgressCircle) {
        [self.ciclePrg setPercent:percentage animated:YES];
    }
}

- (void)getImageCB:(DownloaderCallbackObj *)cb
{
    
    if (cb) {
        UIImage* image = [UIImage imageWithData:cb.rspData];
        CGSize size =  self.frame.size;
        switch (_style) {
            case HUMWebImageStyleNO:
                break;
            case HUMWebImageStyleScale:
                image = [image scaleImagetoSize:size];
                break;
            case HUMWebImageStyleCut:
                image = [image cutImagetoSize:size];
                break;
            case HUMWebImageStyleStretch:
                image = [image stretchImagetoSize:size];
                break;
            case HUMWebImageStyleTopLeft:
                image = [image topLeftImagetoSize:size];
                break;
            case HUMWebImageStyleTopCentre:
                image = [image centreImagetoSize:size];
                break;
            case HUMWeiImageStyleEqualHeight:
                image = [image topLeftImagetoSize:size];
                break;
            case HUMWebImageStyleEqualWidth:
                image = [image topLeftImagetoSize:size];
                break;
            default:
                break;
        }
        if (_progressStyle == HMProgressNO) {
             [_acty stopAnimating];
        }else if(_progressStyle == HMProgressCircle){
            self.ciclePrg.hidden = YES;
        }
        
        if (image) {
           
            self.image = image;
            self.downImage = image;
            if (self.delegate && [self.delegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
                [self.delegate humWebImageDidDownloader:self image:image];
            }
        }
    
    }
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
        
        HumDotaDataMgr *dm = [HumDotaDataMgr instance];//save news category
        PackageFile *pkg = [dm imgCacheFilePath];
        
        self.cacheFile = pkg;
        _style = HUMWebImageStyleTopCentre;
        _progressStyle = HMProgressNO;
        self.backgroundColor = [UIColor clearColor];
        
        _acty = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_acty];
        _acty.center = self.center;
        _acty.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        
        
        self.ciclePrg = [[[KDGoalBar alloc] initWithFrame:CGRectMake(0, 0, kCircleProgWidth, kCircleProgHeigh)] autorelease];
        [self.ciclePrg setAllowDragging:NO];
        [self.ciclePrg setAllowSwitching:NO];
        [self.ciclePrg setPercent:0 animated:NO];
        self.ciclePrg.hidden = YES;
        [self addSubview:self.ciclePrg];
        
        self.downloader = [[[Downloader alloc] init] autorelease];
        self.downloader.delegate = self;
        self.downloader.bSearialLoad = YES;

       
        
    }
    return self;
}



- (id)init{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    HumDotaDataMgr *dm = [HumDotaDataMgr instance];//save news category
    PackageFile *pkg = [dm imgCacheFilePath];
    
    return [self initWithFrame:frame urlPath:nil pkFile:pkg style:HUMWebImageStyleScale];
}


- (id)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath
{
    HumDotaDataMgr *dm = [HumDotaDataMgr instance];//save news category
    PackageFile *pkg = [dm imgCacheFilePath];
    return [self initWithFrame:frame urlPath:urlPath pkFile:pkg style:HUMWebImageStyleScale];
}


- (id)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath pkFile:(PackageFile *)file style:(HUMWebImageStyle) style{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
        
        self.cacheFile = file;
        _style = style;
        _progressStyle = HMProgressNO;
        self.backgroundColor = [UIColor clearColor];
        
        _acty = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_acty];
        _acty.center = self.center;
        _acty.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        
        self.ciclePrg = [[[KDGoalBar alloc] initWithFrame:CGRectMake(0, 0, kCircleProgWidth, kCircleProgHeigh)] autorelease];
        [self.ciclePrg setAllowDragging:NO];
        [self.ciclePrg setAllowSwitching:NO];
        [self.ciclePrg setPercent:0 animated:NO];
        self.ciclePrg.hidden = YES;
        [self addSubview:self.ciclePrg];
        
        self.downloader = [[[Downloader alloc] init] autorelease];
        self.downloader.delegate = self;
        self.downloader.bSearialLoad = YES;
    
    }
    return self;
}

- (void)setImageFrame:(CGRect)frame
{
    self.frame = frame;
    _acty.frame = CGRectMake(0, 0, 20, 20);
    _acty.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.ciclePrg.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)layoutSubviews
{
    _acty.frame = CGRectMake(0, 0, 20, 20);
    _acty.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.ciclePrg.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}




#pragma mark 
#pragma mark touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // cancel any pending handleSingleTap messages
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    }
    
    // check for 2-finger tap if we've seen multiple touches and haven't yet ruled out that possibility
    else if (multipleTouches && twoFingerTapIsPossible) {
        
        // case 1: this is the end of both touches at once
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0;
            int tapCounts[2]; CGPoint tapLocations[2];
            for (UITouch *touch in touches) {
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) { // it's a two-finger tap if they're both single taps
                tapLocation = webMidpointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];
            }
        }
        
        // case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if touch is a single tap, store its location so we can average it with the second touch location
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        }
        
        // case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = webMidpointBetweenPoints(tapLocation, [touch locationInView:self]);
                [self handleTwoFingerTap];
            }
        }
    }
    
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

CGPoint webMidpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}


#pragma mark Private

- (void)handleSingleTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapDetectingImageView:gotSingleTapAtPoint:)])
        [self.delegate tapDetectingImageView:self gotSingleTapAtPoint:tapLocation];
}

- (void)handleDoubleTap {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tapDetectingImageView:gotDoubleTapAtPoint:)])
        [self.delegate tapDetectingImageView:self gotDoubleTapAtPoint:tapLocation];
}

- (void)handleTwoFingerTap {
    if (self.delegate && [delegate respondsToSelector:@selector(tapDetectingImageView:gotTwoFingerTapAtPoint:)])
        [self.delegate tapDetectingImageView:self gotTwoFingerTapAtPoint:tapLocation];
}






@end
