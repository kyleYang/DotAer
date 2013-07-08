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

typedef enum
{
   
    VideoScreenNormal = 0,
    VideoScreenClear = 1, //default
    VideoScreenHD = 2,
    VideoScreenUnknow = 3
}VideoScreenStatus;

typedef VideoScreenStatus VideoScreen;

@interface Video : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *youkuId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content; //高清
@property (nonatomic, copy) NSString *hdContent;//超清
@property (nonatomic, copy) NSString *norContent;//标清
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *md5;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Video *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj;



@end
