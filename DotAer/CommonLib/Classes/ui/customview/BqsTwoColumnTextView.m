//
//  BqsTwoColumnTextView.m
//  iMobeeBook
//
//  Created by ellison on 11-9-3.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsTwoColumnTextView.h"
#import "BqsUtils.h"
#import "LineBreaker.h"
#import "TextRender.h"

@interface BqsTwoColumnTextView()
@property (nonatomic, assign) CGSize szLineBreak;
@property (nonatomic, retain) NSData *lineDataColumnOne;
@property (nonatomic, retain) NSData *lineDataColumnTwo;
@property (nonatomic, assign) int nColumnCount;
@property (nonatomic, assign) float fColumnWidth;
@end

@implementation BqsTwoColumnTextView
@synthesize strContent = _strContent;
@synthesize fPaddingHori;
@synthesize fPaddingVer;
@synthesize fMinColumnWidth;
@synthesize fColumnGap;
@synthesize fLineGap;
@synthesize fParaGap;
@synthesize txtFont;
@synthesize txtColor;


@synthesize szLineBreak;
@synthesize lineDataColumnOne;
@synthesize lineDataColumnTwo;
@synthesize nColumnCount;
@synthesize fColumnWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.opaque = NO;
    
    self.txtFont = [UIFont systemFontOfSize:16];
    self.txtColor = [UIColor blackColor];
    
    self.fPaddingHori = 0;
    self.fPaddingVer = 0;
    self.fMinColumnWidth = 350;
    self.fColumnGap = 28;
    self.fLineGap = 1;
    self.fPaddingVer = 4;
    
    self.nColumnCount = 1;
    
    return self;
}
- (void)dealloc
{
    [_strContent release];
    self.txtFont = nil;
    self.txtColor = nil;
    
    self.lineDataColumnOne = nil;
    self.lineDataColumnTwo = nil;
    [super dealloc];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(nil == self.strContent || [self.strContent length] < 1) return;

    // check re-break text
    if(!CGSizeEqualToSize(self.szLineBreak, rect.size)) {
        self.szLineBreak = rect.size;
        
        // calc column
        float w = round(CGRectGetWidth(rect)-(self.fPaddingHori*2));
        if(w >= self.fMinColumnWidth * 2 + self.fColumnGap) {
            self.nColumnCount = 2;
            self.fColumnWidth = floor((w - self.fColumnGap) / 2.0);
        }
        else {
            self.nColumnCount = 1;
            self.fColumnWidth = w;
        }
        
        self.lineDataColumnOne = nil;
        self.lineDataColumnTwo = nil;
        
        // re-do line break
        LineBreaker *lb = [[LineBreaker alloc] init];
        
        CGSize txtSz = CGSizeMake(self.fColumnWidth, CGRectGetHeight(rect)-(self.fPaddingVer*2));
        lb.size = txtSz;
        lb.font = self.txtFont;
        lb.lineGap = self.fLineGap;
        lb.paraGap = self.fParaGap;
        
        self.lineDataColumnOne = [lb breakStringIntoLinesBinary:self.strContent StartCharPos:0 InArea:txtSz];
        if(nil == self.lineDataColumnOne) {
            BqsLog(@"failed to break text: %@", self.strContent);
            [lb release];
            return;
        }
        if(self.nColumnCount > 1) {
            t_PAGE_LINES *pLines = (t_PAGE_LINES *)[self.lineDataColumnOne bytes];
            t_LINE_POS *pLastLine = &pLines->lines[pLines->nNumberOfLines - 1];
            int lastCharPos = pLastLine->nLocation + pLastLine->nLength;
            
            self.lineDataColumnTwo = [lb breakStringIntoLinesBinary:self.strContent StartCharPos:lastCharPos InArea:txtSz];
        }
        
        [lb release];        
    }
    
    // draw text
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rc = CGRectInset(rect, self.fPaddingHori, self.fPaddingVer);
    
    TextRender *tr = [[TextRender alloc] init];
    tr.font = self.txtFont;
    tr.fontColor = self.txtColor;
    tr.lineGap = self.fLineGap;
    tr.paraGap = self.fParaGap;
    
    if(self.nColumnCount > 1) {
        CGRect rcD = rc;
        rcD.size.width = self.fColumnWidth;
        
//        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//        CGContextFillRect(context, rcD);

        
        [tr renderText:self.strContent BinaryLines:(t_PAGE_LINES*)[self.lineDataColumnOne bytes] Context:context Rc:rcD CenterText:NO];
        
        if(nil != self.lineDataColumnTwo) {
            rcD.origin.x += self.fColumnWidth + self.fColumnGap;

//            CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//            CGContextFillRect(context, rcD);

            [tr renderText:self.strContent BinaryLines:(t_PAGE_LINES*)[self.lineDataColumnTwo bytes] Context:context Rc:rcD CenterText:NO];
        }
        
    } else {
        [tr renderText:self.strContent BinaryLines:(t_PAGE_LINES*)[self.lineDataColumnOne bytes] Context:context Rc:rc CenterText:NO];
    }
    
    [tr release];
    
}


-(void)setStrContent:(NSString *)aStrContent {
    [_strContent release];
    _strContent = [aStrContent retain];
    
    self.szLineBreak = CGSizeZero;
    self.lineDataColumnOne = nil;
    self.lineDataColumnTwo = nil;

    [self setNeedsDisplay];
}

@end
