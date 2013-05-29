//
//  MptMacro.h
//  TVGontrol
//
//  Created by Kyle on 13-4-25.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef weak_delegate
#undef __weak_delegate

#if __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#define __weak_delegate __weak
#else
#define weak_delegate unsafe_unretained
#define __weak_delegate __unsafe_unretained
#endif





@interface MptMacro : NSObject



@end
