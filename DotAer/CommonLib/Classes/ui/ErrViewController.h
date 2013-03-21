//
//  ErrViewController.h
//  iMobee
//
//  Created by ellison on 10-9-16.
//  Copyright 2010 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ErrViewControllerDelegate;

@interface ErrViewController : UIViewController {
	UILabel *_lblTitle;
	UITextView *_lblErrMsg;
	UIButton *_btBackOrRetry;
	
	id<ErrViewControllerDelegate> _delegate;
	
	NSString *_strTitle;
	NSString *_strErrMsg;
	NSString *_strButton;
}

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UITextView *lblErrMsg;
@property (nonatomic, retain) IBOutlet UIButton *btBackOrRetry;
@property (nonatomic, assign, readwrite) id<ErrViewControllerDelegate> delegate;

-(id)initWithErrorTitle: (NSString*)sTitle Msg: (NSString*)sMsg Button: (NSString*)sBtn Delegate:(id)delg;

-(IBAction) backOrRetryAction:(id)from;

@end

@protocol ErrViewControllerDelegate <NSObject>

-(void)errViewDidDisappear:(ErrViewController*)viewCtl;

@end


