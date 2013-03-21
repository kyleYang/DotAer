//
//  KGModal.h
//  KGModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    KGModalBackgroundDisplayStyleGradient = 0,
    KGModalBackgroundDisplayStyleSolid,
}
KGModalBackgroundDisplayStyle;


typedef enum
{
    KGModalBackgrounFullScreenModel = 0,
    KGModalBackgrounPartScreenMOdel,
}
KGModalBackgroundScreenModel;

@interface KGModal : UIView
{
    CGRect _superFrame;
}

#define kgDefalutTimer 2.5


@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat timeInterval;

// Determines if the modal should dismiss if the user taps outside of the modal view
// Defaults to YES
@property (nonatomic) BOOL tapOutsideToDismiss;

// Determins if the close button or tapping outside the modal should animate the dismissal
// Defaults to YES
@property (nonatomic) BOOL animateWhenDismissed;

// Determins if the close button is shown
// Defaults to YES
@property (nonatomic) BOOL showCloseButton;

// The background display style, can be a transparent radial gradient or a transparent black
// Defaults to gradient, this looks better but takes a bit more time to display on the retina iPad
@property (nonatomic) KGModalBackgroundDisplayStyle backgroundDisplayStyle;
@property (nonatomic) KGModalBackgroundScreenModel backgroundScreenMode;

// The shared instance of the modal
+ (id)sharedInstance;

// Set the content view to display in the modal and display with animations
- (void)showWithContentView:(UIView *)contentView;

// Set the content view to display in the modal and whether the modal should animate in
- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated;

// Hide the modal with animations
- (void)hide;

// Hide the modal and whether the modal should animate away
- (void)hideAnimated:(BOOL)animated;

@end
