//
//  LeavesViewController.h
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeavesPadView.h"
#import "OHAttributedLabel.h"

@interface LeavesPadViewController : UIViewController <LeavesPadViewDataSource, LeavesPadViewDelegate,OHAttributedLabelDelegate> {
	LeavesPadView *leavesView;
    
}

@property (nonatomic, retain) LeavesPadView *leavesView;
// added by Lnkd.com?24 - use designated initializer to avoid continuous loop when loaded from NIB
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle;

- (id)init;

@end

