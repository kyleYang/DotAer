//
//  ServiceEntryParser.h
//  iMobeeNews
//
//  Created by ellison on 11-5-25.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceEntryParser : NSObject {
	BOOL _bInItem;
	
}

- (NSMutableDictionary*) parseData:(NSData*)data;


@end
