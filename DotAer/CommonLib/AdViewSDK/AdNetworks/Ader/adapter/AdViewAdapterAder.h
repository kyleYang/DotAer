/*
 
 Copyright 2010 www.adview.cn. All rights reserved.
 
 */

#import "AdViewAdNetworkAdapter+helpers.h"
#import "AderDelegateProtocal.h"


/*Ader*/

@interface AdViewAdapterAder : AdViewAdNetworkAdapter <AderDelegateProtocal> {

}

+ (AdViewAdNetworkType)networkType;

@end
