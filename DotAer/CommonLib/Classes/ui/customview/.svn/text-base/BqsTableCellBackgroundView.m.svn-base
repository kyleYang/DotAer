//
//  BqsTableCellBackgroundView.m
//  TVGuide
//
//  Created by ellison on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BqsTableCellBackgroundView.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight);

@implementation BqsTableCellBackgroundView
@synthesize borderColor, fillColor, position;

- (BOOL) isOpaque {
    return NO;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [fillColor CGColor]);
    CGContextSetStrokeColorWithColor(c, [borderColor CGColor]);
    CGContextSetLineWidth(c, 1);
    
    float ROUND_SIZE = 8;
    
    if (position == BqsTableCellBackgroundViewPositionTop) {
        
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny + 1;
        
        maxx = maxx - 1;
        maxy = maxy ;
        
        CGContextMoveToPoint(c, minx, maxy);
        CGContextAddArcToPoint(c, minx, miny, midx, miny, ROUND_SIZE);
        CGContextAddArcToPoint(c, maxx, miny, maxx, maxy, ROUND_SIZE);
        CGContextAddLineToPoint(c, maxx, maxy);
        
        // Close the path
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);                
        return;
    } else if (position == BqsTableCellBackgroundViewPositionBottom) {
        
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny ;
        
        maxx = maxx - 1;
        maxy = maxy - 1;
        
        CGContextMoveToPoint(c, minx, miny);
        CGContextAddArcToPoint(c, minx, maxy, midx, maxy, ROUND_SIZE);
        CGContextAddArcToPoint(c, maxx, maxy, maxx, miny, ROUND_SIZE);
        CGContextAddLineToPoint(c, maxx, miny);
        // Close the path
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);        
        return;
    } else if (position == BqsTableCellBackgroundViewPositionMiddle) {
        CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny ;
        
        maxx = maxx - 1;
        maxy = maxy ;
        
        CGContextMoveToPoint(c, minx, miny);
        CGContextAddLineToPoint(c, maxx, miny);
        CGContextAddLineToPoint(c, maxx, maxy);
        CGContextAddLineToPoint(c, minx, maxy);
        
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);        
        return;
    } else if (position == BqsTableCellBackgroundViewPositionSingle)
    {
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
        minx = minx + 1;
        miny = miny + 1;
        
        maxx = maxx - 1;
        maxy = maxy - 1;
        
        CGContextMoveToPoint(c, minx, midy);
        CGContextAddArcToPoint(c, minx, miny, midx, miny, ROUND_SIZE);
        CGContextAddArcToPoint(c, maxx, miny, maxx, midy, ROUND_SIZE);
        CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, ROUND_SIZE);
        CGContextAddArcToPoint(c, minx, maxy, minx, midy, ROUND_SIZE);
        
        // Close the path
        CGContextClosePath(c);
        // Fill & stroke the path
        CGContextDrawPath(c, kCGPathFillStroke);                
        return;         
    }
}


- (void)dealloc {
    [borderColor release];
    [fillColor release];
    [super dealloc];
}


@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)

{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);// 2
    
    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6
    
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12
    
    CGContextRestoreGState(context);// 13
}