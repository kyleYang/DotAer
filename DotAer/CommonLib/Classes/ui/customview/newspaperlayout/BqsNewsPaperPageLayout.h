//
//  BqsNewsPaperPageLayout.h
//  iMobeeNews
//
//  Created by ellison on 11-8-30.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _enumBqsNewsPaperPageLayout {
    PageLayout_Invalid,
    
    PageLayout_1,
    PageLayout_2, // 50%, 50%
    
    PageLayout_3_1, // two upper equal, one downer(60%, 40%)
//         |
//    ------------
//    
    PageLayout_3_2, // two upper equal, one downer(50%, 50%)
//         |
//    ------------
//    
    PageLayout_3_3, // two upper (left 40%, right 60%), on downer (upper 60%, downer 40%)
    
//       |
//    ------------
//    
    PageLayout_3_4, // one upper, two downer(left 50%, right 50%) (upper 40%, downer 60%)
//      
//    ------------
//         |
    PageLayout_3_5, // 1 upper, 2 downer(40%, 60%) (upper 40%, downer 60%)
//       
//    ------------
//       |
    PageLayout_4_1, // 1 upper, 3 downer(1 left, 2 right(1 upper, 1 downer))
//
//    ------------
//         |
//         |------
//         |
    PageLayout_4_2, // 2 left(upper 40%, downer 60%), 2 right(upper 60%, downer 40%) (50%, %50)
//         |
//   ------|
//         |
//         |------
//         |
    PageLayout_4_3, // 1 upper, 3 downer(33%, 33%, 33%) (50%, 50%)
//         
//   --------------
//       |    |
//       |    |
//       |    |
    PageLayout_4_4, 
//       
//      |
//   --------------
//           |
    PageLayout_4_5,
//         |
//         |------
//         |
//   ------|
//         |
} BqsNewsPaperPageLayout_enum;



@interface BqsNewsPaperPageLayout : NSObject {
    
}
+(BqsNewsPaperPageLayout*)layoutWithData:(NSString*)data;
+(int)getPageLayoutItemCnt:(BqsNewsPaperPageLayout_enum)pageLayout;
+(NSArray*)rectsForLayout:(BqsNewsPaperPageLayout_enum)pageLayout Rect:(CGRect)rc Gap:(float)fGap; //NSArray( NSValue->CGRect)
+(NSArray*)seperateLinesForLayout:(BqsNewsPaperPageLayout_enum)pageLayout Rect:(CGRect)rc; //NSArray( NSValue->CGRect)

-(id)initNewLayoutWithTotalItem:(int)totalItemCnt;
-(NSString*)getEncDataStr;

-(int)getPageCnt;
-(int)getTotalItemCnt;
-(BqsNewsPaperPageLayout_enum)getLayoutInPage:(int)pageId;
-(NSRange)getItemIdsInPage:(int)pageId;
-(int)getPageIdForItemId:(int)itemId;


@end
