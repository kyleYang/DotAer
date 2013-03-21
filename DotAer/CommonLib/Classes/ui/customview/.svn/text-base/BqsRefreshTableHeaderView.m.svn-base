//
//  BqsRefreshTableHeaderView.m
//  iMobeeNews
//
//  Created by ellison on 11-7-17.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsRefreshTableHeaderView.h"
#import "BqsUtils.h"
#import "Env.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface BqsRefreshTableHeaderView (Private)
- (void)setState:(BRTH_PullRefreshState)aState;
@end

@implementation BqsRefreshTableHeaderView

@synthesize callback=_callback;
@synthesize fPullDistance;


- (id)initWithFrame:(CGRect)frame arrowImage:(UIImage *)arrow textColor:(UIColor *)textColor  {
    self = [super initWithFrame:frame];
    if(nil == self) return nil;
    
    self.fPullDistance = 65.0;
		
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = textColor;
//    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    _lastUpdatedLabel=label;
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = textColor;
//    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    _statusLabel=label;
    [label release];
    
    if(nil == arrow) arrow = [[Env sharedEnv] cacheImage:@"pullRefreshArrow.png"];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f + (65.0f - arrow.size.height)/2, arrow.size.width, arrow.size.height);
    layer.contentsGravity = kCAGravityResizeAspect;
    
    layer.contents = (id)arrow.CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:layer];
    _arrowImage=layer;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    [view release];
    
    
    [self setState:BRTH_PullRefreshNormal];
    
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImage:nil textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

-(void)setArrowLeftPadding:(float)x {
    CGRect frm = _arrowImage.frame;
    frm.origin.x = x;
    _arrowImage.frame = frm;
    
    frm = _activityView.frame;
    frm.origin.x = x;
    _activityView.frame = frm;
}


/*
 "view.pullrefresh.timestr"="最后更新:%@";
 "view.pullrefresh.pulltorefresh"="下拉以更新...";
 "view.pullrefresh.releasetorefresh"="松开以更新...";
 "view.pullrefresh.loading"="更新中...";
 */
- (void)refreshLastUpdatedDate {
	
	if ([_callback respondsToSelector:@selector(bqsRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_callback bqsRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"view.pullrefresh.timestr", @"commonlib", nil), [formatter stringFromDate:date]];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"BqsRefreshTableView_LastRefresh"];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(BRTH_PullRefreshState)aState{
	
	switch (aState) {
		case BRTH_PullRefreshPulling:
			
			_statusLabel.text = NSLocalizedStringFromTable(@"view.pullrefresh.releasetorefresh", @"commonlib", nil);
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case BRTH_PullRefreshNormal:
			
			if (_state == BRTH_PullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedStringFromTable(@"view.pullrefresh.pulltorefresh", @"commonlib", nil);
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case BRTH_PullRefreshLoading:
			
			_statusLabel.text = NSLocalizedStringFromTable(@"view.pullrefresh.loading", @"commonlib", nil);
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)bqsRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == BRTH_PullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_callback respondsToSelector:@selector(bqsRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_callback bqsRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == BRTH_PullRefreshPulling && scrollView.contentOffset.y > -self.fPullDistance && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:BRTH_PullRefreshNormal];
		} else if (_state == BRTH_PullRefreshNormal && scrollView.contentOffset.y < -self.fPullDistance && !_loading) {
			[self setState:BRTH_PullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)bqsRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_callback respondsToSelector:@selector(bqsRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_callback bqsRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - self.fPullDistance && !_loading) {
		
		if ([_callback respondsToSelector:@selector(bqsRefreshTableHeaderDidTriggerRefresh:)]) {
			[_callback bqsRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:BRTH_PullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)bqsRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:BRTH_PullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_callback=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
