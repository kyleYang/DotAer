//
//  BqsNewsPaperItemView.m
//  iMobeeNews
//
//  Created by ellison on 11-9-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsNewsPaperItemView.h"

@interface BqsNewsPaperItemView()
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) UIView *contentView;

-(void)onTouchUpInside:(id)sender;
@end

@implementation BqsNewsPaperItemView
@synthesize callback;
@synthesize identifier;
@synthesize contentView;

- (id)initWithFrame:(CGRect)frame Identifier:(NSString*)aIdentifier
{
    self = [super initWithFrame:frame];
    if(nil == self) return nil;
        
    self.identifier = aIdentifier;
    
    self.contentView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.userInteractionEnabled = NO;
    [self addSubview:self.contentView];

    [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    return self;
}

- (void)dealloc
{
    self.callback = nil;
    self.identifier = nil;
    self.contentView = nil;

    [super dealloc];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - ui responder
-(void)onTouchUpInside:(id)sender {
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNewsPaperItemViewDidTap:)]) {
        [self.callback bqsNewsPaperItemViewDidTap:self];
    }
}

@end
