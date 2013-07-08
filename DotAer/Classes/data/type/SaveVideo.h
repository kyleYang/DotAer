//
//  SaveVideo.h
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XmlWriter.h"
#import "TBXML.h"
#import "Video.h"

@class Video;
@class News;

@interface SaveVideo : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *youkuId;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL downingStatus; // ture for download ,false for pause
@property (nonatomic, assign) BOOL downedStatus; // ture for finish ,false for not finish
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) VideoScreen videoStep;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *imageUrl;

- (id)initWithVideo:(Video *)video withStep:(VideoScreen)vStep;
- (id)initWithNews:(News *)news withStep:(VideoScreen)vStep;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(SaveVideo *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj;


@end
