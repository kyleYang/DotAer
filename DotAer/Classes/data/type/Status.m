//
//  Status.m
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Status.h"

#import "Env.h"
#import "BqsUtils.h"


#define kCode @"code"
#define kMsg @"msg"
#define kPassport @"passport"
#define kTotalPage @"totalPage"
#define kPage @"page"


@implementation Status
@synthesize code;
@synthesize msg;
@synthesize totalPage;
@synthesize curPage;
@synthesize passport;
- (void)dealloc{
    self.msg = nil;
    self.passport = nil;
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[Status code:%d,msg:%@,totalPage:%d,curPage:%d,passport:%@]",
            !self.code, self.msg,self.totalPage,self.curPage,self.passport];
}





+(Status *)parseXmlData:(NSData*)data {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
    Status *status = [[[Status alloc] init] autorelease];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL == tbxml.rootXMLElement) {
        [tbxml release];
        return nil;
    }
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    
    while(NULL != item) {
        
        NSString *name = [TBXML elementName:item];
        NSString *value = [TBXML textForElement:item];
        if([kCode isEqualToString:name]) {
            status.code = ![value boolValue]; //retun defalut 0 for true
        }else if([kMsg isEqualToString:name]){
            status.msg = value;
        }else if([kPassport isEqualToString:name]){
            status.passport = value;
        }else if([kTotalPage isEqualToString:name]){
            status.totalPage = [value intValue];
        }else if([kPage isEqualToString:name]){
            status.curPage = [value intValue];
        }else{
            BqsLog(@"Unknown tag: %@", name);
        }
        
        item = item->nextSibling;
    }
    
    [tbxml release];
    
    return status;
    
}


@end
