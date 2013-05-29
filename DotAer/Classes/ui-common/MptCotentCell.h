//
//  MptCotentCell.h
//  TVGontrol
//
//  Created by Kyle on 13-4-26.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MptMacro.h"

@interface MptCotentCell : UIView{
@private
    NSUInteger _cellTag;
    NSString *_identifier;
}

@property (nonatomic, assign) NSUInteger cellTag;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, weak_delegate) UIViewController *parCtl;


- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident withController:(UIViewController *)ctrl;
- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident;

//shouled be rewite
- (void)viewWillAppear;
- (void)viewDidAppear;

- (void)viewWillDisappear;
- (void)viewDidDisappear;

@end
