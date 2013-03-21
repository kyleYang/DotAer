//
//  BqsAvlMap.m
//  iMobeeNews
//
//  Created by ellison on 11-6-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsAvlMap.h"
#import "BqsUtils.h"
#import "BqsMemAllocator.h"

//#define kItemIncreaseCnt 10

#pragma mark - BqsAvlMapUIntPtr
@interface BqsAvlMapUIntPtr()
@property (nonatomic, retain) BqsMemAllocator *memData;

-(void)printAvl:(AvlNode*)pRoot;
@end


@implementation BqsAvlMapUIntPtr
@synthesize memData;

-(id)initWithCapacity:(int)cnt {
    self = [super init];
    if(nil == self) return nil;
    
    _pAvlRoot = NULL;
    _nNodeCnt = 0;
    
    _nInitCnt = MAX(100, cnt);
    self.memData = [[[BqsMemAllocator alloc] initWithBlockSize:sizeof(AvlNode) Cnt:_nInitCnt IncreaseStep:100] autorelease];
    
    return self;
}

-(void)dealloc {
    self.memData = nil;
    
    [super dealloc];
}

-(void)setPtr:(void*)pData forKey:(unsigned int)key {
    AvlNode *pN = avl_find(_pAvlRoot, key);
    
    if(NULL != pN) {
        pN->pData = pData;
        return;
    }
    
    // new node 
    pN = (AvlNode*)[self.memData getNode];
    if(NULL == pN) {
        BqsLog(@"Failed to alloc memory.");
        return;
    }
    pN->key = key;
    pN->pData = pData;
    
    avl_insert(&_pAvlRoot, pN);
    _nNodeCnt ++;
    
    [self printAvl:_pAvlRoot];
}

-(void*)getPtrForKey:(unsigned int)key {
    AvlNode *pN = avl_find(_pAvlRoot, key);
    
    if(NULL != pN) {
        return pN->pData;
    }
    return NULL;
}

-(void)deletePtrForKey:(unsigned int)key {
    AvlNode *pN = avl_find(_pAvlRoot, key);
    
    if(NULL != pN) {
        avl_delete(&_pAvlRoot, &pN);
        
        _nNodeCnt --;
        
        if(NULL != pN) {
//            [self freeNode:pN];
            [self.memData freeNode:pN];
        }
        [self printAvl:_pAvlRoot];
    }
}

-(void)removeAll {
    _nNodeCnt = 0;
    _pAvlRoot = NULL;
    self.memData = [[[BqsMemAllocator alloc] initWithBlockSize:sizeof(AvlNode) Cnt:_nInitCnt IncreaseStep:100] autorelease];
}

-(NSUInteger)count {
    return _nNodeCnt;
}

-(void)printAvl:(AvlNode*)pRoot {
//    if(NULL == pRoot) return;
//    
//    if(NULL == pRoot->parent) {
//        BqsLog(@"--------");
//    }
//    
//    [self printAvl:pRoot->left];
//    BqsLog(@"%x", pRoot->key);
//    [self printAvl:pRoot->right];
}

@end

#pragma mark - BqsAvlSetUInt
@interface BqsAvlSetUInt()
@property (nonatomic, retain) BqsMemAllocator *memData;
@end


@implementation BqsAvlSetUInt
@synthesize memData;

-(id)initWithCapacity:(int)cnt {
    self = [super init];
    if(nil == self) return nil;
    
    _pAvlRoot = NULL;
    _nNodeCnt = 0;
    
    _nInitCnt = MAX(100, cnt);
    self.memData = [[[BqsMemAllocator alloc] initWithBlockSize:sizeof(AvlNode) Cnt:_nInitCnt IncreaseStep:100] autorelease];
    
    return self;
}

-(void)dealloc {
    self.memData = nil;
    
    [super dealloc];
}
-(void)add:(unsigned int)val {
    AvlNode *pN = avl_find(_pAvlRoot, val);
    
    if(NULL != pN) {
        return;
    }
    
    // new node 
    pN = (AvlNode*)[self.memData getNode];
    if(NULL == pN) {
        BqsLog(@"Failed to alloc memory.");
        return;
    }
    pN->key = val;
    pN->pData = NULL;
    
    avl_insert(&_pAvlRoot, pN);
    _nNodeCnt ++;

}

-(BOOL)contains:(unsigned int)val {
    AvlNode *pN = avl_find(_pAvlRoot, val);
    
    if(NULL != pN) {
        return YES;
    }
    return NO;

}

-(void)remove:(unsigned int)val {
    AvlNode *pN = avl_find(_pAvlRoot, val);
    
    if(NULL != pN) {
        avl_delete(&_pAvlRoot, &pN);
        
        _nNodeCnt --;
        
        if(NULL != pN) {
            [self.memData freeNode:pN];
        }
    }

}

-(void)removeAll {
    _nNodeCnt = 0;
    _pAvlRoot = NULL;
    self.memData = [[[BqsMemAllocator alloc] initWithBlockSize:sizeof(AvlNode) Cnt:_nInitCnt IncreaseStep:100] autorelease];
}

-(NSUInteger)count {
    return _nNodeCnt;
}

@end
