//
//  UIBarButtonItem+Image.h
//  pangu
//
//  Created by Kyle on 12-10-26.
//
//

#import <Foundation/Foundation.h>

#define kBarStrePosX 20
#define kBarStrePosY 13

typedef enum {
    CustomUIBarButtonItemStylePlain,    // shows glow when pressed
    CustomUIBarButtonItemStyleBack,
    CustomUIBarButtonItemStyleDone,
} CustomUIBarButtonItemStyle;

@interface CustomUIBarButtonItem:UIBarButtonItem

+(UIBarButtonItem *)initWithImage:(UIImage *)image eventImg:(UIImage *)eventImage title:(NSString*)title target:(id)target action:(SEL)action;
-(void)setEnabled:(BOOL)enabled;

@end
