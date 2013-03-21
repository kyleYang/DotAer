//
//  XmlWriter.m
//  iMobee
//
//  Created by ellison on 10-9-20.
//  Copyright 2010 borqs. All rights reserved.
//

#import "XmlWriter.h"
#import "BqsUtils.h"

#define kBufSize 4096
#define kXmlHeader @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"

@interface XmlWriter()

@property (nonatomic, retain) NSMutableData *oData;
- (BOOL)checkFlush;

@end

@implementation XmlWriter

@synthesize bError = _bError;
@synthesize oData;

- (id)initWithData:(NSMutableData*)data {
	self = [super init];
	if(nil == self) return nil;

    self.oData = data;
    [self.oData setLength:0];
    
    _buf = [[NSMutableString alloc] initWithCapacity:kBufSize+128];
	if(nil == _buf) {
		[self release];
		return nil;
	}
	
	[_buf appendString:kXmlHeader];
	
	_bError = NO;

    
    return self;
}

- (id)initWithFile:(NSString*)path {
	
	self = [super init];
	if(nil == self) return nil;
	
    [BqsUtils checkCreateDir:[path stringByDeletingLastPathComponent]];
	_outStream = [[NSOutputStream alloc] initToFileAtPath:path append:NO];
	if(nil == _outStream) {
		[self release];
		return nil;
	}
	
	[_outStream open];

	_buf = [[NSMutableString alloc] initWithCapacity:kBufSize+128];
	if(nil == _buf) {
		[self release];
		return nil;
	}
	
	[_buf appendString:kXmlHeader];
	
	_bError = NO;
	
	return self;
}
- (void)dealloc {
	[self flush];
	if(nil != _outStream) [_outStream close];
	[_outStream release];
	[_buf release];
    self.oData = nil;
	
	[super dealloc];
}

- (BOOL)flush {
	if([_buf length] < 1) {
		return YES;
	}
	
    if(nil != _outStream) {
        NSInteger dataLength;
        const uint8_t * dataBytes;
        NSInteger bytesWritten;
        NSInteger bytesWrittenSoFar;
        
        dataBytes = (const uint8_t*)[_buf UTF8String];
        dataLength = (int)strlen((const char*)dataBytes);
        
        [_buf setString:@""];
        
        bytesWrittenSoFar = 0;
        do {
            bytesWritten = [_outStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
            //assert(bytesWritten != 0);
            if (bytesWritten <= 0) {
                _bError = YES; 
                return NO;
            } else {
                bytesWrittenSoFar += bytesWritten;
            }
        } while (bytesWrittenSoFar < dataLength);
	} else if(nil != self.oData) {
        NSInteger dataLength;
        const uint8_t * dataBytes;

        dataBytes = (const uint8_t*)[_buf UTF8String];
        dataLength = (int)strlen((const char*)dataBytes);

        //[self.oData appendBytes:dataBytes length:dataLength];
        int curLen = [self.oData length];
        [self.oData increaseLengthBy:dataLength];
        
        void *pM = ([self.oData mutableBytes] + curLen);
        memcpy(pM, dataBytes, dataLength);
        
        [_buf setString:@""];
        
    } else {
        return NO;
    }
	return YES;
}

- (BOOL)checkFlush {
	
	if([_buf length] < kBufSize) {
		return YES;
	}
	
	return [self flush];
}
- (BOOL)writeStartTag:(NSString*)tag {
	[_buf appendString:@"<"];
	[_buf appendString:tag];
	[_buf appendString:@">"];
	return [self checkFlush];
}
- (BOOL)writeEndTag:(NSString*)tag {
	[_buf appendString:@"</"];
	[_buf appendString:tag];
	[_buf appendString:@">"];
	return [self checkFlush];
}
- (BOOL)writeStringTag:(NSString*)tag Value:(NSString*)value CData:(BOOL)bCData {
	if(![self writeStartTag: tag]) return NO;
	if(bCData) {
		[_buf appendString:@"<![CDATA["];
	}
	if(nil != value) {
		[_buf appendString:value];
	}
	
	if(bCData) {
		[_buf appendString:@"]]>"];
	}
	if(![self writeEndTag:tag]) return NO;
	
	return YES;
}
- (BOOL)writeIntTag:(NSString*)tag Value:(NSInteger)value {
	
	NSString *s = [NSString stringWithFormat:@"%d", value];
	return [self writeStringTag:tag Value:s CData:NO];
}

- (BOOL)writeDoubleTag:(NSString*)tag Value:(double)value {
	NSString *s = [NSString stringWithFormat:@"%f", value];
	return [self writeStringTag:tag Value:s CData:NO];
}

@end
