//
//  question.h
//  DotAer
//
//  Created by Kyle on 13-4-1.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlWriter.h"
#import "TBXML.h"

@interface Question : NSObject

@property (nonatomic, assign) int questId;
@property (nonatomic, copy) NSString *descript;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *userName;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Question *)parseXml:(TBXMLElement*)element;
+(NSArray *)parseXmlData:(NSData*)data;



@end
