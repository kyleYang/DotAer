//
//  MptWeak.h
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//


/**  If compiled for iOS 5 up zeroing weak refs are used  */

#if __has_feature(objc_arc_weak)
#define mpt_weak  assign
#define __mpt_weak __weak
#else
#define mpt_weak  assign
#define __mpt_weak __unsafe_unretained
#endif


#ifdef DEBUG
#define MptSafeRelease(x) [x release]
#else
#define MptSafeRelease(x) [x release]; x=nil
#endif


#define kMptFadeDuration                     0.33

#define kButtomBtn_W 60
#define kButtomBtn_H 50

#define kTopBtn_W 60
#define kTopBtn_H 40



