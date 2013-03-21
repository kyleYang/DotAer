//
//  BqsMemAllocator.m
//  iMobeeNews
//
//  Created by ellison on 11-6-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsMemAllocator.h"
#import "BqsUtils.h"

typedef struct MemBlock {
    void *next;
}MemBlock;

#define kMinBlockSize sizeof(MemBlock)

@interface BqsMemAllocator()

-(void)buildFreeNodeList:(void*)pMem Cnt:(int)cnt;
@end


@implementation BqsMemAllocator
-(id)initWithBlockSize:(int)blockSize Cnt:(int)cnt IncreaseStep:(int)incStep {
    self = [super init];
    if(nil == self) return nil;
    
    _freeNodes = NULL;
    _nBlockSize = MAX(blockSize, kMinBlockSize);
    _nIncreaseStep = MAX(incStep, 1);
    int iCnt = MAX(cnt, 1);
    
    // alloc
    _arrSize = 0;
    _arrCapacity = 10;
    _arrMem = malloc(_arrCapacity * sizeof(void*));
    if(NULL == _arrMem) {
        BqsLog(@"Can't alloc memory.");
        [self release];
        return nil;
    }
    memset(_arrMem, 0, sizeof(void*)*_arrCapacity);
    
    
    void* pMem = malloc(_nBlockSize * iCnt);
    if(NULL == pMem) {
        BqsLog(@"Can't alloc memory");
        [self release];
        return nil;
    }
    
    void **pA = (_arrMem + _arrSize*sizeof(void*));
    *pA = pMem;
    _arrSize ++;
    [self buildFreeNodeList:pMem Cnt:iCnt];
    
//    _setMem = [[NSMutableSet alloc] initWithCapacity:10];
//    NSMutableData *dat = [[NSMutableData alloc] initWithLength:_nBlockSize*iCnt];
//    [self buildFreeNodeList:[dat mutableBytes] Cnt:iCnt];
//    [_setMem addObject:dat];
//    [dat release];
    
    return self;

}

-(void)dealloc {
//    [_setMem release];
    if(NULL != _arrMem) {
        for(int i = 0; i < _arrSize; i ++) {
            void **pA = (_arrMem + i*sizeof(void*));
            if(NULL != *pA) {
//                BqsLog(@"free: %p", *pA);
                free(*pA);
            }
        }
//        BqsLog(@"free: %p, arrSize: %d", _arrMem, _arrSize);
        free(_arrMem);
    }

    [super dealloc];
}

-(void*)getNode {
    if(NULL == _freeNodes) {
        if(_arrSize >= _arrCapacity) {
            // enlarge list
            int newCap = _arrCapacity + 10;
            void* newList = malloc(newCap * sizeof(void*));
            if(NULL == newList) {
                BqsLog(@"Failed to alloc mem: %d", newCap*sizeof(void*));
                return NULL;
            }
            
            memcpy(newList, _arrMem, _arrCapacity*sizeof(void*));
            memset(newList + _arrCapacity*sizeof(void*), 0, 10*sizeof(void*));
            _arrCapacity = newCap;
            free(_arrMem);
            _arrMem = newList;
        }
        
        // alloc        
        void* pMem = malloc(_nBlockSize * _nIncreaseStep);
        if(NULL == pMem) {
            BqsLog(@"Can't alloc memory");
            return NULL;
        }
        
        void **pA = (_arrMem + _arrSize*sizeof(void*));
        *pA = pMem;
        _arrSize ++;
        [self buildFreeNodeList:pMem Cnt:_nIncreaseStep];

//        NSMutableData *dat = [[NSMutableData alloc] initWithLength:_nBlockSize*_nIncreaseStep];
//        [self buildFreeNodeList:[dat mutableBytes] Cnt:_nIncreaseStep];
//        [_setMem addObject:dat];
//        [dat release];
        
//        BqsLog(@"increase length");
    }
    
    if(nil == _freeNodes) {
        BqsLog(@"Failed to alloc nodes");
        return NULL;
    }
    MemBlock *pN = (MemBlock*)_freeNodes;
    _freeNodes = pN->next;
    
    memset(pN, 0, _nBlockSize);
    
    return pN;

}

-(void)freeNode:(void*)pMem {
    if(NULL == pMem) {
        BqsLog(@"Invalid param. pMem: %d", pMem);
        return;
    }
    
    MemBlock *pB = (MemBlock*)pMem;
    pB->next = _freeNodes;
    _freeNodes = pB;
    
}

-(void)buildFreeNodeList:(void*)pMem Cnt:(int)cnt {
    if(nil == pMem || cnt < 1 || _nBlockSize < kMinBlockSize) {
        BqsLog(@"Invalid param. pMem: %d, cnt: %d, block: %d", pMem, cnt, _nBlockSize);
        return;
    }
//    BqsLog(@"pMem: %x, cnt: %d, block: %d", pMem, cnt, _nBlockSize);
    for(int i = 0; i < cnt; i ++) {
        MemBlock *pN = (MemBlock*)(pMem + i * _nBlockSize);
        pN->next = _freeNodes;
        _freeNodes = pN;
    }

}


@end
