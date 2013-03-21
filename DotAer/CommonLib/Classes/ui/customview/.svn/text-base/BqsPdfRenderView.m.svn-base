//
//  BqsPdfRenderView.m
//  iMobeeBook
//
//  Created by ellison on 11-9-5.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsPdfRenderView.h"
#import "BqsUtils.h"
#import <QuartzCore/QuartzCore.h>


@interface BqsPdfRenderView()
@property (nonatomic, retain) UIImage *imgNoZoom;
@property (nonatomic, retain) UIImageView *imgViewNoZoom;

-(UIImage*)drawNoZoomImg;
@end


@implementation BqsPdfRenderView
@synthesize fZoomScale = _fZoomScale;
@synthesize imgNoZoom;
@synthesize imgViewNoZoom;

+ (Class)layerClass {
	return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    _pdfDocument = nil;
    _pageId = -1;
    _fZoomScale = 1.0;
    
    self.opaque = NO;
    
    // Setup tiled layer.
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    tiledLayer.levelsOfDetail = 3;
    tiledLayer.levelsOfDetailBias = 3;
    tiledLayer.tileSize = CGSizeMake(512, 512);
    
    return self;
}
- (void)dealloc
{
    @synchronized(self) {
        _pdfDocument = nil;
        _pageId = -1;
        self.imgNoZoom = nil;
        self.imgViewNoZoom = nil;
    }
    
    [super dealloc];
}



-(void)layoutSubviews {
    [super layoutSubviews];
    
    @synchronized(self) {
        self.contentScaleFactor = 1.0;
        
        if(nil != _pdfDocument && !CGSizeEqualToSize(self.imgNoZoom.size, self.bounds.size)) {
            
            self.imgNoZoom = [self drawNoZoomImg];
            self.imgViewNoZoom.image = self.imgNoZoom;
        }
    }
    
    [self setNeedsDisplay];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    @synchronized(self) {
    //    CGAffineTransform currentCTM = CGContextGetCTM(context);  
    //    BqsLog(@"drawLayer. pageId: %d, scale: %.1f, zooming: %.1f", _pageId, currentCTM.a, self.fZoomScale);
        
        CGRect rect = self.bounds;
        
        CGContextTranslateCTM(context, 0.0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        
        if(nil != self.imgNoZoom && self.fZoomScale <= 1.0001) {
    //        BqsLog(@"Draw Img");
            CGContextDrawImage(context, rect, [self.imgNoZoom CGImage]);
            return;
        }
        
        if(nil == _pdfDocument){
            BqsLog(@"_pdfDocument is nil");
            return;
        }


        CGPDFPageRef page = CGPDFDocumentGetPage(_pdfDocument, _pageId + 1);
        
        if(nil == page) {
            BqsLog(@"Can't get page for pageid: %d", _pageId);
            return;
        }
        
        CGContextSaveGState (context);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetAllowsFontSmoothing(context, YES);
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
        
        
        CGRect rcMedia = CGPDFPageGetBoxRect (page, kCGPDFMediaBox);
        
        CGAffineTransform m = [BqsUtils aspectFitFromRc:rcMedia ToRc:rect];
        CGContextConcatCTM(context, m);
        
        CGContextDrawPDFPage (context, page);
        
        CGContextRestoreGState (context);
    }
    
}
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//
- (void)drawRect:(CGRect)rect
{
}


-(void)setFZoomScale:(float)afZoomScale {
    _fZoomScale = afZoomScale;
    
    if(_fZoomScale <= 1.0001) {
        if(nil == self.imgViewNoZoom) {
            self.imgViewNoZoom = [[[UIImageView alloc] initWithFrame: self.bounds] autorelease];
            self.imgViewNoZoom.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        
        self.imgViewNoZoom.image = self.imgNoZoom;
        self.imgViewNoZoom.frame = self.bounds;
        if(![self.subviews containsObject:self.imgViewNoZoom]) {
            [self addSubview:self.imgViewNoZoom];
        }
    } else {
        [self.imgViewNoZoom removeFromSuperview];
        self.imgViewNoZoom.image = nil;
    }
    
    [self setNeedsDisplay];
}

-(void)setPdf:(CGPDFDocumentRef)pdf Page:(int)pageId {
    
    @synchronized(self) {
        if(nil != pdf) {
            int totalPage = CGPDFDocumentGetNumberOfPages(pdf);

            if(pageId >= totalPage || pageId < 0) {
                BqsLog(@"Invalid page id: %d, total: %d", pageId, totalPage);
                _pdfDocument = nil;
                _pageId = -1;
                return;
            }
        }
        _pdfDocument = pdf;
        _pageId = pageId;
        
        if(nil != _pdfDocument) {
            self.imgNoZoom = [self drawNoZoomImg];
        } else {
            self.imgNoZoom = nil;
        }
        
        self.imgViewNoZoom.image = self.imgNoZoom;
    }
    
    [self setNeedsDisplay];
}

-(UIImage*)drawNoZoomImg {
    
    CGPDFPageRef page = CGPDFDocumentGetPage(_pdfDocument, _pageId + 1);
    
    if(nil == page) {
        BqsLog(@"Can't get page for pageid: %d", _pageId);
        return nil;
    }
    
    CGRect rect = self.bounds;

//    // determine the size of the PDF page
//    CGRect rcMedia = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
//    CGFloat scaleFactor = MIN(rect.size.width/MAX(rcMedia.size.width, 1), rect.size.height/MAX(rcMedia.size.height, 1));
//    rcMedia.size = CGSizeMake(rcMedia.size.width*scaleFactor, rcMedia.size.height*scaleFactor);
    
    // Create a low res image representation of the PDF page to display before the TiledPDFView
    // renders its content.
	if([BqsUtils getOsVer] >= 4.0f) {
		UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(rect.size);
	}

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // First fill the background with white.
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,rect);
    
    CGContextSaveGState(context);
    // Flip the context so that the PDF page is rendered
    // right side up.
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Scale the context so that the PDF page is rendered 
    // at the correct size for the zoom level.
    CGRect rcMedia = CGPDFPageGetBoxRect (page, kCGPDFMediaBox);
    
    CGAffineTransform m = [BqsUtils aspectFitFromRc:rcMedia ToRc:rect];
    CGContextConcatCTM(context, m);

//    CGContextScaleCTM(context, scaleFactor,scaleFactor);	
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return backgroundImage;
}

@end
