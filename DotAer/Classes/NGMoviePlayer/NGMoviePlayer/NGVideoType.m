//
//  NGVideoType.m
//  DotAer
//
//  Created by Kyle on 13-7-6.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "NGVideoType.h"
#import "URBSegmentedControl.h"
#import "HumDotaUserCenterOps.h"

@implementation NGVideoType

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
        NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"settin.video.qulity.one", nil), NSLocalizedString(@"settin.video.qulity.two", nil), NSLocalizedString(@"settin.video.qulity.three", nil), nil];
        
    //
        // Basic horizontal segmented control
        //
        URBSegmentedControl *control = [[URBSegmentedControl alloc] initWithItems:titles];
        control.frame = self.bounds;
        control.segmentBackgroundColor = [UIColor blueColor];
        [self addSubview:control];
        
        // UIKit method of handling value changes
        [control addTarget:self action:@selector(handleSelection:) forControlEvents:UIControlEventValueChanged];
        // block-based value change handler
        [control setControlEventBlock:^(NSInteger index, URBSegmentedControl *segmentedControl) {
            NSLog(@"URBSegmentedControl: control block - index=%i", index);
        }];
        
        int playStep = [HumDotaUserCenterOps intValueReadForKey:kScreenPlayType];
        control.selectedSegmentIndex = playStep;

        
    }
    return self;
}


- (void)handleSelection:(id)sender {
    URBSegmentedControl *control = (URBSegmentedControl *)sender;
    NSUInteger select = control.selectedSegmentIndex;
	NSLog(@"URBSegmentedControl: value changed atIndex:%d",select);
    
    if (_delegate && [_delegate respondsToSelector:@selector(NGVideoType:didSelectAtIndex:)]) {
        [_delegate NGVideoType:self didSelectAtIndex:select];
    }
}


@end
