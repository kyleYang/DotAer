//
//  BqsCloseButton.m
//  iMobeeNews
//
//  Created by ellison on 11-8-10.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsCloseButton.h"
#import "Env.h"

#define TT_ROUNDED -1
#define RD(_RADIUS) (_RADIUS == TT_ROUNDED ? round(fh/2) : _RADIUS)


#define kBtnWidth 27
#define kBtnHeight 29

@interface BqsCloseButton()
@property (nonatomic, retain) UIImage *imgClose;

@end

@implementation BqsCloseButton
@synthesize imgClose;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return  nil;
    
    self.imgClose = [[Env sharedEnv] cacheImage:@"close_button.png"];
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)dealloc
{
    self.imgClose = nil;
    [super dealloc];
}


-(void)sizeToFit {
    CGRect frm = self.frame;
    frm.size.width = kBtnWidth;
    frm.size.height = kBtnHeight;
    self.frame = frm;
}


- (void)openPath:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextBeginPath(context);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)closePath:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


-(void)addRoundRectShapeToPath:(CGRect)rect Radius:(CGFloat)radius {
    [self openPath:rect];
    
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, fw, floor(fh/2));
    CGContextAddArcToPoint(context, fw, fh, floor(fw/2), fh, RD(radius));
    CGContextAddArcToPoint(context, 0, fh, 0, floor(fh/2), RD(radius));
    CGContextAddArcToPoint(context, 0, 0, floor(fw/2), 0, RD(radius));
    CGContextAddArcToPoint(context, fw, 0, fw, floor(fh/2), RD(radius));
    
    [self closePath:rect];
}

#define kRadius TT_ROUNDED
-(void)addShapeToPath:(CGRect)rc {
    [self addRoundRectShapeToPath:rc Radius:kRadius];
}
- (void)addTopEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;
    
    if (lightSource >= 0 && lightSource <= 90) {
        CGContextMoveToPoint(context, RD(kRadius), 0);
        
    } else {
        CGContextMoveToPoint(context, 0, RD(kRadius));
        CGContextAddArcToPoint(context, 0, 0, RD(kRadius), 0, RD(kRadius));
    }
    CGContextAddArcToPoint(context, fw, 0, fw, RD(kRadius), RD(kRadius));
    CGContextAddLineToPoint(context, fw, RD(kRadius));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addRightEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;
    
    CGContextMoveToPoint(context, fw, RD(kRadius));
    CGContextAddArcToPoint(context, fw, fh, fw-RD(kRadius), fh, RD(kRadius));
    CGContextAddLineToPoint(context, fw-RD(kRadius), fh);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addBottomEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;
    
    CGContextMoveToPoint(context, fw-RD(kRadius), fh);
    CGContextAddLineToPoint(context, RD(kRadius), fh);
    CGContextAddArcToPoint(context, 0, fh, 0, fh-RD(kRadius), RD(kRadius));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addLeftEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat fh = rect.size.height;
    
    CGContextMoveToPoint(context, 0, fh-RD(kRadius));
    CGContextAddLineToPoint(context, 0, RD(kRadius));
    
    if (lightSource >= 0 && lightSource <= 90) {
        CGContextAddArcToPoint(context, 0, 0, RD(kRadius), 0, RD(kRadius));
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rectDraw
{
    CGRect frm = rectDraw;
    
    
    UIEdgeInsets _inset = UIEdgeInsetsMake(1, 1, 1, 1);
    frm = CGRectMake(frm.origin.x+_inset.left, frm.origin.y+_inset.top,
                     frm.size.width - (_inset.left + _inset.right),
                     frm.size.height - (_inset.top + _inset.bottom));
    ///////////shadow style
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        {
            float _blur = 2;
            CGSize _offset = CGSizeMake(0, 3);
            UIColor *_color = RGBA(0, 0, 0, .3);
            
            CGFloat blurSize = round(_blur / 2);
            UIEdgeInsets inset = UIEdgeInsetsMake(blurSize, blurSize, blurSize, blurSize);
            if (_offset.width < 0) {
                inset.left += fabs(_offset.width) + blurSize*2;
                inset.right -= blurSize;
                
            } else if (_offset.width > 0) {
                inset.right += fabs(_offset.width) + blurSize*2;
                inset.left -= blurSize;
            }
            if (_offset.height < 0) {
                inset.top += fabs(_offset.height) + blurSize*2;
                inset.bottom -= blurSize;
                
            } else if (_offset.height > 0) {
                inset.bottom += fabs(_offset.height) + blurSize*2;
                inset.top -= blurSize;
            }
            
            frm = CGRectMake(frm.origin.x+inset.left, frm.origin.y+inset.top,
                             frm.size.width - (inset.left + inset.right),
                             frm.size.height - (inset.top + inset.bottom));

            
            CGContextSaveGState(ctx);
            
            // Due to a bug in OS versions 3.2 and 4.0, the shadow appears upside-down. It pains me to
            // write this, but a lot of research has failed to turn up a way to detect the flipped shadow
            // programmatically
            float shadowYOffset = -_offset.height;
            NSString *osVersion = [UIDevice currentDevice].systemVersion;
            if ([osVersion floatValue] >= 3.2) {
                shadowYOffset = _offset.height;
            }
            
            [self addShapeToPath:frm];
            CGContextSetShadowWithColor(ctx, CGSizeMake(_offset.width, shadowYOffset), _blur,
                                        _color.CGColor);
            CGContextBeginTransparencyLayer(ctx, nil);
        }
        // solidfill
        {
            {
                UIColor *_color = [UIColor blackColor];
                
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGRect rc = CGRectInset(frm, 0, 0);
                
                CGContextSaveGState(ctx);
                [self addShapeToPath:rc];
                CGContextClip(ctx);
                
                // Draw the background color
                [_color setFill];
                CGContextFillRect(ctx, rc);
                                
                CGContextRestoreGState(ctx);
            }
            //            return [self.next draw:context];
            //        [self.next draw:context];
            {
                UIEdgeInsets _inset = UIEdgeInsetsMake(-1, -1, -1, -1);
                frm = CGRectMake(frm.origin.x+_inset.left, frm.origin.y+_inset.top,
                                 frm.size.width - (_inset.left + _inset.right),
                                 frm.size.height - (_inset.top + _inset.bottom));
            }
            ///SolidBorderStyle
            {
                {
                    UIColor *_color = [UIColor whiteColor];
                    CGFloat _width = 2;
                    
                    CGContextSaveGState(ctx);
                    
                    CGRect strokeRect = CGRectInset(frm, _width/2, _width/2);
                    [self addShapeToPath:strokeRect];
                    
                    [_color setStroke];
                    CGContextSetLineWidth(ctx, _width);
                    CGContextStrokePath(ctx);
                    
                    CGContextRestoreGState(ctx);
                    
//                    frm = CGRectInset(frm, _width, _width);
                }
                //                return [self.next draw:context];
                
                // draw pic
                {
//                    BqsLog(@"frm: %.1f, %.1f, %1.fx%.1f", frm.origin.x, frm.origin.y, frm.size.width, frm.size.height);
                    if(nil == self.imgClose) self.imgClose = [[Env sharedEnv] cacheImage:@"close_button.png"];
                    CGRect frmImg = CGRectMake(floor(CGRectGetMidX(frm) - self.imgClose.size.width/2), floor(CGRectGetMidY(frm)-self.imgClose.size.height/2), self.imgClose.size.width, self.imgClose.size.height);
                    [self.imgClose drawInRect:frmImg];
                }
                
                
            }
            
            if(_bPressed) {
                // Draw the background color
                
                CGContextSaveGState(ctx);
                [self addShapeToPath:frm];
                CGContextClip(ctx);
                
                CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
                CGContextSetFillColorWithColor(ctx, RGBA(0.0, 0.0, 0.0, .2).CGColor);
                CGContextFillRect(ctx, frm);
                
                CGContextRestoreGState(ctx);
            }
        }
        CGContextEndTransparencyLayer(ctx);
        
        CGContextRestoreGState(ctx);

    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    _bPressed = YES;
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _bPressed = NO;
    [self setNeedsDisplay];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    _bPressed = NO;
    [self setNeedsDisplay];
}

@end
