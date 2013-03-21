//
//  HTMLParser.h
//  iMobeeNews
//
//  Created by ellison on 11-5-31.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTMLParser : NSObject {
    BOOL _bAddParaLine;
    
    NSMutableString *_content;
    
    unichar *_pSrcBuf;
    int _nSrcBufPos;
    
    unichar *_pTitleBuf;
    int _nTitleBufPos;
    
    unichar *_pContentBuf;
    int _nContentBufPos;
    
    BOOL _bOldInContent;
    BOOL _bInContent;
    BOOL _bInTitle;
    
    unichar _curChar;
    BOOL _bFirstChar;
}

//@property (nonatomic, assign) id callback;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSMutableString *content;
//@property (nonatomic, retain) NSMutableArray *imgList;
@property (nonatomic, retain) NSMutableDictionary *meta;


+(HTMLParser*)parseData:(NSData*)data Encoding:(NSString*)encoding;
+(HTMLParser*)parseData:(NSData*)data Encoding:(NSString*)encoding AddParaLine:(BOOL)bAddParaLine;

@end
