//
//  BqsTextView.m
//  iMobeeNews
//
//  Created by ellison on 11-6-13.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsTextView.h"
#import "TextRender.h"
#import "BqsUtils.h"
#import "LineBreaker.h"

@interface BqsTextView()
@property (nonatomic, retain) NSData *dataPages;// self calc pages
@end

@implementation BqsTextView
@synthesize strContent = _strContent;
@synthesize pPageLines = _pPageLines;
@synthesize fMarginHori;
@synthesize fMarginVer;
@synthesize fLineGap;
@synthesize fParaGap;
@synthesize txtFont;
@synthesize txtColor;
@synthesize bAdjTextHoriCenter;
@synthesize callback;
@synthesize attached;

@synthesize dataPages;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pPageLines = NULL;
        self.fMarginVer = 0;
        self.fMarginHori = 10.0;
        self.fLineGap = 1;
        self.fParaGap = 10.0;
        self.txtFont = [UIFont systemFontOfSize:17.0];
        self.txtColor = [UIColor blackColor];
        
        self.bAdjTextHoriCenter = NO;
        _arrLineInfo = nil;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.strContent = nil;
    self.txtFont = nil;
    self.txtColor = nil;
    [_arrLineInfo release];
    self.dataPages = nil;
    [super dealloc];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
	UITouch *touch = [event.allTouches anyObject];
	touchBeganPoint = [touch locationInView:self];
    _touch = touch;
}	
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	
    for (UITouch* touch in touches) {
        if (touch == _touch) {
            _touch = nil;
            CGPoint touchPoint = [touch locationInView:self];
            float dist = [BqsUtils distancePoint1:touchPoint Point2:touchBeganPoint];
            if(dist < 20.0 && CGRectContainsPoint(self.bounds, touchPoint)) {
                
                if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsTextView:didTapped:)]) {
                    [self.callback bqsTextView:self didTapped:touchPoint];
                }
            } else {
                BqsLog(@"dist: %.1f", dist);
            }
            break;
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    BqsLog(@"drawRect: (%.1f, %.1f, %.1f, %.1f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    if([_strContent length] < 1) {
        BqsLog(@"_pParaLines: %x, _strContent.length: %d", _pPageLines, [_strContent length]);
        return;
    }
    if(NULL == _pPageLines) {
        [self calcTextLines];
        
        if(NULL == _pPageLines) {
            BqsLog(@"_pParaLines: %x, _strContent.length: %d", _pPageLines, [_strContent length]);
            return;
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	float x = self.fMarginHori;
	float y = self.fMarginVer;
//    float dx = rect.origin.x;
    float dy = rect.origin.y;
	float dw = rect.size.width;
    float dh = rect.size.height;
    
    UIFont *font = self.txtFont;
	CGFloat fontSize = self.txtFont.pointSize;
	CGFloat actualFontSize = fontSize;
//    CGFloat lineGap = self.fLineGap;
//    CGFloat paraGap = self.fParaGap;
    int cnt = _pPageLines->nNumberOfLines;
        
    //BqsLog(@"txtLineW: %.1f, dw: %.1f, totalH: %.1f", _fMaxTxtLineWidth, dw, _fTotalLineHeight);
    
    if(self.bAdjTextHoriCenter) {
        float dtxtW = dw - 2 * self.fMarginHori;
        if(dtxtW > _pPageLines->nMaxLineWidth) {
            x += (dtxtW - _pPageLines->nMaxLineWidth) / 2.0;
        }
    }
//	CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    CGContextFillRect(context, CGRectInset(rect, self.fMarginHori, self.fMarginVer));
	
	CGContextSetFillColorWithColor(context, self.txtColor.CGColor);
	

    float lineHeight = 0.0f;
    
	for(int i = 0; i < cnt; i ++) {
        
        float gap = self.fLineGap;
        
        if((y + lineHeight >= dy && y + lineHeight <= dy + dh) ||
           (y >= dy && y < dy + dh)) {
            
            NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
            
            // with in draw rect
            t_LINE_POS *lPos = &_pPageLines->lines[i];
            
            NSString *str = [_strContent substringWithRange:NSMakeRange(lPos->nLocation, lPos->nLength)];
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            
            if([str length] == 1 &&'\n' == [str characterAtIndex:0]) {
                str = @" \n";
            }

            if('\n' == [str characterAtIndex:[str length]-1]) {
                str = [str substringWithRange:NSMakeRange(0, [str length]-1)];
                gap = self.fParaGap;
            }
                        

            actualFontSize = fontSize;
            CGSize sz = [str drawAtPoint:CGPointMake(x, y) forWidth:dw*2.0
                    withFont:font 
                    minFontSize:fontSize actualFontSize:&actualFontSize
                    lineBreakMode:UILineBreakModeClip 
                    baselineAdjustment:UIBaselineAdjustmentNone];
            [subPool drain];
            
            lineHeight = sz.height;
        }
        
		y += lineHeight;
        y += gap;
	}

//    BqsLog(@"Draw end. txtLineW: %.1f, dw: %.1f, totalH: %.1f", _fMaxTxtLineWidth, dw, _fTotalLineHeight);
}

-(float)getPageHeight {
    if(nil == _pPageLines) {
        [self calcTextLines];
    }
    
    if(nil == _pPageLines) return 0;
    
    return _pPageLines->nHeight + 2 * self.fMarginVer;
}

-(void)calcTextLines {
    LineBreaker *lb = [[LineBreaker alloc] init];
	
	CGSize txtSz = CGSizeMake(CGRectGetWidth(self.bounds)-(self.fMarginHori*2), 10240.0);
	lb.size = txtSz;
	lb.font = self.txtFont;
	lb.lineGap = self.fLineGap;
	lb.paraGap = self.fParaGap;
	
	NSData *data = [lb breakStringIntoLinesBinary:self.strContent StartCharPos:0 InArea:txtSz];
	[lb release];

    if(nil == data) {
        BqsLog(@"failed to break text: %@", self.strContent);
        return;
    }
    
    _pPageLines = (t_PAGE_LINES*)[data bytes];
    self.dataPages = data;
    
    return;
}

@end
