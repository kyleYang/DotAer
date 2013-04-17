//
//  PgTextField.h
//  pangu
//
//  Created by Kyle on 12-11-7.
//
//

#import <UIKit/UIKit.h>

@interface HMTextField : UIView
{
    UIImageView *_bgImgView;
}


@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *clean;
- (void)setBgImageView:(UIImage *)bgImg;

@end
