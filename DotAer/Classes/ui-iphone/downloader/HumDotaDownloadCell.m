//
//  HumDotaDownloadCell.m
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaDownloadCell.h"
#import "Env.h"
#import "BqsUtils.h"

@implementation HumDotaDownloadCell
@synthesize imgLog;
@synthesize titel;
@synthesize sceenType;
@synthesize precent;
@synthesize stopBtn;

- (void)dealloc{
    self.delegate = nil;
    self.imgLog = nil;
    self.titel = nil;
    self.sceenType = nil;
    self.precent = nil;
    self.stopBtn = nil;
    
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

        
        self.imgLog = [[[HumWebImageView alloc] initWithFrame:CGRectMake(kedImageOrgX, 20, kedImageWidth, kedImageHeigh)] autorelease];
        self.imgLog.style = HUMWebImageStyleTopCentre;
        [self addSubview:self.imgLog];
        
        self.titel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgLog.frame)+kedImgTiteGap, kedImageOrgy, kedTitleWidth, kedTitleHeigh)] autorelease];
        self.titel.font = [UIFont systemFontOfSize:15.0f];
        self.titel.numberOfLines = 0;
        self.titel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titel];
        
        self.sceenType = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titel.frame), CGRectGetMaxY(self.titel.frame)+kedTitTypeGap, kedTypeWidth, kedTypeHeigh)] autorelease];
        self.sceenType.font = [UIFont systemFontOfSize:17.0f];
        self.sceenType.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sceenType];
        
        self.precent =  [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-kedTypeWidth-30, CGRectGetMinY(self.sceenType.frame), kedSizeWidth, kedTypeHeigh)] autorelease];
        self.precent.font = [UIFont systemFontOfSize:13.0f];
        self.precent.backgroundColor = [UIColor clearColor];
        [self addSubview:self.precent];

        
               
        self.stopBtn = [[[UIButton alloc] initWithFrame:self.bounds] autorelease];
        self.stopBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.stopBtn addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
        self.stopBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stopBtn];

    }
    return self;
}

- (void)videoPlay:(id)sender{
    
        
    NSIndexPath *path =  [((UITableView *)self.superview) indexPathForCell:self] ;
    BqsLog(@"videoPlay press at index row: %d",path.row);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HumDotaDownloadCell:didSelectAtIndex:)]) {
        [self.delegate HumDotaDownloadCell:self didSelectAtIndex:path];
    }
    
}


@end
