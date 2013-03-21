//
//  BqsAttachedInfoItem.h
//  iMobeeNews
//
//  Created by ellison on 11-8-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BqsAttachedInfoItem : NSObject {
    NSString* _topic;
    id _strongRef;
    id _weakRef;
}

@property (nonatomic, copy) NSString* topic;
@property (nonatomic, retain) id strongRef;
@property (nonatomic, assign) id weakRef;

+ (id)topic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef;
+ (id)topic:(NSString*)topic;
+ (id)weakRef:(id)weakRef;

- (id)initWithTopic:(NSString*)topic strongRef:(id)strongRef weakRef:(id)weakRef;

@end
