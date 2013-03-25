//
//  MptLeftRightTextCell.h
//  TVGuide
//
//  Created by ellison on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMLeftRightTextCell : UITableViewCell
@property (nonatomic, retain, readonly) UILabel *lblLeft;
@property (nonatomic, retain, readonly) UILabel *lblRight;
@property (nonatomic, retain, readonly) UIImageView *imgDisclosure;
@property (nonatomic, assign) float paddingHori;
@end
