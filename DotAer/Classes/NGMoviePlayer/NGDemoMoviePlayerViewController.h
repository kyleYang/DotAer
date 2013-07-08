//
//  NGMoviePlayerViewController.h
//  NGMoviePlayerDemo
//
//  Created by Tretter Matthias on 13.03.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGMoviePlayer.h"
#import "NGWeak.h"
#import "NGMoviePlayerAudioSessionCategory.h"
#import "MobClick.h"
#import "AdViewView.h"
#import "AdViewDelegateProtocol.h"

typedef enum
{
    NGMoviePlayerrUnknowed,
    NGMoviePlayerCancelled,
    NGMoviePlayerFinished,
    NGMoviePlayerURLError,
    NGMoviePlayerFailed,
} NGMoviePlayerResult;

@class News;
@class Video;


@protocol MoviePlayerViewControllerDelegate;

@interface NGDemoMoviePlayerViewController : UIViewController <NGMoviePlayerDelegate,AdViewDelegate>{
    AdViewView *_adView;
    BOOL                bSuperOrientFix;
    CGFloat             ad_x;         //-1 means center in horizontal
    CGFloat             ad_y;         //-1 means center in vertical
    BOOL                _setVideo;
    
    
}

@property (nonatomic, retain) AdViewView* adView;
@property (nonatomic,assign) BOOL bSuperOrientFix;

- (id)initWithNews:(News *)vide;

- (id)initWithVideo:(Video *)vide;

- (id)initWithUrl:(NSString *)url title:(NSString *)title;

@property (nonatomic, ng_weak) id<MoviePlayerViewControllerDelegate> delegate;

@end



@protocol MoviePlayerViewControllerDelegate <NSObject>

@required
- (void)moviePlayerViewController:(NGDemoMoviePlayerViewController*)ctl didFinishWithResult:(NGMoviePlayerResult)result error:(NSError *)error;

@optional


@end

