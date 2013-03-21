//
//  XmlWriter.h
//  iMobee
//
//  Created by ellison on 10-9-20.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlWriter : NSObject {
	NSOutputStream *_outStream;
	NSMutableString *_buf;
	
	BOOL _bError;
}
@property (assign) BOOL bError;

- (id)initWithFile:(NSString*)path;
- (id)initWithData:(NSMutableData*)data;
- (void)dealloc;

- (BOOL)flush;

- (BOOL)writeStartTag:(NSString*)tag;
- (BOOL)writeEndTag:(NSString*)tag;
- (BOOL)writeStringTag:(NSString*)tag Value:(NSString*)value CData:(BOOL)bCData;
- (BOOL)writeIntTag:(NSString*)tag Value:(NSInteger)value;
- (BOOL)writeDoubleTag:(NSString*)tag Value:(double)value;

@end
