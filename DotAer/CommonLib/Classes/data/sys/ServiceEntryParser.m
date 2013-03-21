//
//  ServiceEntryParser.m
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "ServiceEntryParser.h"
#import "XmlParser.h"
#import "BqsUtils.h"


// tag definition
#define kItemList @"services_list"
#define kItem @"service"
#define kItem_Name @"title"
#define kItem_Entry @"entry"

@interface ServiceEntryParser() <XmlParserCallback>

@property (nonatomic, copy) NSString *curName;
@property (nonatomic, copy) NSString *curEntry;
@property (nonatomic, retain) NSMutableDictionary *entries;

- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr;
- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value;
@end


@implementation ServiceEntryParser
@synthesize curName;
@synthesize curEntry;
@synthesize entries;

-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    _bInItem = NO;
    self.entries = [NSMutableDictionary dictionaryWithCapacity:100];
    
    return self;
}

- (void)dealloc {
    self.curName = nil;
    self.curEntry = nil;
    self.entries = nil;
    
	[super dealloc];
}

- (NSMutableDictionary*) parseData:(NSData*)data {
	XmlParser *psr = [[XmlParser alloc] init];
	
    [self.entries removeAllObjects];
	_bInItem = NO;
	
	if(![psr parseData:data Callback: self]) {
		BqsLog(@"Failed to parse services xml data: %@", data);
	}
	[psr release];
	
	return self.entries;
	
}

- (void) onXmlElementStart: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Attribute: (NSDictionary*)attr {
	if(2 == level && [kItem isEqualToString:sElementame]) {
		_bInItem = YES;
	}
}

- (void) onXmlElementEnd: (NSXMLParser*) parser Level: (NSInteger)level Name: (NSString*)sElementame Value: (NSString*)value {
	
	if(!_bInItem) return;
	
	//NSBqsLog(@"%@=%@", sElementame, value);
		
	if([kItem isEqualToString:sElementame]) {
		_bInItem = NO;
		
		if([self.curName length] > 0 && nil != self.curEntry) {
			[self.entries setObject:self.curEntry forKey:self.curName];
		}
		self.curName = nil;
        self.curEntry = nil;
	} else {
		if([kItem_Name isEqualToString:sElementame]) {
            self.curName = value;
        } else if([kItem_Entry isEqualToString:sElementame]) {
            self.curEntry = value;
        }
	}
}

@end
