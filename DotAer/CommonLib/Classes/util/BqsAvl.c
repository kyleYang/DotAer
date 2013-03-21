//
//  BqsAvl.c
//  iMobeeNews
//
//  Created by ellison on 11-6-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#include "BqsAvl.h"
#include "stdio.h"


AvlNode* avl_find( AvlNode *pRoot, unsigned int key )
{
	AvlNode *p = pRoot;
    
	while( NULL != p )
	{
		if( key > p->key )
		{	/* right child */
			p = p->right;
		}
		else if( key < p->key )
		{	/* left child */
			p = p->left;
		}
		else /* equal !*/
		{
			/* found it !*/
			break;
		}
	}
    
	return p;
}

void avl_LL( AvlNode* pA,  AvlNode* pB, AvlNode** ppRoot )
{
	/* param check */
	if( NULL == pA || NULL == pB ||NULL == ppRoot )
	{
        fprintf(stderr,"Invalid param. pA: %p, pB: %p, ppRoot: %p", pA, pB, ppRoot);
		return;
	}
	
	/*routate */
	pB->parent = pA->parent;
	if( NULL != pA->parent )
	{
		if( pA->key > pA->parent->key )
		{	/*right child*/
			pA->parent->right = pB;
		}
		else
		{
			pA->parent->left = pB;
		}
	}
	else
	{	/* pp is root item */
		*ppRoot = pB;
	}
	pA->left = pB->right;
	if( NULL != pB->right )
	{
		pB->right->parent = pA;
	}
	pA->parent = pB;
	pB->right = pA;
    
	/* change balance factor */
	pA->bf = 0;
	pB->bf = 0;
    
	return;
}

void avl_RR( AvlNode* pA,  AvlNode* pB, AvlNode** ppRoot )
{
	/* param check */
	if( NULL == pA || NULL == pB ||NULL == ppRoot )
	{
        fprintf(stderr,"Invalid param. pA: %p, pB: %p, ppRoot: %p", pA, pB, ppRoot);
		return;		
	}
	
	/*routate */
	pB->parent = pA->parent;
	if( NULL != pA->parent )
	{
		if( pA->key > pA->parent->key )
		{	/*right child*/
			pA->parent->right = pB;
		}
		else
		{
			pA->parent->left = pB;
		}
	}
	else
	{	/* pp is root item ! */
		*ppRoot = pB;
	}
	pA->right = pB->left;
	if( NULL != pB->left )
	{
		pB->left->parent = pA;
	}
	pA->parent = pB;
	pB->left = pA;
    
	/* change balance factor */
	pB->bf = 0;
	pA->bf = 0;
    
	return;
}

void avl_LR( AvlNode* pA,  AvlNode* pB, AvlNode* pC,  AvlNode** ppRoot )
{
	/* param check */
	if( NULL == pA || NULL == pB ||
       NULL == pC ||NULL == ppRoot )
	{
        fprintf(stderr,"Invalid param. pA: %p, pB: %p, pC: %p, ppRoot: %p", pA, pB, pC, ppRoot);
		return;		
	}
    
	/* routate */
	pC->parent = pA->parent;
	if( NULL != pA->parent )
	{
		if( pA->key > pA->parent->key )
		{	/* right child */
			pA->parent->right = pC;
		}
		else
		{	/* left child */
			pA->parent->left = pC;
		}
	}
	else
	{	/* pp is root item */
		*ppRoot = pC;
	}
	pA->left = pC->right;
	if( NULL != pC->right )
	{
		pC->right->parent = pA;
	}
	pB->right = pC->left;
	if( NULL != pC->left )
	{
		pC->left->parent = pB;
	}
	pC->left = pB;
	pB->parent = pC;
	pC->right = pA;
	pA->parent = pC;
	
	/* change balance factor */
	if( 0 == pC->bf )
	{
		pB->bf = 0;
		pA->bf  = 0;
	}
	else if ( 1 == pC->bf )
	{
		pB->bf = 0;
		pA->bf = -1;
	}
	else	/* -1 == pt->bf */
	{
		pB->bf = 1;
		pA->bf = 0;
	}
	pC->bf = 0;
	
	return;
}

void avl_RL( AvlNode* pA,  AvlNode* pB, AvlNode* pC, AvlNode** ppRoot )
{
	/* param check */
	if( NULL == pA || NULL == pB ||NULL == pC ||NULL == ppRoot )
	{
        fprintf(stderr,"Invalid param. pA: %p, pB: %p, pC:%p, ppRoot: %p", pA, pB, pC, ppRoot);
		return;		
	}
    
	/* routate */
	pC->parent = pA->parent;
	if( NULL != pA->parent )
	{
		if( pA->key > pA->parent->key )
		{	/* right child */
			pA->parent->right = pC;
		}
		else
		{	/* left child */
			pA->parent->left = pC;
		}
	}
	else
	{	/* pp is root item ! */
		*ppRoot = pC;
	}
	pA->right = pC->left;
	if( NULL != pC->left )
	{
		pC->left->parent = pA;
	}
	pB->left = pC->right;
	if( NULL != pC->right )
	{
		pC->right->parent = pB;
	}
	pC->left = pA;
	pA->parent = pC;
	pC->right = pB;
	pB->parent = pC;
	
	/* change balance factor */
	if( 0 == pC->bf )
	{
		pB->bf = 0;
		pA->bf  = 0;
	}
	else if ( 1 == pC->bf )
	{
		pB->bf = -1;
		pA->bf = 0;
	}
	else	/* -1 == pt->bf */
	{
		pB->bf = 0;
		pA->bf = 1;
	}
	pC->bf = 0;
}

int avl_insert( AvlNode **ppRoot, AvlNode *pAnnItem )
{
	AvlNode *p, *pp;
	
	/* 1. check param */
	if( NULL == pAnnItem || NULL == ppRoot )
	{
        fprintf(stderr,"Invalid param. pAnnItem: %p, ppRoot: %p", pAnnItem, ppRoot);
		return 0;
	}
    
	/* 2. new tree ? */
	p = *ppRoot;
	if( NULL == p )
	{
		/* first item of the tree */
		pAnnItem->parent = NULL;
		pAnnItem->left = NULL;
		pAnnItem->right = NULL;
		pAnnItem->bf = 0;
		*ppRoot = pAnnItem;
		
		return 1;
	}
    
	/* 3. find the insert position */
	while( NULL != p )
	{
		if( pAnnItem->key < p->key )
		{
			pp = p;
			p = p->left;
		}
		else if ( pAnnItem->key > p->key )
		{
			pp = p;
			p = p->right;
		}
		else
		{
			/* key equal !
             the ann type item already exists in the AVL.
             */
			return 0;
		}
	}
    
	/* 4. insert */
	pAnnItem->bf = 0;
	pAnnItem->left = NULL;
	pAnnItem->right = NULL;
	pAnnItem->parent = pp;
	
	if( pAnnItem->key > pp->key )
	{
		pp->right = pAnnItem;
	}
	else
	{
		pp->left = pAnnItem;
	}
    
	/* 5. check and maintain balance */	
	p = pAnnItem;
	pp = p->parent;
	while( NULL != pp )
	{
		if( p->key < pp->key )
		{
			/* inserted in left tree */
			pp->bf ++;
		}
		else
		{
			/* inserted in right tree */
			pp->bf --;
		}
		
		if( 2 == pp->bf )
		{
			switch( p->bf )
			{
                case 1:
                    /* LL */
                    avl_LL( pp, p, ppRoot );
                    break;
                case -1:
                    /* LR */
                    avl_LR( pp, p,  p->right, ppRoot );				
                    break;
                default:
                    break;
			}
            
			return 1;
		}
		else if ( -2 == pp->bf )
		{
			switch( p->bf )
			{
                case -1:
                    /* RR */
                    avl_RR( pp, p, ppRoot );
                    break;
                case 1:
                    /* RL */
                    avl_RL( pp, p, p->left, ppRoot );
                    break;
                default:
                    break;
			}
            
			return 1;
		}
		else if ( 0 == pp->bf )
		{
			/* balance ! */
			return 1;
		}
		else
		{
			/* -1 or 1.
             need to check upper layer
             */
		}
		p = pp;
		pp = pp->parent;
        
	}
    
	
	return 1;
}

int avl_delete( AvlNode **ppRoot, AvlNode** ppAnnItem )
{
	AvlNode *pd,*pA, *pB, *pC, *p;
    void *pData;
	unsigned int key;
	
	if( NULL == ppAnnItem ||NULL == *ppAnnItem || NULL == ppRoot || NULL == *ppRoot )
	{
        fprintf(stderr,"Invalid param. ppAnnItem: %p, ppRoot: %p", ppAnnItem, ppRoot);
		return 0;
	}
    
	p = *ppAnnItem;
    
	/* 1. strip out the item */
	/* save the item to be delete */
	/* conver the situation that the item has two children to have only one child */
	pd = p;
	if( NULL != p->left && NULL != p->right )
	{
		/* search the left tree for the bigest item to replace the pd */
		p = p->left;
		while( NULL != p->right ) p = p->right;
        
		/* p <-> pd */
		pData = p->pData;
		key = p->key;
        
		p->pData = pd->pData;
		p->key = pd->key;
		pd->pData = pData;
		pd->key = key;
        
		/* return the actually deleted item */
		*ppAnnItem = p;
	}
	/* now p only have one child  at most */
	/* save the child */
	if( NULL != p->left ) pd = p->left;
	else pd = p->right;
    
	pA = p->parent;
	
	/* delete p */
	if( NULL == pA )
	{	/* the root item */
		*ppRoot = pd;
		if( NULL != pd )
		{
			pd->parent = NULL;
		}
		return 1;
	}
	else
	{	/* we can't use the key to compare here because the p may be 'move' here. */
		if( pA->left == p )
		{	/* left child */
			pA->bf --;
			pA->left = pd;
		}
		else
		{	/* right child */
			pA->bf ++;
			pA->right = pd;
		}
		if( NULL != pd )
		{
			pd->parent = pA;
		}
	}
    
	/* 2. search the pA, pB, and pC, matain balance */
	while( NULL != pA )
	{		
		if( 2 == pA->bf )
		{
			pB = pA->left;
			switch( pB->bf )
			{
                case 0:
                    /* R0 */
                    /* R0 is the same as LL except the balance factor */
                    avl_LL( pA,  pB, ppRoot );
                    pB->bf = -1;
                    pA->bf = 1;
                    /* balance!*/
                    return 1;
                    break;
                case 1:
                    /* R1 */
                    /* R1 is exactly the same as LL */
                    avl_LL( pA, pB, ppRoot );
                    
                    /* height changed! should check upper layer. 
                     change current point for the loop operation.
                     */
                    p = pA;
                    pA = pB;
                    break;
                case -1:
                    /* R-1*/
                    /* R-1 is exactly the same as LR */
                    pC = pB->right;
                    avl_LR( pA, pB, pC, ppRoot );
                    
                    /* height changed! should check upper layer.
                     change current point for the loop operation.
                     */
                    p = pA;
                    pA = pC;
                    break;
                default:
                    break;
			}
		}
		else if( -2 == pA->bf )
		{
			pB = pA->right;
			switch( pB->bf )
			{
                case 0:
                    /* L0 */
                    /* L0 is the same as RR except the factor */
                    avl_RR( pA, pB, ppRoot );
                    pB->bf = 1;
                    pA->bf = -1;
                    /* balanced! */
                    return 1;
                    break;
                case -1:
                    /* L-1 */
                    /* L-1 is exactly the same as RR */
                    avl_RR( pA, pB, ppRoot );
                    
                    /* height changed!
                     check upper layer for balance.
                     */
                    /* change pointer for the loop operation */
                    p = pA;
                    pA = pB;
                    break;
                case 1:
                    /* L1 */
                    /* L1 is exactly the same as RL */
                    pC = pB->left;
                    avl_RL( pA, pB, pC, ppRoot );
                    
                    /* height changed !
                     check upper layer for balance.
                     */
                    /* change point for the loop operation */
                    p = pA;
                    pA = pC;
                    break;
                default:
                    break;
			}
		}
		else if ( 0 == pA->bf )
		{	/* should check upper layer for balance*/
		}
		else /* -1 or 1, height not change */
		{
			return 1;
		}
		
		p = pA;
		pA = pA->parent;
		
		if( NULL == pA )
			break;
        
		if( p->key < pA->key )
		{	/* left child */
			pA->bf --;
		}
		else
		{	/* right child */
			pA->bf ++;
		}
	}
    
	return 1;
}

