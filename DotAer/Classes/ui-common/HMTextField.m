//
//  PgTextField.m
//  pangu
//
//  Created by Kyle on 12-11-7.
//
//

#import "HMTextField.h"
#import "Env.h"

@implementation HMTextField
@synthesize textField;
@synthesize clean;

#define kInputOrgX 10
#define kCleanButWidth 23

- (void)dealloc
{
    self.textField = nil;
    self.clean = nil;

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        Env *env = [Env sharedEnv];
    
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.image = [env cacheScretchableImage:@"pg_input_bg.png" X:10 Y:10];
        bgImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:bgImgView];
        _bgImgView = bgImgView;
        [bgImgView release];
        
        self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(kInputOrgX, 0, CGRectGetWidth(frame) - kCleanButWidth - 2*kInputOrgX, CGRectGetHeight(frame))] autorelease];
        self.textField.textAlignment = UITextAlignmentLeft;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.textField];
        
        
        self.clean = [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textField.frame), (CGRectGetHeight(frame) - kCleanButWidth)/2, kCleanButWidth, kCleanButWidth)] autorelease];
        self.clean.backgroundColor = [UIColor clearColor];
        self.clean.hidden = YES;
        [self.clean setBackgroundImage:[env cacheImage:@"search_clean_normal.png"] forState:UIControlStateNormal];
        [self.clean setBackgroundImage:[env cacheImage:@"search_clean_down.png"] forState:UIControlStateHighlighted];
        [self.clean addTarget:self action:@selector(cleanChar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clean];
   
    }
    return self;
}

- (void)setBgImageView:(UIImage *)bgImg
{
  
    _bgImgView.image = bgImg;
}

- (void)cleanChar:(id)sender
{
    self.textField.text = nil;
    self.clean.hidden = YES;
}

@end
