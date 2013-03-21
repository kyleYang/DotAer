//
//  LeavesView.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "LeavesView.h"
#import "NSAttributedString+Attributes.h"

@interface LeavesView ()

CGPoint CGPointFlipped(CGPoint point, CGRect bounds);
CGRect CGRectFlipped(CGRect rect, CGRect bounds);
NSRange NSRangeFromCFRange(CFRange range);
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin);
CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin);
BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range);
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range);
CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment);
CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode);

/////////////////////////////////////////////////////////////////////////////
// MARK: -
/////////////////////////////////////////////////////////////////////////////


CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment) {
	switch (alignment) {
		case UITextAlignmentLeft: return kCTLeftTextAlignment;
		case UITextAlignmentCenter: return kCTCenterTextAlignment;
		case UITextAlignmentRight: return kCTRightTextAlignment;
		case UITextAlignmentJustify: return kCTJustifiedTextAlignment; /* special OOB value if we decide to use it even if it's not really standard... */
		default: return kCTNaturalTextAlignment;
	}
}

CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode) {
	switch (lineBreakMode) {
		case UILineBreakModeWordWrap: return kCTLineBreakByWordWrapping;
		case UILineBreakModeCharacterWrap: return kCTLineBreakByCharWrapping;
		case UILineBreakModeClip: return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation: return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation: return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation: return kCTLineBreakByTruncatingMiddle;
		default: return 0;
	}
}

// Don't use this method for origins. Origins always depend on the height of the rect.
CGPoint CGPointFlipped(CGPoint point, CGRect bounds) {
	return CGPointMake(point.x, CGRectGetMaxY(bounds)-point.y);
}

CGRect CGRectFlipped(CGRect rect, CGRect bounds) {
	return CGRectMake(CGRectGetMinX(rect),
					  CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
					  CGRectGetWidth(rect),
					  CGRectGetHeight(rect));
}

NSRange NSRangeFromCFRange(CFRange range) {
	return NSMakeRange(range.location, range.length);
}

// Font Metrics: http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/FontHandling/Tasks/GettingFontMetrics.html
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin) {
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGFloat height = ascent + descent /* + leading */;
	
	return CGRectMake(lineOrigin.x,
					  lineOrigin.y - descent,
					  width,
					  height);
}

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin) {
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
	CGFloat height = ascent + descent /* + leading */;
	
	CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
	
	return CGRectMake(lineOrigin.x + xOffset,
					  lineOrigin.y - descent,
					  width,
					  height);
}

BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range) {
	NSRange lineRange = NSRangeFromCFRange(CTLineGetStringRange(line));
	NSRange intersectedRange = NSIntersectionRange(lineRange, range);
	return (intersectedRange.length > 0);
}

BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range) {
	NSRange runRange = NSRangeFromCFRange(CTRunGetStringRange(run));
	NSRange intersectedRange = NSIntersectionRange(runRange, range);
	return (intersectedRange.length > 0);
}

@property (assign) CGFloat leafEdge;

@end





CGFloat distance(CGPoint a, CGPoint b);


@implementation LeavesView

@synthesize delegate;
@synthesize leafEdge, currentPageIndex, backgroundRendering, preferredTargetWidth;
@synthesize attributedText = _attributedText;

- (void) setUpLayers {
	self.clipsToBounds = YES;
	
    CGFloat scale = [UIScreen mainScreen].scale;
    
	topPage = [[CALayer alloc] init];
	topPage.masksToBounds = YES;
    topPage.contentsScale = scale;
	topPage.contentsGravity = kCAGravityLeft;
	topPage.backgroundColor = [[UIColor whiteColor] CGColor];
	
	topPageOverlay = [[CALayer alloc] init];
    topPageOverlay.contentsScale = scale;
	topPageOverlay.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
	
	topPageShadow = [[CAGradientLayer alloc] init];
	topPageShadow.colors = [NSArray arrayWithObjects:
							(id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
							(id)[[UIColor clearColor] CGColor],
							nil];
	topPageShadow.startPoint = CGPointMake(1,0.5);
	topPageShadow.endPoint = CGPointMake(0,0.5);
	
	topPageReverse = [[CALayer alloc] init];
    topPageReverse.contentsScale = scale;
	topPageReverse.backgroundColor = [[UIColor whiteColor] CGColor];
	topPageReverse.masksToBounds = YES;
	
	topPageReverseImage = [[CALayer alloc] init];
	topPageReverseImage.masksToBounds = YES;
    topPageReverseImage.contentsScale = scale;
	topPageReverseImage.contentsGravity = kCAGravityRight;
	
	topPageReverseOverlay = [[CALayer alloc] init];
    topPageReverseOverlay.contentsScale = scale;
	topPageReverseOverlay.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.8] CGColor];
	
	topPageReverseShading = [[CAGradientLayer alloc] init];
    topPageReverseShading.contentsScale = scale;
	topPageReverseShading.colors = [NSArray arrayWithObjects:
									(id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
									(id)[[UIColor clearColor] CGColor],
									nil];
	topPageReverseShading.startPoint = CGPointMake(1,0.5);
	topPageReverseShading.endPoint = CGPointMake(0,0.5);
	
	bottomPage = [[CALayer alloc] init];
    bottomPage.contentsScale = scale;
	bottomPage.backgroundColor = [[UIColor whiteColor] CGColor];
	bottomPage.masksToBounds = YES;
	
	bottomPageShadow = [[CAGradientLayer alloc] init];
	bottomPageShadow.colors = [NSArray arrayWithObjects:
							   (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
							   (id)[[UIColor clearColor] CGColor],
							   nil];
    bottomPageShadow.contentsScale = scale;
	bottomPageShadow.startPoint = CGPointMake(0,0.5);
	bottomPageShadow.endPoint = CGPointMake(1,0.5);
	
	[topPage addSublayer:topPageShadow];
	[topPage addSublayer:topPageOverlay];
	[topPageReverse addSublayer:topPageReverseImage];
	[topPageReverse addSublayer:topPageReverseOverlay];
	[topPageReverse addSublayer:topPageReverseShading];
	[bottomPage addSublayer:bottomPageShadow];
	[self.layer addSublayer:bottomPage];
	[self.layer addSublayer:topPage];
	[self.layer addSublayer:topPageReverse];
	
	self.leafEdge = 1.0;
}

- (void) initialize {
	backgroundRendering = NO;
	pageCache = [[LeavesCache alloc] initWithPageSize:self.bounds.size];
    NSLog(@"the screen size is widht =%f heigh = %f",CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds));
    customLinks = [[NSMutableArray alloc] init];
    drawingRect = self.bounds;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setUpLayers];
		[self initialize];
    }
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self setUpLayers];
	[self initialize];
}

- (void)dealloc {
	[topPage release];
	[topPageShadow release];
	[topPageOverlay release];
	[topPageReverse release];
	[topPageReverseImage release];
	[topPageReverseOverlay release];
	[topPageReverseShading release];
	[bottomPage release];
	[bottomPageShadow release];
    [activeLink release];
	
    [_attributedText release];
	[pageCache release];
    [customLinks release];
	
    [super dealloc];
}

- (void) flush{
    [pageCache flush];
    numberOfPages = [pageCache.dataSource numberOfPagesInLeavesView:self];
}

- (void) reloadData {
	[pageCache flush];
	numberOfPages = [pageCache.dataSource numberOfPagesInLeavesView:self];
	self.currentPageIndex = 0;
}

- (void)reloadCurrentPage:(NSUInteger)page    //editby kyle yang for asynchronous image download
{
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
    if (page < numberOfPages) {
        [pageCache reloadImageForPageIndex:page];
        if (page < numberOfPages - 1) {
            [pageCache reloadImageForPageIndex:currentPageIndex+1];
        }
    }
    
    
	if (currentPageIndex < numberOfPages) {
        topPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
		topPageReverseImage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
        _textFrame = [pageCache.dataSource getTextFrameAtPage:currentPageIndex];
        self.attributedText = [pageCache.dataSource getAttributedTextAtPage:currentPageIndex];
        [pageCache.dataSource leafAddLinker:self withLines:nil withFrame:_textFrame];
		if (currentPageIndex < numberOfPages - 1)
			bottomPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex + 1];
		[pageCache minimizeToPageIndex:currentPageIndex];
	} else {
		topPage.contents = nil;
        _textFrame = nil;
        self.attributedText = nil;
		topPageReverseImage.contents = nil;
		bottomPage.contents = nil;
	}

	
	
	self.leafEdge = 1.0;
    [CATransaction commit];

}

- (void) getImages {
	if (currentPageIndex < numberOfPages) {
		if (currentPageIndex > 0 && backgroundRendering)
			[pageCache precacheImageForPageIndex:currentPageIndex-1];
		topPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
		topPageReverseImage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
        _textFrame = [pageCache.dataSource getTextFrameAtPage:currentPageIndex];
        self.attributedText = [pageCache.dataSource getAttributedTextAtPage:currentPageIndex];
        [pageCache.dataSource leafAddLinker:self withLines:nil withFrame:_textFrame];
		if (currentPageIndex < numberOfPages - 1)
			bottomPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex + 1];
		[pageCache minimizeToPageIndex:currentPageIndex];
	} else {
		topPage.contents = nil;
        _textFrame = nil;
        self.attributedText = nil;
		topPageReverseImage.contents = nil;
		bottomPage.contents = nil;
	}
}

- (void) setLayerFrames {
	topPage.frame = CGRectMake(self.layer.bounds.origin.x, 
							   self.layer.bounds.origin.y, 
							   leafEdge * self.bounds.size.width, 
							   self.layer.bounds.size.height);
	topPageReverse.frame = CGRectMake(self.layer.bounds.origin.x + (2*leafEdge-1) * self.bounds.size.width, 
									  self.layer.bounds.origin.y, 
									  (1-leafEdge) * self.bounds.size.width, 
									  self.layer.bounds.size.height);
	bottomPage.frame = self.layer.bounds;
	topPageShadow.frame = CGRectMake(topPageReverse.frame.origin.x - 40, 
									 0, 
									 40, 
									 bottomPage.bounds.size.height);
	topPageReverseImage.frame = topPageReverse.bounds;
	topPageReverseImage.transform = CATransform3DMakeScale(-1, 1, 1);
	topPageReverseOverlay.frame = topPageReverse.bounds;
	topPageReverseShading.frame = CGRectMake(topPageReverse.bounds.size.width - 50, 
											 0, 
											 50 + 1, 
											 topPageReverse.bounds.size.height);
	bottomPageShadow.frame = CGRectMake(leafEdge * self.bounds.size.width, 
										0, 
										40, 
										bottomPage.bounds.size.height);
	topPageOverlay.frame = topPage.bounds;
}

- (void) willTurnToPageAtIndex:(NSUInteger)index {
	if ([delegate respondsToSelector:@selector(leavesView:willTurnToPageAtIndex:)])
		[delegate leavesView:self willTurnToPageAtIndex:index];
}

- (void) didTurnToPageAtIndex:(NSUInteger)index {
	if ([delegate respondsToSelector:@selector(leavesView:didTurnToPageAtIndex:)])
		[delegate leavesView:self didTurnToPageAtIndex:index];
}

- (void) didTurnPageBackward {
	interactionLocked = NO;
	[self didTurnToPageAtIndex:currentPageIndex];
}

- (void) didTurnPageForward {
	interactionLocked = NO;
	self.currentPageIndex = self.currentPageIndex + 1;	
	[self didTurnToPageAtIndex:currentPageIndex];
}

- (BOOL) hasPrevPage {
	return self.currentPageIndex > 0;
}

- (BOOL) hasNextPage {
	return self.currentPageIndex < numberOfPages - 1;
}

- (BOOL) touchedNextPage {
	return CGRectContainsPoint(nextPageRect, touchBeganPoint);
}

- (BOOL) touchedPrevPage {
	return CGRectContainsPoint(prevPageRect, touchBeganPoint);
}

- (CGFloat) dragThreshold {
	// Magic empirical number
	return 10;
}

- (CGFloat) targetWidth {
	// Magic empirical formula
	if (preferredTargetWidth > 0 && preferredTargetWidth < self.bounds.size.width / 2)
		return preferredTargetWidth;
	else
		return MAX(28, self.bounds.size.width / 5);
}

- (void) updateTargetRects {
	CGFloat targetWidth = [self targetWidth];
	nextPageRect = CGRectMake(self.bounds.size.width - targetWidth,
							  0,
							  targetWidth,
							  self.bounds.size.height);
	prevPageRect = CGRectMake(0,
							  0,
							  targetWidth,
							  self.bounds.size.height);
}

#pragma mark accessors

- (id<LeavesViewDataSource>) dataSource {
	return pageCache.dataSource;
	
}

- (void) setDataSource:(id<LeavesViewDataSource>)value {
	pageCache.dataSource = value;
}

- (void) setLeafEdge:(CGFloat)aLeafEdge {
	leafEdge = aLeafEdge;
	topPageShadow.opacity = MIN(1.0, 4*(1-leafEdge));
	bottomPageShadow.opacity = MIN(1.0, 4*leafEdge);
	topPageOverlay.opacity = MIN(1.0, 4*(1-leafEdge));
	[self setLayerFrames];
}

- (void) setCurrentPageIndex:(NSUInteger)aCurrentPageIndex {
	currentPageIndex = aCurrentPageIndex;
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	
	[self getImages];
	
	self.leafEdge = 1.0;
	
	[CATransaction commit];
}

- (void) setPreferredTargetWidth:(CGFloat)value {
	preferredTargetWidth = value;
	[self updateTargetRects];
}




- (void)setAttributedText:(NSAttributedString *)aattributedText
{
    [_attributedText release];
    _attributedText = [aattributedText retain];
    [self removeAllCustomLinks];
}

- (CTFrameRef)getCurentFrame{
    return _textFrame;
}

/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: Links Mgmt
/////////////////////////////////////////////////////////////////////////////


-(void)addCustomLink:(NSURL*)linkUrl inRange:(NSRange)range {
	NSTextCheckingResult* link = [NSTextCheckingResult linkCheckingResultWithRange:range URL:linkUrl];
	[customLinks addObject:link];
    
}

-(void)removeAllCustomLinks {
	[customLinks removeAllObjects];
	
}

//-(NSMutableAttributedString*)attributedTextWithLinks {
//    //    NSLog(@"customLinks:%@", customLinks);
//	NSMutableAttributedString* str = [self.attributedText mutableCopy];
//	if (!str) return nil;
//	NSString* plainText = [str string];
//	if (plainText && (self.automaticallyAddLinksForType > 0)) {
//		NSError* error = nil;
//		NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:self.automaticallyAddLinksForType error:&error];
//		[linkDetector enumerateMatchesInString:plainText options:0 range:NSMakeRange(0,[plainText length])
//									usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
//		 {
//			 int32_t uStyle = self.underlineLinks ? kCTUnderlineStyleSingle : kCTUnderlineStyleNone;
//			 UIColor* thisLinkColor = (self.delegate && [self.delegate respondsToSelector:@selector(colorForLink:underlineStyle:)])
//			 ? [self.delegate colorForLink:result underlineStyle:&uStyle] : self.linkColor;
//			 
//			 if (thisLinkColor)
//				 [str setTextColor:thisLinkColor range:[result range]];
//			 if (uStyle>0)
//				 [str setTextUnderlineStyle:uStyle range:[result range]];
//		 }];
//	}
//	[customLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//	 {
//		 NSTextCheckingResult* result = (NSTextCheckingResult*)obj;
//		 
//		 int32_t uStyle = self.underlineLinks ? kCTUnderlineStyleSingle : kCTUnderlineStyleNone;
//		 UIColor* thisLinkColor = (self.delegate && [self.delegate respondsToSelector:@selector(colorForLink:underlineStyle:)])
//		 ? [self.delegate colorForLink:result underlineStyle:&uStyle] : self.linkColor;
//		 
//		 @try {
//			 if (thisLinkColor)
//				 [str setTextColor:thisLinkColor range:[result range]];
//			 if (uStyle>0)
//				 [str setTextUnderlineStyle:uStyle range:[result range]];
//		 }
//		 @catch (NSException * e) {
//			 // Protection against NSRangeException
//			 if ([[e name] isEqualToString:NSRangeException]) {
//				 NSLog(@"[OHAttributedLabel] exception: %@",e);
//			 } else {
//				 @throw;
//			 }
//		 }
//	 }];
//	return [str autorelease];
//}

-(NSTextCheckingResult*)linkAtCharacterIndex:(CFIndex)idx {
	__block NSTextCheckingResult* foundResult = nil;
	
//	NSString* plainText = [_attributedText string];
//	if (plainText && (self.automaticallyAddLinksForType > 0)) {
//		NSError* error = nil;
//		NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:self.automaticallyAddLinksForType error:&error];
//		[linkDetector enumerateMatchesInString:plainText options:0 range:NSMakeRange(0,[plainText length])
//									usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
//		 {
//			 NSRange r = [result range];
//			 if (NSLocationInRange(idx, r)) {
//				 foundResult = [[result retain] autorelease];
//				 *stop = YES;
//			 }
//		 }];
//		if (foundResult) return foundResult;
//	}
	
	[customLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger aidx, BOOL *stop)
	 {
		 NSRange r = [(NSTextCheckingResult*)obj range];
		 if (NSLocationInRange(idx, r)) {
			 foundResult = [[obj retain] autorelease];
			 *stop = YES;
		 }
	 }];
	return foundResult;
}

-(NSTextCheckingResult*)linkAtPoint:(CGPoint)point {
	static const CGFloat kVMargin = 5.f;
	if (!CGRectContainsPoint(drawingRect, point)) return nil;
	
	CFArrayRef lines = CTFrameGetLines(_textFrame);
	if (!lines) return nil;
	CFIndex nbLines = CFArrayGetCount(lines);
	NSTextCheckingResult* link = nil;
	
	CGPoint origins[nbLines];
	CTFrameGetLineOrigins(_textFrame, CFRangeMake(0,0), origins);
	
	for (int lineIndex=0 ; lineIndex<nbLines ; ++lineIndex) {
		// this actually the origin of the line rect, so we need the whole rect to flip it
		CGPoint lineOriginFlipped = origins[lineIndex];
		
		CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
		CGRect lineRectFlipped = CTLineGetTypographicBoundsAsRect(line, lineOriginFlipped);
		CGRect lineRect = CGRectFlipped(lineRectFlipped, CGRectFlipped(drawingRect,self.bounds));
		
		lineRect = CGRectInset(lineRect, 0, -kVMargin);
		if (CGRectContainsPoint(lineRect, point)) {
			CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(lineRect),
												point.y-CGRectGetMinY(lineRect));
			CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
			link = ([self linkAtCharacterIndex:idx]);
			if (link) return link;
		}
	}
	return nil;
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//	// never return self. always return the result of [super hitTest..].
//	// this takes userInteraction state, enabled, alpha values etc. into account
//	UIView *hitResult = [super hitTest:point withEvent:event];
//	
//	// don't check for links if the event was handled by one of the subviews
//	if (hitResult != self) {
//		return hitResult;
//	}
//	
//	
//		BOOL didHitLink = ([self linkAtPoint:point] != nil);
//		if (!didHitLink) {
//			// not catch the touch if it didn't hit a link
//			return nil;
//		}
//	
//	return hitResult;
//}



#pragma mark UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (interactionLocked)
		return;
	
	UITouch *touch = [event.allTouches anyObject];
	touchBeganPoint = [touch locationInView:self];
    if ([delegate respondsToSelector:@selector(eventTouchAtPoint:atPageIndex:)])
		touchOtherEvent = [delegate eventTouchAtPoint:touchBeganPoint atPageIndex:currentPageIndex];
    if (touchOtherEvent == -1) {
        [activeLink release]; activeLink = nil;
        activeLink = [[self linkAtPoint:touchBeganPoint] retain];
    }

	
	if ([self touchedPrevPage] && [self hasPrevPage]) {		
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
		self.currentPageIndex = self.currentPageIndex - 1;
		self.leafEdge = 0.0;
		[CATransaction commit];
		touchIsActive = YES;
		pageChanged = YES;
	} 
	else if ([self touchedNextPage] && [self hasNextPage])
		touchIsActive = YES;
	
	else 
		touchIsActive = NO;
    
       
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!touchIsActive)
		return;
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.07]
					 forKey:kCATransactionAnimationDuration];
	self.leafEdge = touchPoint.x / self.bounds.size.width;
	[CATransaction commit];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	BOOL dragged = distance(touchPoint, touchBeganPoint) > [self dragThreshold];
    
    if (!touchIsActive){
        NSTextCheckingResult *linkAtTouchesEnded = [self linkAtPoint:touchPoint];
        if (touchOtherEvent != -1 && !dragged) {
            if ([delegate respondsToSelector:@selector(eventTouchAtPoint:atPageIndex:)])
                [delegate excuteEventAtIndex:touchOtherEvent atPageIndex:currentPageIndex];
        }else if(activeLink && (NSEqualRanges(activeLink.range,linkAtTouchesEnded.range) || !dragged)){
            BOOL openLink = (delegate && [delegate respondsToSelector:@selector(leavef:shouldFollowLink:)])
            ? [delegate leavef:self shouldFollowLink:activeLink] : YES;
            if (openLink) [[UIApplication sharedApplication] openURL:activeLink.URL];
        }else{
            if (delegate && [delegate respondsToSelector:@selector(leavef:showController:)]){
                [delegate leavef:self showController:YES];
            }
        }
		return;
    }
	touchIsActive = NO;
	
	[CATransaction begin];
	float duration;
    
    if (dragged) {  //发生拖事件
        if (self.leafEdge < 0.5) { //发生翻页,下一页
            [self willTurnToPageAtIndex:currentPageIndex+1];
            self.leafEdge = 0;
            duration = leafEdge;
            interactionLocked = YES;
            if (currentPageIndex+2 < numberOfPages && backgroundRendering)
                [pageCache precacheImageForPageIndex:currentPageIndex+2];
            [self performSelector:@selector(didTurnPageForward)
                       withObject:nil 
                       afterDelay:duration + 0.25];
            
        }else{
            [self willTurnToPageAtIndex:currentPageIndex];
            self.leafEdge = 1.0;
            duration = 1 - leafEdge;
            interactionLocked = YES;
            [self performSelector:@selector(didTurnPageBackward)
                       withObject:nil
                       afterDelay:duration + 0.25];
            
        }
    }else{
        if (touchOtherEvent != -1) {
            if (pageChanged) {
                self.currentPageIndex = currentPageIndex+1;
            }
            if ([delegate respondsToSelector:@selector(eventTouchAtPoint:atPageIndex:)])
                 [delegate excuteEventAtIndex:touchOtherEvent atPageIndex:currentPageIndex];
            
            
            [self willTurnToPageAtIndex:currentPageIndex];
            self.leafEdge = 1.0;
            duration = 1 - leafEdge;
            interactionLocked = YES;
            [self performSelector:@selector(didTurnPageBackward)
                       withObject:nil
                       afterDelay:duration + 0.25];
            
        }else if(activeLink){
            if (pageChanged) {
                self.currentPageIndex = currentPageIndex+1;
            }
            BOOL openLink = (delegate && [delegate respondsToSelector:@selector(leavef:shouldFollowLink:)])
            ? [delegate leavef:self shouldFollowLink:activeLink] : YES;
            if (openLink) [[UIApplication sharedApplication] openURL:activeLink.URL];
            
            [self willTurnToPageAtIndex:currentPageIndex];
            self.leafEdge = 1.0;
            duration = 1 - leafEdge;
            interactionLocked = YES;
            [self performSelector:@selector(didTurnPageBackward)
                       withObject:nil
                       afterDelay:duration + 0.25];
            
        }else if([self touchedNextPage]){
            [self willTurnToPageAtIndex:currentPageIndex+1];
            self.leafEdge = 0;
            duration = leafEdge;
            interactionLocked = YES;
            if (currentPageIndex+2 < numberOfPages && backgroundRendering)
                [pageCache precacheImageForPageIndex:currentPageIndex+2];
            [self performSelector:@selector(didTurnPageForward)
                       withObject:nil 
                       afterDelay:duration + 0.25];

        }else{
            [self willTurnToPageAtIndex:currentPageIndex];
            self.leafEdge = 1.0;
            duration = 1 - leafEdge;
            interactionLocked = YES;
            [self performSelector:@selector(didTurnPageBackward)
                       withObject:nil
                       afterDelay:duration + 0.25];
            
        }

    }
    touchOtherEvent = -1;
    pageChanged = NO;
    
//	if ((dragged && self.leafEdge < 0.5) || (!dragged && [self touchedNextPage])) {
//		[self willTurnToPageAtIndex:currentPageIndex+1];
//		self.leafEdge = 0;
//		duration = leafEdge;
//		interactionLocked = YES;
//		if (currentPageIndex+2 < numberOfPages && backgroundRendering)
//			[pageCache precacheImageForPageIndex:currentPageIndex+2];
//		[self performSelector:@selector(didTurnPageForward)
//				   withObject:nil 
//				   afterDelay:duration + 0.25];
//	}else {
//		[self willTurnToPageAtIndex:currentPageIndex];
//		self.leafEdge = 1.0;
//		duration = 1 - leafEdge;
//		interactionLocked = YES;
//		[self performSelector:@selector(didTurnPageBackward)
//				   withObject:nil 
//				   afterDelay:duration + 0.25];
//	}
	[CATransaction setValue:[NSNumber numberWithFloat:duration]
					 forKey:kCATransactionAnimationDuration];
	[CATransaction commit];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	
	if (!CGSizeEqualToSize(pageSize, self.bounds.size)) {
		pageSize = self.bounds.size;
        drawingRect = self.bounds;
		
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
		[self setLayerFrames];
		[CATransaction commit];
		pageCache.pageSize = self.bounds.size;
		[self getImages];
		[self updateTargetRects];
	}
}

@end

CGFloat distance(CGPoint a, CGPoint b) {
	return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
}

