//
//  MptVolumeControl.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-11.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


typedef enum {
    MptVolumChange = 0,  // default
    MptVolumBig,
    MptVolumSmall,
} MptVolumeType;

NS_INLINE CGFloat MptDistanceBetweenCGPoints(CGPoint p1, CGPoint p2) {
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    
    return (CGFloat)sqrt((double)(dx*dx+dy*dy));
}

@protocol MptVolumeDelegate;

@interface MptVolumeControl : UIView


@property (nonatomic, assign) id<MptVolumeDelegate>delegate;
/* The delegate to be informed about volume control changes */
//@property (nonatomic, unsafe_unretained) id<NGVolumeControlDelegate> volumeDelegate;

/** The system volume, between 0.0f and 1.0f */
@property (nonatomic, assign) float volume;


/** The height of the expanded volume slider */
@property (nonatomic, assign) CGFloat sliderWidth;


@property (nonatomic, retain) UIImage *minimumTrackImage;

@property (nonatomic, retain) UIImage *maximumTrackImage;
@property (nonatomic, retain) UIImage *thumbTrckImage;


@end

@protocol MptVolumeDelegate <NSObject>

- (void)mptVolume:(MptVolumeControl *)volume Option:(MptVolumeType)type;

@end
