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

@interface LeavesPadViewController : UIViewController

- (id)initWithLocalPath:(NSString *)path;

- (id)initWithString:(NSString *)string;

- (id)initWithArtUrl:(NSString *)url articeId:(NSString *)artId;

- (id)initWithArtUrl:(NSString *)url articeId:(NSString *)artId articlMd5:(NSString *)md5;

@end

