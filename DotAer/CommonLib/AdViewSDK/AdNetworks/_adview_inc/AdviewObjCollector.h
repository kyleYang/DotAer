//
//  AdviewObjCollector.h
//  AdViewSDK
//
//  Created by zhiwen on 12-7-24.
//  Copyright 2012 www.adview.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 有些Adapter对象必须等待网络成功或失败后才能释放，因此必须先收集起来，延长到一定时间后释放。
 */

#define INFINITE_WAIT   -1

@interface AdviewObjCollector : NSObject {
	NSMutableArray	*arrObjs;
	NSObject		*lockObj;
	NSTimer			*cTimer;
}

@property (retain) NSMutableArray *arrObjs;

+ (AdviewObjCollector*)sharedCollector;

- (void)addObj:(NSObject*)obj;
- (void)addObj:(NSObject*)obj wait:(int)seconds;

- (void)removeObj:(NSObject*)obj;

- (void)setAdapterAdViewViewNil:(NSObject*)_adView;

@end
