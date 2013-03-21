//
//  BqsNewsPaperPageView.m
//  iMobeeNews
//
//  Created by ellison on 11-9-1.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsNewsPaperPageView.h"
#import "BqsUtils.h"

@interface BqsNewsPaperPageView()
@property (nonatomic, retain) NSMutableDictionary *dicViews; // itemid->BqsNewsPaperItemView

@end

@implementation BqsNewsPaperPageView
@synthesize callback;

@synthesize pageLayout;
@synthesize pageId;

@synthesize fPaddingHor;
@synthesize fPaddingVer;
@synthesize fGap;
@synthesize bDrawGapLine;
@synthesize fGapLineWidth;
@synthesize gapLineColor;


@synthesize dicViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) return nil;
    
    self.opaque = NO;
    
    return self;
}


- (void)dealloc
{
    self.callback = nil;
    
    self.pageLayout = nil;
    self.gapLineColor = nil;

    self.dicViews = nil;

    [super dealloc];
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     CGContextRef context = UIGraphicsGetCurrentContext();
     
//     CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
//     CGContextFillRect(context, rect);
     
     // Drawing code
     if(!self.bDrawGapLine) return;
     
     NSRange rng = [self.pageLayout getItemIdsInPage:self.pageId];
     if(NSNotFound == rng.location || rng.length < 1) {
         return;
     }
     
     BqsNewsPaperPageLayout_enum layout = [self.pageLayout getLayoutInPage:self.pageId];
     
     UIEdgeInsets padding = UIEdgeInsetsMake(self.fPaddingVer, self.fPaddingHor, self.fPaddingVer, self.fPaddingHor);
     CGRect rc = [BqsUtils rect:self.bounds Inset:padding];
     
     NSArray *arr = [BqsNewsPaperPageLayout seperateLinesForLayout:layout Rect:rc];
     for( NSValue *v in arr) {
         CGRect line = [v CGRectValue];
         
         float dx = 0, dy = 0;
         if(line.origin.x == line.size.width) dx = .5;
         else dy = .5;
         
         CGContextBeginPath(context);
         CGContextMoveToPoint(context, line.origin.x+dx, line.origin.y+dy);
         CGContextAddLineToPoint(context, line.size.width+dx, line.size.height+dy);
         
         CGContextSetStrokeColorWithColor(context, self.gapLineColor.CGColor);
         CGContextSetLineWidth(context, self.fGapLineWidth);
         
         CGContextStrokePath(context);

     }
//     NSArray *arr = [BqsNewsPaperPageLayout rectsForLayout:layout Rect:rc Gap:0];
//     
//     float boundsMinX = CGRectGetMinX(rc);
//     float boundsMinY = CGRectGetMinY(rc);
//     float boundsMaxX = CGRectGetMaxX(rc);
//     float boundsMaxY = CGRectGetMaxY(rc);
//     
//     CGRect *doneLines = malloc(sizeof(CGRect) * rng.length * 4);
//     int doneLineCnt = 0;
//     
//     
//     for(NSValue *v in arr) {
//         
//         CGRect itemrc = [v CGRectValue];
//         
//         // check four borders
//         float minx = CGRectGetMinX(itemrc);
//         float miny = CGRectGetMinY(itemrc);
//         float maxx = CGRectGetMaxX(itemrc);
//         float maxy = CGRectGetMaxY(itemrc);
//
//         CGRect rcLines[4];
//         
//         rcLines[0] = CGRectMake(minx, miny, minx, maxy);// top
//         rcLines[1] = CGRectMake(maxx, miny, maxx, maxy);// right
//         rcLines[2] = CGRectMake(maxx, maxy, minx, maxy);// bottom
//         rcLines[3] = CGRectMake(minx, maxy, minx, miny);// left
//         
//         for(int line = 0; line < 4; line ++) {
//             CGPoint lineP1 = rcLines[line].origin;
//             CGPoint lineP2;
//             lineP2.x = rcLines[line].size.width;
//             lineP2.y = rcLines[line].size.height;
//             
//             // check should draw line
//             BOOL bShouldDraw = NO;
//             
//             if(lineP1.x == lineP2.x) {
//                 // ver line
//                 if(lineP1.x != boundsMinX && lineP1.x != boundsMaxX) {
//                     bShouldDraw = YES;
//                 }
//             } else if(lineP1.y == lineP2.y) {
//                 // hor line
//                 if(lineP1.y != boundsMinY && lineP1.y != boundsMaxY) {
//                     bShouldDraw = YES;
//                 }
//             }
//             
//             
//             if(bShouldDraw) {
//                 int i = 0;
//                 CGPoint p1, p2;
//                 for(i = 0; i < doneLineCnt; i ++) {
//                     p1 = doneLines[i].origin;
//                     p2.x = doneLines[line].size.width;
//                     p2.y = doneLines[line].size.height;
//
//                     if((CGPointEqualToPoint(lineP1, p1) && CGPointEqualToPoint(lineP2, p2)) ||
//                        (CGPointEqualToPoint(lineP1, p2) && CGPointEqualToPoint(lineP2, p1))) {
////                         BqsLog(@"ignore equal line (%.1f,%.1f)-(%.1f,%.1f)", lineP1.x, lineP1.y, lineP2.x, lineP2.y);
//                         break;
//                     }
//                 }
//                 if(i >= doneLineCnt) {
//                     doneLines[doneLineCnt++] = rcLines[line];
//                     
//                     // draw line
////                     BqsLog(@"draw line (%.1f,%.1f)-(%.1f,%.1f)", lineP1.x, lineP1.y, lineP2.x, lineP2.y);
//                     
//                     CGContextBeginPath(context);
//                     CGContextMoveToPoint(context, lineP1.x, lineP1.y);
//                     CGContextAddLineToPoint(context, lineP2.x, lineP2.y);
//                     
//                     CGContextSetStrokeColorWithColor(context, self.gapLineColor.CGColor);
//                     CGContextSetLineWidth(context, self.fGapLineWidth);
//                     
//                     CGContextStrokePath(context);
//                 }
//             }
//         }
//         
//     }
//     
//     free(doneLines);

 }


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if(self.bDrawGapLine) {
        [self setNeedsDisplay]; // re-draw background lines
    }
    
    NSRange rng = [self.pageLayout getItemIdsInPage:self.pageId];
    if(NSNotFound == rng.location || rng.length < 1) {
        return;
    }
    
    
    BqsNewsPaperPageLayout_enum layout = [self.pageLayout getLayoutInPage:self.pageId];
    
    BqsLog(@"layoutPage. layout: %d, number of view: %d", layout, rng.length);

    UIEdgeInsets padding = UIEdgeInsetsMake(self.fPaddingVer, self.fPaddingHor, self.fPaddingVer, self.fPaddingHor);
    CGRect rc = [BqsUtils rect:self.bounds Inset:padding];
    
    NSArray *arr = [BqsNewsPaperPageLayout rectsForLayout:layout Rect:rc Gap:self.fGap];
    
    if([arr count] < rng.length) {
        BqsLog(@"Invalid rects count: %d, itemcount: %d", [arr count], rng.length);
        return;
    }
    
    for(int i = 0; i < rng.length; i ++) {
        NSNumber *key = [NSNumber numberWithInt:i + rng.location];
        BqsNewsPaperItemView *item = [self.dicViews objectForKey:key];
        
        if(nil == item) continue;
        
        CGRect rc = [[arr objectAtIndex:i] CGRectValue];
        
        item.frame = rc;
    }
}

#pragma mark - BqsNewsPaperItemView_Callback

-(void)bqsNewsPaperItemViewDidTap:(BqsNewsPaperItemView*)itemView {
    int idx = -1;
    NSArray *ak = [self.dicViews allKeysForObject:itemView];
    if(nil != ak && [ak count] > 0) {
        NSNumber *key = [ak objectAtIndex:0];
        idx = [key intValue];
    }
    
    if(idx < 0) {
        BqsLog(@"Invalid itemView: %@, idx: %d", itemView, idx);
        return;
    }
    
    if(nil != self.callback && [self.callback respondsToSelector:@selector(bqsNewsPaperPageView:DidSelectItem:)]) {
        [self.callback bqsNewsPaperPageView:self DidSelectItem:idx];
    }
}


#pragma mark - my methods


#pragma mark - public method
-(void)unloadPage {
    self.pageLayout = nil;
    self.pageId = -1;
    
    // remove all item views
    if(nil != self.dicViews && [self.dicViews count] > 0) {
        NSArray *allK = [self.dicViews allKeys];
        if(nil != allK && [allK count] > 0) {
            for(NSNumber *key in allK) {
                BqsNewsPaperItemView *item = [self.dicViews objectForKey:key];
                
                [self.callback bqsNewsPaperPageView:self RecycleItemView:item ItemIdx:[key intValue]];
                [item removeFromSuperview];
            }
        }
        [self.dicViews removeAllObjects];
    }
    [self setNeedsDisplay];
}

-(void)loadPage {
    if(nil == self.pageLayout) {
        BqsLog(@"Invalid pagelayout");
        return ;
    }
    
    NSRange rng = [self.pageLayout getItemIdsInPage:self.pageId];
    if(NSNotFound == rng.location) {
        BqsLog(@"page not found: %d", self.pageId);
        return;
    }
    
    int minItemId = rng.location;
    int maxItemId = rng.location + rng.length - 1;
    
    // remove not exist
    if(nil != self.dicViews && [self.dicViews count] > 0) {
        NSArray *allK = [self.dicViews allKeys];
        if(nil != allK && [allK count] > 0) {
            for(NSNumber *key in allK) {
                int itemid = [key intValue];
                if(itemid < minItemId || itemid > maxItemId) {
                    BqsNewsPaperItemView *item = [self.dicViews objectForKey:key];
                    
                    [self.callback bqsNewsPaperPageView:self RecycleItemView:item ItemIdx:[key intValue]];
                    [item removeFromSuperview];
                    
                    [self.dicViews removeObjectForKey:key];
                }
            }
        }
    }
    
    // create pages
    if(nil == self.dicViews) self.dicViews = [NSMutableDictionary dictionaryWithCapacity:rng.length + 1];
    
    if(rng.length > 0) {
        for(int i = minItemId; i <= maxItemId; i ++) {
            NSNumber *key = [NSNumber numberWithInt:i];
            BqsNewsPaperItemView *itemView = [self.dicViews objectForKey:key];
            if(nil == itemView) {
                itemView = [self.callback bqsNewsPaperPageView:self GetViewForItem:i];
                itemView.callback = self;
                [self addSubview:itemView];
                [self.dicViews setObject:itemView forKey:key];
            }
        }
    }
    
    // re-locate items
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


-(UIView*)viewOfIndex:(int)idx {
    NSNumber *key = [NSNumber numberWithInt:idx];
    BqsNewsPaperItemView *item = [self.dicViews objectForKey:key];
    if(nil != item) {
        return item;
    }
    
    return nil;
}


@end
