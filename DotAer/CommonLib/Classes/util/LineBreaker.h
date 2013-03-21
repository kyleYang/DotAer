//
//  LineBreaker.h
//  iMobee
//
//  Created by ellison on 10-10-19.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PackageFile.h"


typedef struct {
	int nNumberOfPages;
	unsigned int pageOffsets[1];
} t_PAGE_HEADER;
typedef struct {
	int nLocation;
	int nLength;
    char bLineFull;
    char reserved[3];
} t_LINE_POS;
typedef struct {
	int nNumberOfLines;
    char bHasFullLine;
    char reserved;
    short nMaxLineWidth;
    short nHeight;
    char reserved2[2];
	t_LINE_POS lines[1];
} t_PAGE_LINES;

@interface BqsPageLinesInfo : NSObject {
}
@property (nonatomic, assign) int txtCharOffset;
@property (nonatomic, assign) int txtCharCnt;
@property (nonatomic, assign) float pageOffset;
@property (nonatomic, assign) float pageHeight;
@property (nonatomic, retain) NSData *linesData;
@end

@interface LineBreaker : NSObject {
	UIFont *_font;
	CGSize _size;
    CGSize _firsPageSize;
	CGFloat _lineGap;
	CGFloat _paraGap;
	
//	CGSize _ascIIFontSizes[256];
//	CGSize _chineseFontSize;
    
    CGFloat _fMaxTxtWidth;
    CGFloat _fTotalTextHeight;
}
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize firstPageSize;
@property (nonatomic, assign) CGFloat lineGap;
@property (nonatomic, assign) CGFloat paraGap;
@property (nonatomic, assign, readonly) CGFloat fMaxTxtWidth; // 
@property (nonatomic, assign, readonly) CGFloat fTotalTextHeight; // for break into lines, total text height
@property (nonatomic, assign) int nCharPos;// for break into lines, last char processed

//// NSArray->NSValue(NSRange)
//-(NSArray *)breakStringIntoLines:(NSString*)str;
//// NSArray->(NSArray->NSValue(NSRange))
//-(NSArray *)breakStringIntoPages:(NSString*)str;

// NSData(t_PAGE_LINES)
-(NSData *)breakStringIntoLinesBinary:(NSString*)str StartCharPos:(int)starCharPos InArea:(CGSize)sz;
// NSData(t_PAGE_HEADER)
-(NSData *)breakStringIntoPagesBinary:(NSString*)str;
// NSArray(BqsPageLinesInfo)
-(NSArray*)breakStringIntoPages:(NSString*)str PageArea:(CGSize)sz;
@end


@protocol BackgroundLineBreakerCallback
-(void)backgroundLineBreakerFinished:(NSData*)result Attached:(id)attached;
@end

@interface BackgroundLineBreaker : NSObject {
	id<BackgroundLineBreakerCallback> _callback;
	LineBreaker *_lineBreaker;
	NSMutableArray *_tasks; // NSArray->(NSDictionry->(path,attached))
    
    BOOL _bRunning;
    PackageFile *_bkPkgFile;
    NSString *_bkPkgFileName;
    int _bkTaskCnt; // task that not yet callback to main thread
    
}
@property (assign) id<BackgroundLineBreakerCallback> callback;
@property (retain) LineBreaker *lineBreaker;

-(void)addTaskFile:(NSString*)path Attached:(id)attached Start:(BOOL)bStart;
-(void)addTaskStr:(NSString*)str Attached:(id)attached Start:(BOOL)bStart;
-(void)addTaskPkgFile:(NSString*)pkgFileName File:(NSString*)fileName Attached:(id)attached Start:(BOOL)bStart;
-(void)start;
-(void)cancelAll;
-(BOOL)hasTask;
@end