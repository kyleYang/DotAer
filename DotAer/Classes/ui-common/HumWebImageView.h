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
#import "DACircularProgressView.h"

@protocol humWebImageDelegae;


typedef enum {
    HMProgressNO,
    HMProgressCircle,     //圆形
} HMProgressStyle;


typedef enum{
    HMImageDisplayALL,
    HMImageDisplaySome,
}HMImageDisplayStyle;


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

@interface HumWebImageView : UIScrollView<UIScrollViewDelegate>{
    Downloader   *_downloader;
    PackageFile *_cacheFile;
    NSUInteger _netsTaskID;
    UIActivityIndicatorView *_acty;
    CGPoint tapLocation;
    BOOL multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).

}

@property (nonatomic, assign) id<humWebImageDelegae> imgDelegate;

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) NSUInteger imgTag;

@property (nonatomic, assign) HUMWebImageStyle style;
@property (nonatomic, assign) HMProgressStyle progressStyle;

@property (nonatomic, assign) HMImageDisplayStyle displayStyle;

@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) PackageFile *cacheFile;

@property (nonatomic, retain) UIImage *downImage; //转换后的image
@property (nonatomic, retain) DACircularProgressView *ciclePrg;

//use for image
- (id)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath;
- (id)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath pkFile:(PackageFile *)file style:(HUMWebImageStyle)style;
- (void)loadImageWithUrl:(NSString*)url;
- (void)cancelTask;
- (void)loadImageWithUrl:(NSString *)url Widht:(NSUInteger)widht Height:(NSUInteger)height;
- (void)loadCacheImage:(NSString *)url;
- (void)loadCacheImage:(NSString *)url Widht:(NSUInteger)widht Height:(NSUInteger)height;


- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image;

//use for zoom
- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;

@end

@protocol humWebImageDelegae <NSObject>

@optional

- (void)humWebImageDidDownloader:(HumWebImageView *)view image:(UIImage *)image;

//Guest
- (void)photoViewDidSingleTap:(HumWebImageView *)photoView;
- (void)photoViewDidDoubleTap:(HumWebImageView *)photoView;
- (void)photoViewDidTwoFingerTap:(HumWebImageView *)photoView;
- (void)photoViewDidDoubleTwoFingerTap:(HumWebImageView *)photoView;

@end
