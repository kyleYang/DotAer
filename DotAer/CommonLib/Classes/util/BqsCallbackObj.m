//
//  BqsCallbackObj.m
//  iMobeeBook
//
//  Created by ellison on 12-2-15.
//  Copyright (c) 2012年 borqs. All rights reserved.
//

#import "BqsCallbackObj.h"

@implementation BqsCallbackObj
@synthesize obj, sel, retainAttached, assignAttached;

-(id)initWithObj:(id)aObj Sel:(SEL)aSel RAttached:(id)aRAttached AAttached:(id)aAAttached {
    self = [super init];
    if(nil == self) return nil;
    
    self.obj = aObj;
    self.sel = aSel;
    self.retainAttached = aRAttached;
    self.assignAttached = aAAttached;
    
    return self;
}
-(void)dealloc {
    self.retainAttached = nil;
    [super dealloc];
}
@end
