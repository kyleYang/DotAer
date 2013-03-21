//
//  BqsAttachedInfoItem.m
//  iMobeeNews
//
//  Created by ellison on 11-8-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsAttachedInfoItem.h"


@implementation BqsAttachedInfoItem

@synthesize topic = _topic;
@synthesize strongRef = _strongRef;
@synthesize weakRef = _weakRef;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)topic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef {
    return [[[BqsAttachedInfoItem alloc] initWithTopic:topic strongRef:strongRef weakRef:weakRef] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)topic:(NSString*)topic {
    return [[[BqsAttachedInfoItem alloc] initWithTopic:topic strongRef:nil weakRef:nil] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)weakRef:(id)weakRef {
    return [[[BqsAttachedInfoItem alloc] initWithTopic:nil strongRef:nil weakRef:weakRef] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTopic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef {
    self = [super init];
    if(nil == self) return nil;
    
    
    self.topic      = topic;
    self.strongRef  = strongRef;
    self.weakRef    = weakRef;

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [_topic release];
    _topic = nil;
    
    [_strongRef release];
    _strongRef = nil;

    [super dealloc];
}


@end
