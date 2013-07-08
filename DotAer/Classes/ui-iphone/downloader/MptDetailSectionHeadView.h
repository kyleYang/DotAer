//
//  MptDetailSectionHeadView.h
//  TVGontrol
//
//  Created by Kyle on 13-5-14.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MptMacro.h"

typedef enum {
    MptDetailTypeNO,
    MptDetailTypeDownloaded,
    MptDetailTypeDownloading,
}MptDetailType;


@protocol MptDetailSectionHeadView_delegate;

@interface MptDetailSectionHeadView : UIView{
    
@private
    id<MptDetailSectionHeadView_delegate> __weak_delegate _delegate;
    MptDetailType _detailType;
}

@property (nonatomic, assign) MptDetailType detailType;
@property (nonatomic, weak_delegate)  id<MptDetailSectionHeadView_delegate> delegate;;

- (id)initWithFrame:(CGRect)frame withType:(MptDetailType)type;

@end

@protocol MptDetailSectionHeadView_delegate <NSObject>

- (void)mptDetailSectionHeadView:(MptDetailSectionHeadView *)view didSelectType:(MptDetailType)type;

@end

