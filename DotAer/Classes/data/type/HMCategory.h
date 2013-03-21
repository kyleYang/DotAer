//
//  category.h
//  DotAer
//
//  Created by Kyle on 13-3-8.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlWriter.h"
#import "TBXML.h"

@interface HMCategory : NSObject

@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *arrSubCat;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(HMCategory *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj;


@end
