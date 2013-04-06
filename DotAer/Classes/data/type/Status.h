//
//  Status.h
//  DotAer
//
//  Created by Kyle on 13-4-2.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XmlWriter.h"
#import "TBXML.h"

@interface Status : NSObject

@property (nonatomic, assign) BOOL code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int curPage;


-(NSString*)description;

+(Status *)parseXmlData:(NSData*)data;


@end
