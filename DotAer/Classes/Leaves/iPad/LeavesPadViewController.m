//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesPadViewController.h"


@implementation LeavesPadViewController
@synthesize leavesView;


- (void) initialize {
    self.leavesView = [[[LeavesPadView alloc] initWithFrame:CGRectZero] autorelease];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
   if (self = [super initWithNibName:nibName bundle:nibBundle]) {
      [self initialize];
   }
   return self;
}

- (id)init {
   return [self initWithNibName:nil bundle:nil];
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self initialize];
}

- (void)dealloc {
	self.leavesView = nil;
    [super dealloc];
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesPadView*)leavesView {
	return 0;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx isleft:(BOOL)lefe{
	
}

#pragma mark  UIViewController methods

- (void)loadView {
	[super loadView];
     
	self.leavesView.frame = self.view.bounds;
	self.leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.leavesView];
}

- (void) viewDidLoad {
	[super viewDidLoad];
   
	self.leavesView.dataSource = self;
	self.leavesView.delegate = self;
	
}

@end
