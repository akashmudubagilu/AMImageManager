//
//  CacheItem.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheItem : NSObject
{
    
    long long   size;
    NSString    *imageUrl;
    NSData      *imageData;
    NSDate      *lastAccessTime;
}

@property(nonatomic) long long            size;
@property(nonatomic,retain)  NSString    *imageUrl;
@property(nonatomic,retain) NSData       *imageData;
@property(nonatomic,retain)  NSDate      *lastAccessTime;

- (id)initWithImageData:(NSData *)newImgaeData withSize:(long long )newSize;


@end
