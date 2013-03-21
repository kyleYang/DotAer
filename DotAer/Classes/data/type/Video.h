//
//  Video.h
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XmlWriter.h"
#import "TBXML.h"

@interface Video : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *imageUrl;


-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Video *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj;



@end
