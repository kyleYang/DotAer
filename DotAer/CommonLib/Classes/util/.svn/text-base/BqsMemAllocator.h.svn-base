//
//  BqsMemAllocator.h
//  iMobeeNews
//
//  Created by ellison on 11-6-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BqsMemAllocator : NSObject {
    int _nBlockSize;
    int _nIncreaseStep;
    //NSMutableSet *_setMem;
    void *_arrMem;
    int _arrSize;
    int _arrCapacity;
    
    void *_freeNodes;
}

-(id)initWithBlockSize:(int)blockSize Cnt:(int)cnt IncreaseStep:(int)incStep;
-(void*)getNode;
-(void)freeNode:(void*)pMem;

@end
