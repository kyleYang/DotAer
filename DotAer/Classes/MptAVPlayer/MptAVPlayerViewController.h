//
//  MptAVPlayerViewController.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-4.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MptAVPlayerDelegate.h"

enum MptAVPlayerResult {
    MptAVPlayerUnknowed,
    MptAVPlayerCancelled,
    MptAVPlayerFinished,
    MptAVPlayerURLError,
    MptAVPlayerFailed,
};
typedef enum MptAVPlayerResult MptAVPlayerResult;


@protocol MptAVPlayer;
@protocol MptAVPlayerViewController_Callback;

@interface MptAVPlayerViewController : UIViewController <MptAVPlayerDelegate>

@property (nonatomic, retain, readonly) MptAVPlayer *moviePlayer;


- (id)initWithContentURL:(NSURL *)contentURL;
- (id)initWithContentString:(NSString *)contentURL;
- (id)initWithContentString:(NSString *)contentURL name:(NSString*)videoName;
- (id)initWithContentURLArray:(NSArray *)urlArray;


@property (nonatomic, assign) id<MptAVPlayerViewController_Callback> call_back;
@property (nonatomic, assign) BOOL mptControlAble;

/** Override to specify your custom subclass of MptAVPlayer */
+ (Class)moviePlayerClass;



@end;

@protocol MptAVPlayerViewController_Callback <NSObject>

@required
- (void)MptAVPlayerViewController:(MptAVPlayerViewController*)ctl didFinishWithResult:(MptAVPlayerResult)result error:(NSError *)error;

@optional
-(void)MptAVPlayerViewControllerDidClickOtt:(MptAVPlayerViewController*)ctl;

@end
