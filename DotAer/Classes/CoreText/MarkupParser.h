//
//  MarkupParser.h
//  CoreTextDemo
//
//  Created by kyle yang on 11-12-23.
//  Copyright (c) 2011年 深圳微普特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#define kDefaultFont @"HelveticaNeueUI"
#define kCTFont @"font_dota"
#define kCTP @"p"
#define kCTPend @"/p>"
#define kCTBrend @"br/>"
#define kCTFileName @"fileName"
#define kCTWidth @"width"
#define kCTHeight @"height"
#define kCTHyperlink @"hyperlink"
#define kCTLocation @"location"
#define kCTLength @"length"
#define kCTImgDefaultType @"url"
#define kCTType @"type"

@interface MarkupParser : NSObject
{
    NSString *font;
    UIColor *color;
    UIColor *strokeColor;
    float stokeWidth;
    float fontSize;//字体大小
    float _fontAdd;//字体增加大小，用于逐步变化字体大小时候用到
    CGFloat _setFontSize;
    NSString  *_setFont;
    BOOL _hyperType;
    BOOL _branch;
    UIColor *_setColor; //设置默认字体颜色
    UIColor *linkColor; //设置超链接显示形式
    UIColor *_setLinkColor;
    NSString *_hyperLink;
    NSMutableArray *images;
    NSMutableArray *linkeres; // 存放连接的地方
}

@property (retain, nonatomic) NSString* font;
@property (assign, nonatomic) CGFloat setFontSize;
@property (nonatomic, retain) NSString *setFont;
@property (nonatomic, retain) UIColor *setColor;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;
@property (assign, readwrite) float fontSize;
@property (assign, readwrite) float fontAdd;

@property (nonatomic, retain) UIColor *linkColor;
@property (nonatomic, retain) UIColor *setlinkColor;
@property (nonatomic, copy) NSString *hyperLink;
@property (nonatomic, assign) BOOL underlineLinks;
@property (nonatomic, assign) BOOL setUnderlineLinks;


@property (retain, nonatomic) NSMutableArray* images;
@property (retain, nonatomic) NSMutableArray* linkeres;


-(NSMutableAttributedString*)attrStringFromMarkup:(NSString*)html;

@end
