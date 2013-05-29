//
//  MptCotentCell.m
//  TVGontrol
//
//  Created by Kyle on 13-4-26.
//  Copyright (c) 2013年 MIPT. All rights reserved.
//

#import "MptCotentCell.h"

@implementation MptCotentCell
@synthesize cellTag = _cellTag;
@synthesize identifier = _identifier;


- (id)initWithFrame:(CGRect)frame
{
    return  [self initWithFrame:frame withIdentifier:@"" withController:nil];
}

- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident{
    return  [self initWithFrame:frame withIdentifier:ident withController:nil];
}


- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident withController:(UIViewController *)ctrl{
    self = [super initWithFrame:frame];
    if (self) {
        self.identifier = ident;
        self.parCtl = ctrl;
    }

    return self;

}

- (void)viewWillAppear{
    
}
- (void)viewDidAppear{
    
}

- (void)viewWillDisappear{
    
}

- (void)viewDidDisappear{
    
}



@end
