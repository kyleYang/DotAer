//
//  MptAVPlayerVideoGravity.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

typedef enum {
    MptAVPlayerVideoGravityResizeAspect = 0,  // default
    MptAVPlayerVideoGravityResizeAspectFill,
    MptAVPlayerVideoGravityResize,
} MptAVPlayerVideoGravity;


NS_INLINE NSString* MptAVLayerVideoGravityFromMptAVPlayerVideoGravity(MptAVPlayerVideoGravity gravity) {
    switch (gravity) {
        case MptAVPlayerVideoGravityResizeAspectFill: {
            return AVLayerVideoGravityResizeAspectFill;
        }
            
        case MptAVPlayerVideoGravityResize: {
            return AVLayerVideoGravityResize;
        }
            
        default:
        case MptAVPlayerVideoGravityResizeAspect: {
            return AVLayerVideoGravityResizeAspect;
        }
    }
}

NS_INLINE MptAVPlayerVideoGravity MptAVPlayerVideoGravityFromAVLayerVideoGravity(NSString *gravity) {
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        return MptAVPlayerVideoGravityResizeAspectFill;
    }
    
    if ([gravity isEqualToString:AVLayerVideoGravityResize]) {
        return MptAVPlayerVideoGravityResize;
    }
    
    // default
    return MptAVPlayerVideoGravityResizeAspect;
}

NS_INLINE NSString* MptAVLayerVideoGravityNext(NSString *gravity) {
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        return AVLayerVideoGravityResizeAspectFill;
    }
    
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        return AVLayerVideoGravityResize;
    }
    
    // default
    return AVLayerVideoGravityResizeAspect;
}
