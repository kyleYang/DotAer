//
//  MptAVPlayerAudioSessionCategory.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef enum {
    MptAVPlayerAudioSessionCategoryPlayback = 0,  // default
    MptAVPlayerAudioSessionCategoryAmbient,
    MptAVPlayerAudioSessionCategorySoloAmbient,
    MptAVPlayerAudioSessionCategoryRecord,
    MptAVPlayerAudioSessionCategoryPlayAndRecord,
    MptAVPlayerAudioSessionCategoryAudioProcessing,
} MptAVPlayerAudioSessionCategory;


NS_INLINE NSString* MptAVAudioSessionCategoryFromMptAVPlayerAudioSessionCategory(MptAVPlayerAudioSessionCategory audioSessionCategory) {
    switch (audioSessionCategory) {
        case MptAVPlayerAudioSessionCategoryAmbient: {
            return AVAudioSessionCategoryAmbient;
        }
            
        case MptAVPlayerAudioSessionCategorySoloAmbient: {
            return AVAudioSessionCategorySoloAmbient;
        }
            
        case MptAVPlayerAudioSessionCategoryRecord: {
            return AVAudioSessionCategoryRecord;
        }
            
        case MptAVPlayerAudioSessionCategoryPlayAndRecord: {
            return AVAudioSessionCategoryPlayAndRecord;
        }
            
        case MptAVPlayerAudioSessionCategoryAudioProcessing: {
            return AVAudioSessionCategoryAudioProcessing;
        }
            
        default:
        case MptAVPlayerAudioSessionCategoryPlayback: {
            return AVAudioSessionCategoryPlayback;
        }
    }
}

