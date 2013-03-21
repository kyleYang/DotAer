//
//  TextRender.m
//  iMobee
//
//  Created by ellison on 10-10-18.
//  Copyright 2010 borqs. All rights reserved.
//

#import "TextRender.h"
#import "BqsUtils.h"


@implementation TextRender
@synthesize font = _font;
@synthesize fontColor = _fontColor;
@synthesize lineGap = _lineGap;
@synthesize paraGap = _paraGap;

-(void)dealloc {
	[_font release];
	[_fontColor release];
	
	[super dealloc];
}


-(void)renderText:(NSString*)txt Lines:(NSArray*)lines Context:(CGContextRef)ctx Rc:(CGRect)rc{
	CGRect bounds = rc;

	UIGraphicsPushContext(ctx);
	
	CGContextSetFillColorWithColor(ctx, _fontColor.CGColor);
	
	float x = bounds.origin.x;
	float y = bounds.origin.y;
	float w = bounds.size.width;
	//float h = bounds.size.height;
	CGFloat fontSize = _font.pointSize;
	CGFloat actualFontSize = fontSize;
								
	for(NSValue *line in lines) {
		float gap = _lineGap;
		
		NSRange loc = [line rangeValue];
		NSString *str = [txt substringWithRange:loc];
		if('\n' == [str characterAtIndex:[str length]-1]) {
			gap = _paraGap;
			str = [str substringWithRange:NSMakeRange(0, [str length]-1)];
		}
		str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
		
//		CGSize sz = [str drawInRect:CGRectMake(x, y, w, h) 
//					  withFont:_font 
//					  lineBreakMode:UILineBreakModeClip 
//					  alignment:UITextAlignmentLeft];
		actualFontSize = fontSize;
		CGSize sz = [str drawAtPoint:CGPointMake(x, y) forWidth:w*2.0
					 withFont:_font 
					minFontSize:fontSize actualFontSize:&actualFontSize
				lineBreakMode:UILineBreakModeClip 
		   baselineAdjustment:UIBaselineAdjustmentNone];
		
		y += sz.height;
		y += gap;
		
	}
		
	UIGraphicsPopContext();
}

-(void)renderText:(NSString*)txt BinaryLines:(t_PAGE_LINES*)lines Context:(CGContextRef)ctx Rc:(CGRect)rc {
    [self renderText:txt BinaryLines:lines Context:ctx Rc:rc CenterText:NO];
}
-(void)renderText:(NSString*)txt BinaryLines:(t_PAGE_LINES*)lines Context:(CGContextRef)ctx Rc:(CGRect)rc CenterText:(BOOL)bCenter {
    if(NULL == lines || nil == txt || [txt length] < 1) {
        return;
    }
    
	CGRect bounds = rc;
	
	UIGraphicsPushContext(ctx);
	
	float x = bounds.origin.x;
	float y = bounds.origin.y;
	float w = bounds.size.width;
//	float h = bounds.size.height;
	CGFloat fontSize = _font.pointSize;
	CGFloat actualFontSize = fontSize;
	
		
	if(bCenter && lines->nMaxLineWidth < w) {
		x += (w - lines->nMaxLineWidth) / 2.0;
	}

//	CGContextSelectFont(ctx, [_font.fontName UTF8String], fontSize, kCGEncodingFontSpecific);
//	CGContextSetTextDrawingMode (ctx, kCGTextFill);
	//CGColorRef fc = _fontColor.CGColor;
	//CGContextSetRGBFillColor(ctx, fc.
	CGContextSetFillColorWithColor(ctx, _fontColor.CGColor);
	
	for(int i = 0; i < lines->nNumberOfLines; i ++) {
        t_LINE_POS *pL = &lines->lines[i];
        NSString *str = [txt substringWithRange:NSMakeRange(pL->nLocation, pL->nLength)];
        
		float gap = _lineGap;
        
		if('\n' == [str characterAtIndex:[str length]-1]) {
			gap = _paraGap;
			str = [str substringWithRange:NSMakeRange(0, [str length]-1)];
		}
        BOOL bEmptyLine = NO;
        if([str length] < 1) {
            str = @" ";
            bEmptyLine = YES;
        }
		        
        
        actualFontSize = fontSize;
        CGSize sz = [str drawAtPoint:CGPointMake(x, y) forWidth:w * 2.0
                            withFont:_font 
                         minFontSize:fontSize actualFontSize:&actualFontSize
                       lineBreakMode:UILineBreakModeClip 
                  baselineAdjustment:UIBaselineAdjustmentNone];
        

//        BqsLog(@"sz: %.1fx%.1f, w: %.1f, x:%.1f", sz.width, sz.height, w, x);

        if(!bEmptyLine) {
            y += sz.height;
        }
		y += gap;
	}
	    
	UIGraphicsPopContext();
}
@end
