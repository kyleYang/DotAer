//
//  HumWebImageView.h
//  DotAer
//
//  Created by Kyle on 13-3-5.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Downloader.h"
#import "UIImage+Additions.h"
#import "KDGoalBar.h"

@protocol humWebImageDelegae;


typedef enum {
    HMProgressNO,
    HMProgressCircle,     //圆形
} HMProgressStyle;


typedef enum {
    HUMWebImageStyleNO,
    HUMWebImageStyleScale,     //按比例
    HUMWebImageStyleCut,       //裁剪
    HUMWebImageStyleStretch,   //拉伸
    HUMWebImageStyleTopLeft,    //左上角
    HUMWebImageStyleTopCentre,
    HUMWebImageStyleEqualWidth, //等宽
    HUMWeiImageStyleEqualHeight,//等高
} HUMWebImageStyle;

@interface HumWebImageView : UIImageView{
    HUMWebImageStyle    _style;
    Downloader   *_downloader;
    PackageFile *_cacheFile;
    NSUInteger _netsTaskID;
    NSString *_logoUrl;
    UIActivityIndicatorView *_acty;
    CGPoint tapLocation;
    BOOL multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).

}

@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, assign) NSUInteger imgTag;
@property (nonatomic, assign) id<humWebImageDelegae> delegate;
@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) PackageFile *cacheFile;
@property (nonatomic, assign) HUMWebImageStyle style;
@property (nonatomic, assign) HMProgressStyle progressStyle;
@property (nonatomic, retain) UIImage *downImage; //转换后的image
@property (nonatomic, retain) KDGoalBar *ciclePrg;

- (id)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath;
- (id)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath pkFile:(PackageFile *)file style:(HUMWebImageStyle)style;
- (void)loadImageWithUrl:(NSString*)url;
- (void)cancelTask;
- (void)loadImageWithUrl:(NSString *)url Widht:(NSUInteger)widht Height:(NSUInteger)height;
- (void)loadCacheImage:(NSString *)url;
- (void)loadCacheImage:(NSString *)url Widht:(NSUInteger)widht Height:(NSUInteger)height;
- (void)setImageFrame:(CGRect)frame;


@end

@protocol humWebImageDelegae <NSObject>

@optional

- (void)humWebImageDidDownloader:(HumWebImageView *)view image:(UIImage *)image;

//Guest
- (void)tapDetectingImageView:(HumWebImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingImageView:(HumWebImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingImageView:(HumWebImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;

@end
