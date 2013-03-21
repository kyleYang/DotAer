//
//  XmlParser.m
//  iMobee
//
//  Created by ellison on 10-9-20.
//  Copyright 2010 borqs. All rights reserved.
//

#import "XmlParser.h"
#import "BqsUtils.h"

@interface XmlParser() <NSXMLParserDelegate>

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict;

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
@end

@implementation XmlParser


- (void)dealloc {
	[_parser release];
	[_value release];
	
	[super dealloc];
}

- (BOOL)parseFile:(NSString*)path Callback:(id<XmlParserCallback>) cb {
	NSData *data = [[NSData alloc] initWithContentsOfFile:path];
	BOOL ret = [self parseData:data Callback:cb];
	
	[data release];
	return ret;
}

- (BOOL)parseData:(NSData*)data Callback:(id<XmlParserCallback>) cb {
	
	if(nil == data) {
		BqsLog(@"data is nil");
		return NO;
	}
	
	[_parser release];
	_parser = [[NSXMLParser alloc] initWithData:data];
	
	if(nil == _parser) return NO;
	
	_callback = cb;
	
	[_parser setDelegate:self];
	BOOL ret = [_parser parse];
	
	if(ret) return YES;
	
	BqsLog(@"Parse failed: %@", [_parser parserError]);
	return NO;
}

- (void)parser:(NSXMLParser *)psr didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if(nil != _value) [_value setString: @""];

	_level ++;
	
	//NSBqsLog(@"elementStart: %d %@ %@ %@ %@", _level, elementName, namespaceURI, qualifiedName, attributeDict);
	
	if(nil != _callback && [_callback respondsToSelector: @selector(onXmlElementStart:Level:Name:Attribute:)]) {
        NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
		[_callback onXmlElementStart:psr Level:_level Name:elementName Attribute:attributeDict];
        [subPool drain];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//NSBqsLog(@"foundCharacters: %@", string);
	
	if(nil == _value) {
		_value = [[NSMutableString alloc] initWithString: string];
	} else {
		[_value appendString: string];
	}
}
- (void)parser:(NSXMLParser *)psr didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSBqsLog(@"elementEnd: %d %@ %@ %@ %@", _level, elementName, namespaceURI, qName, _value);
	
	if(nil != _callback && [_callback respondsToSelector: @selector(onXmlElementEnd:Level:Name:Value:)]) {
        NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
		[_callback onXmlElementEnd:psr Level:_level Name:elementName Value: _value];
        [subPool drain];
	}
	if(nil != _value) [_value setString: @""];
	_level --;
}
@end
