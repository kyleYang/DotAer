//
//  MptGuideLoadingFooterView.m
//  TVGuide
//
//  Created by ellison on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PgLoadingFooterView.h"
#import "Env.h"

@interface PgLoadingFooterView()


@end

@implementation PgLoadingFooterView
@synthesize viewAct;
@synthesize message;
@synthesize state = _state;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *activty = [[UIButton alloc] initWithFrame:self.bounds];
    activty.backgroundColor = [UIColor clearColor];
    activty.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [activty addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    [activty setBackgroundImage:[[Env sharedEnv] cacheImage:@"dota_cell_double_bg.png"] forState:UIControlStateNormal];
    [activty setBackgroundImage:[[Env sharedEnv] cacheImage:@"dota_cell_select.png"] forState:UIControlEventTouchDown];
    
    
    [self addSubview:activty];
    [activty release];
    
    self.viewAct = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.viewAct stopAnimating];
    [self addSubview:self.viewAct];
    
    
    self.message = [[[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(frame), 20)] autorelease];
    self.message.backgroundColor = [UIColor clearColor];
    self.message.textAlignment = UITextAlignmentCenter;
    self.message.textColor = [UIColor blackColor];
    self.message.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:self.message];
    
    _state = PgFootRefreshInit;
    
    return self;
}
-(void)dealloc {
    
    self.viewAct = nil;
    self.message = nil;
    _delegate = nil;
    [super dealloc];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.viewAct.center = CGPointMake(80, CGRectGetMidY(self.message.frame));
    
}

- (void)loadMore:(id)sender
{
    if(_state == PgFootRefreshLoading||_state == PgFootRefreshAllDown){
        return;
    }
    
    self.state = PgFootRefreshLoading;
    
    if ([_delegate respondsToSelector:@selector(footLoadMore)]) {
        [_delegate footLoadMore];
    }
}

//- (void)setDelegate:(id<pgFootViewDelegate>)adelegate
//{
//    if (_delegate != adelegate) {
//        _delegate = adelegate;
//        if ([_delegate respondsToSelector:@selector(messageTxtForState:)]) {
//            self.message.text = [_delegate messageTxtForState:_state];
//        }
//    }
//}


- (void)setState:(PgFootRefreshState)astate
{
    if (_state == astate) {
        return;
    }
    _state = astate;
    if (_state == PgFootRefreshLoading) {
        [self.viewAct startAnimating];
    }else if(_state == PgFootRefreshNormal){
        [self.viewAct stopAnimating];
    }else if(_state == PgFootRefreshAllDown){
        [self.viewAct stopAnimating];
    }
    
    if ([_delegate respondsToSelector:@selector(messageTxtForState:)]) {
        self.message.text = [_delegate messageTxtForState:_state];
    }
}

@end
