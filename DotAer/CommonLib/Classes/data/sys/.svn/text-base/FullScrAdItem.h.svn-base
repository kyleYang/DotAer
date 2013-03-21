//
//  FullScrAdItem.h
//  iMobeeBook
//
//  Created by ellison on 11-11-25.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFullScrActionOpType_InAppWeb 1
#define kFullScrActionOpType_SysWeb 2

#define kFullScrActionOpType_MIN 1
#define kFullScrActionOpType_MAX 2

@interface FullScrAdItem : NSObject<NSCopying> {
    
}
@property (nonatomic, copy) NSString *imgUrlVer;
@property (nonatomic, copy) NSString *imgUrlHori;
@property (nonatomic, assign) int ratio;
@property (nonatomic, assign) BOOL bAutoRemove;
@property (nonatomic, assign) int minIntervalS;
@property (nonatomic, assign) int actionOpType;
@property (nonatomic, copy) NSString *actionOpData;

+(NSArray *)parseXmlData:(NSData*)data;
+(BOOL)saveToFile:(NSString*)path Data:(NSArray*)data;

@end
