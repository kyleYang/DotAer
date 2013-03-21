//
//  MptAVPlayerControlActionDelegate.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MptAVPlayerControlActionStartToPlay,
    MptAVPlayerControlActionTogglePlayPause,
    MptAVPlayerControlActionDismiss,
    MptAVPlayerControlActionToggleZoomState,
    MptAVPlayerControlActionBeginSkippingBackwards,
    MptAVPlayerControlActionBeginSkippingForwards,
    MptAVPlayerControlActionBeginScrubbing,
    MptAVPlayerControlActionScrubbingValueChanged,
    MptAVPlayerControlActionEndScrubbing,
    MptAVPlayerControlActionEndSkipping,
    MptAVPlayerControlActionOttConnect,
    MptAVPlayerControlActionVolumeChanged,
    MptAVPlayerControlActionWillShowControls,
    MptAVPlayerControlActionDidShowControls,
    MptAVPlayerControlActionWillHideControls,
    MptAVPlayerControlActionDidHideControls,
    MptAVPlayerControlActionAirPlayMenuActivated
} MptAVPlayerControlAction;




@protocol MptAVPlayerControlActionDelegate <NSObject>

- (void)moviePlayerControl:(id)control didPerformAction:(MptAVPlayerControlAction)action;

@end
