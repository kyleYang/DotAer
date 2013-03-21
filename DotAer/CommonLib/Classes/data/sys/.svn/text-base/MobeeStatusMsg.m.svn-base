//
//  MobeeStatusMsg.m
//  iMobeeBook
//
//  Created by ellison on 11-11-25.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import "MobeeStatusMsg.h"
#import "TBXML.h"

@interface MobeeStatusMsg()
@property (nonatomic, copy, readwrite) NSString* status;
@property (nonatomic, copy, readwrite) NSString* msg;
@property (nonatomic, assign, readwrite) int total;

@end

@implementation MobeeStatusMsg
@synthesize status, msg, total;

-(void)dealloc {
    self.status = nil;
    self.msg = nil;
    self.total = 0;
    
    [super dealloc];
}

-(BOOL)isSuccess {
    return [kMobeeStatusResultSuccess isEqualToString: self.status];
}

+(MobeeStatusMsg*)parseXmlData:(NSData*)data {
    
    MobeeStatusMsg *ret = [[[MobeeStatusMsg alloc] init] autorelease];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL != tbxml.rootXMLElement) {
        TBXMLElement *item = tbxml.rootXMLElement->firstChild;
        while(NULL != item) {
            
            NSString *name = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([@"status" isEqualToString:name]) {
                ret.status = text;
            } else if([@"msg" isEqualToString:name]) {
                ret.msg = text;
            } else if([@"total" isEqualToString:name]) {
                ret.total = [text intValue];
            }
            
            item = item->nextSibling;
        }
    }
    [tbxml release];

    return ret;
}

@end
