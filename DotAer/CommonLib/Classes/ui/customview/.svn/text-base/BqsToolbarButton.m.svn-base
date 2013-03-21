//
//  BqsToolbarButton.m
//  iMobeeBook
//
//  Created by ellison on 11-8-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsToolbarButton.h"
#import "BqsUtils.h"
#import "BqsColorAdditions.h"

#define TT_ROUNDED -1
#define RD(_RADIUS) (_RADIUS == TT_ROUNDED ? round(fh/2) : _RADIUS)

#define kDefaultFontSize 12

@implementation BqsToolbarButton
@synthesize tintColor;
@synthesize textFont;
@synthesize text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.textFont = [UIFont boldSystemFontOfSize:kDefaultFontSize];
    return self;
}
- (void)dealloc
{
    self.tintColor = nil;
    self.textFont = nil;
    self.text = nil;
    
    [super dealloc];
}
- (UIColor*)toolbarButtonColorWithTintColor:(UIColor*)color forState:(UIControlState)state {
//    BqsLog(@"state: %d, value: %.1f, saturation: %.1f", state, color.value, color.saturation);

    if (state & UIControlStateHighlighted || state & UIControlStateSelected) {
        if (color.value < 0.2) {
            return [color addHue:0 saturation:0 value:0.2];
            
        } else if (color.saturation > 0.3) {
            return [color multiplyHue:1 saturation:1 value:0.4];
            
        } else {
            return [color multiplyHue:1 saturation:2.3 value:0.64];
        }
        
    } else {
        if (color.saturation < 0.5) {
            return [color multiplyHue:1 saturation:1.6 value:0.97];
            
        } else {
            UIColor *c = [color multiplyHue:1 saturation:1 value:1];
//            UIColor *c = [color multiplyHue:1 saturation:1.25 value:0.75];
//            const CGFloat* rgba = CGColorGetComponents(c.CGColor);
//            CGFloat r = rgba[0];
//            CGFloat g = rgba[1];
//            CGFloat b = rgba[2];
//            CGFloat a = rgba[3];
//            BqsLog(@"r:%f,g:%f,b:%f,a:%.1f", r,g,b,a);
//            
//            {
//                UIColor *c = [color multiplyHue:1 saturation:.8 value:1.33];
//                const CGFloat* rgba = CGColorGetComponents(c.CGColor);
//                CGFloat r = rgba[0];
//                CGFloat g = rgba[1];
//                CGFloat b = rgba[2];
//                CGFloat a = rgba[3];
//                BqsLog(@"r:%f,g:%f,b:%f,a:%.1f", r,g,b,a);
//            }
            
            return c;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)toolbarButtonTextColorForState:(UIControlState)state {
    if (state & UIControlStateDisabled) {
        return [UIColor colorWithWhite:1 alpha:0.4];
        
    } else {
        return [UIColor whiteColor];
    }
}

//CGRect TTRectInset(CGRect rect, UIEdgeInsets insets) {
//    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
//                      rect.size.width - (insets.left + insets.right),
//                      rect.size.height - (insets.top + insets.bottom));
//}

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

- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations
                                 count:(int)count {
    CGFloat* components = malloc(sizeof(CGFloat)*4*count);
    for (int i = 0; i < count; ++i) {
        UIColor* color = colors[i];
        size_t n = CGColorGetNumberOfComponents(color.CGColor);
        const CGFloat* rgba = CGColorGetComponents(color.CGColor);
        if (n == 2) {
            components[i*4] = rgba[0];
            components[i*4+1] = rgba[0];
            components[i*4+2] = rgba[0];
            components[i*4+3] = rgba[1];
            
        } else if (n == 4) {
            components[i*4] = rgba[0];
            components[i*4+1] = rgba[1];
            components[i*4+2] = rgba[2];
            components[i*4+3] = rgba[3];
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
    free(components);
    
    return gradient;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGGradientRef)newGradientWithColors:(UIColor**)colors count:(int)count {
    return [self newGradientWithColors:colors locations:nil count:count];
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

#define kRadius 4.5
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeOfText:(NSString*)txt withFont:(UIFont*)font size:(CGSize)size NumberOfLines: (int) lines LineBreakMode:(UILineBreakMode)lbMode{
    if (lines == 1) {
        return [txt sizeWithFont:font];
        
    } else {
        CGSize maxSize = CGSizeMake(size.width, CGFLOAT_MAX);
        CGSize textSize = [txt sizeWithFont:font constrainedToSize:maxSize
                               lineBreakMode:lbMode];
        if (lines) {
            CGFloat maxHeight = [BqsUtils getFontHeight:font] * lines;
            if (textSize.height > maxHeight) {
                textSize.height = maxHeight;
            }
        }
        return textSize;
    }
}

- (CGRect)rectForText:(NSString*)txt forSize:(CGSize)size withFont:(UIFont*)font TextAligment:(UITextAlignment)align VerAligment:(UIControlContentVerticalAlignment)valgn  NumberOfLines: (int) lines LineBreakMode:(UILineBreakMode)lbMode {
    CGRect rect = CGRectZero;
    if (align == UITextAlignmentLeft
        && valgn == UIControlContentVerticalAlignmentTop) {
        rect.size = size;
        
    } else {
        CGSize textSize = [self sizeOfText:txt withFont:font size:size NumberOfLines:lines LineBreakMode:lbMode];
        
        if (size.width < textSize.width) {
            size.width = textSize.width;
        }
        
        rect.size = textSize;
        
        if (align == UITextAlignmentCenter) {
            rect.origin.x = round(size.width/2 - textSize.width/2);
            
        } else if (align == UITextAlignmentRight) {
            rect.origin.x = size.width - textSize.width;
        }
        
        if (valgn == UIControlContentVerticalAlignmentCenter) {
            rect.origin.y = round(size.height/2 - textSize.height/2);
            
        } else if (valgn == UIControlContentVerticalAlignmentBottom) {
            rect.origin.y = size.height - textSize.height;
        }
    }
    return rect;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rectDraw
{
    CGRect frm = rectDraw;
    CGRect contentFrm = frm;
    
    UIColor* stateTintColor = [self toolbarButtonColorWithTintColor:tintColor forState: _bPressed ? UIControlStateHighlighted : UIControlStateNormal];
    UIColor* stateTextColor = [self toolbarButtonTextColorForState: _bPressed ? UIControlStateHighlighted : UIControlStateNormal];

    
    UIEdgeInsets _inset = UIEdgeInsetsMake(2, 0, 1, 0);
    frm = CGRectMake(frm.origin.x+_inset.left, frm.origin.y+_inset.top,
                     frm.size.width - (_inset.left + _inset.right),
                     frm.size.height - (_inset.top + _inset.bottom));
    ///////////shadow style
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        {
            float _blur = 0;
            CGSize _offset = CGSizeMake(0, 1);
            UIColor *_color = RGBA(0xff, 0xff, 0xff, .18);

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

            contentFrm = CGRectMake(contentFrm.origin.x+inset.left, contentFrm.origin.y+inset.top,
                             contentFrm.size.width - (inset.left + inset.right),
                             contentFrm.size.height - (inset.top + inset.bottom));
            
            
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
//        [self.next draw:context];
        // reflectivefill
        {
            {
                UIColor *_color = stateTintColor;
                BOOL _withBottomHighlight = NO;
                
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGRect rc = CGRectInset(frm, 1, 1);
                
                CGContextSaveGState(ctx);
                [self addShapeToPath:rc];
                CGContextClip(ctx);
                
                // Draw the background color
                [_color setFill];
                CGContextFillRect(ctx, rc);
                
                // The highlights are drawn using an overlayed, semi-transparent gradient.
                // The values here are absolutely arbitrary. They were nabbed by inspecting the colors of
                // the "Delete Contact" button in the Contacts app.
                UIColor* topStartHighlight = [UIColor colorWithWhite:1.0 alpha:0.5];
                UIColor* topEndHighlight = [UIColor colorWithWhite:1.0 alpha:0.09];
                UIColor* clearColor = [UIColor colorWithWhite:1.0 alpha:0.0];
                
                UIColor* botEndHighlight;
                if ( _withBottomHighlight ) {
                    botEndHighlight = [UIColor colorWithWhite:1.0 alpha:0.27];
                    
                } else {
                    botEndHighlight = clearColor;
                }
                
                UIColor* colors[] = {
                    topStartHighlight, topEndHighlight,
                    clearColor,
                    clearColor, botEndHighlight};
                CGFloat locations[] = {0, 0.5, 0.5, 0.6, 1.0};
                
                CGGradientRef gradient = [self newGradientWithColors:colors locations:locations count:5];
                CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rc.origin.x, rc.origin.y),
                                            CGPointMake(rc.origin.x, rc.origin.y+rc.size.height), 0);
                CGGradientRelease(gradient);
                
                CGContextRestoreGState(ctx);
            }
//            return [self.next draw:context];
            ///TTBevelBorderStyle
            {
                {
                    UIColor *_highlight = [stateTintColor multiplyHue:1 saturation:0.9 value:0.7];
                    UIColor *_shadow = [stateTintColor multiplyHue:1 saturation:0.5 value:0.6];
                    float _width = 1;
                    int _lightSource = 270;
                    
                    
                    CGRect strokeRect = CGRectInset(frm, _width/2, _width/2);
                    [self openPath:strokeRect];
                    
                    CGContextRef ctx = UIGraphicsGetCurrentContext();
                    CGContextSetLineWidth(ctx, _width);
                    
                    UIColor* topColor = _lightSource >= 0 && _lightSource <= 180 ? _highlight : _shadow;
                    UIColor* leftColor = _lightSource >= 90 && _lightSource <= 270
                    ? _highlight : _shadow;
                    UIColor* bottomColor = (_lightSource >= 180 && _lightSource <= 360) || _lightSource == 0
                    ? _highlight : _shadow;
                    UIColor* rightColor = (_lightSource >= 270 && _lightSource <= 360)
                    || (_lightSource >= 0 && _lightSource <= 90)
                    ? _highlight : _shadow;
                    
                    CGRect rect = frm;
                    
                    [self addTopEdgeToPath:strokeRect lightSource:_lightSource];
                    if (topColor) {
                        [topColor setStroke];
                        
                        rect.origin.y += _width;
                        rect.size.height -= _width;
                        
                    } else {
                        [[UIColor clearColor] setStroke];
                    }
                    CGContextStrokePath(ctx);
                    
                    [self addRightEdgeToPath:strokeRect lightSource:_lightSource];
                    if (rightColor) {
                        [rightColor setStroke];
                        
                        rect.size.width -= _width;
                        
                    } else {
                        [[UIColor clearColor] setStroke];
                    }
                    CGContextStrokePath(ctx);
                    
                    [self addBottomEdgeToPath:strokeRect lightSource:_lightSource];
                    if (bottomColor) {
                        [bottomColor setStroke];
                        
                        rect.size.height -= _width;
                        
                    } else {
                        [[UIColor clearColor] setStroke];
                    }
                    CGContextStrokePath(ctx);
                    
                    [self addLeftEdgeToPath:strokeRect lightSource:_lightSource];
                    if (leftColor) {
                        [leftColor setStroke];
                        
                        rect.origin.x += _width;
                        rect.size.width -= _width;
                        
                    } else {
                        [[UIColor clearColor] setStroke];
                    }
                    CGContextStrokePath(ctx);
                    
                    CGContextRestoreGState(ctx);
                    
                    frm = rect;
                }
//                return [self.next draw:context];
                {
                    CGRect rect = frm;
                    UIEdgeInsets _inset = UIEdgeInsetsMake(0, -1, 0, -1);
                    frm = CGRectMake(rect.origin.x+_inset.left, rect.origin.y+_inset.top,
                                               rect.size.width - (_inset.left + _inset.right),
                                               rect.size.height - (_inset.top + _inset.bottom));
                    // TTBevelBorderStyle
                    {
                        
                        UIColor *_highlight = nil;
                        UIColor *_shadow = RGBA(0, 0, 0, .15);
                        float _width = 1;
                        int _lightSource = 270;
                        
                        CGRect strokeRect = CGRectInset(frm, _width/2, _width/2);
                        [self openPath:strokeRect];
                        
                        CGContextRef ctx = UIGraphicsGetCurrentContext();
                        CGContextSetLineWidth(ctx, _width);
                        
                        UIColor* topColor = _lightSource >= 0 && _lightSource <= 180 ? _highlight : _shadow;
                        UIColor* leftColor = _lightSource >= 90 && _lightSource <= 270
                        ? _highlight : _shadow;
                        UIColor* bottomColor = (_lightSource >= 180 && _lightSource <= 360) || _lightSource == 0
                        ? _highlight : _shadow;
                        UIColor* rightColor = (_lightSource >= 270 && _lightSource <= 360)
                        || (_lightSource >= 0 && _lightSource <= 90)
                        ? _highlight : _shadow;
                        
                        CGRect rect = frm;
                        
                        [self addTopEdgeToPath:strokeRect lightSource:_lightSource];
                        if (topColor) {
                            [topColor setStroke];
                            
                            rect.origin.y += _width;
                            rect.size.height -= _width;
                            
                        } else {
                            [[UIColor clearColor] setStroke];
                        }
                        CGContextStrokePath(ctx);
                        
                        [self addRightEdgeToPath:strokeRect lightSource:_lightSource];
                        if (rightColor) {
                            [rightColor setStroke];
                            
                            rect.size.width -= _width;
                            
                        } else {
                            [[UIColor clearColor] setStroke];
                        }
                        CGContextStrokePath(ctx);
                        
                        [self addBottomEdgeToPath:strokeRect lightSource:_lightSource];
                        if (bottomColor) {
                            [bottomColor setStroke];
                            
                            rect.size.height -= _width;
                            
                        } else {
                            [[UIColor clearColor] setStroke];
                        }
                        CGContextStrokePath(ctx);
                        
                        [self addLeftEdgeToPath:strokeRect lightSource:_lightSource];
                        if (leftColor) {
                            [leftColor setStroke];
                            
                            rect.origin.x += _width;
                            rect.size.width -= _width;
                            
                        } else {
                            [[UIColor clearColor] setStroke];
                        }
                        CGContextStrokePath(ctx);
                        
                        CGContextRestoreGState(ctx);
                        
                        frm = rect;
//                        return [self.next draw:context];
                        {
                            UIEdgeInsets _padding = UIEdgeInsetsMake(8, 8, 8, 8);
                            contentFrm = CGRectMake(contentFrm.origin.x+_padding.left, contentFrm.origin.y+_padding.top,
                                                    contentFrm.size.width - (_padding.left + _padding.right),
                                                    contentFrm.size.height - (_padding.top + _padding.bottom));

                            {
                                UIFont*   _font = self.textFont;
                                UIColor*  _color = stateTextColor;
                                
                                UIColor*  _shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
                                CGSize    _shadowOffset = CGSizeMake(0, 1);
                                
                                CGFloat   _minimumFontSize = 0;
                                NSInteger _numberOfLines = 1;
                                
                                UITextAlignment                   _textAlignment = UITextAlignmentCenter;
                                UIControlContentVerticalAlignment _verticalAlignment = UIControlContentVerticalAlignmentCenter;
                                
                                UILineBreakMode _lineBreakMode = UILineBreakModeTailTruncation;
                                /////

                                CGContextRef ctx = UIGraphicsGetCurrentContext();
                                CGContextSaveGState(ctx);
                                
                                UIFont* font = _font;
                                
                                if (nil == font) {
                                    font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                                }
                                
                                if (_shadowColor) {
                                    CGSize offset = CGSizeMake(_shadowOffset.width, -_shadowOffset.height);
                                    CGContextSetShadowWithColor(ctx, offset, 0, _shadowColor.CGColor);
                                }
                                
                                if (_color) {
                                    [_color setFill];
                                }
                                
                                CGRect rect = contentFrm;
                                
                                if (_numberOfLines == 1) {
                                    CGRect titleRect = [self rectForText:self.text forSize:rect.size withFont:font TextAligment:_textAlignment VerAligment:_verticalAlignment NumberOfLines:_numberOfLines LineBreakMode:_lineBreakMode];
                                    titleRect.size = [text drawAtPoint:
                                                      CGPointMake(floor(titleRect.origin.x+rect.origin.x),
                                                                  floor(titleRect.origin.y+rect.origin.y))
                                                              forWidth:rect.size.width withFont:font
                                                           minFontSize:_minimumFontSize ? _minimumFontSize : font.pointSize
                                                        actualFontSize:nil lineBreakMode:_lineBreakMode
                                                    baselineAdjustment:UIBaselineAdjustmentAlignCenters];
                                    contentFrm = titleRect;
                                    
                                } else {
                                    CGRect titleRect = [self rectForText:self.text forSize:rect.size withFont:font TextAligment:_textAlignment VerAligment:_verticalAlignment NumberOfLines:_numberOfLines LineBreakMode:_lineBreakMode];
                                    titleRect = CGRectOffset(titleRect, floor(rect.origin.x), floor(rect.origin.y));
                                    rect.size = [text drawInRect:titleRect withFont:font lineBreakMode:_lineBreakMode
                                                       alignment:_textAlignment];
                                    contentFrm = rect;
                                }
                                
                                CGContextRestoreGState(ctx);

                            }
                            
                        }


                    }

                }


            }

        }
        CGContextEndTransparencyLayer(ctx);
        
        CGContextRestoreGState(ctx);
    }
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}
-(void)sizeToFit {
    UIFont *fnt = self.textFont;
    if(nil == fnt) fnt = [UIFont systemFontOfSize:kDefaultFontSize];
    
    CGSize textSize = CGSizeZero;
    if(nil != self.text && [self.text length] > 0) textSize = [self.text sizeWithFont:textFont];
    
    CGRect rcFrm = self.frame;
    
    int paddingHori = 10;
    int paddingVer = 9;
    
    rcFrm.size.width = MAX(50, textSize.width + 2*(paddingHori));
    rcFrm.size.height = textSize.height + 2*(paddingVer);
    
    self.frame = rcFrm;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
    //	UITouch *touch = [event.allTouches anyObject];
    
    _bPressed = YES;
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _bPressed = NO;
    [self setNeedsDisplay];    
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _bPressed = NO;
    [self setNeedsDisplay];
    [super touchesCancelled:touches withEvent:event];
}

@end
