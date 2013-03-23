//
//  Article.h
//  DotAer
//
//  Created by Kyle on 13-3-23.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XmlWriter.h"
#import "TBXML.h"

@interface Article : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *content;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Article *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path article:(Article*)obj;


@end
