//
//  PgNoticeView.h
//  pangu
//
//  Created by Kyle on 12-10-31.
//
//

#import <UIKit/UIKit.h>

@interface HMNoticeView : UIView
{
    UILabel *_msgLebal;
    UIFont *_msgFont;
    NSString *_message;
}
@property (nonatomic, copy) NSString *message;
@property (nonatomic, retain) UIFont *msgFont;

- (id)initWithString:(NSString *)msg;
+ (id)sharedInstance;

@end
