//
//  AMImageManager.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  This class does the actual cache managing job. it creates, handles the cache and also storage of images in the local database.

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>
#define DIRECTORY_NAME @"ImageCache"
#define MAXIMUM_FILESYSTEM_SIZE 25000000000 //5MB

@interface AMImageManager : NSObject		
 

- (NSData *)imageWithImageUrl:(NSString *)imageUrl ;
+ (AMImageManager *)sharedInstance ;
- (NSString *)getCacheDirectoryName ;
- (void)storeImage:(NSData *)imageData withImageUrl:(NSString *)imageUrl ;
- (BOOL)checkIfSpaceAvailableForImageOfSize:( long long )imageSize ;
- (void)createSpaceForImageOfSize:( long long )imageSize;
- (NSString *)fileNameForImageWithUrl:(NSString *)imageUrl;
@end
