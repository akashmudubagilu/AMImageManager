//
//  DateUtil.m
//  iPublishCentral
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateUtil.h"


@implementation DateUtil

+ (long long)getTimeInMilliSecondsForDate:(NSDate *)date {
	
	if	(date == nil) {
		return -1;
	}
	
	NSTimeInterval timeInterval = [date timeIntervalSince1970];
	return ((long long ) timeInterval);
}


+ (NSDate *)getDateFromTimeInterval:(long long)timeInterval { 
	
	if(timeInterval >=  0) {
		return [NSDate dateWithTimeIntervalSince1970:timeInterval];
	} else {
		return nil;
	}
}


+(NSString *)getDateStringFromDate:(id )date{
	
	if ([date isKindOfClass:[NSString class]]) {
		NSDateFormatter *dateFormatterToPrepareDate = [[NSDateFormatter alloc] init] ;
		[dateFormatterToPrepareDate setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
		NSDate *myDate = [dateFormatterToPrepareDate dateFromString: date];
		[dateFormatterToPrepareDate release];
		
		NSDateFormatter *dateFormatterToGetString = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatterToGetString setDateFormat:@"K:mma, EEE MMM d, yyyy"];
		return [dateFormatterToGetString stringFromDate:myDate];
		
		
	}else if ([date isKindOfClass:[NSDate class]]) {
		NSDateFormatter *dateFormatterToGetString = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatterToGetString setDateFormat:@"K:mma, EEE MMM d, yyyy"];
		return [dateFormatterToGetString stringFromDate:date];
	}
	return @"";
    
}
@end
