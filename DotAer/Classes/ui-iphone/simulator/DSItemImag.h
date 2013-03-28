//
//  DSItemImag.h
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroInfo.h"
#import "Equipment.h"

@interface DSItemImag : UIButton
{
    HeroInfo *_hero;
    Equipment *_quip;
    BOOL _isFormula;
    
}
@property (nonatomic, assign) BOOL isFormula;//是不是卷轴
@property (nonatomic, assign) BOOL hasMatch;//是否已经匹配
@property (nonatomic, assign) BOOL autoRemove;//匹配成功，自动删除
@property (nonatomic, assign) BOOL goods;//是不是物品栏
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) HeroInfo *hero;
@property (nonatomic, retain) Equipment *equip;

@end
