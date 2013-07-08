//
//  MptDetailSectionHeadView.m
//  TVGontrol
//
//  Created by Kyle on 13-5-14.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import "MptDetailSectionHeadView.h"
#import "BqsUtils.h"
#import "Env.h"

#define kBtnOrgX 0
#define kBtnOrgY 3

#define kBtnWidth 150
#define kBtnHeigh 25

@interface MptDetailSectionHeadView(){
    
}

@property (nonatomic, strong) UIButton *detail;
@property (nonatomic, strong) UIButton *episode;

@end

@implementation MptDetailSectionHeadView
@synthesize detailType = _detailType;
@synthesize delegate = _delegate;

//"iKan.control.detail.head.detail" = "详情";
//"iKan.control.detail.head.episode" = "剧集";


- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame withType:MptDetailTypeDownloaded];
}


- (id)initWithFrame:(CGRect)frame withType:(MptDetailType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _detailType = type; //default = 剧集
        
        Env *env = [Env sharedEnv];
        
//        "dota.video.downloader.downloaded" = "已下载";
//        "dota.video.downloader.downloading" = "正在下载";
        
        
    
        self.detail = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, CGRectGetWidth(self.bounds)/2 , CGRectGetHeight(self.bounds))];
        self.detail.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.detail setBackgroundImage:[env cacheImage:@"cache_button_nor.png"] forState:UIControlStateNormal];
        [self.detail setBackgroundImage:[env cacheImage:@"cache_button_select.png"] forState:UIControlStateSelected];
        [self.detail setBackgroundImage:[env cacheImage:@"cache_button_select.png"] forState:UIControlEventTouchDown];
        [self.detail setTitle:NSLocalizedString(@"dota.video.downloader.downloaded", nil) forState:UIControlStateNormal];
        [self.detail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.detail addTarget:self action:@selector(detailSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.detail];
        
        
        self.episode = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.detail.bounds), 0, CGRectGetWidth(self.detail.bounds), CGRectGetHeight(self.detail.bounds))];
        self.episode.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.episode setBackgroundImage:[env cacheImage:@"cache_button_nor.png"] forState:UIControlStateNormal];
        [self.episode setBackgroundImage:[env cacheImage:@"cache_button_select.png"] forState:UIControlStateSelected];
        [self.episode setBackgroundImage:[env cacheImage:@"cache_button_select.png"] forState:UIControlEventTouchDown];
        [self.episode setTitle:NSLocalizedString(@"dota.video.downloader.downloading", nil) forState:UIControlStateNormal];
        [self.episode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.episode addTarget:self action:@selector(episodeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.episode];
        
        if (_detailType == MptDetailTypeDownloaded) {
            self.detail.selected = YES;
        }else if(_detailType == MptDetailTypeDownloading){
            self.episode.selected = YES;
        }


    }
    return self;
}

#pragma mark
#pragma mark property

- (void)setDetailType:(MptDetailType)detailType{
    if (_detailType == detailType) {
        return;
    }
    
    _detailType = detailType;
    //change indicator
       
    if (_delegate && [_delegate respondsToSelector:@selector(mptDetailSectionHeadView:didSelectType:)]) {
        [_delegate mptDetailSectionHeadView:self didSelectType:_detailType];
    }
    
}

#pragma mark
#pragma mark UIButton Method

- (void)detailSelect:(id)sender{
    if (_detailType == MptDetailTypeDownloaded) {
        BqsLog(@"MptDetailTypeDetail already selected");
        return;
    }
    self.detailType = MptDetailTypeDownloaded;
    self.detail.selected = YES;
    self.episode.selected = NO;
    

}

- (void)episodeSelect:(id)sender{
    if (_detailType == MptDetailTypeDownloading) {
        BqsLog(@"MptDetailTypeDetail already selected");
        return;
    }
    self.detailType = MptDetailTypeDownloading;
    self.detail.selected = NO;
    self.episode.selected = YES;
    
}





@end
