//
//  MarkupParser.m
//  CoreTextDemo
//
//  Created by kyle yang on 11-12-23.
//  Copyright (c) 2011年 深圳微普特. All rights reserved.
//

#import "MarkupParser.h"

#import <libkern/OSAtomic.h>


#define kHTML @"These are <font color=\"red\">red<font color=\"black\"> and\
<font color=\"blue\">blue <font color=\"black\">words."
#define kDefultFontSize 17.0f

@implementation MarkupParser
@synthesize font, color, strokeColor, strokeWidth,fontSize,fontAdd = _fontAdd;
@synthesize setFont = _setFont;//外部改变默认字体
@synthesize setColor = _setColor;
@synthesize setFontSize = _setFontSize;
@synthesize linkColor,setlinkColor = _setLinkColor,hyperLink = _hyperLink;
@synthesize images,linkeres;
@synthesize underlineLinks = _underlineLinks;
@synthesize setUnderlineLinks = _setUnderlineLinks;

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.font = kDefaultFont;
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.fontSize = kDefultFontSize;
        _setFontSize = 0.0f;
        self.fontAdd = 0.0f;
        _hyperType =  FALSE;
        _branch = FALSE;
        self.linkColor = [UIColor blueColor];
        self.underlineLinks = YES;
        self.images = [NSMutableArray array];
        self.linkeres = [NSMutableArray array];
    }
    
    return self;
}

- (void)setSetFont:(NSString *)asetFont
{
    [_setFont release];
    _setFont = [asetFont retain];
    self.font = _setFont;
}

- (void)setSetColor:(UIColor *)aColor
{
    [_setColor release];
    _setColor = [aColor retain];
    self.color = _setColor;
}

- (void)setSetFontSize:(CGFloat)aFontSize
{
    _setFontSize = aFontSize;
    if (_setFontSize == 0.0f) {
        return;
    }
    self.fontSize = _setFontSize;
}

- (void)setSetlinkColor:(UIColor *)aColor
{
    [_setColor release];
    _setColor = [aColor retain];
    self.linkColor = _setColor;
}

- (void)setSetUnderlineLinks:(BOOL)aUnderlineLinks
{
    _underlineLinks = aUnderlineLinks;
    self.underlineLinks = _underlineLinks;
}

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:kCTHeight] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:kCTWidth] floatValue];
}

/***edit by kyle for color  begine**********************/
// Return a static cached device RGB colorspace
static inline CGColorSpaceRef RGBColorSpace(void) {
    static CGColorSpaceRef cachedRGBColorSpace = NULL;
    if (cachedRGBColorSpace == NULL) {
        CGColorSpaceRef tmp = CGColorSpaceCreateDeviceRGB();
        if (tmp != NULL && !OSAtomicCompareAndSwapPtrBarrier(NULL, tmp, (void * volatile *)&cachedRGBColorSpace))
            CGColorSpaceRelease(tmp);
    }
    return cachedRGBColorSpace;
}

// Return a static cached device gray colorspace
static inline CGColorSpaceRef GrayColorSpace(void) {
    static CGColorSpaceRef cachedGrayColorSpace = NULL;
    if (cachedGrayColorSpace == NULL) {
        CGColorSpaceRef tmp = CGColorSpaceCreateDeviceGray();
        if (tmp != NULL && !OSAtomicCompareAndSwapPtrBarrier(NULL, tmp, (void * volatile *)&cachedGrayColorSpace))
            CGColorSpaceRelease(tmp);
    }
    return cachedGrayColorSpace;
}

// Return a static cached clearcolor
static inline CGColorRef ClearColor(void) {
    static CGColorRef cachedClearColor = NULL;
    
    if (cachedClearColor == NULL) {
        CGFloat components[2] = {0.0, 0.0};
        CGColorRef tmp = CGColorCreate(GrayColorSpace(), components); //return clear color
        if (tmp != NULL && !OSAtomicCompareAndSwapPtrBarrier(NULL, tmp, (void * volatile *)&cachedClearColor))
            CGColorRelease(tmp);
    }
    
    return cachedClearColor;
}

// Create CGColorRef from RGB(A) array, or clearcolor if no RGB provided
static CGColorRef CreateColorFromRGBComponentsArray(NSArray* calibratedRGB) {
	if (calibratedRGB) {
		CGFloat components[4] = {
			[(NSNumber*)[calibratedRGB objectAtIndex:0] floatValue],
			[(NSNumber*)[calibratedRGB objectAtIndex:1] floatValue],
			[(NSNumber*)[calibratedRGB objectAtIndex:2] floatValue],
			[(NSNumber*)[calibratedRGB objectAtIndex:3] floatValue]
		};
		return  CGColorCreate(RGBColorSpace(), components);
	}
	
	CGFloat components[2] = {0.0, 0.0};
    return CGColorCreate(GrayColorSpace(), components); //return clear color
    
}


static UIColor* creatColorWith16(NSString *hexColor)//16进制颜色转换  形式是 ＃ff0000 需要严格控制格式
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    if (hexColor.length != 7) { //当不是 ＃ff0000 形式时候
        return  [UIColor blackColor];
    }
    
    range.location =1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}

/***edit by kyle for color  end**********************/



-(NSMutableAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    //NSLog(@"markup %@",markup);
    NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
    
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil]; //2
    NSArray* chunks = [regex matchesInString:markup options:0
                                       range:NSMakeRange(0, [markup length])];
    [regex release];
    
    for (NSTextCheckingResult* b in chunks)
    {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1

        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 (self.fontSize + self.fontAdd), NULL);
       
        NSDictionary* attrs;
        NSString *linkerStr;
        
        if (_branch) {
            [string appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n" attributes:nil] autorelease]]; //p分行
        }
        
        if (!_hyperType) {
            attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)self.color.CGColor, kCTForegroundColorAttributeName,
                                   (id)fontRef, kCTFontAttributeName,
                                   (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                                   (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,nil];
            [string appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        }else{
            linkerStr = [parts objectAtIndex:0];  //case for hyperlinke
            [self.linkeres addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      self.hyperLink,kCTHyperlink,
                                      [NSNumber numberWithInt: [string length]], kCTLocation,
                                      [NSNumber numberWithInt:[linkerStr length]],kCTLength,nil
                                      ]];
            
            attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                     (id)self.linkColor.CGColor, kCTForegroundColorAttributeName,
                     (id)fontRef, kCTFontAttributeName,
                     [NSNumber numberWithInt:self.underlineLinks],kCTUnderlineStyleAttributeName,
                     (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                     (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,nil];
             [string appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        }
        //apply the current text style //2
       
        
        

       
            
        CFRelease(fontRef);
        
        _branch = FALSE;
        
        if (_setFont && _setFont.length>1) { //根据外部设置的默认值
            self.font = _setFont;
        }else{
             self.font = kDefaultFont;
        }
        if (_setColor) {
            self.color = _setColor;
        }else{
            self.color = [UIColor blackColor]; //  用完后初始化
        }
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        if (_setFontSize != 0.0f) {
            self.fontSize = _setFontSize;
        }else{
             self.fontSize = kDefultFontSize;//对font Size 初始化
        }
        _hyperType = FALSE;
        
        if ([parts count]>1) 
        {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            if ([tag isEqualToString:kCTPend]) {
              
                _branch = TRUE;
                
            }
            if ([tag isEqualToString:kCTBrend]) {
                
                _branch = TRUE;
                
            }
            if ([tag hasPrefix:kCTFont]) { //don't change text color,if want to change the text font and color CTFont @"font"
                //stroke color
                NSRegularExpression* scolorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=[\'\"])\\w+" options:0 error:NULL] autorelease];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    if ([[tag substringWithRange:match.range] isEqualToString:@"none"]) {
                        self.strokeWidth = 0.0;
                    } else {
                        self.strokeWidth = -2.0;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                }];
                
                //color
                NSRegularExpression* colorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=color=[\'\"])([^\'\"]+)" options:0 error:NULL] autorelease];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    NSString *colorString = [tag substringWithRange:match.range]; //addby kyle yang for set color format like color = "0.1,0.2,0.3,1.0"];
                    NSArray *colorArray = [colorString componentsSeparatedByString:@","];
                    if ([colorString hasPrefix:@"#"]) { //color = "#ff0000"
                        self.color = creatColorWith16(colorString);
    
                    }else if(colorArray.count > 1){
                        NSArray *rgbaArray = nil;
                        if (colorArray.count != 4) { //判断解析后不是r g b a 形式
                            if (colorArray.count == 2) {
                                rgbaArray = [NSArray arrayWithObjects:[colorArray objectAtIndex:0], [colorArray objectAtIndex:1],@"1.0",@"1.0",nil];
                            
                            }else if(colorArray.count == 3){
                                rgbaArray = [NSArray arrayWithObjects:[colorArray objectAtIndex:0], [colorArray objectAtIndex:1],[colorArray objectAtIndex:2],@"1.0",nil];
                            }
                        }else{
                            rgbaArray = [NSArray arrayWithObjects:[colorArray objectAtIndex:0], [colorArray objectAtIndex:1],[colorArray objectAtIndex:2],[colorArray objectAtIndex:3],nil];
                        }
                        CGColorRef colorRef = CreateColorFromRGBComponentsArray(rgbaArray);
                        self.color = [UIColor colorWithCGColor:colorRef];   //added end
                        CGColorRelease(colorRef);
                    }else{
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", colorString]);
                        self.color = [UIColor performSelector:colorSel];
                    }
                }];
                
                //face
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=face=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.font = [tag substringWithRange:match.range];
                }];
                
                NSRegularExpression* fontSizeRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=size=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [fontSizeRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.fontSize = [[tag substringWithRange: match.range] floatValue];
                }];
            } //end of font parsing
            
            if ([tag rangeOfString:@"img"].location != NSNotFound) {
                
                __block NSNumber* width = [NSNumber numberWithInt:310];
                __block NSNumber* height = [NSNumber numberWithInt:200];
                __block NSString* fileName = @"";
                __block NSString* type = kCTImgDefaultType;
                
                __block int widthInt = 310;
                __block int heithInt = 200;
                
                if (_branch) {
                    [string appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n" attributes:nil] autorelease]]; //p分行
                }
                
    
                //width
                NSRegularExpression* widthRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=width=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    widthInt = [[tag substringWithRange: match.range] intValue];
                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
                }];
                
                //height
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=height=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    heithInt = [[tag substringWithRange: match.range] intValue];
                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
                }];
                
                NSRegularExpression* PxRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=-width: )[^[px]]+" options:0 error:NULL] autorelease];
                [PxRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    widthInt = [[tag substringWithRange: match.range] intValue];
                    if(widthInt == 0) {
                        widthInt = 32;
                        heithInt = 32;
                    }
                    width = [NSNumber numberWithInt: widthInt];
                    height = [NSNumber numberWithInt: heithInt];
                }];

                
                NSRegularExpression* widthPxRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<= width: )[^[px]]+" options:0 error:NULL] autorelease];
                [widthPxRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    widthInt = [[tag substringWithRange: match.range] intValue];
                    if(widthInt == 0) widthInt = 32;
                    width = [NSNumber numberWithInt: widthInt];
                }];
                
                //height
                NSRegularExpression* facePxRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<= height: )[^[px]]+" options:0 error:NULL] autorelease];
                [facePxRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    heithInt = [[tag substringWithRange: match.range] intValue];
                    if(heithInt == 0) heithInt = 32;
                    height = [NSNumber numberWithInt: heithInt];
                }];

                
                
                //image
                NSRegularExpression* srcRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=src=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                    NSLog(@"fileName = %@",fileName);
                }];
                
                //type
                NSRegularExpression* typeRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=imgtype=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [typeRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    type = [tag substringWithRange: match.range];
                }];
                
                int tempH = 0;
                if(widthInt > 200){
                    tempH = 310*heithInt/widthInt;
                    width = [NSNumber numberWithInt:310];
                    height = [NSNumber numberWithInt:tempH];
                    
//                    [string appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n" attributes:nil] autorelease]];
                }
                
                int tempW = 0;
                if (tempH > 460) {
                    tempH = 460;
                    tempW = 460*widthInt/tempH;
                    width = [NSNumber numberWithInt:tempW];
                    height = [NSNumber numberWithInt:460];
                }
                
                
            
                
                //add the image for drawing
                [self.images addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  width, kCTWidth,
                  height, kCTHeight,
                  fileName, kCTFileName,
                  type, kCTType,
                  [NSNumber numberWithInt: [string length]], kCTLocation,
                  nil]
                 ];
                
                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                          width, kCTWidth,
                                          height, kCTHeight,
                                          nil] retain];
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //set the delegate
                                                        (id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                        nil];
                
                //add a space to the text so that it can call the delegate
                [string appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate] autorelease]];
            }
            if([tag rangeOfString:@"href"].location != NSNotFound){ //added by keyle yang for hyperlink
                _hyperType = TRUE; // the hyperlinke tag
                NSRegularExpression* hyperRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=href=[\'\"])[^[\'\"]]+" options:0 error:NULL] autorelease];
                [hyperRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.hyperLink = [tag substringWithRange: match.range];
                }];
                                               
            }

        }
        
    }
    //NSLog(@"string %@",string.string);
    return (NSMutableAttributedString*)string;
}


-(void)dealloc
{
    //[font release];
    self.font = nil;
    //[color release];
    self.color = nil;
    //[strokeColor release];
    self.strokeColor = nil;
    //[images release];
    self.images = nil;
    self.linkeres = nil;
    self.hyperLink = nil;
    [_setFont release];
    [_setColor release];
    [_setLinkColor release];
    self.linkColor = nil;
    [super dealloc];
}

@end
