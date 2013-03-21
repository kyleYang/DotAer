//
//  Photo.h
//  DotAer
//
//  Created by Kyle on 13-1-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlWriter.h"
#import "TBXML.h"

@interface PhotoImg : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *introduce;

@end

@interface Photo : NSObject

@property (nonatomic, copy) NSString *imgCate;
@property (nonatomic, copy) NSString *imgId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, retain) NSArray *arrImgUrls;


-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Photo *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj;


@end
