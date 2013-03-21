//
//  LunarCalander.h
//  iMobeeWeather
//
//  Created by ellison on 11-2-21.
//  Copyright 2011 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LunarCalander : NSObject {
	NSDate *_date;
	NSInteger _year;
	NSInteger _month;
	NSInteger _day;
	BOOL _bLeap;
	
	NSString *_lunarString;
	NSString *_lunarMonDayString;
}
@property (nonatomic, retain) NSDate *date;

-(id)initWithDate:(NSDate*)aDate;
-(NSString*)getLunarString;
-(NSString*)getMonthDayString;

@end
