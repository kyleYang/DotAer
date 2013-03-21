//
//  MpAVPlayerPlaceholderView.m
//  CoreTextDemo
//
//  Created by Kyle on 12-12-10.
//  Copyright (c) 2012年 深圳微普特. All rights reserved.
//

#import "MptAVPlayerPlaceholderView.h"
#import "MptWeak.h"

@interface MptAVPlayerPlaceholderView ()

@property (nonatomic, retain) UIActivityIndicatorView *activityView;

@end


@implementation MptAVPlayerPlaceholderView
@synthesize playButton = _playButton,infoLabel = _infoLabel,imageView = _imageView,infoText = _infoText,image = _image;
@synthesize backButton = _backButton;
@synthesize activityView;

- (void)dealloc
{
    MptSafeRelease(_infoLabel);
    MptSafeRelease(_infoText);
    MptSafeRelease(_imageView);
    _image = nil;
    _backButton = nil;
    self.activityView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.hidden = YES;
        [self addSubview:_imageView];
        
        
        _backButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(15, 20, kTopBtn_W, kTopBtn_H);
        [_backButton setImage:[UIImage imageNamed:@"MptPlayer.bundle/iPhone/player_back"] forState:UIControlStateNormal];
        [self addSubview:_backButton];

        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        self.activityView.hidesWhenStopped = YES;
        [self.activityView startAnimating];
        [self  addSubview:self.activityView];
        
        
        
//        UIImage *playImage = [UIImage imageNamed:@"NGMoviePlayer.bundle/playVideo"];
//        
//        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playButton.frame = (CGRect){.size = playImage.size};
//        _playButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//        _playButton.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f);
//        [_playButton setImage:playImage forState:UIControlStateNormal];
//        [_playButton addTarget:self action:@selector(handlePlayButtonPress:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_playButton];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:14.f];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        _infoLabel.textAlignment = UITextAlignmentCenter;
        _infoLabel.hidden = YES;
        [self addSubview:_infoLabel];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.activityView.center = self.center;
    
    CGFloat centerX = self.activityView.center.x;
    CGFloat topY = self.activityView.frame.origin.y + self.activityView.frame.size.height + 5.f;
    
    self.infoLabel.center = CGPointMake(centerX, topY + self.infoLabel.frame.size.height/2.f);
    self.infoLabel.frame = CGRectIntegral(self.infoLabel.frame);
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGMoviePlayerPlaceholderView
////////////////////////////////////////////////////////////////////////


- (void)setInfoText:(NSString *)infoText {
    self.infoLabel.text = infoText;
    
    if (infoText.length == 0) {
        self.infoLabel.hidden = YES;
    } else {
        [self.infoLabel sizeToFit];
        self.infoLabel.hidden = NO;
        [self setNeedsLayout];
    }
}

- (NSString *)infoText {
    return self.infoLabel.text;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.hidden = (image == nil);
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)resetToInitialState {
//    [self.activityView stopAnimating];
//    [self.activityView removeFromSuperview];
}

- (void)addPlayButtonTarget:(id)target action:(SEL)action
{
    
}
- (void)addBackButtonTarget:(id)target action:(SEL)action
{
    [_backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



@end
