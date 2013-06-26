//
//  DateUtil.h
//  iPublishCentral
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject {
    
}

//Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT represented by this Date object.
+ (long long)getTimeInMilliSecondsForDate:(NSDate *)date;

+ (NSDate *)getDateFromTimeInterval:(long long)timeInterval;
+(NSString *)getDateStringFromDate:(id )date;

@end
