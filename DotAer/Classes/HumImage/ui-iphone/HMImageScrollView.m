//
//  PanguImageScrollView.m
//  pangu
//
//  Created by yang zhiyun on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMImageScrollView.h"
#import "HumWebImageView.h"
#import "Env.h"
#import "BqsUtils.h"

#define kSumOrgX 5
#define kSumOrgY 5

#define kTagKey @"key="

#define KNavCharColor [UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1.0f]

#define ZOOM_STEP 1.5
#define ZOOM_MIN 0.3

#define SET_FRAME(ARTICLEX) x = ARTICLEX.frame.origin.x + increase;\
if(x < 0) x = pageWidth * 2;\
if(x > pageWidth * 2) x = 0.0f;\
[ARTICLEX setFrame:CGRectMake(x, \
                                   ARTICLEX.frame.origin.y,\
                                   ARTICLEX.frame.size.width,\
                                   ARTICLEX.frame.size.height)]

#define kDefinTimeVas 1
#define kLoadmoreSize 5


@interface HMImageScrollView ()<UIScrollViewDelegate,humWebImageDelegae,UIGestureRecognizerDelegate,HumLeavesControlActionDelegate>
{

    Env *_env;
    
    BOOL _statusBarVisible;
    UIStatusBarStyle _statusBarStyle;
    BOOL _shouldHideControls;
    
    NSInteger befro;
    NSInteger now;
    NSInteger after;
    UIView *_viewZomm;
    NSUInteger _cbIndex;
    NSMutableArray *reuseQueue;
    
    NSUInteger _total;
    
    struct {
        unsigned int didBack:1;
        
    } _delegateFlags;
}

@property (nonatomic, retain) UIScrollView *imgScorll;
@property (nonatomic, retain) NSMutableArray *savedCell;

@property (nonatomic, retain) NSMutableArray *onScreenCells;
@property (nonatomic, retain) NSMutableArray *zommLeft;

@property (nonatomic, retain, readwrite) HMImageControllerView *controlsView;

@property (nonatomic, retain) NSString *sumStr;
@property (nonatomic, retain) UIImageView *summaryBg;
@property (nonatomic, retain) UILabel *summary;

@end

@implementation HMImageScrollView
@synthesize imgScorll;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize imgesAry;
@synthesize onScreenCells = _onScreenCells;
@synthesize zommLeft;
@synthesize savedCell;

@synthesize controlsView = _controlsView;
@synthesize controlsVisible = _controlsVisible;
@synthesize summaryBg;
@synthesize summary;
@synthesize sumStr = _sumStr;

- (void)dealloc
{
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
    [_controlsView release]; _controlsView = nil;
     _dataSource = nil;
    _delegate = nil;
    self.imgScorll = nil;
    self.imgesAry = nil;
    self.savedCell = nil;
    self.onScreenCells = nil;
    self.zommLeft = nil;
    self.summaryBg = nil;
    self.summary = nil;
    [_sumStr release]; _sumStr = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _env = [Env sharedEnv];
        
        self.backgroundColor = [UIColor blackColor];
        
        self.imgScorll = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        self.imgScorll.delegate = self;
        self.imgScorll.BackgroundColor = [UIColor blackColor];
        self.imgScorll.pagingEnabled = YES;
        self.imgScorll.bouncesZoom = YES;
//        self.imgScorll.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.imgScorll setMaximumZoomScale:3];
        [self.imgScorll setMinimumZoomScale:.5];
        [self.imgScorll setZoomScale:1];
        [self.imgScorll setContentOffset:CGPointZero];
        [self.imgScorll setContentSize:CGSizeMake(self.frame.size.width*3, self.frame.size.height)];
        [self addSubview:self.imgScorll];
        
        
        self.summaryBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 0)] autorelease];
        self.summaryBg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.summaryBg];
        
        self.summary = [[[UILabel alloc] initWithFrame:CGRectMake(kSumOrgX, kSumOrgY, CGRectGetWidth(self.summaryBg.frame)-2*kSumOrgX, CGRectGetHeight(self.summaryBg.frame))] autorelease];
        self.summary.textColor = [UIColor whiteColor];
        self.summary.backgroundColor = [UIColor clearColor];
        self.summary.font = [UIFont systemFontOfSize:13.0f];
        self.summary.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.summaryBg addSubview:self.summary];

        
        _controlsView = [[HMImageControllerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 60)];
        _controlsView.delegate = self;
        [self addSubview:_controlsView];
        

        _controlsVisible = YES;
        [self setControlsVisible:NO animated:YES];; //初始化控制可见，自动隐藏
        
    
    
        self.savedCell = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        self.onScreenCells = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        self.zommLeft = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        
        _viewZomm = nil;
        _bBlockScrollEvent = FALSE;
        _positset = FALSE;
        _bZooming = FALSE;
        _loadMore = FALSE;
        
        _nowIndex = -1;
        
        thumbViewShowing = TRUE;
        _shouldHideControls = TRUE;

        
    }
    return self;
}




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
        HMImageControlAction willAction = controlsVisible ? HMImageControlActionWillShowControls : HMImageControlActionWillHideControls;
        HMImageControlAction didAction = controlsVisible ? HMImageControlActionWillHideControls : HMImageControlActionDidHideControls;
        
        [self humLeavesControl:self.controlsView didPerformAction:willAction];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
        
        __block HMImageScrollView *weakSelf = self;
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
        
        
        [[UIApplication sharedApplication] setStatusBarHidden:(!controlsVisible) withAnimation:UIStatusBarAnimationFade];
        
    }
}

- (void)fadeOutControls {
    if (_shouldHideControls) {
        [self setControlsVisible:NO animated:YES];
    }
}







////////////////////////////////////////////////////////////////////////
#pragma mark - HumLeavesControlActionDelegate
////////////////////////////////////////////////////////////////////////

- (void)humLeavesControl:(HMImageControllerView *)control didPerformAction:(HMImageControlAction)action {
    [self stopFadeOutControlsViewTimer];
    
    switch (action) {
        case HMImageControlActionBack:{
            if (_delegateFlags.didBack) {
                _shouldHideControls = FALSE;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutControls) object:nil];
    
               [self.delegate humImageViewBack:self];
            }
            
        }
            
            
        case HMImageControlActionWillShowControls: {
            [self leavesWillShowControlsWithDuration:kHumFadeDuration];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
        case HMImagesControlActionDidShowControls: {
            [self leavesDidShowControls];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
        case HMImageControlActionWillHideControls: {
            [self leavesWillHideControlsWithDuration:kHumFadeDuration];
            [self restartFadeOutControlsViewTimer];
            break;
        }
            
        case HMImageControlActionDidHideControls: {
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


- (void)setSumStr:(NSString *)sumStr{
     [_sumStr release]; _sumStr = nil;
    _sumStr = [sumStr retain];
    
    CGSize size = [_sumStr sizeWithFont:self.summary.font constrainedToSize:self.summary.frame.size lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect frame = self.summaryBg.frame;
    frame.size.height = size.height + kSumOrgY;
    frame.origin.y = CGRectGetHeight(self.bounds)-frame.size.height;
    self.summaryBg.frame = frame;
    
    self.summary.text = _sumStr;
    
}

#pragma mark
#pragma mark imageScrooll


- (void)reloadData{
    
    for (HumWebImageView *temp in self.onScreenCells) {
        [temp removeFromSuperview];
        [temp release];
    }
    [self.onScreenCells removeAllObjects];
    for (HumWebImageView *temp in self.savedCell) {
        [temp release];
    }
    [self.savedCell removeAllObjects];

    if ([_dataSource respondsToSelector:@selector(numberOfItemFor:)]) {
        _total = [_dataSource numberOfItemFor:self];
    }
    
    self.imgScorll.contentOffset = CGPointZero;
    self.imgScorll.contentSize = CGSizeMake(CGRectGetWidth(self.imgScorll.frame)*_total, CGRectGetHeight(self.imgScorll.frame));
    
    NSUInteger nowIndex = self.imgScorll.contentOffset.x/CGRectGetWidth(self.imgScorll.bounds);
    
    for (int i= 0; i<3 && i<_total; i++) {
        HumWebImageView *imageView = [[HumWebImageView alloc] initWithImage:[_env cacheScretchableImage:@"pic_default.png" X:5.0f Y:5.0f]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.delegate = self;
        imageView.style = HUMWebImageStyleNO;
        imageView.progressStyle = HMProgressCircle;
        CGRect frame = CGRectMake(CGRectGetWidth(self.imgScorll.frame)*i, 0,CGRectGetWidth(self.imgScorll.frame),CGRectGetHeight(self.imgScorll.frame));
        imageView.frame = frame;
        imageView.imgTag = i;
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(imageUrlForScrollView:AtIndex:)]) {
            NSString *url = [_dataSource imageUrlForScrollView:self AtIndex:i];
            imageView.logoUrl = url;
        }
        
        if (i == nowIndex) {
            if (_dataSource && [_dataSource respondsToSelector:@selector(summaryForScrollView:AtIndex:)]) {
                NSString *sum = [_dataSource summaryForScrollView:self AtIndex:i];
                self.sumStr = sum;
            }
        }
        
    

        [self.imgScorll addSubview:imageView];
        [self.onScreenCells addObject:imageView];
        [imageView release];
    
    }

}

#pragma mark
#pragma mark dataSource
-(void)setDataSource:(id<HMImageScrollDataSource>)dataSource{
    _dataSource = dataSource;
    _total = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfItemFor:)]) {
        _total = [_dataSource numberOfItemFor:self];
    }
    self.imgScorll.contentOffset = CGPointZero;
    self.imgScorll.contentSize = CGSizeMake(CGRectGetWidth(self.imgScorll.frame)*_total, CGRectGetHeight(self.imgScorll.frame));
    NSUInteger nowIndex = self.imgScorll.contentOffset.x/CGRectGetWidth(self.imgScorll.bounds);
    
    for (int i= 0; i<3 && i<_total; i++) {
        HumWebImageView *imageView = [[HumWebImageView alloc] initWithImage:[_env cacheScretchableImage:@"pic_default.png" X:5.0f Y:5.0f]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.delegate = self;
        imageView.style = HUMWebImageStyleNO;
        imageView.progressStyle = HMProgressCircle;
        CGRect frame = CGRectMake(CGRectGetWidth(self.imgScorll.frame)*i, 0,CGRectGetWidth(self.imgScorll.frame),CGRectGetHeight(self.imgScorll.frame));
        imageView.frame = frame;
        imageView.imgTag = i;
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(imageUrlForScrollView:AtIndex:)]) {
            NSString *url = [_dataSource imageUrlForScrollView:self AtIndex:i];
            imageView.logoUrl = url;
        }
        
        if (i == nowIndex) {
            if (_dataSource && [_dataSource respondsToSelector:@selector(summaryForScrollView:AtIndex:)]) {
                NSString *sum = [_dataSource summaryForScrollView:self AtIndex:i];
                self.sumStr = sum;
            }
        }
        
        
        [self.imgScorll addSubview:imageView];
        [self.onScreenCells addObject:imageView];
        [imageView release];

    }
    
}


- (void)setDelegate:(id<HMImageScrollDelegate>)delegate{
    if (delegate != _delegate) {
        _delegate = delegate;
        
        _delegateFlags.didBack = [delegate respondsToSelector:@selector(humImageViewBack:)];
        
    }

    
}


- (void)scrllEnable
{
    self.imgScorll.scrollEnabled = TRUE;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    if (_bZooming) {
        return;
    }
    
    CGPoint off = self.imgScorll.contentOffset;
    NSUInteger index =  off.x/CGRectGetWidth(self.imgScorll.frame);
    _nowIndex = index;
    
}

//获取重用的cell
- (HumWebImageView *)dequeueReusableCellWithIdentifier{

	if(self.savedCell && [self.savedCell isKindOfClass:[NSArray class]] && self.savedCell.count > 0){
		//找到了重用的 
		HumWebImageView *cell_ = [[[self.savedCell lastObject] retain] autorelease];
		[self.savedCell removeLastObject];
		return cell_;
	}
	return nil;
}

//将要移除屏幕的cell添加到可重用列表中
- (void)addCellToReuseQueue:(HumWebImageView *)cell
{
    [self.savedCell addObject:cell];
    
}


- (void)reloadImageViews{ 
    CGPoint offset = self.imgScorll.contentOffset;
    
    //移掉划出屏幕外的图片 保存3个
    NSMutableArray *readyToRemove = [NSMutableArray array];
    for (HumWebImageView *view in self.onScreenCells) {
        if(view.frame.origin.x + 2*view.frame.size.width  < offset.x || view.frame.origin.x - 2*view.frame.size.width > offset.x ){
            [readyToRemove addObject:view];
        }
    }
    for (HumWebImageView *view in readyToRemove) {
        [self.onScreenCells removeObject:view];
        [view removeFromSuperview];
        view.ciclePrg.hidden = YES;
        [self addCellToReuseQueue:view];
    }
    //遍历图片数组
    
    for (int i = 0;i<_total;i++) {
                
        BOOL OnScreen = FALSE;
        
        if (i*CGRectGetWidth(self.imgScorll.frame)>offset.x - 2*CGRectGetWidth(self.imgScorll.frame) && i*CGRectGetWidth(self.imgScorll.frame) < offset.x + 2*CGRectGetWidth(self.imgScorll.frame) )
            OnScreen = TRUE;
        
        //在屏幕范围内的创建添加
        if (OnScreen) {
            BOOL HasOnScreen = FALSE;
            for (HumWebImageView *vi in self.onScreenCells) {
                if (i == vi.imgTag) {
                    HasOnScreen = TRUE;
                    break;
                }
            }
            if (!HasOnScreen) {
                HumWebImageView *imageView = [self dequeueReusableCellWithIdentifier];
                if(imageView == nil)
                {
                    imageView  = [[HumWebImageView alloc] init];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    [imageView setUserInteractionEnabled:YES];
                    imageView.image = [_env cacheScretchableImage:@"pic_default.png" X:5.0f Y:5.0f];//保证在图片未加载出来之前能接受滑动手势
                    
    
                }
                else 
                {
                    //NSLog(@"此条是从重用列表中获取的。。。。。");
                    imageView.image = [_env cacheScretchableImage:@"pic_default.png" X:5.0f Y:5.0f];
                }
                imageView.imgTag = i;
                imageView.style = HUMWebImageStyleNO;
                imageView.progressStyle = HMProgressCircle;
                imageView.delegate = self;
                
                imageView.frame = CGRectMake(CGRectGetWidth(self.imgScorll.frame)*i,0, CGRectGetWidth(self.imgScorll.frame), CGRectGetHeight(self.imgScorll.frame));
            
        
                if (_dataSource && [_dataSource respondsToSelector:@selector(imageUrlForScrollView:AtIndex:)]) {
                    NSString *url = [_dataSource imageUrlForScrollView:self AtIndex:i];
                    imageView.logoUrl = url;
                }
                NSUInteger nowIndex = self.imgScorll.contentOffset.x/CGRectGetWidth(self.imgScorll.bounds);
                if (i == nowIndex) {
                    if (_dataSource && [_dataSource respondsToSelector:@selector(summaryForScrollView:AtIndex:)]) {
                        NSString *sum = [_dataSource summaryForScrollView:self AtIndex:i];
                        self.sumStr = sum;
                    }
                }
                
                [self.imgScorll addSubview:imageView];
                [self.onScreenCells addObject:imageView];
            }
        }
    }
    _loadMore = FALSE;
    
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (!_viewZomm) {
        if (scrollView == self.imgScorll){
            _bZooming = YES;
            _zoomOff = self.imgScorll.contentOffset;
            for(HumWebImageView *temp in self.onScreenCells){
                if (temp.frame.origin.x != _zoomOff.x) {
                    [self.zommLeft addObject:temp];
                    [temp removeFromSuperview];
                }else {
                    _viewZomm = temp;
                }
            }
        }
    }
    
    
    if (_viewZomm&&!_positset) {
        self.imgScorll.pagingEnabled = NO;
        CGRect rc = _viewZomm.frame;
        BqsLog(@"the scal orgx = %d",rc.origin.x);
        rc.origin.x = 0;
        rc.origin.y = 0;
        _viewZomm.frame = rc;
        _bBlockScrollEvent = YES;
        _positset = TRUE;
        self.imgScorll.contentSize = self.imgScorll.frame.size;
        self.imgScorll.contentOffset = CGPointMake(0, 0);
        _bBlockScrollEvent = NO;
        if (thumbViewShowing) {
            [self setControlsVisible:!self.controlsVisible animated:YES];
        }
    }
    
    return _viewZomm;
    
    
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if(self.imgScorll != scrollView) return;
    
    if(scale < 1.1) {
        
        // reset drag tags
        _bBlockScrollEvent = YES;
        
        // reset zooming scale
        self.imgScorll.maximumZoomScale = 3.0;
        self.imgScorll.minimumZoomScale = .5;
        self.imgScorll.zoomScale = 1.0;
        self.imgScorll.bouncesZoom = YES;
        self.imgScorll.pagingEnabled = YES;
        
        _bZooming = FALSE;
        _positset = FALSE;
        if (!thumbViewShowing) {
             [self setControlsVisible:!self.controlsVisible animated:YES];
        }
        
        
        CGRect frme = _viewZomm.frame;
        frme.origin.x = _zoomOff.x;
        _viewZomm.frame = frme;
        
        _viewZomm = nil;
        for (HumWebImageView *get in self.zommLeft) {
            [self.imgScorll addSubview:get];
        }
        [self.zommLeft removeAllObjects];
        float scrollW = CGRectGetWidth(self.imgScorll.frame)*_total;
        float scrollH = CGRectGetHeight(self.imgScorll.frame);
        
        self.imgScorll.contentSize = CGSizeMake(scrollW, scrollH);
        self.imgScorll.contentOffset = _zoomOff;
    } 
    
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_bZooming) return;
	[self reloadImageViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_bZooming) return;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_bZooming) return;
	[self reloadImageViews];
}





#pragma mark
#pragma mark humWebImageDelegae
- (void)tapDetectingImageView:(HumWebImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // Single tap shows or hides drawer of thumbnails.
    if (_bZooming) {
        float newScale = [self.imgScorll zoomScale] * ZOOM_MIN;    
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
        [self.imgScorll zoomToRect:zoomRect animated:YES];

        return;
    }
    [self setControlsVisible:!self.controlsVisible animated:YES];
}



- (void)tapDetectingImageView:(HumWebImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in
    float newScale = [self.imgScorll zoomScale] * ZOOM_STEP;    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self.imgScorll zoomToRect:zoomRect animated:YES];
    
}

- (void)tapDetectingImageView:(HumWebImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
    float newScale = [self.imgScorll zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self.imgScorll zoomToRect:zoomRect animated:YES];
}


#pragma mark
#pragma mark ZOOM
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.imgScorll frame].size.height / scale;
    zoomRect.size.width  = [self.imgScorll frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


@end
