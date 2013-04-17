//
//  PanguRegistVC.h
//  pangu
//
//  Created by yang zhiyun on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTextField.h"

@interface HMRegistVC : UIViewController<UITextFieldDelegate>
{
    HMTextField *phoneNumTF;
    HMTextField *passwordTF;
    HMTextField *surewordTF;
    HMTextField *emailTF;
}
@property (nonatomic, retain) HMTextField *phoneNumTF;
@property (nonatomic, retain) HMTextField *passwordTF;
@property (nonatomic, retain) HMTextField *surewordTF;
@property (nonatomic, retain) HMTextField *emailTF;

@end
