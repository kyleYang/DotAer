//
//  TextRender.h
//  iMobee
//
//  Created by ellison on 10-10-18.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineBreaker.h"

@interface TextRender : NSObject {
	UIFont *_font;
	UIColor *_fontColor;
	CGFloat _lineGap;
	CGFloat _paraGap;
}
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, assign) CGFloat lineGap;
@property (nonatomic, assign) CGFloat paraGap;


// NSArray -> NSValue(NSRange)
-(void)renderText:(NSString*)txt Lines:(NSArray*)lines Context:(CGContextRef)ctx Rc:(CGRect)rc;

-(void)renderText:(NSString*)txt BinaryLines:(t_PAGE_LINES*)lines Context:(CGContextRef)ctx Rc:(CGRect)rc;
-(void)renderText:(NSString*)txt BinaryLines:(t_PAGE_LINES*)lines Context:(CGContextRef)ctx Rc:(CGRect)rc CenterText:(BOOL)bCenter;
@end
