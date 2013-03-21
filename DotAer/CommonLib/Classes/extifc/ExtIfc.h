//
//  ExtIfc.h
//  iMobee
//
//  Created by ellison on 10-9-14.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class ExtIfcCommand;
@class WebviewController;

#define kExtIfcScheme @"bqsifc"


@interface ExtIfc : NSObject {

	NSMutableDictionary *_ifcObjects;
}

@property (nonatomic, retain) NSMutableDictionary *ifcObjects;

- (BOOL)procURLRequest:(NSURLRequest*)request webViewController:(WebviewController*)webviewCtl;
- (BOOL)execute:(ExtIfcCommand*)command webViewController:(WebviewController*)webviewCtl;
- (void)dealloc;
@end
