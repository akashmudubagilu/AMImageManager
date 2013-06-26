//
//  CacheItem.m
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CacheItem.h"

@implementation CacheItem

@synthesize size;
@synthesize imageUrl;
@synthesize imageData;
@synthesize lastAccessTime;

- (id)initWithImageData:(NSData *)newImageData withSize:( long long )newSize {
    if ((self = [super init]) != nil) {
        self.imageData = newImageData;
        self.size = newSize;
    }
    return self;
}


- (NSComparisonResult)compareLastAccessTime:(CacheItem *)cacheItemSecond {
	NSComparisonResult  result = NSOrderedSame;
	NSDate *laterDate = [self.lastAccessTime laterDate:cacheItemSecond.lastAccessTime];
    if ([laterDate isEqualToDate:cacheItemSecond.lastAccessTime]) {
        result = NSOrderedAscending;
	}
	else{
		result = NSOrderedDescending;
	}
	return result;
}


- (void)dealloc {
    [imageUrl release];
    [imageData release];
    [lastAccessTime release];
    [super dealloc];
}

@end
