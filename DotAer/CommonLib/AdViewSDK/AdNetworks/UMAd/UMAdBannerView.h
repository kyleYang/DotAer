//
//  UMAdBannerView.h
//  UMAds
//
//  Created by luyiyuan on 9/13/11.
//  Copyright (c) 2011 umeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UMAdADBannerViewDelegate;

/** UMAdBannerView是广告banner的UIView类
 */
@interface UMAdBannerView : UIView
{
@private
    id _delegate;
    id _storage;
}
@property (nonatomic, assign) id <UMAdADBannerViewDelegate> delegate;

///---------------------------------------------------------------------------------------
/// @name Class Methods
///---------------------------------------------------------------------------------------

/** 根据当前设备自动获取BannerSize
 
 目前只有两种尺寸 iPhone:320x50 iPad:480x75
 
 @return CGSize 当前设备应该返回广告Banner的长宽
 */
+ (CGSize)sizeOfBannerContentSize;

/** 自主请求banner的Size尺寸
 
 320x50(iphone版本尺寸)
 
 @return CGSize 320x50
 */
+ (CGSize)bannerSizeofSize320x50;

/** 获取banner的size尺寸支持
 
 480x75(ipad版本尺寸)
 
 @return CGSize 480x75
 */
+ (CGSize)bannerSizeofSize480x75;

///---------------------------------------------------------------------------------------
/// @name Instance Methods
///---------------------------------------------------------------------------------------

/** 设置banner的广告属性
 
 绑定banner相关的参数，方法被调用后，内部直接开始网络交互，并显示Banner
 
 @param viewController  为点击后可能全屏的WebView提供PresentingModalView的父Controller
 @param slotid          当前Banner绑定的广告位id
 
 @warning 请在调用本接口之前，先调用`setDelegate`否则部分`UMAdADBannerViewDelegate`方法无法及时响应
 */
- (void)setProperty:(UIViewController *)viewController slotid:(NSString *)slotid;

/** 为Banner设定delegate
 
 delegate可以监听banner的一些动作，如获取失败，点击等等
 
 @param delegate 实现`UMAdADBannerViewDelegate`的Class
 */
- (void)setDelegate:(id<UMAdADBannerViewDelegate>)delegate;
@end

/** 用于侦测BannerView的各个事件的委托
 */
@protocol UMAdADBannerViewDelegate <NSObject>
@optional
/** bannerView开始请求数据
 
 delegate会通过该方法了解Banner开始请求广告
 
 @param banner 当前事件属于的bannerview
 */
- (void)UMADBannerViewWillLoadAd:(UMAdBannerView *)banner;

/** bannerView已经获取数据，并加载
 
 delegate会通过该方法了解Banner数据已经获取并加载
 
 @param banner 当前事件属于的bannerview
 */
- (void)UMADBannerViewDidLoadAd:(UMAdBannerView *)banner;

/** bannerView已经成功显示
 
 delegate会通过该方法了解Banner已经成功显示了
 
 @param banner 当前事件属于的bannerview
 */
- (void)UMADBannerViewDidAppear:(UMAdBannerView *)banner;

/** bannerView获取内容失败
 
 delegate会通过该方法了解Banner数据已经获取失败
 
 @param banner 当前事件属于的bannerview
 @param error  出错具体信息，error code可与UMAdManager.h中的UMADError对照
 */
- (void)UMADBannerView:(UMAdBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;

/** bannerview点击事件即将开始

 delegate会通过该方法了解Banner点击事件即将响应
 
 @param banner 当前事件属于的bannerview
 */
- (void)UMADBannerViewActionWillBegin:(UMAdBannerView *)banner;

/** bannerview点击事件已经完毕
 
 delegate会通过该方法了解Banner点击事件已经响应完毕 
 
 @param banner 当前事件属于的bannerview
 */
- (void)UMADBannerViewActionDidFinish:(UMAdBannerView *)banner;
@end
