//
//  LeavesView.h
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "LeavesPadCache.h"

@protocol LeavesPadViewDataSource;
@protocol LeavesPadViewDelegate;

#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)

@interface LeavesPadView : UIView {
	CALayer *topPage;
	CALayer *topPageOverlay;
	CAGradientLayer *topPageShadow;
	
	CALayer *topPageReverse;
	CALayer *topPageReverseImage;
	CALayer *topPageReverseOverlay;
	CAGradientLayer *topPageReverseShading;
	
	CALayer *bottomPage;
	CAGradientLayer *bottomPageShadow;
	
	CGFloat leafEdge;
	NSUInteger currentPageIndex;
	NSUInteger numberOfPages;
	id<LeavesPadViewDelegate> delegate;
	
	CGSize pageSize;
	LeavesPadCache *pageCache;
	CGFloat preferredTargetWidth;
	BOOL backgroundRendering;
	
	CGPoint touchBeganPoint;
	BOOL touchIsActive;
    BOOL pageChanged;
    int touchOtherEvent;//判断是不是有其他的事件，除了翻书
	CGRect nextPageRect, prevPageRect;
	BOOL interactionLocked;
    
    NSTextCheckingResult* activeLink;
    CTFrameRef _leftTextFrame;
    CTFrameRef _rightTextFrame;
    NSAttributedString* _leftAttributedText; //!< Internally mutable, but externally immutable copy access only
    NSAttributedString* _rightAttributedText;
    NSMutableArray* leftCustomLinks; //for link
    NSMutableArray* rightCustomLinks;
    
    CGRect drawingRect;
}

@property (assign) id<LeavesPadViewDataSource> dataSource;
@property (assign) id<LeavesPadViewDelegate> delegate;

// the automatically determined width of the interactive areas on either side of the page
@property (readonly) CGFloat targetWidth;

// set this to a nonzero value to get a targetWidth other than the default
@property (nonatomic,assign) CGFloat preferredTargetWidth;

// the zero-based index of the page currently being displayed.
@property (nonatomic,assign) NSUInteger currentPageIndex;

// If backgroundRendering is YES, some pages not currently being displayed will be pre-rendered in background threads.
// The default value is NO.  Only set this to YES if your implementation of the data source methods is thread-safe.
@property (assign) BOOL backgroundRendering;

// refreshes the contents of all pages via the data source methods, much like -[UITableView reloadData]
- (void) reloadData;
- (void) flush;
- (CTFrameRef)getCurentFrame;

- (void)reloadCurrentPage:(NSUInteger)page;


@property(nonatomic, retain) NSAttributedString* leftAttributedText; //!< Use this instead of the "text" property inherited from UILabel to set and get text
@property(nonatomic, retain) NSAttributedString* rightAttributedText;

-(void)addCustomLink:(NSURL*)linkUrl inRange:(NSRange)range isLeft:(BOOL)left;
-(void)removeAllLeftCustomLinks;
-(void)removeAllRightCustomLinks;

@end


@protocol LeavesPadViewDataSource <NSObject>

- (NSUInteger) numberOfPagesInLeavesView:(LeavesPadView*)leavesView;
- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx isleft:(BOOL)left;

@optional
-(void)leafAddLinker:(LeavesPadView *)leaf withLines:(NSMutableArray *)allLinkes withFrame:(CTFrameRef)frame isLeft:(BOOL)left;
- (CTFrameRef)getTextFrameAtPage:(NSUInteger)index isLeft:(BOOL)left;
- (NSMutableAttributedString *)getAttributedTextAtPage:(NSUInteger)index isLeft:(BOOL)left;
- (void) asyRenderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx isLeft:(BOOL)left;



@end


@protocol LeavesPadViewDelegate <NSObject>

@optional


- (BOOL)leavef:(LeavesPadView *)leaf shouldFollowLink:(NSTextCheckingResult*)active;

// called when touch a event over to call the event except book events

- (void) excuteEventAtIndex:(int)index atPageIndex:(NSUInteger)pageIndex;

// called for the touched page have other Events like touch a image or a link
- (int) eventTouchAtPoint:(CGPoint)point atPageIndex:(NSUInteger)pageIndex;

// called when the user touches up on the left or right side of the page, or finishes dragging the page
- (void) leavesView:(LeavesPadView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex;

// called when the page-turn animation (following a touch-up or drag) completes 
- (void) leavesView:(LeavesPadView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex;

@end

