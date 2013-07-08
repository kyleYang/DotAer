//
//  HumDotaDownloadingCell.m
//  DotAer
//
//  Created by Kyle on 13-5-31.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaDownloadingCell.h"
#import "Env.h"
#import "BqsUtils.h"

@implementation HumDotaDownloadingCell
@synthesize imgLog;
@synthesize titel;
@synthesize sceenType;
@synthesize precent;
@synthesize progress;
@synthesize stopBtn;
@synthesize buttonState = _buttonState;

- (void)dealloc{
    self.delegate = nil;
    self.imgLog = nil;
    self.titel = nil;
    self.sceenType = nil;
    self.precent = nil;
    self.stopBtn = nil;
    self.progress = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds] ;
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.backgroundColor = [UIColor clearColor];
        bg.image = [[Env sharedEnv] cacheScretchableImage:@"news_cell_bg.png" X:40 Y:20];
        [self addSubview:bg];
        [bg release];
        
        self.imgLog = [[[HumWebImageView alloc] initWithFrame:CGRectMake(kImageOrgX, kImageOrgy, kImageWidth, kImageHeigh)] autorelease];
        [self addSubview:self.imgLog];
        
        self.titel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgLog.frame)+kImgTiteGap, 10, kTitleWidth, kTitleHeigh)] autorelease];
        self.titel.font = [UIFont systemFontOfSize:13.0f];
        self.titel.numberOfLines = 0;
        self.titel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titel];
        
        self.sceenType = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titel.frame), CGRectGetMaxY(self.titel.frame)+kTitTypeGap, kTypeWidth, kTypeHeigh)] autorelease];
        self.sceenType.font = [UIFont systemFontOfSize:13.0f];
        self.sceenType.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sceenType];
        
        self.precent = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sceenType.frame)+kTitTypeGap, CGRectGetMinY(self.sceenType.frame), kPrecentWidht, kTypeHeigh)] autorelease];
        self.precent.font = [UIFont systemFontOfSize:13.0f];
        self.precent.backgroundColor = [UIColor clearColor];
        [self addSubview:self.precent];
        
        self.progress = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
        self.progress.frame = CGRectMake(CGRectGetMinX(self.sceenType.frame), CGRectGetMaxY(self.sceenType.frame)+5, CGRectGetWidth(self.titel.frame)-70, 10);
        self.progress.trackTintColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
        self.progress.progressTintColor = [UIColor colorWithRed:23.0f/255.0f green:133.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
        [self addSubview:self.progress];
        
        self.stopBtn = [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-kStopeBtnOrgX-kStopeBtnWidht, CGRectGetMinY(self.titel.frame)+20, kStopeBtnWidht, kStopBtnHeigh)] autorelease];
        [self.stopBtn setBackgroundImage:[[Env sharedEnv] cacheScretchableImage:@"cache_down_resum.png" X:10 Y:5] forState:UIControlStateNormal];
        [self.stopBtn addTarget:self action:@selector(videoStp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.stopBtn];
    }
    return self;
}

//"video.download.cell.resum" = "继续";
//"video.download.cell.stop" = "暂停";

- (void)setButtonState:(ButtonState)buttonState{
    _buttonState = buttonState;
    
    if (_buttonState == VideoButtonStope) {
        [self.stopBtn setTitle:NSLocalizedString(@"video.download.cell.resum", nil) forState:UIControlStateNormal];
    }else if(_buttonState == VideoButtonResum){
        [self.stopBtn setTitle:NSLocalizedString(@"video.download.cell.stop", nil) forState:UIControlStateNormal];
    }
    
}

- (void)videoStp:(id)sender{
    
    if (_buttonState == VideoButtonStope) {
        self.buttonState = VideoButtonResum;
    }else if(_buttonState == VideoButtonResum){
        self.buttonState = VideoButtonStope;
    }
    
    NSIndexPath *path =  [((UITableView *)self.superview) indexPathForCell:self] ;
    BqsLog(@"videoStp press at index row: %d for buttonState :%d",path.row,self.buttonState);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HumDotaDownloadingCell:didCilicType:atIndex:)]) {
        [self.delegate HumDotaDownloadingCell:self didCilicType:self.buttonState atIndex:path];
    }
    
}

@end
