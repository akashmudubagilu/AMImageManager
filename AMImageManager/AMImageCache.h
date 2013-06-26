//
//  AMImageCache.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAXIMUM_CACHE_SIZE 5000000000 //5MB


@interface AMImageCache : NSObject{
    
    NSMutableDictionary *cacheItems;
    long long cacheSize;
    
}

@property(nonatomic,retain)  NSMutableDictionary *cacheItems;
@property(nonatomic)  long long                   cacheSize;

+ (AMImageCache *)sharedInstance;
+ (NSData *)imageWithImageUrl:(NSString *)imageUrl;
- (BOOL)storeImage:(NSData *)imageData withImageUrl:(NSString *)imageUrl andSize:(long long )imageSize;
- (BOOL)checkIfMemoryIsAvailableForSize:(long long )imageSize;
- (void)removeLRUCacheItemsForImageWithSize:(long long )imageSize;

 
@end
