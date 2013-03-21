//
//  LineBreaker.m
//  iMobee
//
//  Created by ellison on 10-10-19.
//  Copyright 2010 borqs. All rights reserved.
//

#import "LineBreaker.h"
#import "BqsUtils.h"
#import "BqsAvlMap.h"


@implementation BqsPageLinesInfo
@synthesize txtCharOffset,txtCharCnt, pageOffset, pageHeight, linesData;
-(NSString*)description {
    return [NSString stringWithFormat:@"ch:%d,%d,pf:%.1f,%.1f",txtCharOffset, txtCharCnt, pageOffset, pageHeight];
}
-(void)dealloc {
    self.linesData = nil;
    [super dealloc];
}
@end


@interface LineBreaker()
@property (nonatomic, retain) BqsAvlMapUIntPtr *mapFontSize; // unichar -> (width << 16 | height)
//-(void)buildFontSizeDict;
-(CGSize) getCharSize:(unichar)ch;
-(NSData *)breakStringIntoLinesBinary:(NSString*)str StartCharPos:(int)starCharPos InArea:(CGSize)sz ExcludeLastParaGap:(BOOL)bExcludeLastParaGap;
@end



@implementation LineBreaker
@synthesize font = _font;
@synthesize size = _size;
@synthesize firstPageSize=_firsPageSize;
@synthesize lineGap = _lineGap;
@synthesize paraGap = _paraGap;
@synthesize fMaxTxtWidth = _fMaxTxtWidth;
@synthesize fTotalTextHeight = _fTotalTextHeight;
@synthesize nCharPos;
@synthesize mapFontSize;

-(id)init {
	self = [super init];
	if(nil == self)return nil;
	
	return self;
}

-(void)dealloc {
	[_font release];
    self.mapFontSize = nil;
	
	[super dealloc];
}

-(void)setFont:(UIFont *)fnt {
	[_font release];
	_font = [fnt retain];
//	[self buildFontSizeDict];
}

-(CGSize) getCharSize:(unichar)ch {
    if(nil == self.mapFontSize) {
        self.mapFontSize = [[[BqsAvlMapUIntPtr alloc] initWithCapacity:4096] autorelease];
    }
    
    CGSize sz = CGSizeMake(0, 0);
    
    unsigned int nsz = (unsigned int)[self.mapFontSize getPtrForKey:ch];
    if((unsigned int)NULL == nsz) {
        unichar chs[5] = {ch, ch, ch, ch, ch};
        NSString *str = [NSString stringWithCharacters:chs length:5];
//        sz = [str sizeWithFont:_font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        sz = [str sizeWithFont:_font forWidth:MAXFLOAT lineBreakMode:UILineBreakModeClip];
        
//        BqsLog(@"%@ -> %.1fx%.1f", str, sz.width, sz.height);
        
        sz.width = MIN(_font.pointSize*2.0, sz.width/5.0);
        sz.height = MIN(_font.pointSize*2.0, sz.height);
        
        int w = sz.width * 10;
        int h = sz.height * 10;
        nsz = ((w & 0xffff) << 16) | (h & 0xffff);
        
        [self.mapFontSize setPtr:(void*)nsz forKey:ch];
    } else {
        sz.width = (((nsz & 0xffff0000) >> 16) & 0xffff) / 10.0;
        sz.height = (nsz & 0xffff) / 10.0;
    }
    
    return sz;
}

// NSData(t_PAGE_LINES)
-(NSData *)breakStringIntoLinesBinary:(NSString*)str StartCharPos:(int)starCharPos InArea:(CGSize)sz {
    return [self breakStringIntoLinesBinary:str StartCharPos:starCharPos InArea:sz ExcludeLastParaGap:YES];
}
-(NSData *)breakStringIntoLinesBinary:(NSString*)str StartCharPos:(int)starCharPos InArea:(CGSize)sz ExcludeLastParaGap:(BOOL)bExcludeLastParaGap {
	if(nil == str || [str length] < 1) {
		BqsLog(@"LineBreaker.breakStringIntoPagesBinary: str is empty");
		return nil;
	}
    
    int nStartPos = MAX(0, starCharPos);
    if(nStartPos >= [str length]) {
        BqsLog(@"Invalid starPos: %d", starCharPos);
        return nil;
    }
    
    CGSize szSmallChar = [self getCharSize:'I'];
    if(szSmallChar.height > sz.height || szSmallChar.width > sz.width) {
        BqsLog(@"area too small");
        return nil;
    }
	
    float lineCharH = 0.0f;
	float rcHeight = sz.height;
	float rcWidth = sz.width;
        
	// estimate	
	int nCharCnt = [str length] - nStartPos;
    
	int estLines = ceil(rcHeight / (self.font.pointSize * 1.1 + self.lineGap));
	int estLinesBufSize = sizeof(t_LINE_POS)*(estLines+1) + sizeof(t_PAGE_LINES);
	
	
	// malloc memory
	NSMutableData *linesBuf = [[[NSMutableData alloc] initWithLength:estLinesBufSize] autorelease];
	t_PAGE_LINES *pLines = (t_PAGE_LINES*)[linesBuf mutableBytes];
    pLines->nNumberOfLines = 0;
    pLines->bHasFullLine = NO;
    pLines->nMaxLineWidth = 0;
    pLines->nHeight = 0;
	
	// calc    
	int nPos, nStart, nEnd, nStrEnd, nEngWordStart, nEngWordPos;
	nPos = nStartPos;
	float fStrWidth = 0.0;
	nStart = nStartPos;
	nEnd = nStart;
    nStrEnd = nStartPos + nCharCnt;
	nEngWordStart = -1;
	nEngWordPos = -1;
    
	
    _fMaxTxtWidth = 0.0f;
    _fTotalTextHeight = 0.0f;
    
    BOOL bPageFull = NO;
    
    while(nPos < nStrEnd) {
        float lineWidth = rcWidth;
        float pageHeight = rcHeight;
        
        unichar ch = [str characterAtIndex:nPos];
		
        CGSize chSize = [self getCharSize:ch];
        
        lineCharH = MAX(chSize.height, lineCharH);
		
		if('\n' == ch) {
			// line break
			if(estLinesBufSize - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < sizeof(t_LINE_POS)) {
				estLinesBufSize += sizeof(t_LINE_POS) * 32;
				[linesBuf setLength:estLinesBufSize];
				pLines = (t_PAGE_LINES*)[linesBuf mutableBytes];
                BqsLog(@"extend buffer1");
			}
			
            t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
            pL->nLocation = nStart;
            pL->nLength = nEnd - nStart + 1;
            pLines->nNumberOfLines ++;
            if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
            
            _fTotalTextHeight += lineCharH;
            
            if(_fTotalTextHeight + _paraGap + lineCharH > pageHeight) {
                if(!bExcludeLastParaGap) {
                    _fTotalTextHeight += _paraGap;
                }
                // full!
                nPos += 1; // skip the \n
                bPageFull = YES;
                break;
            }
            _fTotalTextHeight += _paraGap;

			
			nStart = nEnd;
			nStart ++; // skip \n
            if(fStrWidth > _fMaxTxtWidth) _fMaxTxtWidth = fStrWidth;
			fStrWidth = 0.0f;
            lineCharH = 0.0f;
		}
		
		BOOL bJump = NO;
		
		if(lineWidth < fStrWidth + chSize.width) {
			// line full
			if(nEngWordStart >= 0) {
				// unended eng word
				if(nEngWordStart > nStart) {
					// line break
                    if(estLinesBufSize - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < sizeof(t_LINE_POS)) {
                        estLinesBufSize += sizeof(t_LINE_POS) * 32;
                        [linesBuf setLength:estLinesBufSize];
                        pLines = (t_PAGE_LINES*)[linesBuf mutableBytes];
                        BqsLog(@"extend buffer2");
                    }
					
					t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
					pL->nLocation = nStart;
					pL->nLength = nEngWordStart - nStart;
					pLines->nNumberOfLines ++;
                    if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
					//BqsLog(@"line2:%@", [str substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)]);
					
					_fTotalTextHeight += lineCharH;
                    _fTotalTextHeight += _lineGap;

					nStart = nEngWordStart;
					nEnd = nEngWordStart - 1;
					nPos = nEngWordPos - 1;
                    if(fStrWidth > _fMaxTxtWidth) _fMaxTxtWidth = fStrWidth;
					fStrWidth = 0.0;
					bJump = YES;
                    
                    if(_fTotalTextHeight + lineCharH > pageHeight) {
						// full !
                        nPos += 1;
                        bPageFull = YES;
                        break;
                        
					}
                    
                    lineCharH = 0.0f;
				}
			}
			
			if(!bJump) {
                // line break
                if(estLinesBufSize - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < sizeof(t_LINE_POS)) {
                    estLinesBufSize += sizeof(t_LINE_POS) * 32;
                    [linesBuf setLength:estLinesBufSize];
                    pLines = (t_PAGE_LINES*)[linesBuf mutableBytes];
                    BqsLog(@"extend buffer3");
                }
				
				t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
				pL->nLocation = nStart;
				pL->nLength = nEnd - nStart;
                pL->bLineFull = YES;
				pLines->nNumberOfLines ++;
                pLines->bHasFullLine = YES;
                if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
				
//                BqsLog(@"charw:%.1f, strw:%.1f line3:%@", chSize.width, fStrWidth, [str substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)]);
                
				_fTotalTextHeight += lineCharH;
                _fTotalTextHeight += _lineGap;
				
				if(_fTotalTextHeight + lineCharH > pageHeight) {
					// full !
                    bPageFull = YES;
                    break;
				}

				
				nStart = nEnd;
                if(fStrWidth > _fMaxTxtWidth) _fMaxTxtWidth = fStrWidth;
				fStrWidth = 0.0f;
                lineCharH = 0.0f;
			}
		}
		
		if(!bJump) {
			if((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')) {
				// is eng char
				if(nEngWordStart < 0) {
					nEngWordStart = nEnd;
					nEngWordPos = nPos;
				}
			} else {
				if(nEngWordStart >= 0) {
					nEngWordStart = -1;
				}
			}
		}
		
		if(!bJump && '\n' != ch) {
			fStrWidth += chSize.width;
		}
		
        nPos ++;
		nEnd ++;
	}
	
    if(!bPageFull) {
        if(nStart < nStrEnd) {
            // last line
            if(estLinesBufSize - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < sizeof(t_LINE_POS)) {
                estLinesBufSize += sizeof(t_LINE_POS);
                [linesBuf setLength:estLinesBufSize];
                pLines = (t_PAGE_LINES*)[linesBuf mutableBytes];
                BqsLog(@"extend buffer3");
            }
            
            t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
            pL->nLocation = nStart;
            pL->nLength = nEnd - nStart;
            pLines->nNumberOfLines ++;
            _fTotalTextHeight += lineCharH;
        }
        self.nCharPos = nStrEnd;
    }
    
    self.nCharPos = nPos;
    pLines->nHeight = _fTotalTextHeight;
	
	return linesBuf;

}

// NSData(t_PAGE_HEADER)
-(NSData *)breakStringIntoPagesBinary:(NSString*)str {
	if(nil == str || [str length] < 1) {
		NSLog(@"LineBreaker.breakStringIntoPagesBinary: str is empty");
		return nil;
	}
	
	float lineCharH = 0.0f;
	float rcHeight = self.size.height;
	float rcWidth = self.size.width;
    
    float rcFirstHeight = self.firstPageSize.height;
    float rcFirstWidth = self.firstPageSize.width;
    
    
    CGSize szSmallChar = [self getCharSize:'I'];
    if(szSmallChar.height > rcHeight || szSmallChar.width > rcWidth) {
        BqsLog(@"area too small");
        return nil;
    }

	
	// estimate	
	int nCharCnt = [str length];
	int estLineChars = (rcWidth / MAX(self.font.pointSize, 5.0)) + 1;
	int estLines = (rcHeight / (self.font.pointSize + self.lineGap));
	int estPageChars = estLineChars * estLines;
	int estPages = nCharCnt / estPageChars + 32;
	
	int estPageMemLen = sizeof(t_LINE_POS)*(estLines+1) + sizeof(t_PAGE_LINES);
	
	int estLinesBufSize = estPages * estPageMemLen;
	int estLinesBufOffset = 0;
	
	// malloc memory
	// pages owns t_PAGE_HEADER
	NSMutableData *pages = [[[NSMutableData alloc] initWithLength:sizeof(t_PAGE_HEADER)+(estPages * sizeof(unsigned int))] autorelease];
	NSMutableData *linesBuf = [[NSMutableData alloc] initWithLength:estLinesBufSize];
	t_PAGE_HEADER *pPages = (t_PAGE_HEADER*)[pages mutableBytes];
	t_PAGE_LINES *pLines = nil;//(t_PAGE_LINES*)[linesBuf mutableBytes];
	pPages->nNumberOfPages = 0;
	
	// calc
    BOOL bFirstPage = YES;
    if(rcFirstWidth < 0.01 || rcFirstHeight < 0.01) bFirstPage = NO;
    
//	const char *pStr = [str UTF8String];
//	int nStrLen = strlen(pStr);
    unichar *pStr = malloc(nCharCnt * sizeof(unichar)  + 10);
    [str getCharacters:pStr range:NSMakeRange(0, nCharCnt)];
    
	int nPos, nStart, nEnd, nEngWordStart, nEngWordPos;
	nPos = 0;
	float fStrWidth = 0.0;
	float fLinesHeight = 0.0;
	nStart = 0;
	nEnd = nStart;
	nEngWordStart = -1;
	nEngWordPos = -1;
	
    _fMaxTxtWidth = 0.0f;
    _fTotalTextHeight = 0.0f;
    
//	while(nPos < nStrLen) {
    while(nPos < nCharCnt) {
        float lineWidth = rcWidth;
        float pageHeight = rcHeight;
        if(bFirstPage) {
            lineWidth = rcFirstWidth;
            pageHeight = rcFirstHeight;
        }
        
//		unsigned char ch = (unsigned char)(*(pStr + nPos));
        unichar ch = *(pStr + nPos);
		
		CGSize chSize = [self getCharSize:ch];
		lineCharH = MAX(lineCharH, chSize.height);
		
		if('\n' == ch) {
			// line break
			if(nil == pLines) {
				pLines = (t_PAGE_LINES*)([linesBuf mutableBytes]+estLinesBufOffset);
				pLines->nNumberOfLines = 0;
                pLines->nMaxLineWidth = 0;
                pLines->nHeight = 0;
                pLines->bHasFullLine = NO;
			}
			if(estLinesBufSize - estLinesBufOffset - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < estPageMemLen) {
				estLinesBufSize += estPageMemLen * 32;
				[linesBuf setLength:estLinesBufSize];
				pLines = (t_PAGE_LINES*)([linesBuf mutableBytes] + estLinesBufOffset);
                BqsLog(@"extend buffer1");
			}
			//NSBqsLog(@"lines: %d, %d, %d, %d", pLines->nNumberOfLines, estLinesBufOffset, pPages->nNumberOfPages, sizeof(t_PAGE_LINES));

            BOOL bLastIsLineBreak = NO;
            if(nStart > 0) {
                unichar lastch = *(pStr + nStart - 1);
                if('\r' == lastch || '\n' == lastch) {
                    bLastIsLineBreak = YES;
                }
            }
            
            BOOL bEmptyLine = YES;
			if(nEnd >= nStart && nStart >= 0) {
                
                for(int ii = nStart; ii <= nEnd; ii++) {
                    unichar ich = *(pStr + ii);
                    
                    if('\r' != ich && '\n' != ich && '\t' != ich && ' ' != ich) {
                        bEmptyLine = NO;
                        break;
                    }
                }                
			}
			
			
			
			if(!bLastIsLineBreak || !bEmptyLine) {
				t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
				pL->nLocation = nStart;
				pL->nLength = nEnd - nStart + 1;
                pL->bLineFull = NO;
				pLines->nNumberOfLines ++;
                if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
//				BqsLog(@"pageHeight: %.1f line1:%@", fLinesHeight, [str substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)]);
				
                if(!bEmptyLine) {
                    fLinesHeight += lineCharH;
                }
				fLinesHeight += _paraGap;
				
				if(fLinesHeight + lineCharH > pageHeight) {
                    
//                    BqsLog(@"fLinesheight: %.1f, lineCharH: %.1f, pageHeight: %.1f, paraGap: %.1f", fLinesHeight, lineCharH, pageHeight, _paraGap);
					// new page
                    bFirstPage = NO;
					if(pPages->nNumberOfPages >= estPages) {
						[pages setLength:[pages length] + sizeof(unsigned int) * 1024];
						estPages += 1024;
						pPages = [pages mutableBytes];
                        BqsLog(@"extend buffer2");
					}
					pPages->pageOffsets[pPages->nNumberOfPages] = estLinesBufOffset;
					pPages->nNumberOfPages ++;
					//BqsLog(@"new page");
					estLinesBufOffset += sizeof(t_PAGE_LINES)  + sizeof(t_LINE_POS) * (pLines->nNumberOfLines-1);
                    
                    pLines->nHeight = fLinesHeight;
					pLines = nil;
                    
                    _fTotalTextHeight += fLinesHeight;
					fLinesHeight = 0.0f;
				}				
			}
			
			nStart = nEnd;
			nStart ++; // skip \n
            if(fStrWidth > _fMaxTxtWidth) _fMaxTxtWidth = fStrWidth;
            
			fStrWidth = 0.0f;
            lineCharH = 0.0f;
		}
		
		BOOL bJump = NO;
		
		if(lineWidth < fStrWidth + chSize.width) {
//			BqsLog(@"LineFull: %f < %f + %f=%f, %d %d %d", lineWidth, fStrWidth, chSize.width, fStrWidth+chSize.width, nStart, nEnd, nPos);
			// line full
			if(nEngWordStart >= 0) {
				// unended eng word
				if(nEngWordStart > nStart) {
					// line break
					if(nil == pLines) {
						pLines = (t_PAGE_LINES*)([linesBuf mutableBytes]+estLinesBufOffset);
						pLines->nNumberOfLines = 0;
                        pLines->nMaxLineWidth = 0;
                        pLines->nHeight = 0;
                        pLines->bHasFullLine = NO;
					}
					if(estLinesBufSize - estLinesBufOffset - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < estPageMemLen) {
						estLinesBufSize += estPageMemLen * 32;
						[linesBuf setLength:estLinesBufSize];
						pLines = (t_PAGE_LINES*)([linesBuf mutableBytes] + estLinesBufOffset);
                        BqsLog(@"extend buffer3");
					}
					
					t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
					pL->nLocation = nStart;
					pL->nLength = nEngWordStart - nStart;
                    pL->bLineFull = NO;
					pLines->nNumberOfLines ++;
                    if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
//					BqsLog(@"pageh: %.1f, line2:%@", fLinesHeight, [str substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)]);
					
					fLinesHeight += lineCharH;
					fLinesHeight += _lineGap;
					
					if(fLinesHeight + lineCharH > pageHeight) {
						// new page
                        bFirstPage = NO;
						if(pPages->nNumberOfPages >= estPages) {
							[pages setLength:[pages length] + sizeof(unsigned int) * 1024];
							estPages += 1024;
							pPages = [pages mutableBytes];
                            BqsLog(@"extend buffer4");
						}
						pPages->pageOffsets[pPages->nNumberOfPages] = estLinesBufOffset;
						pPages->nNumberOfPages ++;
//						BqsLog(@"new page");
						estLinesBufOffset += sizeof(t_PAGE_LINES)  + sizeof(t_LINE_POS) * (pLines->nNumberOfLines-1);
                        
                        pLines->nHeight = fLinesHeight;
						pLines = nil;
                        
                        _fTotalTextHeight += fLinesHeight;
						fLinesHeight = 0.0f;
					}
					
					
					nStart = nEngWordStart;
					nEnd = nEngWordStart - 1;
					nPos = nEngWordPos - 1;
                    if(fStrWidth > _fMaxTxtWidth) _fMaxTxtWidth = fStrWidth;
					fStrWidth = 0.0f;
                    lineCharH = 0.0f;
					bJump = YES;
					
				}
			}
			
			if(!bJump) {
				// line break
				if(nil == pLines) {
					pLines = (t_PAGE_LINES*)([linesBuf mutableBytes]+estLinesBufOffset);
					pLines->nNumberOfLines = 0;
                    pLines->nMaxLineWidth = 0;
                    pLines->nHeight = 0;
                    pLines->bHasFullLine = NO;
				}
				if(estLinesBufSize - estLinesBufOffset - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < estPageMemLen) {
					estLinesBufSize += estPageMemLen * 32;
					[linesBuf setLength:estLinesBufSize];
					pLines = (t_PAGE_LINES*)([linesBuf mutableBytes] + estLinesBufOffset);
                    BqsLog(@"extend buffer5");
				}
				
				t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
				pL->nLocation = nStart;
				pL->nLength = nEnd - nStart;
                pL->bLineFull = YES;
				pLines->nNumberOfLines ++;
                pLines->bHasFullLine = YES;
                if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
				
				fLinesHeight += lineCharH;
				fLinesHeight += _lineGap;

//                BqsLog(@"fLinesHeight: %.1f,linegap:%.1f,lineCharH:%.1f pageHeight: %.1f, line3:%@", fLinesHeight, _lineGap, lineCharH, pageHeight, [str substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)]);

				if(fLinesHeight + lineCharH > pageHeight) {
					// new page
                    bFirstPage = NO;
					if(pPages->nNumberOfPages >= estPages) {
						[pages setLength:[pages length] + sizeof(unsigned int) * 1024];
						estPages += 1024;
						pPages = [pages mutableBytes];
                        BqsLog(@"extend buffer6");
					}
					pPages->pageOffsets[pPages->nNumberOfPages] = estLinesBufOffset;
					pPages->nNumberOfPages ++;
					//BqsLog(@"new page");
					estLinesBufOffset += sizeof(t_PAGE_LINES)  + sizeof(t_LINE_POS) * (pLines->nNumberOfLines-1);
                    
                    pLines->nHeight = fLinesHeight;
					pLines = nil;
                    
                    _fTotalTextHeight += fLinesHeight;
					fLinesHeight = 0.0f;
				}
				
				nStart = nEnd;
                if(fStrWidth > _fMaxTxtWidth) _fMaxTxtWidth = fStrWidth;
				fStrWidth = 0.0f;
                lineCharH = 0.0f;
			}
		}
		
		if(!bJump) {
			if((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')) {
				// is eng char
				if(nEngWordStart < 0) {
					nEngWordStart = nEnd;
					nEngWordPos = nPos;
				}
			} else {
				if(nEngWordStart >= 0) {
					nEngWordStart = -1;
				}
			}
		}
		
		if(!bJump && '\n' != ch) {
			fStrWidth += chSize.width;
		}
		
        nPos ++;

		nEnd ++;
	}
	
	if(nStart < [str length]) {
		if(nil == pLines) {
			pLines = (t_PAGE_LINES*)([linesBuf mutableBytes]+estLinesBufOffset);
			pLines->nNumberOfLines = 0;
            pLines->nMaxLineWidth = 0;
            pLines->bHasFullLine = NO;
		}
		if(estLinesBufSize - estLinesBufOffset - (pLines->nNumberOfLines * sizeof(t_LINE_POS)) - sizeof(t_PAGE_LINES)  < estPageMemLen) {
			estLinesBufSize += estPageMemLen * 1;
			[linesBuf setLength:estLinesBufSize];
			pLines = (t_PAGE_LINES*)([linesBuf mutableBytes] + estLinesBufOffset);
		}
		
		t_LINE_POS *pL = &pLines->lines[pLines->nNumberOfLines];
		pL->nLocation = nStart;
		pL->nLength = nEnd - nStart;
        pL->bLineFull = NO;
		pLines->nNumberOfLines ++;
        if(fStrWidth > pLines->nMaxLineWidth) pLines->nMaxLineWidth = fStrWidth;
        
        _fTotalTextHeight += lineCharH; 
        fLinesHeight += lineCharH;
		//BqsLog(@"line:%@", [str substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)]);
	}

    if(nil != pLines) {
        if(pLines->nNumberOfLines < 1) {
            pLines = nil;
        } else if(1 == pLines->nNumberOfLines) {
            t_LINE_POS *pL = &pLines->lines[0];
            if(pL->nLength < 1) {
                pLines = nil;
                BqsLog(@"drop empty last page");
            }
        }
    }
    
	if(nil != pLines) {        
		// new page
		if(pPages->nNumberOfPages >= estPages) {
			[pages setLength:[pages length] + sizeof(unsigned int) * 1];
			estPages += 1;
			pPages = [pages mutableBytes];
		}
		pPages->pageOffsets[pPages->nNumberOfPages] = estLinesBufOffset;
		pPages->nNumberOfPages ++;
		estLinesBufOffset += sizeof(t_PAGE_LINES)  + sizeof(t_LINE_POS) * (pLines->nNumberOfLines-1);
        pLines->nHeight = fLinesHeight;
        
		pLines = nil;

	}
	
	// merge memory into one
	int nP = pPages->nNumberOfPages;
	int memPos = sizeof(t_PAGE_HEADER) + nP * sizeof(int);
	//int nTotalMem = memPos + estLinesBufOffset;
	[pages setLength:memPos];
	[pages appendBytes:[linesBuf mutableBytes] length:estLinesBufOffset];
	pPages = [pages mutableBytes];
	
	for(int n = 0; n < nP; n ++) {
		pPages->pageOffsets[n] += memPos;
//		t_PAGE_LINES *pL = (t_PAGE_LINES*)((void*)pPages + pPages->pageOffsets[n]);
//		NSLog(@"page %d, lines: %d", n, pL->nNumberOfLines);
	}
	[linesBuf release];
    free(pStr);
    
//    BqsLog(@"maxLineWdith: %f", _fMaxTxtWidth);
	
	return pages;
	
}

// NSArray(BqsPageLinesInfo)
-(NSArray*)breakStringIntoPages:(NSString*)str PageArea:(CGSize)sz {

//    BqsLog(@"sz: %.1fx%.1f", sz.width, sz.height);
    
    CGSize szSmallChar = [self getCharSize:'I'];
    if(szSmallChar.height > sz.height || szSmallChar.width > sz.width) {
        BqsLog(@"area too small");
        return nil;
    }

    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:128];
    int charOffset = 0;
    int charCnt = [str length];

    float maxTxtWidth = 0.0f;
    float totalTxtHeight = 0.0f;
    
    float pageOffet = 0.0f;
    
    while(charOffset < charCnt) {
        NSData *lines = [self breakStringIntoLinesBinary:str StartCharPos:charOffset InArea:sz ExcludeLastParaGap:NO];
        BqsPageLinesInfo *pl = [[[BqsPageLinesInfo alloc] init] autorelease];
        pl.linesData = lines;
        pl.txtCharOffset = charOffset;
        pl.txtCharCnt = self.nCharPos - charOffset;
        pl.pageOffset = pageOffet;
        pl.pageHeight = self.fTotalTextHeight;
        
//        BqsLog(@"maxw: %.1f, h: %.1f", self.fMaxTxtWidth, pl.pageHeight);
        
        [ret addObject:pl];
        
        pageOffet += pl.pageHeight;
        
        
        if(self.fMaxTxtWidth > maxTxtWidth) maxTxtWidth = self.fMaxTxtWidth;
        totalTxtHeight += self.fTotalTextHeight;
        
        charOffset = self.nCharPos;
    }
    
    _fMaxTxtWidth = maxTxtWidth;
    _fTotalTextHeight = totalTxtHeight;
    
    return ret;
}


@end


#define kPath @"path"
#define kStr @"str"
#define kPkgFile @"pkgfile"
#define kAttached @"attached"
#define kResult @"result"
#define kMaxLineW @"maxLineW"

@interface BackgroundLineBreaker()
@property (retain) NSMutableArray *tasks;

-(NSMutableDictionary*)getNextTask;
-(void)backgroundTaskThread;
-(void)doBackgroundTask:(NSMutableDictionary*)task;
-(void)backgroundFinished:(NSMutableDictionary*)task;
@end

@implementation BackgroundLineBreaker
@synthesize callback=_callback;
@synthesize lineBreaker=_lineBreaker;
@synthesize tasks=_tasks;

-(id)init {
	self = [super init];
	if(nil == self) return nil;
	
    _bRunning = NO;
    
    _bkPkgFileName = nil;
    _bkPkgFile = nil;
    _bkTaskCnt = 0;
    
	return self;
}
-(void)dealloc {
    
    self.callback = nil;
    
	[self cancelAll];
	
	[_lineBreaker release];
	[_tasks release];
	
	[super dealloc];
}

-(void)addTaskFile:(NSString*)path Attached:(id)attached Start:(BOOL)bStart {
	@synchronized(self) {
		if(nil == self.tasks) {
			_tasks = [[NSMutableArray alloc] initWithCapacity:10];
		}
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
							  path, kPath,
							  attached, kAttached, nil];
		
		[_tasks addObject:dict];
        _bkTaskCnt ++;
		[dict release];
		//NSBqsLog(@"add task: %@", dict);
		if(bStart) {
			[self start];
		}
	}
}
-(void)addTaskStr:(NSString*)str Attached:(id)attached Start:(BOOL)bStart {
    @synchronized(self) {
		if(nil == self.tasks) {
			_tasks = [[NSMutableArray alloc] initWithCapacity:10];
		}
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     str, kStr,
                                     attached, kAttached, nil];
		
		[_tasks addObject:dict];
        _bkTaskCnt ++;
		[dict release];
		//NSBqsLog(@"add task: %@", dict);
		if(bStart) {
			[self start];
		}
	}
}
-(void)addTaskPkgFile:(NSString*)pkgFileName File:(NSString*)fileName Attached:(id)attached Start:(BOOL)bStart {
    @synchronized(self) {
		if(nil == self.tasks) {
			_tasks = [[NSMutableArray alloc] initWithCapacity:10];
		}
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     pkgFileName, kPkgFile,
                                     fileName, kPath,
                                     attached, kAttached, nil];
		
		[_tasks addObject:dict];
        _bkTaskCnt ++;
		[dict release];
		//NSBqsLog(@"add task: %@", dict);
		if(bStart) {
			[self start];
		}
	}
    
}
-(void)start {
    @synchronized(self) {
        if(_bRunning) return;
        BqsLog(@"start ====================================================================");
        _bRunning = YES;
        [self performSelectorInBackground:@selector(backgroundTaskThread) withObject:nil];
    }
}
-(void)cancelAll {
	@synchronized(self) {
		if(nil != self.tasks) {
			[self.tasks removeAllObjects];
		}
        _bRunning = NO;
        _bkTaskCnt = 0;
	}
}
-(BOOL)hasTask {
	@synchronized(self) {
		return (_bkTaskCnt > 0);
	}
}
-(NSMutableDictionary*)getNextTask {
	@synchronized(self) {
		if(nil == self.tasks || [self.tasks count] < 1) return nil;
		
//        BqsLog(@"tasks count: %d", [self.tasks count]);
		NSMutableDictionary *ret = [[[self.tasks objectAtIndex:0] retain] autorelease];
		[self.tasks removeObjectAtIndex:0];
        
        NSString *pkgFileName = [ret objectForKey:kPkgFile];
        if(nil != pkgFileName && [pkgFileName length] > 0) {
            if(nil != _bkPkgFileName && ![_bkPkgFileName isEqualToString:pkgFileName]) {
                [_bkPkgFile release];
                _bkPkgFile = nil;
                
                [_bkPkgFileName release];
                _bkPkgFileName = nil;
            }
            if(nil == _bkPkgFileName) {
                _bkPkgFileName = [pkgFileName copy];
            }
            if(nil == _bkPkgFile) {
                _bkPkgFile = [[PackageFile alloc] initWithPath:_bkPkgFileName DelOldDataBefore:0 ReadOnly:YES];
            }
            
            NSString *path = [ret objectForKey:kPath];
            if(nil != path) {
                NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
                NSData *data = [_bkPkgFile readDataName:path];
                NSString *txt = [BqsUtils stringFromData:data Encoding:nil];
                if(nil != txt && [txt length] > 0) {
                    [ret removeObjectForKey:kPath];
                    [ret removeObjectForKey:kPkgFile];
                    [ret setObject:txt forKey:kStr];
                }
                [subPool drain];
            }
        }
        
        return ret;
		//BqsLog(@"befor trigger curTask: %@", self.curTask);
//		[self performSelectorInBackground:@selector(doBackgroundTask:) withObject:self.curTask];
        
	}
    return nil;
}

-(void)backgroundFinished:(NSMutableDictionary*)task {
    @synchronized(self) {
        if(_bkTaskCnt > 0) {
            _bkTaskCnt --;
        }
    }
	if(nil != self.callback) {
		[self.callback backgroundLineBreakerFinished:[task objectForKey:kResult] Attached:[task objectForKey:kAttached]];
	}
    
}

-(void)backgroundTaskThread {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [_bkPkgFileName release];
    [_bkPkgFile release];

    _bkPkgFileName = nil;
    _bkPkgFile = nil;
    
    while(YES) {
        NSMutableDictionary *task = nil;
        
        @synchronized(self) {
            task = [self getNextTask];
            
            if(nil == task) {
                _bRunning = NO;
            }
        }
        
        if(nil != task) {
            
            NSAutoreleasePool * spool = [[NSAutoreleasePool alloc] init];
            [self doBackgroundTask:task];
            [spool drain];
            
        } else {
            break;
        }
    }
    [_bkPkgFileName release];
    [_bkPkgFile release];
    
    BqsLog(@"end ====================================================================");
    [pool drain];
}

-(void)doBackgroundTask:(NSMutableDictionary*)task {
	//NSLog(@"doBackgroundTask: %@", task);
	
	NSString *path = [task objectForKey:kPath];
	NSString *txt = nil;
    
    if(nil == path || [path length] < 1) {
        txt = [[[task objectForKey:kStr] retain] autorelease];
    } else {
        NSData *dat = [[NSData alloc] initWithContentsOfFile:path];
        if(nil != dat) {
            txt = [BqsUtils stringFromData:dat Encoding:nil];
        }
        [dat release];
//        txt = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//        if(nil == txt) {
//            //NSBqsLog(@"loadBookData: error: %@, path=%@", error, path);
//            
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            if(nil != data) {
//                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//                txt = [[[NSString alloc] initWithData:data encoding:enc] autorelease];
//            }
//        }
    }
    LineBreaker *lb = [[self.lineBreaker retain]autorelease];
	NSData *result = [lb breakStringIntoPagesBinary:txt];
	if(nil != result) {
		[task setObject:result forKey:kResult];
        [task setObject:[NSNumber numberWithFloat:lb.fMaxTxtWidth] forKey:kMaxLineW];
	}
	
	//NSLog(@"done %@", path);
	[self performSelectorOnMainThread:@selector(backgroundFinished:) withObject:task waitUntilDone:NO];
	
}

@end
