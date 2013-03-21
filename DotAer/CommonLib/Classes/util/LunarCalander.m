//
//  LunarCalander.m
//  iMobeeWeather
//
//  Created by ellison on 11-2-21.
//  Copyright 2011 borqs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunarCalander.h"
#import "BqsUtils.h"


static long lunarInfo[] = {
	0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
	0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,
	0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
	0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
	0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,
	0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0,
	0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
	0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
	0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
	0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,
	0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
	0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
	0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
	0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
	0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0
};

@interface LunarCalander()
@property (nonatomic, copy) NSString *lunarString;
@property (nonatomic, copy) NSString *lunarMonDayString;
-(void)calcLunar;

-(NSInteger)yearDays:(NSInteger)year;
-(NSInteger)leapMonth:(NSInteger)year;
-(NSInteger)leapDays:(NSInteger)year;
-(NSInteger)monthDaysYear:(NSInteger)year Month:(NSInteger)month;

-(NSString*)animalsYear:(NSInteger)year;
-(NSString*)ganZhiByDayOffset:(NSInteger)offset;
-(NSString*)ganZhiByYear:(NSInteger)year;
-(NSString*)getLunarDayString:(NSInteger)day;

-(void)formatLunar;
@end


@implementation LunarCalander
@synthesize date=_date;
@synthesize lunarString = _lunarString;
@synthesize lunarMonDayString = _lunarMonDayString;

-(id)initWithDate:(NSDate*)aDate {
	self = [super init];
	if(nil == self) return nil;
	
	
	self.date = aDate;
	
	return self;
}

-(void)dealloc {
	[_date release];
	[_lunarString release];
	[_lunarMonDayString release];
	[super dealloc];
}

-(void)setDate:(NSDate *)aDate {
	[_date release];
	_date = [aDate retain];
	
	self.lunarString = nil;
}

-(NSString*)getLunarString {
	if(nil == self.lunarString) {
		[self calcLunar];
		[self formatLunar];
	}
	
	return self.lunarString;
}
-(NSString*)getMonthDayString {
	if(nil == self.lunarString) {
		[self calcLunar];
		[self formatLunar];
	}
	
	return self.lunarMonDayString;	
}

-(void)calcLunar {
	if(nil == _date) {
		BqsLog(@"date is nil");
		return;
	}
	
	NSInteger leapMonth = 0;
	
	NSDate *baseDate = nil;
	{
		NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
		[date_formater setDateFormat:@"yyyy-MM-dd"];
		baseDate = [date_formater dateFromString:@"1900-01-31"];
		[date_formater release];
		
		//BqsLog(@"baseDate: %@", baseDate);
	}
	
	// days offser from 1900-01-31
	NSInteger offset = ([_date timeIntervalSinceDate:baseDate]/(24*60*60));
	NSInteger yearCyl, monCyl, dayCyl;
	
	dayCyl = offset + 40;
	monCyl = 14;
	
	// offset mirus days of each lunar year
	// to caclc which day the lunar in
	// i is the lunar year
	// offset is day offset in the lunar year
	NSInteger iYear, daysOfYear = 0;
	
	for(iYear = 1900; iYear < 2050 && offset > 0; iYear ++) {
		daysOfYear = [self yearDays:iYear];
		offset -= daysOfYear;
		monCyl += 12;
	}
	
	if(offset < 0) {
		offset += daysOfYear;
		iYear --;
		monCyl -= 12;
	}
	
	// lunar year
	_year = iYear;
	yearCyl = iYear - 1864;
	leapMonth = [self leapMonth:iYear]; // which month is leap. 1-12
	
	_bLeap = NO;
	
	// minus days of each lunar month, using offset in the year, 
	// to calc day offset in the month
	NSInteger iMonth, daysOfMonth = 0;
	for(iMonth = 1; iMonth < 13 && offset > 0; iMonth ++) {
		// leap month
		if(leapMonth > 0 && iMonth == (leapMonth + 1) && !_bLeap) {
			iMonth --;
			_bLeap = YES;
			daysOfMonth = [self leapDays:_year];
		} else {
			daysOfMonth = [self monthDaysYear:_year Month:iMonth];
		}
		offset -= daysOfMonth;
		
		// not leap
		if(_bLeap && iMonth == (leapMonth + 1)) _bLeap = NO;
		
		if(!_bLeap) monCyl ++;
	}
	
	// should adjust when offset is 0 and is Leap month
	if(0 == offset && leapMonth > 0 && iMonth == leapMonth + 1) {
		if(_bLeap) {
			_bLeap = NO;
		} else {
			_bLeap = YES;
			iMonth --;
			monCyl --;
		}
	}
	
	// should adjust when offset less than 0
	if(offset < 0) {
		offset += daysOfMonth;
		iMonth --;
		monCyl --;
	}
	
	_month = iMonth;
	_day = offset + 1;
	
}

-(NSInteger)yearDays:(NSInteger)year {	
	NSInteger i, sum = 348;
	
	for(i = 0x8000; i > 0x8; i >>= 1) {
		if(0 != (lunarInfo[year-1900] & i)) {
			sum += 1;
		}
	}
	return (sum + [self leapDays:year]);
}

-(NSInteger)leapMonth:(NSInteger)year {
	return (NSInteger)(lunarInfo[year - 1900] & 0xf);
}

-(NSInteger)leapDays:(NSInteger)year {
	if(0 != [self leapMonth:year]) {
		if(0 != (lunarInfo[year-1900] & 0x10000)) {
			return 30;
		} else {
			return 29;
		}
	}
	return 0;
}

-(NSInteger)monthDaysYear:(NSInteger)year Month:(NSInteger)month {
	
	if(0 == (lunarInfo[year-1900] & (0x10000 >> month))) {
		return 29;
	}
	return 30;
}

-(NSString*)animalsYear:(NSInteger)year {
	NSString *sA = NSLocalizedStringFromTable(@"lunar.shenqiao", @"commonlib", nil);
	NSArray *arr = [sA componentsSeparatedByString:@","];
	
	return [arr objectAtIndex:(year - 4) % 12];
}

-(NSString*)ganZhiByDayOffset:(NSInteger)offset {
	NSArray *arrGan = [NSLocalizedStringFromTable(@"lunar.gan", @"commonlib", nil) componentsSeparatedByString:@","];
	NSArray *arrZhi = [NSLocalizedStringFromTable(@"lunar.zhi", @"commonlib", nil) componentsSeparatedByString:@","];
	
	return [NSString stringWithFormat:@"%@%@", [arrGan objectAtIndex:(offset%10)],
			[arrZhi objectAtIndex:(offset%12)]];
}

-(NSString*)ganZhiByYear:(NSInteger)year {
	NSInteger num = year - 1900 + 36;
	return [self ganZhiByDayOffset:num];
}

-(NSString*)getLunarDayString:(NSInteger)day {
	NSArray *arrTen = [NSLocalizedStringFromTable(@"lunar.ten", @"commonlib", nil) componentsSeparatedByString:@","];
	NSArray *arrNum = [NSLocalizedStringFromTable(@"lunar.numbers", @"commonlib", nil) componentsSeparatedByString:@","];
	
	NSInteger n = (0==(day%10)) ? 9 : (day%10 - 1);
	
	if(day > 30) return @"";
	if(10 == day) return [NSString stringWithFormat:@"%@%@", [arrTen objectAtIndex:0], [arrTen objectAtIndex:1]];
	else return [NSString stringWithFormat:@"%@%@", [arrTen objectAtIndex:(day/10)], [arrNum objectAtIndex:n]];
}

-(void)formatLunar {
	NSArray *arrNum = [NSLocalizedStringFromTable(@"lunar.numbers", @"commonlib", nil) componentsSeparatedByString:@","];
	self.lunarMonDayString = [NSString stringWithFormat:@"%@%@%@",
							  [arrNum objectAtIndex:_month-1], NSLocalizedStringFromTable(@"lunar.month", @"commonlib",nil),
							  [self getLunarDayString:_day]];
	self.lunarString = [NSString stringWithFormat:@"%d%@(%@)%@",
						_year,NSLocalizedStringFromTable(@"lunar.year", @"commonlib", nil),[self animalsYear:_year],
						_lunarMonDayString];
}
@end
