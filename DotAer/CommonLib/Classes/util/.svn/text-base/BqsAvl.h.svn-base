//
//  BqsAvl.h
//  iMobeeNews
//
//  Created by ellison on 11-6-10.
//  Copyright 2011年 borqs. All rights reserved.
//
#ifndef _bqsavl_H
#define _bqsavl_H

#ifdef __cplusplus
extern "C" {
#endif

    typedef struct AvlNode
    {
        struct AvlNode *parent;
        struct AvlNode *left;
        struct AvlNode *right;
        int bf;					// balance factor for avl calcuate
        unsigned int key;		// compare key
        void *pData;	        // data
    }AvlNode;
    
    AvlNode* avl_find( AvlNode *pRoot, unsigned int key );
    int avl_insert( AvlNode **ppRoot, AvlNode *pItem ); // 0 failed, 1 ok
    int avl_delete( AvlNode **ppRoot, AvlNode** ppItem );// 0 failed, 1 ok

#ifdef __cplusplus
}
#endif

#endif /* _zip_H */
