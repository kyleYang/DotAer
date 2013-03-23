//
//  ASMediaFocusViewController.m
//  ASMediaFocusManager
//
//  Created by Philippe Converset on 21/12/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import "HMImagePopController.h"

static NSTimeInterval const kDefaultOrientationAnimationDuration = 0.4;

@interface HMImagePopController ()

@property (nonatomic, assign) UIDeviceOrientation previousOrientation;

@end

@implementation HMImagePopController
@synthesize previousOrientation;
@synthesize scrollView;
@synthesize mainImageView;
@synthesize contentView;

- (void)dealloc{
    self.scrollView = nil;
    self.mainImageView = nil;
    self.contentView = nil;
    [super dealloc];
}


- (void)viewDidLoad{
    self.contentView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:self.contentView];

    
    self.mainImageView = [[[UIImageView alloc] initWithFrame:self.contentView.bounds] autorelease];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.mainImageView];
    
    
}

- (void)viewDidUnload
{
    [self setMainImageView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark IOS 6

-(NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;  // 可以修改为任何方向
}

-(BOOL)shouldAutorotate{
    
    return YES;
}


- (BOOL)isParentSupportingInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch(toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortraitUpsideDown;
            
        case UIInterfaceOrientationLandscapeLeft:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeLeft;
            
        case UIInterfaceOrientationLandscapeRight:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeRight;
    }
}

#pragma mark - Public
- (void)updateOrientationAnimated:(BOOL)animated
{
    return;
    
    CGAffineTransform transform;
    CGRect frame;
    NSTimeInterval duration = kDefaultOrientationAnimationDuration;
    
    if([UIDevice currentDevice].orientation == self.previousOrientation)
        return;
    
    if((UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsLandscape(self.previousOrientation))
       || (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsPortrait(self.previousOrientation)))
    {
        duration *= 2;
    }
    
    if(([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait)
       || [self isParentSupportingInterfaceOrientation:[UIDevice currentDevice].orientation])
    {
        transform = CGAffineTransformIdentity;
    }
    else
    {
        switch ([UIDevice currentDevice].orientation)
        {
            case UIInterfaceOrientationLandscapeLeft:
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait)
                {
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                else
                {
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait)
                {
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }
                else
                {
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                break;
                
            case UIInterfaceOrientationPortrait:
                transform = CGAffineTransformIdentity;
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
                
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationUnknown:
                return;
        }
    }
    
    if(animated)
    {
        frame = self.contentView.frame;
        [UIView animateWithDuration:duration
                         animations:^{
                             self.contentView.transform = transform;
                             self.contentView.frame = frame;
                         }];
    }
    else
    {
        frame = self.contentView.frame;
        self.contentView.transform = transform;
        self.contentView.frame = frame;
    }
    self.previousOrientation = [UIDevice currentDevice].orientation;
}

#pragma mark - Notifications
- (void)orientationDidChangeNotification:(NSNotification *)notification
{
    [self updateOrientationAnimated:YES];
}
@end
