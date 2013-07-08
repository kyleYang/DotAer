//
//  YRViewDelegate.h
//  SuizongAdsSdk
//
//  Created by yunrang on 13-3-8.
//  Copyright (c) 2013年 yunrang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRView.h"

@protocol YRViewDelegate <NSObject>

@required

#pragma mark -
#pragma mark optional Connection methods
// 当第一次成功接收到广告后通知应用程序。开发者可以在以将广告视图添回到当前的View中。
// yrView:广告视图对象，用于标识哪个对象使用该函数返回值。
-(void)yrViewDidReceiveAdRequest:(YRView *)yrView;

@optional

- (void)actionViewWillAppear:(YRView *)yrView;

- (void)actionViewDidAppear:(YRView *)yrView;

- (void)actionViewWillDisappear:(YRView *)yrView;

- (void)actionViewDidDisappear:(YRView *)yrView;

- (void)yrViewDidFailedToReceiveAd:(YRView *)yrView;

@end
