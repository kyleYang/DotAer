//
//  PopupWebviewController.h
//  iMobeeOmscn
//
//  Created by ellison on 10-12-25.
//  Copyright 2010 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebviewController.h"


@interface PopupWebviewController : WebviewController {
}
@property (nonatomic, assign) id callback;
@property (nonatomic, assign) BOOL bEnableScale;
@property (nonatomic, copy) NSString *url;


@end


@protocol PopupWebviewController_Callback <NSObject>

@optional
-(void)popupWebviewControllerDidClickClose:(PopupWebviewController*)ctl;

@end