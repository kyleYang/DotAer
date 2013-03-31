//
//  Simulator.h
//  DotAer
//
//  Created by Kyle on 13-3-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlWriter.h"
#import "TBXML.h"

@interface Simulator : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;

-(NSString*)description;

-(void)writeXmlItem:(XmlWriter*)wrt;

+(Simulator *)parseXmlData:(NSData*)data;

+(BOOL)saveToFile:(NSString*)path article:(Simulator*)obj;


@end
