//
//  HTMLParser.m
//  iMobeeNews
//
//  Created by ellison on 11-5-31.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "HTMLParser.h"
#import "BqsUtils.h"

#define kBufSize 512
#define kTitleSize 512

@interface HTMLParser()
@property (nonatomic, assign) BOOL bAddParaLine;

@property (nonatomic, copy) NSString *curTagName;
@property (nonatomic, copy) NSString *curAttrName;
@property (nonatomic, retain) NSMutableDictionary *attrs;


-(BOOL)doParse:(NSData*)data Encoding:(NSString*)encoding;
-(int)procContent:(unichar)c;
-(int)procTag:(unichar)c;
-(int)procEndTag:(unichar)c;
-(int)procStartTag:(unichar)c;
-(int)procWaitAttr:(unichar)c;
-(int)procAttrName:(unichar)c;
-(int)procAttrValue:(unichar)c;
-(int)procEscapeChar:(unichar)c;

-(void)detectedAttr;
-(void)detectedEscape;
-(void)detectedTagEnd;
-(void)detectedTagStart;
-(void)putInContentBuf:(unichar)c;
-(void)putInSrcBuf:(unichar)c;

@end

@implementation HTMLParser
@synthesize bAddParaLine=_bAddParaLine;
//@synthesize callback;
@synthesize title;
@synthesize content = _content;
//@synthesize imgList;
@synthesize meta;

@synthesize curTagName;
@synthesize curAttrName;
@synthesize attrs;

-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    //self.imgList = [NSMutableArray arrayWithCapacity:10];
    self.meta = [NSMutableDictionary dictionaryWithCapacity:10];
    self.title = @"";
    
    
    _bOldInContent = NO;
    _bInContent = NO;
    _curChar = 0;
    _bFirstChar = YES;
    
    self.attrs = [NSMutableDictionary dictionaryWithCapacity:10];
    
    return self;
}

-(void)dealloc {
    self.title = nil;
    self.content = nil;
    self.meta = nil;
    
    self.curTagName = nil;
    self.curAttrName = nil;
    self.attrs = nil;
    
    [super dealloc];
}


+(HTMLParser*)parseData:(NSData*)data Encoding:(NSString*)encoding {
    return [self parseData:data Encoding:encoding AddParaLine:NO];
}
+(HTMLParser*)parseData:(NSData*)data Encoding:(NSString*)encoding AddParaLine:(BOOL)bAddParaLine {
    HTMLParser *ht = [[[HTMLParser alloc] init] autorelease];
    ht.bAddParaLine = bAddParaLine;
    
    if(![ht doParse:data Encoding:encoding]) {
        return nil;
    }
    
    return ht;    
}

-(BOOL)doParse:(NSData*)data Encoding:(NSString*)encoding {
    if(nil == data || [data length] < 1) {
        BqsLog(@"Invalid param. data=%@", data);
        return NO;
    }
    
    NSMutableData *dData = nil;    
    unichar *pData = nil;
    int srcLength = 0;
    
    {
        NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
        
        // parse data to string
        NSString *sData = [BqsUtils stringFromData:data Encoding:encoding];
        srcLength = [sData length];
        
        if(srcLength < 1) {
            BqsLog(@"Can't parse data into string");
            return NO;
        }

        // get unichar array of string
        dData = [[NSMutableData alloc] initWithLength:(srcLength+5) * sizeof(unichar)];
        pData = (unichar*)[dData bytes];
        
        [sData getCharacters:pData range:NSMakeRange(0, srcLength)];
        
        [subPool drain];
    }
    
    
    // prepare buffer
    NSMutableData *srcBuf = [[NSMutableData alloc] initWithLength:kBufSize * sizeof(unichar)];
    NSMutableData *contentBuf = [[NSMutableData alloc] initWithLength:kBufSize * sizeof(unichar)];
    NSMutableData *titleBuf = [[NSMutableData alloc] initWithLength:kTitleSize * sizeof(unichar)];
    
    _pSrcBuf = (unichar*)[srcBuf bytes];
    _pContentBuf = (unichar*)[contentBuf bytes];
    _pTitleBuf = (unichar*)[titleBuf bytes];
    
    _nSrcBufPos = 0;
    _nContentBufPos = 0;
    _nTitleBufPos = 0;
    
    // prepare output content buffer
    _content = [[NSMutableString alloc] initWithCapacity:srcLength];
    
    int pos;
    int nState = 0;
    for(pos = 0; pos < srcLength; pos ++) {
        unichar c = pData[pos];
        
        int newState = nState;
        
        NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
        switch(nState) {
            case 0: // proc content
            {
                newState = [self procContent:c];
                break;
            }
            case 1: // proc tag 
            {
                newState = [self procTag:c];
                break;
            }
            case 2:
            {
                newState = [self procEndTag:c];
                break;
            }
            case 3: 
            {
                newState = [self procStartTag:c];
                break;
            }
            case 4:
            {
                newState = [self procWaitAttr:c];
                break;
            }
            case 5:
            {
                newState = [self procAttrName:c];
                break;
            }
            case 6:
            {
                newState = [self procAttrValue:c];
                break;
            }
            case 7:
            {
                newState = [self procEscapeChar:c];
                break;
            }
            default:
            {
                BqsLog(@"Invalid state: %d", nState);
                pos = srcLength;
                break;
            }
                
        }
        [subPool drain];
        
        nState = newState;
    }
    
    if(_nContentBufPos > 0) {
        [_content appendString:[NSString stringWithCharacters:_pContentBuf length:_nContentBufPos]];
        _nContentBufPos = 0;
    }
    
    
    // release buffers
    
    [dData release];
    [srcBuf release];
    [contentBuf release];
    [titleBuf release];
    
    _pSrcBuf = nil;
    _pContentBuf = nil;
    _pTitleBuf = nil;
    
    _nSrcBufPos = 0;
    _nContentBufPos = 0;
    _nTitleBufPos = 0;

    return YES;
}

-(int)procContent:(unichar)c {
    if('&' == c) {
        _nSrcBufPos = 0;
        [self putInSrcBuf:c];
        return 7; // escape char
    }
    
    if('<' == c) {
        _nSrcBufPos = 0;
        [self putInSrcBuf:c];
        return 1; // tag
    }
    
    [self putInContentBuf:c];
    
    return 0; // old state
}

-(int)procTag:(unichar)c {
    // eat space
    if(' ' == c) {
        return 1;
    }
    
    if('/' == c) {
        // end tag
        return 2;
    }
    
    _nSrcBufPos = 0;
    [self putInSrcBuf:c];
    
    return 3;
}

-(int)procEndTag:(unichar)c {
    if('>' == c) {
        [self detectedTagEnd];
        _nSrcBufPos = 0;
        self.curTagName = @"";
        return 0; // finish, return to content
    }
    return 2;
}

-(int)procStartTag:(unichar)c {
    if('/' == c) {
        return 2; // end tag
    }
    
    if('>' == c) {
        // save tag name
        self.curTagName = [NSString stringWithCharacters:_pSrcBuf length:_nSrcBufPos];
        _nSrcBufPos = 0;
        [self detectedTagStart];
        return 0; // content;
    }
    
    if(' ' == c) {
        // save tag name
        self.curTagName = [NSString stringWithCharacters:_pSrcBuf length:_nSrcBufPos];
        _nSrcBufPos = 0;
        [self detectedTagStart];
        return 4; // attr
    }
    
    [self putInSrcBuf:c];
    return 3;
}

-(int)procWaitAttr:(unichar)c {
    // eat space
    if(' ' == c) {
        return 4;
    }
    
    if('>' == c) {
        _nSrcBufPos = 0;
        return 0; // content
    }
    
    if('/' == c) {
        _nSrcBufPos = 0;
        return 2;
    }
    
    [self putInSrcBuf:c];
    
    return 5;
}
-(int)procAttrName:(unichar)c {
    if('=' == c) {
        self.curAttrName = [NSString stringWithCharacters:_pSrcBuf length:_nSrcBufPos];
        _nSrcBufPos = 0;
        return 6;
    }
    
    [self putInSrcBuf:c];
    
    return 5;
}
-(int)procAttrValue:(unichar)c {
    if(0 == _nSrcBufPos) {
        // eat space
        if(' ' == c) {
            return 6;
        }
    } else {
        if('\'' == _pSrcBuf[0] || '\"' == _pSrcBuf[0]) {
            if('\'' == c || '\"' == c) {
                // end attr name
                [self detectedAttr];
                 return 4;
            }
        } else {
            if(' ' == c) {
                // end attr name
                [self detectedAttr];
                return 4;
            } else if('/' == c) {
                [self detectedAttr];
                return 2;
            } else if('>' == c) {
                [self detectedAttr];
                return 0;
            }
        }
    }
    [self putInSrcBuf:c];
    return 6;
}
-(int)procEscapeChar:(unichar)c {
    [self putInSrcBuf:c];
    
    if(';' == c || _nSrcBufPos >= 10) {
        [self detectedEscape];
        return 0;
    }
    
    return 7;
}


-(void)detectedAttr {
    NSString *sAttrVal = [NSString stringWithCharacters:_pSrcBuf length:_nSrcBufPos];
    _nSrcBufPos = 0;
    
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@" \'\""];
    NSString *sName = [self.curAttrName stringByTrimmingCharactersInSet:cs];
    NSString *sValue = [sAttrVal stringByTrimmingCharactersInSet:cs];
    
    if([sName length] > 0 && [sValue length] > 0) {
        BqsLog(@"detected attr. tag: %@, %@=%@", self.curTagName, sName, sValue);
        [self.attrs setObject:sValue forKey:sName];
    }
    
}

-(void)detectedEscape {
    NSString *sEscape = [NSString stringWithCharacters:_pSrcBuf length:_nSrcBufPos];
    _nSrcBufPos = 0;
    
    NSString *lwEscape = [sEscape lowercaseString];
    
    unichar c = 0;
    if([@"&amp;" isEqualToString:lwEscape]) {
        c = '&';
    } else if([@"&apos;" isEqualToString:lwEscape]) {
        c = '\'';
    } else if([@"&gt;" isEqualToString:lwEscape]) {
        c = '>';
    } else if([@"&lt;" isEqualToString:lwEscape]) {
        c = '<';
    } else if([@"&quot;" isEqualToString:lwEscape]) {
        c = '\"';
    } else if([@"&copy;" isEqualToString:lwEscape]) {
        c = 251;
    } else if([@"&reg;" isEqualToString:lwEscape]) {
        c = 256;
    } else if([@"&yen;" isEqualToString:lwEscape]) {
        c = 245;
    } else if([@"&mdash;" isEqualToString:lwEscape]) {
        c = '-';        
    }
    
    if(0 != c) {
        [self putInContentBuf:c];
    }
}

-(void)detectedTagEnd {
    NSString *lwTagName = self.curTagName;
    
    if([@"title" isEqualToString:lwTagName]) {
        _bInTitle = NO;
        _bInContent = YES;
        self.title = [NSString stringWithCharacters:_pTitleBuf length:_nTitleBufPos];
        _nTitleBufPos = 0;
    } else if([@"body" isEqualToString:lwTagName]) {
    } else if([@"a" isEqualToString:lwTagName]) {
        _bInContent = _bOldInContent;
    } else if([@"div" isEqualToString:lwTagName]) {
        _bInContent = _bOldInContent;
    } else if([@"meta" isEqualToString:lwTagName]) {
        // metas
        if([self.attrs count] >= 2) {
            NSString *sName = [self.attrs objectForKey:@"name"];
            NSString *sContent = @"";
            
            if(nil != sName) {
                sContent = [self.attrs objectForKey:@"content"];
            } else {
                // contains encoding
                sName = [self.attrs objectForKey:@"http-equiv"];
                sContent = [self.attrs objectForKey:@"content"];
            }
            
            if([sName length] > 0 && [sContent length] > 0) {
                [self.meta setObject:sContent forKey:sName];
            }
        }
    } else if([@"img" isEqualToString:lwTagName]) {
        // image src=xxx is in attrs
//        NSString *sSrc = [self.attrs objectForKey:@"src"];
//        if([sSrc length] > 0) {
//            // detected image
//        }
    }
    [self.attrs removeAllObjects];

}

-(void)detectedTagStart {
    NSString *lwTagName = self.curTagName;
    
    if([@"title" isEqualToString:lwTagName]) {
        _bInTitle = YES;
        _bInContent = NO;
    } else if([@"body" isEqualToString:lwTagName]) {
    } else if([@"br" isEqualToString:lwTagName]) {
        [self putInContentBuf:'\n'];
    } else if([@"p" isEqualToString:lwTagName]) {
        [self putInContentBuf:'\n'];
    } else if([@"a" isEqualToString:lwTagName]) {
        _bOldInContent = _bInContent;
        _bInContent = NO;
    } else if([@"div" isEqualToString:lwTagName]) {
        _bOldInContent = _bInContent;
        _bInContent = NO;
        
    }
    [self.attrs removeAllObjects];
}

-(void)putInContentBuf:(unichar)c {
    if(!_bInContent) {
        if(_bInTitle) {
            if(_nTitleBufPos >= kTitleSize) {
//                _nTitleBufPos = 0;
//                BqsLog(@"titleBuf full!!!!");
            } else {
                _pTitleBuf[_nTitleBufPos] = c;
                _nTitleBufPos ++;
            }
        }
        return;
    }
    
    if('\r' == c) {
        c = '\n';
    }
    if('\t' == c) {
        c = ' ';
    }
    
    BOOL bNormalC = YES;
    
    // skip spaces
    char lastC = _curChar;
    if(' ' == c || '\t' == c/* ||
       '\r' == c || '\n' == c*/) {
        if(' ' == lastC || '\t' == lastC/* ||
           '\r' == lastC || '\n' == lastC*/) {
            return;
        }
        bNormalC = NO;
    }
    if('\r' == c || '\n' == c) {
        if('\r' == lastC || '\n' == lastC) {
            return;
        }
        bNormalC = NO;
    }
    
    // ignore heading space of every line
    if(_bFirstChar && !bNormalC) return;
    
    if('\n' == c) {
        // new line
        if(_bFirstChar) {
            // ignore empty line
            if(_nContentBufPos > 0 && 
               (' ' == lastC || '\t' == lastC)) {
                _nContentBufPos --;
            }
            return;
        }
        _bFirstChar = YES;
    }
    if(bNormalC) {
        _bFirstChar = NO;
    }
    
//    if(_bFirstChar && '\n' == c) {
//        _nContentBufPos = 0;
//        return;
//    }
//    if(bNormalC) {
//        _bFirstChar = NO;
//    }
    
    
    
    _curChar = c;
    
    if(_nContentBufPos >= kBufSize) {
        [_content appendString:[NSString stringWithCharacters:_pContentBuf length:_nContentBufPos]];
        _nContentBufPos = 0;
    }
    
    _pContentBuf[_nContentBufPos] = c;
    _nContentBufPos ++;

    if(_bAddParaLine && '\n' == c) {
        if(_nContentBufPos >= kBufSize) {
            [_content appendString:[NSString stringWithCharacters:_pContentBuf length:_nContentBufPos]];
            _nContentBufPos = 0;
        }
        
        _pContentBuf[_nContentBufPos] = '\n';
        _nContentBufPos ++;
    }
}

-(void)putInSrcBuf:(unichar)c {
    if(_nSrcBufPos >= kBufSize) {
        _nSrcBufPos = 0;
        BqsLog(@"srcBuf full!!!!");
    }
    
    _pSrcBuf[_nSrcBufPos] = c;
    _nSrcBufPos ++;
}

@end
