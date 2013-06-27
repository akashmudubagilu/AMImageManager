//
//  AMImageCache.m
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AMImageCache.h"
#import "CacheItem.h"
static AMImageCache *sharedInstance = nil;

@implementation AMImageCache
@synthesize cacheItems;
@synthesize cacheSize;

#pragma mark 
#pragma mark Singleton methods

- (id)init {
    
    if (sharedInstance == nil) {
        if ((self = [super init]) != nil) {
            sharedInstance = self;
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            self.cacheItems = tempDictionary;
            [tempDictionary release];
        }
    }
    return sharedInstance;
}


+(AMImageCache *)sharedInstance {
    
    if(sharedInstance == nil) {
        sharedInstance = [[AMImageCache alloc]init];
    }
    return sharedInstance;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain {
    return self;
}


- (unsigned)retainCount {
    return UINT_MAX;  
}


- (void)release {
    //do nothing
}


- (id)autorelease {
    return self;
}


#pragma mark 
#pragma mark Cache Methods

//return s the image if it present in the cache else returns nil
- (NSData *)imageWithImageUrl:(NSString *)imageUrl {
    
    if (imageUrl != nil) {
        CacheItem *image = (CacheItem *)[sharedInstance.cacheItems objectForKey:imageUrl];
        if (image != nil) {
            image.lastAccessTime = [NSDate date];
            return image.imageData;
        }
    }
    return nil;
}


//stores the image in memory cache 
- (BOOL)storeImage:(NSData *)imageData withImageUrl:(NSString *)imageUrl andSize:( long long )imageSize {
    
    if ((imageUrl != nil) && (imageData != nil) && (imageSize >= 0 )) {
        
        BOOL available = [self checkIfMemoryIsAvailableForSize:imageSize];
        if (!available) {
            [self removeLRUCacheItemsForImageWithSize:imageSize];
        }
        
        CacheItem *imageItem = [[CacheItem alloc] initWithImageData:imageData withSize:imageSize]; 
        imageItem.imageUrl = imageUrl;
        imageItem.lastAccessTime = [NSDate date];
        [self.cacheItems setObject:imageItem forKey:imageUrl];
        self.cacheSize = self.cacheSize + imageSize;
        [imageItem release];
        return YES;
    }
    return NO;
}


//checks if memory is available in memory cache
- (BOOL)checkIfMemoryIsAvailableForSize:( long long  )imageSize {
    
    long long  totalCacheSize = imageSize + self.cacheSize;
    if (totalCacheSize <= MAXIMUM_CACHE_SIZE) {
        return YES;
    }
    return NO;
}


//applying LRU to remove last item. first sort the items according to last access time and then delete 
- (void)removeLRUCacheItemsForImageWithSize:( long long )imageSize {
    
    //Fetch all cached items from cacheItems Dictionary 
    NSMutableArray *images = [[NSMutableArray alloc]initWithArray:[self.cacheItems allValues]];
    
    
    //Sort the images array in ascending order based on Lastaccesstime
    [images sortUsingSelector:@selector(compareLastAccessTime:)];
    
    //Removes images which is least recently used  from cacheItems and images array
    for (int count = 0; count < [images count]; count++) {
        CacheItem *item = (CacheItem *)[images objectAtIndex:count];
        [self.cacheItems removeObjectForKey:item.imageUrl];
        self.cacheSize = self.cacheSize - item.size;
        BOOL available = [self checkIfMemoryIsAvailableForSize:imageSize];
        if (available) {
            break;
        }
    }
    [images release];
}


- (void)dealloc {
    [cacheItems release];
    [super dealloc];
}

@end
