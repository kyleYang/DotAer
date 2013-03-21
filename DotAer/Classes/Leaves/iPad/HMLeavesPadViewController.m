//
//  HMLeavesViewController.m
//  CoreTextDemo
//
//  Created by Kyle on 12-8-27.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "HMLeavesPadViewController.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+Attributes.h"
#import "HMImageViewController.h"
#import "RegexKitLite.h"
#import "MarkupParser.h"
#import "AsyncImageView.h"
#import "Utilities.h"

@interface HMLeavesPadViewController ()<AsyncImageViewGuestDelegate>
{
    NSMutableArray *_images;
    NSMutableArray *_linkes;
    NSUInteger _totalPageNum;
}

@property (nonatomic, retain) NSString *transmitText; // 存放转换好的数据
@property (nonatomic, retain) NSMutableArray *frames; //存放解析好的分页数据
@property (nonatomic, retain) NSMutableArray *attributes; //存放解析好的分页数据
@property (nonatomic, retain) NSMutableAttributedString *attString;
@property (retain, nonatomic) NSMutableArray* images;
@property (nonatomic, retain) NSMutableArray *linkes;
@property (nonatomic, retain) NSMutableDictionary *asyImgViews; // 存放imaviews;


@end

@implementation HMLeavesPadViewController

@synthesize offsetX = _offsetX,offsetY = _offsetY,bottomX = _bottomX,bottomY = _bottomY;
@synthesize characterSpacing = _characterSpacing , linesSpacing = _linesSpacing , paragraphSpacing = _paragraphSpacing;
@synthesize fontAdd = _fontAdd;
@synthesize bgColor = _bgColor, characterColor = _characterColor,characterSize = _characterSize, characterFont = _characterFont, linkerColor = _linkerColor;
@synthesize content = _content;
@synthesize attString = _attString;
@synthesize images = _images;
@synthesize linkes = _linkes;
@synthesize frames;
@synthesize attributes;
@synthesize transmitText;
@synthesize asyImgViews;
@synthesize imgDic = _imgDic;
@synthesize paraseImges;
@synthesize paraImagesDictory;  //跟单页有区别，单页dictionary里面每项是个arry，双页每项是包涵左右两页array的一个array


- (void)dealloc
{
    [_bgColor release]; _bgColor= nil;
    [_characterColor release]; _characterColor = nil;
    [_characterFont release]; _characterFont = nil;
    [_linkerColor release]; _linkerColor = nil;
    
    NSArray*keys = [self.asyImgViews allKeys];
    
    if ([keys count]) {
        for (id key in keys) {
            NSArray *imgViewAry = [self.asyImgViews objectForKey:key];
            if ([imgViewAry count]) {
                for (AsyncImageView *img in imgViewAry) {
                    img.delegate = nil;
                    [img release];
                    
                }
            }
        }
        
    }
    self.asyImgViews = nil;
    
    self.imgDic = nil;
    self.paraseImges = nil;
    self.paraImagesDictory = nil;
    self.attributes = nil;
    [_content release]; _content = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self parameterInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)] autorelease];
    
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 50, 50)];
    add.backgroundColor = [UIColor redColor];
    [add setTitle:@"+" forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addFont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    [add release];
    
    UIButton *plus = [[UIButton alloc] initWithFrame:CGRectMake(200, 50, 50, 50)];
    plus.backgroundColor = [UIColor redColor];
    [plus setTitle:@"-" forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(plusFont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plus];
    [plus release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addFont:(id)sender
{
    
    self.fontAdd = self.fontAdd + 0.5;
}

- (void)plusFont:(id)sender
{
    
    self.fontAdd = self.fontAdd - 0.5;
}


- (void)parameterInit
{
    _offsetX = 3.0f;
    _offsetY = 3.0f;
    _bottomX = 3.0f;
    _bottomY = 3.0f;
    
    _characterSpacing = 1.0f;
    _linesSpacing = 3.0f;
    _paragraphSpacing = 7.0f;
    
    _fontAdd = 0.0f;
    
    _bgColor = [[UIColor whiteColor] retain];
    _characterColor = [[UIColor blackColor] retain];
    _linkerColor = [[UIColor blueColor] retain];
    _characterFont = [@"Arial" retain];
    _characterSize = 17.0f;
    
    self.asyImgViews = [NSMutableDictionary dictionary];
    self.imgDic = [NSMutableDictionary dictionary];
    self.paraImagesDictory = [NSMutableDictionary dictionary];
    
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.view.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.view.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;
    
}


#pragma makr property setting
- (void)setContent:(NSString *)acontent
{
    if (!acontent || acontent.length == 0) {
        return;
    }
    
    
    
    [_content release];
    _content = [acontent copy];
    NSArray*keys = [self.asyImgViews allKeys];
    
    if ([keys count]) {
        for (id key in keys) {
            NSArray *imgViewAry = [self.asyImgViews objectForKey:key];
            if ([imgViewAry count]) {
                for (AsyncImageView *img in imgViewAry) {
                    img.delegate = nil;
                    [img release];
                    
                }
            }
        }
        self.asyImgViews = nil;
        self.asyImgViews = [NSMutableDictionary dictionary];
    }
    
    
    
    self.transmitText = [self transformString:_content];
    
    [self stringParaseAgain];
    //    [self.attString setFont:_characterFont];
    
    [self buildFrames];
    
    [self.leavesView reloadData];
    
}

- (void)setOffsetX:(CGFloat)aoffsetX
{
    _offsetX = aoffsetX;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.view.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.view.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;
    
    [self propertySetAgain];
}

- (void)setOffsetY:(CGFloat)aoffsetY
{
    _offsetY = aoffsetY;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.view.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.view.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;
    
    [self propertySetAgain];
}

- (void)setBottomX:(CGFloat)abottomX
{
    _bottomX = abottomX;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.view.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.view.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;
    
    [self propertySetAgain];
}

- (void)setBottomY:(CGFloat)abottomY
{
    _bottomY = abottomY;
    
    if (!_content || _content.length == 0) {
        return;
    }
    CGRect labFrame = CGRectMake(_offsetX, _offsetX, CGRectGetWidth(self.view.bounds)-_offsetX-_bottomX, CGRectGetHeight(self.view.bounds)-_offsetY-_bottomY);
    self.leavesView.frame = labFrame;
    [self propertySetAgain];
}

- (void)setCharacterSpacing:(CGFloat)acharacterSpacing
{
    _characterSpacing = acharacterSpacing;
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}

- (void)setLinesSpacing:(CGFloat)alinesSpacing
{
    _linesSpacing = alinesSpacing;
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}

- (void)setParagraphSpacing:(CGFloat)aparagraphSpacing
{
    _paragraphSpacing = aparagraphSpacing;
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}

- (void)setFontAdd:(CGFloat)afontAdd
{
    _fontAdd = afontAdd;
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}

- (void)setBgColor:(UIColor *)abgColor
{
    [_bgColor release];
    _bgColor = [abgColor retain];
    if (!_content || _content.length == 0) {
        return;
    }
    self.leavesView.backgroundColor = _bgColor;
}


- (void)setCharacterColor:(UIColor *)acharacterColor
{
    [_characterColor release];
    _characterColor = [acharacterColor retain];
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}

- (void)setCharacterSize:(CGFloat)aSize
{
    _characterSize = aSize;
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}

- (void)setCharacterFont:(NSString *)acharacterFont
{
    [_characterFont release];
    _characterFont = [acharacterFont copy];
    if (!_content || _content.length == 0) {
        return;
    }
    [self stringParaseAgain];
    [self propertySetAgain];
}





- (void)buildFrames //创建分页信息
{
    
    self.frames = [NSMutableArray array];
    self.attributes = [NSMutableArray array];
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.view.bounds, _offsetX*2, _offsetY);
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attString);
    CFRelease(path);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    while (textPos < [self.attString length]) { //4
        CGRect colRect;
        
        colRect = CGRectMake(_offsetX, _offsetY , (textFrame.size.width-_offsetX-_bottomX)/2, textFrame.size.height-_offsetY-_bottomY);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        //        [self attachImagesWithFrame:frame inColumnView: content];
        NSRange subRange = NSMakeRange(frameRange.location, frameRange.length);
        NSAttributedString *subString = [self.attString  attributedSubstringFromRange:subRange];
        
        [self.attributes addObject:subString];
        [self.frames addObject: (id)frame];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    _totalPageNum =  columnIndex/2+(columnIndex%2);
    
}


- (void)stringParaseAgain
{
    if (!_content || _content.length == 0) {
        return;
    }
    self.attString = nil;
    self.images = nil;
    
    
    MarkupParser* p = [[[MarkupParser alloc] init] autorelease];
    p.fontAdd = _fontAdd;
    p.setColor = _characterColor;
    p.setFont = _characterFont;
    p.setFontSize = _characterSize;
    
    self.attString = [p attrStringFromMarkup:self.transmitText]; //解析数据
    self.images = p.images;
    self.linkes = p.linkeres; //链接
    
    self.attString = [NSMutableAttributedString attributedStringWithAttributedString:self.attString];
    
    [self ParagraphStyleAttributeSetting:self.attString];
    
    
}


- (void)propertySetAgain
{
    CTFrameRef curframe = [self.leavesView getCurentFrame];
    CFRange curRange = CTFrameGetVisibleStringRange(curframe); //得到没有变化时候的字体的frame
    
    for (id temp in self.frames) {
        CFRelease((CTFrameRef)temp);
        temp = NULL;
    }
    
    self.frames = nil;
    self.attributes = nil;
    
    [self buildFrames];
    
    int curPage = 0;
    for (id temp in self.frames) {  //重新计算原来的页面在新的参数下属于哪一页
        CTFrameRef frame = (CTFrameRef)temp;
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        if (curRange.location+curRange.length/2>=frameRange.location && curRange.location+curRange.length/2<frameRange.location+frameRange.length) {
            break;
        }
        curPage++;
    }
    if (curPage >= self.attributes.count) {
        curPage = self.attributes.count - 1;
    }
    
    NSUInteger newPageIndex = curPage/2+(curPage%2);
    [self.leavesView flush];
    [self.leavesView setCurrentPageIndex:newPageIndex];
    
}






- (void)ParagraphStyleAttributeSetting:(NSMutableAttributedString *)attributeSting // 设置文章间隔距离
{
    /*****设置字间距离*********/
    long number = _characterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributeSting addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0, [attributeSting length])];
    CFRelease(num);
    
    /*****设置对齐方式*********/
    CTParagraphStyleSetting alignmentStyle;
    CTTextAlignment alignment = kCTLeftTextAlignment;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    
    /*****设置行间距离*********/
    CGFloat lineSpace = _linesSpacing;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
    
    
    //设置文本段间距
    CGFloat paragraphSpacing = _paragraphSpacing;
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    paragraphSpaceStyle.value = &paragraphSpacing;
    
    CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
    //给文本添加设置
    [attributeSting addAttribute:(id)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0 , [attributeSting length])];
}



-(void)attachImagesWithFrame:(CTFrameRef)f withImages:(NSMutableArray *)imags withContext:(CGContextRef) ctx inIndex:(NSUInteger)index isLeft:(BOOL)left//inColumnView:(OHAttributedLabel*)col
{
    
    CTFrameDraw(f, ctx);//CTFrmeDraw in CGContextRef
    
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    NSMutableArray *imgFrams = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:index]];
    if(!imgFrams)
        imgFrams = [NSMutableArray array];
    
    NSMutableArray *pagImgFrames = [NSMutableArray array];
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [imags objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[imags count]) return; //quit if no images for this column
        nextImage = [imags objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds;
	            CGFloat ascent;//height above the baseline
	            CGFloat descent;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
	            runBounds.origin.x = origins[lineIndex].x  + xOffset;
	            runBounds.origin.y = origins[lineIndex].y;
	            runBounds.origin.y -= descent;
                //NSLog(@"name %@",[nextImage objectForKey:@"fileName"]);
                //                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                NSString *imgStr = [nextImage objectForKey:@"fileName"];
                //NSLog(@"img %@",img);
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                
                if(!left) //在右边
                    imgBounds.origin.x = imgBounds.origin.x + self.view.bounds.size.width/2;
                
                //-->
                NSString *type = [nextImage objectForKey:@"type"];
                [pagImgFrames  addObject: //11
                 [NSArray arrayWithObjects:imgStr, NSStringFromCGRect(imgBounds), type, nil]
                 ];
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
    
    if(left){
        if(imgFrams.count>0){
            [imgFrams replaceObjectAtIndex:0 withObject:pagImgFrames];
        }else{
            [imgFrams addObject:pagImgFrames];
        }
    }
    else{
        if(imgFrams.count>1){
            [imgFrams replaceObjectAtIndex:1 withObject:pagImgFrames];
        }else{
            [imgFrams addObject:pagImgFrames];
        }
    }
    
    [self.paraImagesDictory setObject:imgFrams forKey:[NSNumber numberWithInt:index]];
    
    NSMutableArray *imgViewAry = [self.asyImgViews objectForKey:[NSNumber numberWithInt:index]];//case for load the async view more than one time in the same page
    if(left){
        if (imgViewAry) {
            for (AsyncImageView *img in imgViewAry) {
                img.delegate = nil;
                [img release];
            }
            [imgViewAry removeAllObjects];
        }
        imgViewAry = nil;
        imgViewAry = [NSMutableArray array];
    }
   
    
    for (NSArray* imageData in pagImgFrames )
    {
        
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        NSString *type = [imageData objectAtIndex:2];
        
        
        //        CGContextDrawImage(ctx, imgBounds, img.CGImage);
        //哥添加的代码
        CGFloat frameOrg = 0;
        if(!left)
            frameOrg = self.view.bounds.size.width/2; //当是右侧的时候，frame 的 org 是半个屏幕
        
        CGRect rect = CGRectMake(imgBounds.origin.x, self.view.frame.size.height-imgBounds.origin.y-imgBounds.size.height, imgBounds.size.width, imgBounds.size.height);
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        //        imageView.image = img;
        
        imgBounds.origin.x = imgBounds.origin.x - frameOrg;
        if ([type isEqualToString:@"url"]) {
            UIImage* img = [self.imgDic objectForKey:[imageData objectAtIndex:0]];
            if (!img) {
                AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:rect];
                imageView.delegate = self;
                imageView.index = [NSNumber numberWithInt:index];
                imageView.urlString = [imageData objectAtIndex:0];
                [imgViewAry addObject:imageView];
                
            }
            //            img = [UIImage imageNamed:[imageData objectAtIndex:0]];//default img
            
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
            UIImage* img = [UIImage imageNamed:[imageData objectAtIndex:0]];
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickEmojiImage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [self.asyImgViews setObject:imgViewAry forKey:[NSNumber numberWithInt:index]];
    
    
}


-(void)redrawImagesWithFrame:(CTFrameRef)f withImages:(NSMutableArray *)imags withContext:(CGContextRef) ctx inIndex:(NSUInteger)index isleft:(BOOL)left//inColumnView:(OHAttributedLabel*)col
{
    
    CTFrameDraw(f, ctx);//CTFrmeDraw in CGContextRef
    
    
    NSMutableArray *imgFrams = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:index]];
    NSMutableArray *pageImgFrames = nil;
    if(left){
        if(imgFrams.count>0)
            pageImgFrames = [imgFrams objectAtIndex:0];
    }
    else{
        if(imgFrams.count>1)
            pageImgFrames = [imgFrams objectAtIndex:1];
    }
    
    if(!pageImgFrames)
        return;
    
    for (NSArray* imageData in pageImgFrames)
    {
        
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        NSString *type = [imageData objectAtIndex:2];
        
        //        CGContextDrawImage(ctx, imgBounds, img.CGImage);
        //
        //        CGRect rect = CGRectMake(imgBounds.origin.x, self.view.frame.size.height-imgBounds.origin.y-imgBounds.size.height, imgBounds.size.width, imgBounds.size.height);
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        //        imageView.image = img;
        
        
        if ([type isEqualToString:@"url"]) {
            UIImage* img = [self.imgDic objectForKey:[imageData objectAtIndex:0]];
            if (!img) {
                
            }
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
            UIImage* img = [UIImage imageNamed:[imageData objectAtIndex:0]];
            CGContextDrawImage(ctx, imgBounds, img.CGImage);
            //            [imageView addTarget:self action:@selector(clickEmojiImage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}


-(void)leafAddLinker:(LeavesPadView *)leaf withLines:(NSMutableArray *)allLinkes withFrame:(CTFrameRef)frame isLeft:(BOOL)left
{
    //     NSString *string = attribstring.string;
    
    int linkIndex = 0; //3
    if ([self.linkes count] == 0) {
        return;
    }
    NSDictionary* nextLink = [self.linkes objectAtIndex:linkIndex];
    int linkLocation = [[nextLink objectForKey:@"location"] intValue];
    int linkLength = [[nextLink objectForKey:@"length"] intValue];
    
    
    
    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    while ( linkLocation < frameRange.location ) {
        linkIndex++;
        if (linkIndex>=[self.linkes count]) return; //quit if no images for this column
        nextLink = [self.linkes objectAtIndex:linkIndex];
        linkLocation = [[nextLink objectForKey:@"location"] intValue];
        linkLength = [[nextLink objectForKey:@"length"] intValue];
    }
    while (linkLocation + linkLength < frameRange.location + frameRange.length) {
        NSString *linkUrl = [nextLink objectForKey:@"hyperlink"];
        [leaf addCustomLink:[NSURL URLWithString:linkUrl] inRange:NSMakeRange(linkLocation, linkLength) isLeft:left];
        linkIndex++;
        if (linkIndex>=[self.linkes count]) return;
        nextLink = [self.linkes objectAtIndex:linkIndex];
        linkLocation = [[nextLink objectForKey:@"location"] intValue];
        linkLength = [[nextLink objectForKey:@"length"] intValue];
    }
    
}



- (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //    NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='16' height='16'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    [m_EmojiDic release];
    return text;
}





#pragma mark AsyncImageView Delegate
- (void)imgDownload:(AsyncImageView *)sender img:(UIImage *)img
{
    int index = [sender.index intValue];
    [self.imgDic setObject:img forKey:sender.urlString];
    [self.leavesView reloadCurrentPage:index];
    
}




#pragma mark  LeavesViewDelegate methods

- (BOOL)leavef:(LeavesPadView *)leaf shouldFollowLink:(NSTextCheckingResult *)active
{
    [[UIApplication sharedApplication] openURL:active.URL];
    return FALSE;
}

- (int) eventTouchAtPoint:(CGPoint)point atPageIndex:(NSUInteger)pageIndex
{
    CGPoint framPoint = CGPointMake(point.x, self.view.frame.size.height - point.y);
    NSMutableArray *imgFrams = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:pageIndex]];
    NSMutableArray *pageFrames = nil;
    if(imgFrams.count>0)
        pageFrames = [imgFrams objectAtIndex:0];
    if(!pageFrames)
        return -1;
    int findIndex = -1;
    for (NSArray* imageData in pageFrames)
    {
        findIndex++;
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        if (CGRectContainsPoint(imgBounds, framPoint)) {
            return findIndex;
        }
        
    }
    
    if(imgFrams.count>1)
        pageFrames = [imgFrams objectAtIndex:1];
    if(!pageFrames)
        return -1;
    
    for (NSArray* imageData in pageFrames)
    {
        findIndex++;
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        if (CGRectContainsPoint(imgBounds, framPoint)) {
            return findIndex;
        }
        
    }

    
    return -1;
    
}
- (void) excuteEventAtIndex:(int)index atPageIndex:(NSUInteger)pageIndex
{
    NSMutableArray *imgViews = [self.paraImagesDictory objectForKey:[NSNumber numberWithInt:pageIndex]];
    NSMutableArray *pageFrames = nil;
    if(imgViews.count>0)
        pageFrames = [imgViews objectAtIndex:0];
    if(!pageFrames)
        return;
   
    if ([pageFrames count] > index) {
        NSArray *imgInfo = [pageFrames objectAtIndex:index];
//        ImageViewController *imgVC = [[ImageViewController alloc] init];
//        imgVC.imgStr = [imgInfo objectAtIndex:0];
//        [self presentModalViewController:imgVC animated:YES];
//        [imgVC release];
        
    }else{
        NSMutableArray *rightPageFrame = nil;
        if(imgViews.count>1)
            rightPageFrame = [imgViews objectAtIndex:1];
        if(!rightPageFrame)
            return;
        int indexInSecond = index - [pageFrames count];
        if ([rightPageFrame count] > indexInSecond) {
            NSArray *imgInfo = [rightPageFrame objectAtIndex:indexInSecond];
//            ImageViewController *imgVC = [[ImageViewController alloc] init];
//            imgVC.imgStr = [imgInfo objectAtIndex:0];
//            [self presentModalViewController:imgVC animated:YES];
//            [imgVC release];
        }
        
       
    }
}


- (void) leavesView:(LeavesPadView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex {
    
}

- (void) leavesView:(LeavesPadView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex {
    //    if (pageIndex >= self.attributes.count) {
    //        pageIndex = self.attributes.count - 1;
    //    }
    //
    //    id subString = [self.attributes objectAtIndex:pageIndex];
    //    if (![subString isKindOfClass:[NSAttributedString class]]) {
    //        return;
    //    }
    //    id subCTFrame = [self.frames objectAtIndex:pageIndex];
    
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesPadView*)leavesView {
    
	return _totalPageNum;
}

- (CTFrameRef) getTextFrameAtPage:(NSUInteger)index isLeft:(BOOL)left
{
    NSUInteger reallIndex = index*2;
    if(!left)
        reallIndex = reallIndex+1;
    
    if (reallIndex >= self.frames.count) {
        return nil;
    }
    id subCTFrame = [self.frames objectAtIndex:reallIndex];
    return (CTFrameRef)subCTFrame;
}

- (NSMutableAttributedString *)getAttributedTextAtPage:(NSUInteger)index isLeft:(BOOL)left
{
    
    NSUInteger reallIndex = index*2;
    if(!left)
        reallIndex = reallIndex+1;
    
    if (reallIndex >= self.frames.count) {
        return nil;
    }

    id subString = [self.attributes objectAtIndex:reallIndex];
    return (NSMutableAttributedString *)subString;
}


- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx isleft:(BOOL)left{
    NSUInteger contIndex = 0;
    if (left) {
        contIndex = index *2;
    }else{
        contIndex = index*2+1;
    }
    
    if (contIndex >= self.attributes.count) {
        return;
    }
    
    id subString = [self.attributes objectAtIndex:contIndex];
    if (![subString isKindOfClass:[NSAttributedString class]]) {
        return;
    }
    id subCTFrame = [self.frames objectAtIndex:contIndex];
    
    [self attachImagesWithFrame:(CTFrameRef)subCTFrame withImages:self.images withContext:ctx inIndex:index isLeft:left];
    
    
    
}

- (void) asyRenderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx isLeft:(BOOL)left
{
    NSUInteger contIndex = 0;
    if (left) {
        contIndex = index *2;
    }else{
        contIndex = index*2+1;
    }

    
    if (contIndex >= self.attributes.count) {
        return;
    }
    
    id subString = [self.attributes objectAtIndex:contIndex];
    if (![subString isKindOfClass:[NSAttributedString class]]) {
        return;
    }
    id subCTFrame = [self.frames objectAtIndex:contIndex];
    [self redrawImagesWithFrame:(CTFrameRef)subCTFrame withImages:self.images withContext:ctx inIndex:index isleft:left];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
