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
#import "LeavesCache.h"

@protocol LeavesViewDataSource;
@protocol LeavesViewDelegate;

#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)

@interface LeavesView : UIView {
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
	id<LeavesViewDelegate> delegate;
	
	CGSize pageSize;
	LeavesCache *pageCache;
	CGFloat preferredTargetWidth;
	BOOL backgroundRendering;
	
	CGPoint touchBeganPoint;
	BOOL touchIsActive;
    BOOL pageChanged;
    int touchOtherEvent;//判断是不是有其他的事件，除了翻书
	CGRect nextPageRect, prevPageRect;
	BOOL interactionLocked;
    
    NSTextCheckingResult* activeLink;
    CTFrameRef _textFrame;
    NSAttributedString* _attributedText; //!< Internally mutable, but externally immutable copy access only
    NSMutableArray* customLinks; //for link
    CGRect drawingRect;
}

@property (assign) id<LeavesViewDataSource> dataSource;
@property (assign) id<LeavesViewDelegate> delegate;

// the automatically determined width of the interactive areas on either side of the page
@property (readonly) CGFloat targetWidth;

// set this to a nonzero value to get a targetWidth other than the default
@property (assign) CGFloat preferredTargetWidth;

// the zero-based index of the page currently being displayed.
@property (assign) NSUInteger currentPageIndex;

// If backgroundRendering is YES, some pages not currently being displayed will be pre-rendered in background threads.
// The default value is NO.  Only set this to YES if your implementation of the data source methods is thread-safe.
@property (assign) BOOL backgroundRendering;

// refreshes the contents of all pages via the data source methods, much like -[UITableView reloadData]
- (void) reloadData;
- (void) flush;
- (CTFrameRef)getCurentFrame;

- (void)reloadCurrentPage:(NSUInteger)page;


@property(nonatomic, retain) NSAttributedString* attributedText; //!< Use this instead of the "text" property inherited from UILabel to set and get text

-(void)addCustomLink:(NSURL*)linkUrl inRange:(NSRange)range;
-(void)removeAllCustomLinks;

@end


@protocol LeavesViewDataSource <NSObject>

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView;
- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;

@optional
-(void)leafAddLinker:(LeavesView *)leaf withLines:(NSMutableArray *)allLinkes withFrame:(CTFrameRef)frame;
- (CTFrameRef)getTextFrameAtPage:(NSUInteger)index;
- (NSMutableAttributedString *)getAttributedTextAtPage:(NSUInteger)index;
- (void) asyRenderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;



@end


@protocol LeavesViewDelegate <NSObject>

@required

- (void)leavef:(LeavesView *)leaf showController:(BOOL)visiale;

@optional


- (BOOL)leavef:(LeavesView *)leaf shouldFollowLink:(NSTextCheckingResult*)active;

// called when touch a event over to call the event except book events

- (void) excuteEventAtIndex:(int)index atPageIndex:(NSUInteger)pageIndex;

// called for the touched page have other Events like touch a image or a link
- (int) eventTouchAtPoint:(CGPoint)point atPageIndex:(NSUInteger)pageIndex;

// called when the user touches up on the left or right side of the page, or finishes dragging the page
- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex;

// called when the page-turn animation (following a touch-up or drag) completes 
- (void) leavesView:(LeavesView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex;

@end

