//
//  BqsAvlMap.h
//  iMobeeNews
//
//  Created by ellison on 11-6-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "BqsAvl.h"

@interface BqsAvlMapUIntPtr : NSObject {
    AvlNode* _pAvlRoot;
    NSUInteger _nNodeCnt;
    int _nInitCnt;
    
//    NSMutableData *_memData;
//    AvlNode *_pFreeNodes; // use its left to link as a link list
}

-(id)initWithCapacity:(int)cnt;
-(void)setPtr:(void*)pData forKey:(unsigned int)key;
-(void*)getPtrForKey:(unsigned int)key;
-(void)deletePtrForKey:(unsigned int)key;
-(void)removeAll;
-(NSUInteger)count;

@end

@interface BqsAvlSetUInt : NSObject {
    AvlNode* _pAvlRoot;
    NSUInteger _nNodeCnt;
    int _nInitCnt;
}

-(id)initWithCapacity:(int)cnt;
-(void)add:(unsigned int)val;
-(BOOL)contains:(unsigned int)val;
-(void)remove:(unsigned int)val;
-(void)removeAll;
-(NSUInteger)count;

@end
