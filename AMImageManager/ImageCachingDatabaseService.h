//
//  ImageCachingDatabaseService.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  a derived class of Database which defines all functionalities for the image cache database.


#import <Foundation/Foundation.h>
#import "Database.h"
@interface ImageCachingDatabaseService : Database
- (void)createTableIfNeeded;	
- (NSString *)pathNameForImageUrl:(NSString *)imageUrl;
- (BOOL)insertNewImageWithUrl:(NSString *)imageUrl withSize:(long long)imageSize andFilePath:(NSString *)pathForImage;
- (BOOL)deleteRecordsForGivenSize:(long long)imageSize;
- (long long )getTotalSize;
- (BOOL)deleteAllRows;
- (BOOL)deleteFileAtPath:(NSString *)pathName;

+ (ImageCachingDatabaseService *)sharedImageCachingDatabaseService ;

@end
