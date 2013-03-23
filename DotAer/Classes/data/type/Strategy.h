//
//  Strategy.h
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "XmlWriter.h"

@interface Strategy : NSObject


@property (nonatomic, assign) int category;
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, retain) NSArray *imgeArry;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Strategy *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj;


@end
