//
//  PgNoticeView.m
//  pangu
//
//  Created by Kyle on 12-10-31.
//
//

#import "HMNoticeView.h"


@implementation HMNoticeView

@synthesize msgFont = _msgFont;
@synthesize message = _message;

#define PaddingWidth 50
#define PaddingHeigh 30
#define kDefaultFont [UIFont systemFontOfSize:15.0f]
#define kMaxWidth 200
#define kLebalWidthPoint 150
#define kLebalHeithPoint 120
#define kDefaultWidth 275
#define kDefaultHeigh 200

- (void)dealloc
{
    [_msgFont release]; _msgFont = nil;
    [_msgLebal release]; _msgLebal = nil;
    [_message release]; _message = nil;
    [super dealloc];
}

+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UIImage *bgImg = [UIImage imageNamed:@"HM_Notice_bg.png"];
        bg.alpha = 0.7;
        bg.image = [bgImg stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self addSubview:bg];
        [bg release];
        
        _msgLebal = [[UILabel alloc] init];
        _msgLebal.backgroundColor = [UIColor clearColor];
        _msgLebal.textColor = [UIColor whiteColor];
        _msgLebal.numberOfLines = 0;
        _msgLebal.font = kDefaultFont;
        [self addSubview:_msgLebal];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UIImage *bgImg = [UIImage imageNamed:@"HM_Notice_bg.png"];
        bg.alpha = 0.7;
        bg.image = [bgImg stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self addSubview:bg];
        [bg release];
        
        _msgLebal = [[UILabel alloc] init];
        _msgLebal.backgroundColor = [UIColor clearColor];
        _msgLebal.textColor = [UIColor whiteColor];
        _msgLebal.numberOfLines = 0;
        _msgLebal.font = kDefaultFont;
        [self addSubview:_msgLebal];
    }
    return self;
}

- (id)initWithString:(NSString *)msg
{
    self = [super init];
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UIImage *bgImg = [UIImage imageNamed:@"HM_Notice_bg.png"];
        bg.alpha = 0.7;
        bg.image = [bgImg stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        [self addSubview:bg];
        [bg release];
        
        _msgLebal = [[UILabel alloc] init];
        _msgLebal.backgroundColor = [UIColor clearColor];
        _msgLebal.textColor = [UIColor whiteColor];
        _msgLebal.numberOfLines = 0;
        _msgLebal.font = kDefaultFont;
        [self addSubview:_msgLebal];
        _message = [msg copy];
        
        [self adjustFrame];
    }
    
    return self;
}

- (void)adjustFrame
{
    if (!_message) {
        return;
    }
    
    CGSize textSize = [_message sizeWithFont:_msgLebal.font constrainedToSize:CGSizeMake(kMaxWidth, 480) lineBreakMode:_msgLebal.lineBreakMode];
    CGRect frame = _msgLebal.frame;
    frame.size = textSize;
    
    CGRect supFrame = self.frame;
    if (textSize.width <= kLebalWidthPoint) {
        supFrame.size.width = textSize.width+2*PaddingWidth;
    }else{
        supFrame.size.width = kDefaultWidth;

    }
    
    if (textSize.height <= kLebalHeithPoint) {
        supFrame.size.height = textSize.height+2*PaddingHeigh;
    }else{
        supFrame.size.height = kDefaultHeigh;
    }
    
    CGPoint org = CGPointMake((CGRectGetWidth(supFrame)-CGRectGetWidth(frame))/2, (CGRectGetHeight(supFrame)-CGRectGetHeight(frame))/2);
    
    frame.origin = org;
    _msgLebal.frame = frame;
    _msgLebal.text = _message;
    
 
    self.frame = supFrame;
}

- (void)setMessage:(NSString *)msg
{
    [_message release]; _message = nil;
    _message = [msg copy];
    [self adjustFrame];
}

- (void)setMsgFont:(UIFont *)font
{
    [_msgFont release]; _msgFont = nil;
    _msgFont = [font retain];
    _msgLebal.font = _msgFont;
    [self adjustFrame];

}

@end
