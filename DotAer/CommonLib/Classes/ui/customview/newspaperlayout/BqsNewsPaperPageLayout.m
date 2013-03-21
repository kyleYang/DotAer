//
//  BqsNewsPaperPageLayout.m
//  iMobeeNews
//
//  Created by ellison on 11-8-30.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "BqsNewsPaperPageLayout.h"
#import "BqsUtils.h"

#define kMark 0x4273516c

typedef struct {
    unsigned int mark; // mark
	int nTotalItemCnt;
    int nPageCnt;
	int pageLayouts[1];
} t_Layout_Header;


@interface BqsNewsPaperPageLayout()
@property (nonatomic, retain) NSData *dataLayout;


-(NSData*)decodeDataFromString:(NSString*)str;
-(NSString*)encodeDataToString:(NSData*)data;
-(void)genLayout:(int)totalItemCnt;
-(BqsNewsPaperPageLayout_enum)genOnePageLayout:(int)itemInPage;

@end

@implementation BqsNewsPaperPageLayout
@synthesize dataLayout;

+(BqsNewsPaperPageLayout*)layoutWithData:(NSString*)data {
    BqsNewsPaperPageLayout *ret = [[[BqsNewsPaperPageLayout alloc] init] autorelease];
    
    ret.dataLayout = [ret decodeDataFromString:data];
    if(nil == ret.dataLayout) {
        BqsLog(@"Failed decode str: %@", data);
        return nil;
    }
    return ret;
}

+(int)getPageLayoutItemCnt:(BqsNewsPaperPageLayout_enum)pageLayout {
    if(PageLayout_3_1 <= pageLayout && pageLayout <= PageLayout_3_5) return 3;
    if(PageLayout_4_1 <= pageLayout && pageLayout <= PageLayout_4_5) return 4;
    if(PageLayout_1 == pageLayout) return 1;
    if(PageLayout_2 == pageLayout) return 2;
    
    return 0;
}

//NSArray( NSValue->CGRect)
+(NSArray*)seperateLinesForLayout:(BqsNewsPaperPageLayout_enum)pageLayout Rect:(CGRect)rect {
    float x = CGRectGetMinX(rect);
    float y = CGRectGetMinY(rect);
    float width = CGRectGetWidth(rect);
    float height = CGRectGetHeight(rect);
    
    if(width < 1 || height < 1) return nil;
    
    NSMutableArray *ret = nil;
        
    if(PageLayout_3_1 <= pageLayout && pageLayout <= PageLayout_3_5) {
        ret = [NSMutableArray arrayWithCapacity:2];
        
        if(PageLayout_3_1 == pageLayout) {
            if(width < height) {
                float h = floor(height * .6);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
            } else {
                float h = floor(height * .5);
                float w = floor(width * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+width, y+h)]];
            }
        } else if(PageLayout_3_2 == pageLayout) {
            if(width < height) {
                float h = floor(height * .5);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
            } else {
                float h = floor(height * .5);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+width, y+h)]];
            }
        } else if(PageLayout_3_3 == pageLayout) {
            if(width < height) {
                float h = floor(height * .6);
                float w = floor(width * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
            } else {
                float h = floor(height * .4);
                float w = floor(width * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+width, y+h)]];

            }
        } else if(PageLayout_3_4 == pageLayout) {
            if(width < height) {
                float h = floor(height * .4);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+w, y+height)]];
            } else {
                float h = floor(height * .5);
                float w = floor(width * .6);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+w, y+h)]];

            }
        } else {//if(PageLayout_3_5 == pageLayout) {
            if(width < height) {
                float h = floor(height * .4);
                float w = floor(width * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+w, y+height)]];
            } else {
                float h = floor(height * .4);
                float w = floor(width * .6);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+w, y+h)]];

            }
        }
    }
    if(PageLayout_4_1 <= pageLayout && pageLayout <= PageLayout_4_5) {
        ret = [NSMutableArray arrayWithCapacity:3];
        
        if(PageLayout_4_1 == pageLayout) {
            if(width < height) {
                float h = floor(height * .4);
                float h1 = floor((height - h) * .5);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h+h1, x+width, y+h+h1)]];
            } else {
                float h = floor(height * .5);
                float w = floor(width * .6);
                float w1 = floor(w * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+w, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w1, y+h, x+w1, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
            }
        } else if(PageLayout_4_2 == pageLayout) {
            float h = floor(height * .4);
            float w = floor(width * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+w, y+h)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+height-h, x+width, y+height-h)]];
        } else if(PageLayout_4_3 == pageLayout) {
            if(width < height) {
                float h = floor(height * .5);
                float w = floor(width * .333);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+h, x+w, y+height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+2*w, y+h, x+2*w, y+height)]];
            } else {
                float h = floor(height * .333);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+w, y+h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+2*h, x+w, y+2*h)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
            }
        } else if(PageLayout_4_4 == pageLayout) {
            float h = floor(height * .5);
            float w = floor(width * .4);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+h)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+width-w, y+h, x+width-w, y+height)]];
        } else {//if(PageLayout_4_5 == pageLayout) {
            float h = floor(height * .6);
            float w = floor(width * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+w, y+h)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y+height-h, x+width, y+height-h)]];
        }
    }
    if(PageLayout_1 == pageLayout) {
        ret = [NSMutableArray arrayWithCapacity:1];
    }
    if(PageLayout_2 == pageLayout) {
        ret = [NSMutableArray arrayWithCapacity:1];
        
        // 50,50
        if(width < height) {
            float h = floor(height * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h, x+width, y+h)]];
        } else {
            float w = floor(width * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, x+w, y+height)]];
        }
    }
    
    return ret;
}

//NSArray( NSValue->CGRect)
+(NSArray*)rectsForLayout:(BqsNewsPaperPageLayout_enum)pageLayout Rect:(CGRect)rect Gap:(float)afGap {
    
    float x = CGRectGetMinX(rect);
    float y = CGRectGetMinY(rect);
    float width = CGRectGetWidth(rect);
    float height = CGRectGetHeight(rect);
    
    if(width < 1 || height < 1) return nil;
    
    NSMutableArray *ret = nil;
    
    float fGap = MAX(afGap, 0.0);
    float hGap = round(fGap/2.0);
    
    if(PageLayout_3_1 <= pageLayout && pageLayout <= PageLayout_3_5) {
        ret = [NSMutableArray arrayWithCapacity:3];
        
        if(PageLayout_3_1 == pageLayout) {
            if(width < height) {
                float h = floor(height * .6);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, width, height-h-hGap)]];
            } else {
                float w = floor(width * .4);
                float h = floor(height * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, width-w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, height)]];
            }
        } else if(PageLayout_3_2 == pageLayout) {
            if(width < height) {
                float h = floor(height * .5);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, width, height-h-hGap)]];
            } else {
                float w = floor(width * .5);
                float h = floor(height * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, width-w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, height)]];
            }
        } else if(PageLayout_3_3 == pageLayout) {
            if(width < height) {
                float h = floor(height * .6);
                float w = floor(width * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, width, height-h-hGap)]];
            } else {
                float w = floor(width * .4);
                float h = floor(height * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, width-w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, height)]];
            }
        } else if(PageLayout_3_4 == pageLayout) {
            if(width < height) {
                float h = floor(height * .4);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, width-w-hGap, height-h-hGap)]];
            } else {
                float w = floor(width * .6);
                float h = floor(height * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
            }
        } else {//if(PageLayout_3_5 == pageLayout) {
            if(width < height) {
                float h = floor(height * .4);
                float w = floor(width * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, width-w-hGap, height-h-hGap)]];
            } else {
                float w = floor(width * .6);
                float h = floor(height * .4);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
            }
        }
    }
    if(PageLayout_4_1 <= pageLayout && pageLayout <= PageLayout_4_5) {
        ret = [NSMutableArray arrayWithCapacity:4];
        
        if(PageLayout_4_1 == pageLayout) {
            if(width < height) {
                float h = floor(height * .4);
                float h1 = floor((height - h) * .5);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, width-w-hGap, h1-fGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+h1+hGap, width-w-hGap, height-h-h1-hGap)]];
            } else {
                float h = floor(height * .5);
                float w = floor(width * .6);
                float w1 = floor(w * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w1+hGap, y+h+hGap, w1-fGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w1-hGap, height-h-hGap)]];
            }
        } else if(PageLayout_4_2 == pageLayout) {
            float h = floor(height * .4);
            float w = floor(width * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, height-h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+height-h+hGap, width-w-hGap, h-hGap)]];
        } else if(PageLayout_4_3 == pageLayout) {
            if(width < height) {
                float h = floor(height * .5);
                float w = floor(width * .333);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+h+hGap, w-fGap, height-h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+2*w+hGap, y+h+hGap, width-2*w-hGap, height-h-hGap)]];
            } else {
                float h = floor(height * .333);
                float w = floor(width * .5);
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w, y, width-w-hGap, height)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, h-fGap)]];
                [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+height-h+hGap, w-fGap, h-hGap)]];
            }
        } else if(PageLayout_4_4 == pageLayout) {
            float h = floor(height * .5);
            float w = floor(width * .4);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, width-w-hGap, height-h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+width-w+hGap, y+h+hGap, w-hGap, height-h-hGap)]];
        } else {//if(PageLayout_4_5 == pageLayout) {
            float h = floor(height * .6);
            float w = floor(width * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, w-hGap, height-h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, height-h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y+height-h+hGap, width-w-hGap, h-hGap)]];
        }
    }
    if(PageLayout_1 == pageLayout) {
        ret = [NSMutableArray arrayWithCapacity:1];
        [ret addObject:[NSValue valueWithCGRect:rect]];
    }
    if(PageLayout_2 == pageLayout) {
        ret = [NSMutableArray arrayWithCapacity:2];
        
        // 50,50
        if(width < height) {
            float h = floor(height * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, h-hGap)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y+h+hGap, width, height-h-hGap)]];
        } else {
            float w = floor(width * .5);
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x+w+hGap, y, width-w-hGap, height)]];
            [ret addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w-hGap, height)]];
        }
    }

    return ret;
}

-(id)initNewLayoutWithTotalItem:(int)totalItemCnt {
    self = [super init];
    if(nil == self) return nil;
    
    [self genLayout:totalItemCnt];
    
    return self;
}

-(void)dealloc {
    self.dataLayout = nil;
    
    [super dealloc];
}

-(NSData*)decodeDataFromString:(NSString*)str {
    NSData *d = [BqsUtils base64DecodeString:str];
    if(nil == d) return nil;
    
    const t_Layout_Header *ph = (const t_Layout_Header *)[d bytes];
    if(kMark != ph->mark) {
        BqsLog(@"Invalid data mark: %x != %x", ph->mark, kMark);
        return nil;
    }
    if(sizeof(t_Layout_Header) + ph->nPageCnt * sizeof(int) > [d length]) {
        BqsLog(@"Invalid data length: %d != %d", sizeof(t_Layout_Header) + ph->nPageCnt * sizeof(int), [d length]);
        return nil;
    }
    
    return d;
}

-(NSString*)encodeDataToString:(NSData*)data {
    if(nil == data) return nil;
    
    return [BqsUtils base64StringFromData:data];
}

-(void)genLayout:(int)totalItemCnt {
    self.dataLayout = nil;
    
    if(totalItemCnt <= 0 || totalItemCnt > 1024) {
        BqsLog(@"invalid totalItemCnt: %d", totalItemCnt);
        return;
    }
    
    // calc page
    int page = MAX(ceil((float)totalItemCnt / 3.5), 1.0);
    
    int onePageCnt = 0;
    int twoPageCnt = 0;
    int threePageCnt = MAX(page / 2, 1);
    int fourPageCnt = page - threePageCnt;
    
    int leftItem = totalItemCnt - threePageCnt * 3 - fourPageCnt * 4;
    
    while (leftItem < 0 && fourPageCnt > 0) {
        fourPageCnt --;
        threePageCnt ++;
        leftItem = totalItemCnt - threePageCnt * 3 - fourPageCnt * 4;
    }
    while (leftItem > 0 && threePageCnt > 0) {
        fourPageCnt ++;
        threePageCnt --;
        leftItem = totalItemCnt - threePageCnt * 3 - fourPageCnt * 4;
    }
    if(leftItem <= -3 && threePageCnt > 0) {
        threePageCnt --;
        onePageCnt ++;
        leftItem = totalItemCnt - threePageCnt * 3 - fourPageCnt * 4 - onePageCnt;
    }
    if(leftItem <= -2 && threePageCnt > 0) {
        threePageCnt --;
        onePageCnt ++;
        leftItem = totalItemCnt - threePageCnt * 3 - fourPageCnt * 4 - onePageCnt;
    }
    if(leftItem <= -1 && threePageCnt > 0) {
        threePageCnt --;
        twoPageCnt ++;
        leftItem = totalItemCnt - threePageCnt * 3 - fourPageCnt * 4 - onePageCnt - twoPageCnt*2;
    }
    
    if(0 != leftItem) {
        BqsLog(@"Failed to calc page count!!!!!!!!!!%d", totalItemCnt);
    }
    
    page = onePageCnt + twoPageCnt + threePageCnt + fourPageCnt;
    
    NSMutableData *d = [[[NSMutableData alloc] initWithLength:sizeof(t_Layout_Header) + page * sizeof(int)] autorelease];
    self.dataLayout = d;
    
    t_Layout_Header *ph = (t_Layout_Header*)[d mutableBytes];
    ph->mark = kMark;
    ph->nPageCnt = page;
    ph->nTotalItemCnt = totalItemCnt;
    
    int pageTotalItem = 0;
    
    for(int i = 0; i < page; i++) {
        
        if(threePageCnt > 0 || fourPageCnt > 0) {
            if(threePageCnt > 0 && fourPageCnt > 0) {
                int ran = [BqsUtils randLimit:100];
                if(ran < 50) {
                    threePageCnt --;
                    ph->pageLayouts[i] = [self genOnePageLayout:3];
                    pageTotalItem += 3;
                } else {
                    fourPageCnt --;
                    ph->pageLayouts[i] = [self genOnePageLayout:4];
                    pageTotalItem += 4;
                }
            } else {
                if(threePageCnt > 0) {
                    threePageCnt --;
                    ph->pageLayouts[i] = [self genOnePageLayout:3];
                    pageTotalItem += 3;
                } else {
                    fourPageCnt --;
                    ph->pageLayouts[i] = [self genOnePageLayout:4];
                    pageTotalItem += 4;
                }
            }
        } else {
            
            if(twoPageCnt > 0) {
                twoPageCnt --;
                ph->pageLayouts[i] = PageLayout_2;
                pageTotalItem += 2;
            } else {
                onePageCnt --;
                ph->pageLayouts[i] = PageLayout_1;
                pageTotalItem += 1;
            }
            
        }
    }
    
    BqsLog(@"page: %d, totalItem: %d, pageTotalItem: %d", page, totalItemCnt, pageTotalItem);
}

-(BqsNewsPaperPageLayout_enum)genOnePageLayout:(int)itemInPage {
    if(4 != itemInPage && 3 != itemInPage) {
        BqsLog(@"Invalid itemInPage: %d", itemInPage);
        return PageLayout_4_1;
    }
    
    float ran = (float)[BqsUtils randLimit:100];
    
    if(4 == itemInPage) {
        if(ran < 20) return PageLayout_4_1;
        else if(ran < 40) return PageLayout_4_2;
        else if(ran < 60) return PageLayout_4_3;
        else if(ran < 80) return PageLayout_4_4;
        else return PageLayout_4_5;
    } else if(3 == itemInPage) {
        if(ran < 20) return PageLayout_3_1;
        else if(ran < 40) return PageLayout_3_2;
        else if(ran < 60) return PageLayout_3_3;
        else if(ran < 80) return PageLayout_3_4;
        else return PageLayout_3_5;
    }
    return PageLayout_4_1;
}

-(NSString*)getEncDataStr {
    return [self encodeDataToString:self.dataLayout];
}

-(int)getPageCnt {
    if(nil == self.dataLayout || [self.dataLayout length] < 10) return 0;
    const t_Layout_Header *ph = (const t_Layout_Header *)[self.dataLayout bytes];
    return ph->nPageCnt;
}
-(int)getTotalItemCnt {
    if(nil == self.dataLayout || [self.dataLayout length] < 10) return 0;
    const t_Layout_Header *ph = (const t_Layout_Header *)[self.dataLayout bytes];
    return ph->nTotalItemCnt;
}

-(BqsNewsPaperPageLayout_enum)getLayoutInPage:(int)pageId {
    if(nil == self.dataLayout || [self.dataLayout length] < 10) return PageLayout_Invalid;
    
    const t_Layout_Header *ph = (const t_Layout_Header *)[self.dataLayout bytes];
    if(pageId < 0 || pageId >= ph->nPageCnt) {
        return PageLayout_Invalid;
    }
    
    return ph->pageLayouts[pageId];
}

-(NSRange)getItemIdsInPage:(int)pageId {
    if(nil == self.dataLayout || [self.dataLayout length] < 10) return NSMakeRange(NSNotFound, 0);
    
    const t_Layout_Header *ph = (const t_Layout_Header *)[self.dataLayout bytes];
    if(pageId < 0 || pageId >= ph->nPageCnt) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    int itemCnt = 0;
    for(int i = 0; i < pageId; i ++) {
        itemCnt += [BqsNewsPaperPageLayout getPageLayoutItemCnt:ph->pageLayouts[i]];
    }
    
    return NSMakeRange(itemCnt, [BqsNewsPaperPageLayout getPageLayoutItemCnt:ph->pageLayouts[pageId]]);
}

-(int)getPageIdForItemId:(int)itemId {
    if(nil == self.dataLayout || [self.dataLayout length] < 10) return -1;
    
    const t_Layout_Header *ph = (const t_Layout_Header *)[self.dataLayout bytes];
    if(itemId < 0 || itemId >= ph->nTotalItemCnt) {
        return -1;
    }
    
    int itemCnt = 0;
    for(int i = 0; i < ph->nPageCnt; i ++) {

        int nextItemCnt = itemCnt + [BqsNewsPaperPageLayout getPageLayoutItemCnt:ph->pageLayouts[i]];
        
        if(itemId >= itemCnt && itemId < nextItemCnt) return i;
        
        itemCnt = nextItemCnt;
    }
    
    return -1;
}

@end
