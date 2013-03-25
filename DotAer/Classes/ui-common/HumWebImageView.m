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

#define kZoomStep 2

#define DOUBLE_TAP_DELAY 0.35

#define kCircleProgWidth 177
#define kCircleProgHeigh 177

@interface  HumWebImageView(){
    CGPoint  _pointToCenterAfterResize;
    CGFloat  _scaleToRestoreAfterResize;
}


@end


@implementation HumWebImageView
@synthesize downloader = _downloader;
@synthesize cacheFile = _cacheFile;
@synthesize imgDelegate;
@synthesize imgTag;
@synthesize imgUrl = _imgUrl;
@synthesize style = _style;
@synthesize displayStyle = _displayStyle;
@synthesize progressStyle = _progressStyle;
@synthesize downImage;
@synthesize ciclePrg;
@synthesize imageView;


- (void)dealloc
{
    [_acty release];_acty = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.cacheFile = nil;
    self.imgDelegate = nil;
    self.downImage = nil;
    self.ciclePrg = nil;
    self.imageView = nil;
    [_imgUrl release];
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
    [self displayImage:image];

    self.downImage = image;
    if (self.imgDelegate && [self.imgDelegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
        [self.imgDelegate humWebImageDidDownloader:self image:image];
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
    [self displayImage:image];
    self.downImage = image;
    if (self.imgDelegate && [self.delegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
        [self.imgDelegate humWebImageDidDownloader:self image:image];
    }
    [_acty stopAnimating];
    
}

- (void)setProgressStyle:(HMProgressStyle)prgStyle{
    if (_progressStyle == prgStyle) {
        return;
    }
    _progressStyle = prgStyle;
}


-(void)setImgUrl:(NSString *)imgUrl{
    [_downloader cancelAll];
    [_imgUrl release]; _imgUrl = nil;
    _imgUrl = [imgUrl copy];
    if(_imgUrl && _imgUrl.length>0){
        [self loadImageWithUrl:_imgUrl];
    }
    
}
- (void)setStyle:(HUMWebImageStyle)astyle
{
    if(_style == astyle)
        return;
    _style = astyle;
    if(_imgUrl && _imgUrl.length>0)
        [self loadImageWithUrl:_imgUrl];
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
        [self displayImage:image];
        self.downImage = image;
        if (self.imgDelegate && [self.imgDelegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
            [self.imgDelegate humWebImageDidDownloader:self image:image];
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
           
            [self displayImage:image];
            self.downImage = image;
            if (self.imgDelegate && [self.imgDelegate respondsToSelector:@selector(humWebImageDidDownloader:image:)]) {
                [self.imgDelegate humWebImageDidDownloader:self image:image];
            }
        }
    
    }
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
        
        
        self.delegate = self;
        self.imageView = nil;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = TRUE;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        UITapGestureRecognizer *scrollViewDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewDoubleTap:)];
        [scrollViewDoubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:scrollViewDoubleTap];
        
        UITapGestureRecognizer *scrollViewTwoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewTwoFingerTap:)];
        [scrollViewTwoFingerTap setNumberOfTouchesRequired:2];
        [self addGestureRecognizer:scrollViewTwoFingerTap];
        
        UITapGestureRecognizer *scrollViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewSingleTap:)];
        [scrollViewSingleTap requireGestureRecognizerToFail:scrollViewDoubleTap];
        [self addGestureRecognizer:scrollViewSingleTap];

    
        self.cacheFile = file;
        _style = style;
        _progressStyle = HMProgressNO;
        _displayStyle = HMImageDisplaySome;
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





- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
    
    CGPoint contentOffset = self.contentOffset;
    
    // ensure horizontal offset is reasonable
    if (frameToCenter.origin.x != 0.0)
        contentOffset.x = 0.0;
    
    // ensure vertical offset is reasonable
    if (frameToCenter.origin.y != 0.0)
        contentOffset.y = 0.0;
    
    self.contentOffset = contentOffset;
    
    // ensure content insert is zeroed out using translucent navigation bars
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    _acty.frame = CGRectMake(0, 0, 20, 20);
    _acty.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.ciclePrg.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
    
    _acty.frame = CGRectMake(0, 0, 20, 20);
    _acty.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.ciclePrg.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

}

#pragma mark - Public Implementation
#pragma mark -

- (void)prepareForReuse {
    // start by dropping any views and resetting the key properties
    if (self.imageView != nil) {
        for (UIGestureRecognizer *gestureRecognizer in self.imageView.gestureRecognizers) {
            [self.imageView removeGestureRecognizer:gestureRecognizer];
        }
    }
    
   
    [self.imageView removeFromSuperview];
    
    
    self.imageView = nil;
}

- (void)displayImage:(UIImage *)image {
    
    if (!image) {
        return;
    }
    
    [self prepareForReuse];
    
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.userInteractionEnabled = TRUE;

    [self insertSubview:view belowSubview: self.ciclePrg];
    self.imageView = view;
    [view release];
    
    [self configureForImageSize:image.size];
    
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    UITapGestureRecognizer *doubleTwoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    [doubleTwoFingerTap setNumberOfTapsRequired:2];
    [doubleTwoFingerTap setNumberOfTouchesRequired:2];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [twoFingerTap requireGestureRecognizerToFail:doubleTwoFingerTap];
    
    [self.imageView addGestureRecognizer:singleTap];
    [self.imageView addGestureRecognizer:doubleTap];
    [self.imageView addGestureRecognizer:twoFingerTap];
    [self.imageView addGestureRecognizer:doubleTwoFingerTap];
    [singleTap release];
    [doubleTap release];
    [twoFingerTap release];
    [doubleTwoFingerTap release];
           
//    [self setMaxMinZoomScalesForCurrentBounds];
//    [self setZoomScale:self.minimumZoomScale animated:FALSE];
}

- (void)configureForImageSize:(CGSize)imageSize
{
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}


#pragma mark - Gestures
#pragma mark -

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imgDelegate != nil && [self.imgDelegate respondsToSelector:@selector(photoViewDidSingleTap:)]) {
        [self.imgDelegate photoViewDidSingleTap:self];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.zoomScale == self.maximumZoomScale) {
        // jump back to minimum scale
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:self.minimumZoomScale];
    }
    else {
        // double tap zooms in
        CGFloat newScale = MIN(self.zoomScale * kZoomStep, self.maximumZoomScale);
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    }
    
    if (self.imgDelegate != nil && [self.imgDelegate respondsToSelector:@selector(photoViewDidDoubleTap:)]) {
        [self.imgDelegate photoViewDidDoubleTap:self];
    }
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    CGFloat newScale = MAX([self zoomScale] / kZoomStep, self.minimumZoomScale);
    [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    
    if (self.imgDelegate != nil && [self.imgDelegate respondsToSelector:@selector(photoViewDidTwoFingerTap:)]) {
        [self.imgDelegate photoViewDidTwoFingerTap:self];
    }
}

- (void)handleDoubleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imgDelegate != nil  && [self.imgDelegate respondsToSelector:@selector(photoViewDidDoubleTwoFingerTap:)]) {
        [self.imgDelegate photoViewDidDoubleTwoFingerTap:self];
    }
}

- (void)handleScrollViewSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imgDelegate != nil  && [self.imgDelegate respondsToSelector:@selector(photoViewDidSingleTap:)]) {
        [self.imgDelegate photoViewDidSingleTap:self];
    }
}

- (void)handleScrollViewDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imageView.image == nil) return;
    CGPoint center =[self adjustPointIntoImageView:[gestureRecognizer locationInView:gestureRecognizer.view]];
    
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        CGFloat newScale = MIN([self zoomScale] * kZoomStep, self.maximumZoomScale);
        [self updateZoomScale:newScale withCenter:center];
    }
}

- (void)handleScrollViewTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.imageView.image == nil) return;
    CGPoint center =[self adjustPointIntoImageView:[gestureRecognizer locationInView:gestureRecognizer.view]];
    
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        CGFloat newScale = MAX([self zoomScale] / kZoomStep, self.minimumZoomScale);
        [self updateZoomScale:newScale withCenter:center];
    }
}

- (CGPoint)adjustPointIntoImageView:(CGPoint)center {
    BOOL contains = CGRectContainsPoint(self.imageView.frame, center);
    
    if (!contains) {
        center.x = center.x / self.zoomScale;
        center.y = center.y / self.zoomScale;
        
        // adjust center with bounds and scale to be a point within the image view bounds
        CGRect imageViewBounds = self.imageView.bounds;
        
        center.x = MAX(center.x, imageViewBounds.origin.x);
        center.x = MIN(center.x, imageViewBounds.origin.x + imageViewBounds.size.height);
        
        center.y = MAX(center.y, imageViewBounds.origin.y);
        center.y = MIN(center.y, imageViewBounds.origin.y + imageViewBounds.size.width);
        
        return center;
    }
    
    return CGPointZero;
}

#pragma mark - Support Methods
#pragma mark -

- (void)updateZoomScale:(CGFloat)newScale {
    CGPoint center = CGPointMake(self.imageView.bounds.size.width/ 2.0, self.imageView.bounds.size.height / 2.0);
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale {
    CGPoint center = [gestureRecognizer locationInView:gestureRecognizer.view];
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center {
    assert(newScale >= self.minimumZoomScale);
    assert(newScale <= self.maximumZoomScale);
    
    if (self.zoomScale != newScale) {
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    assert(scale >= self.minimumZoomScale);
    assert(scale <= self.maximumZoomScale);
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



- (void)setMaxMinZoomScalesForCurrentBounds {
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    CGSize boundsSize = self.bounds.size;
    
    CGFloat minScale = 0.25;
    
    if (self.imageView.bounds.size.width > 0.0 && self.imageView.bounds.size.height > 0.0) {
        // calculate min/max zoomscale
        CGFloat xScale = boundsSize.width  / self.imageView.bounds.size.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / self.imageView.bounds.size.height;   // the scale needed to perfectly fit the image height-wise
        
        //        xScale = MIN(1, xScale);
        //        yScale = MIN(1, yScale);
        
        minScale = MIN(xScale, yScale);
    }
    
    CGFloat maxScale = minScale * (kZoomStep * 2);
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)prepareToResize {
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.imageView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.imageView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset {
    return CGPointZero;
}

#pragma mark - UIScrollViewDelegate Methods
#pragma mark -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Layout Debugging Support
#pragma mark -

- (void)logRect:(CGRect)rect withName:(NSString *)name {
    NSLog(@"%@: %f, %f / %f, %f", name, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

- (void)logLayout {
    NSLog(@"#### PZPhotoView ###");
    
    [self logRect:self.bounds withName:@"self.bounds"];
    [self logRect:self.frame withName:@"self.frame"];
    
    NSLog(@"contentSize: %f, %f", self.contentSize.width, self.contentSize.height);
    NSLog(@"contentOffset: %f, %f", self.contentOffset.x, self.contentOffset.y);
    NSLog(@"contentInset: %f, %f, %f, %f", self.contentInset.top, self.contentInset.right, self.contentInset.bottom, self.contentInset.left);
}





@end
