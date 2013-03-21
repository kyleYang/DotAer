//
//  extifc_store.h
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmptyExtIfc.h"


@interface extifc_store : EmptyExtIfc {

}

-(void)test:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;
-(void)put:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;
-(void)get:(NSDictionary*)args webViewController:(WebviewController*)webviewCtl;
@end
