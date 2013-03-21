//
//  BqsLauncherButton.m
//  iMobeeBook
//
//  Created by ellison on 11-8-2.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsLauncherButton.h"
#import "BqsCustomBadge.h"
#import "BqsCloseButton.h"
#import "BqsColorAdditions.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface BqsLauncherButton()
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) BqsCloseButton* btnClose;
@property (nonatomic, retain) BqsCustomBadge* vBadage;

-(void)onClickCloseButton;
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BqsLauncherButton

@synthesize identifier;
@synthesize contentView;
@synthesize badage = _badage;
@synthesize editing = _editing;
@synthesize dragging = _dragging;
@synthesize callback;

@synthesize btnClose;
@synthesize vBadage;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame Identifier:(NSString*)aIdentifier {
    self = [self initWithFrame:frame];
    if(nil == self) return nil;
    
    _savedDragSize = frame.size;
    
    self.identifier = aIdentifier;
    
    self.contentView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentView.userInteractionEnabled = NO;
    [self addSubview:self.contentView];
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    
    self.identifier = nil;
    self.contentView = nil;
    self.badage = nil;

    self.vBadage = nil;
    self.btnClose = nil;
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBadage:(NSString *)badage {
    [_badage release];
    _badage = [badage copy];
    
    if(nil == _badage || [_badage length] < 1) {
        [self.vBadage removeFromSuperview];
        self.vBadage = nil;
    } else {
        if(nil == self.vBadage) {
            self.vBadage = [[[BqsCustomBadge alloc] init] autorelease];
            self.vBadage.backgroundColor = [UIColor clearColor];
            self.vBadage.userInteractionEnabled = NO;
            [self addSubview:self.vBadage];
        }
        
        self.vBadage.badgeText = _badage;
        [self.vBadage sizeToFit];
        [self setNeedsLayout];
    }    
}

-(void)onClickCloseButton {
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsLauncherButtonDidClickCloseButton:)]) {
        [self.callback bqsLauncherButtonDidClickCloseButton:self];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIResponder


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[self nextResponder] touchesBegan:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [[self nextResponder] touchesMoved:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [[self nextResponder] touchesEnded:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIControl


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted {
    return !_dragging && [super isHighlighted];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
        
    [self setNeedsDisplay];
    
}
- (BOOL)isSelected {
    return !_dragging && [super isSelected];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (nil != self.vBadage || nil != self.btnClose) {
        CGRect rc = self.bounds;
        
        if (nil != self.vBadage) {
            CGRect rcBadage = self.vBadage.frame;
            self.vBadage.center = CGPointMake(CGRectGetMaxX(rc)-(floor(CGRectGetWidth(rcBadage)*.2)),
                                        CGRectGetMinY(rc)+(floor(CGRectGetHeight(rcBadage)*.25)));
        }
        
        if (self.btnClose) {
            CGRect rcClose = self.btnClose.frame;
            self.btnClose.center = CGPointMake(CGRectGetMinX(rc)+(floor(CGRectGetWidth(rcClose)*.4)), 
                                              CGRectGetMinY(rc)+(floor(CGRectGetHeight(rcClose)*.4)));
        }
    }
}

//-(void)drawRect:(CGRect)rect {
//    [_item.callback bqsLauncherItem:_item Draw:rect];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDragging:(BOOL)dragging {
    if (_dragging != dragging) {
        _dragging = dragging;
        
        if (dragging) {
//            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            CGRect rc = self.frame;
            _savedDragSize = rc.size;
            rc = CGRectInset(rc, -round(.1 * _savedDragSize.width), -round(.1 * _savedDragSize.height));
            
            self.frame = rc;
            
        } else {
//            self.transform = CGAffineTransformIdentity;
            CGRect rc = self.frame;
            float dx = floor((_savedDragSize.width - CGRectGetWidth(rc)) / 2.0);
            float dy = floor((_savedDragSize.height - CGRectGetHeight(rc)) / 2.0);
            
            self.frame = CGRectMake(CGRectGetMinX(rc) - dx, CGRectGetMinY(rc) - dy, _savedDragSize.width, _savedDragSize.height);
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEditing:(BOOL)editing {
    if (_editing != editing) {
        _editing = editing;
        
        CGRect rcContent = self.bounds;
        
        if (editing) {
            if(nil == self.btnClose) {
                self.btnClose = [[[BqsCloseButton alloc] init] autorelease];
                [self.btnClose sizeToFit];
            }
            [self addSubview:self.btnClose];
            [self.btnClose addTarget:self action:@selector(onClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
            
            float dx = floor(CGRectGetWidth(btnClose.frame)/2);
            rcContent = CGRectInset(rcContent, dx, dx);
            
        } else {
            [self.btnClose removeFromSuperview];
            self.btnClose = nil;
        }
        
        if(!CGRectEqualToRect(rcContent, self.contentView.frame)) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:.2];
            
            self.contentView.frame = rcContent;
            
//            [UIView commitAnimations];
        }
    }
}


@end
