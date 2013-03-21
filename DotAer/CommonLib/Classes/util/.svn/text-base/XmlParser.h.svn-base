//
//  XmlParser.h
//  iMobee
//
//  Created by ellison on 10-9-20.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol XmlParserCallback <NSObject>
- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;

@end

@interface XmlParser : NSObject {
	NSXMLParser *_parser;
	id<XmlParserCallback> _callback;
	
	NSInteger _level;
	NSMutableString *_value;
}

- (BOOL)parseFile:(NSString*)path Callback:(id<XmlParserCallback>) cb;
- (BOOL)parseData:(NSData*)data Callback:(id<XmlParserCallback>) cb;
- (void)dealloc;

@end
