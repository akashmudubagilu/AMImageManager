//
//  ImageCachingDatabaseService.m
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCachingDatabaseService.h"
#import "AMImageManager.h"
#import "DateUtil.h"

static ImageCachingDatabaseService *sharedInstance = NULL;


@implementation ImageCachingDatabaseService

- (void)createTableIfNeeded {
	@synchronized(self) {
		//sqlite3_stmt *create_statement = NULL;
		
		static char *sql = "CREATE TABLE IF NOT EXISTS ImageCache (Url VARCHAR ( 500 ) NOT NULL PRIMARY KEY, FilePath VARCHAR ( 250 ), size INTEGER, lastAccessedTime INTEGER)";
        [self createTableIfNeededWithQuery:sql];
	}
}


- (id)init {
	
	if((self = [super init]) != nil) {
		sharedInstance = self;
		[self createTableIfNeeded];
	}
	return self;
}


+ (ImageCachingDatabaseService *)sharedImageCachingDatabaseService {
	if (sharedInstance == nil) {
		[[ImageCachingDatabaseService alloc] init];
	}
	return sharedInstance;
}


- (NSString *)pathNameForImageUrl:(NSString *)imageUrl {
    
    @synchronized(self) {
        
        NSString *query = @"SELECT FilePath FROM ImageCache WHERE Url = ? ";
        sqlite3_stmt *select_statement = NULL;
        NSString *filePathName = nil;
        
        int result = sqlite3_prepare_v2(database, [query UTF8String], -1, &select_statement, NULL);
        if ( result != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(select_statement, 1, [imageUrl UTF8String], -1, SQLITE_TRANSIENT);
        
        result = sqlite3_step(select_statement);
        if (result == SQLITE_ROW) {
            NSString *tempString = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(select_statement,0)];
            if (tempString != nil) {
                filePathName = [NSString stringWithString:tempString];
            }
            
            [tempString release];
            tempString = nil;
        }
        sqlite3_finalize(select_statement);
        return filePathName;
    }
    return nil;
}


- (BOOL)insertNewImageWithUrl:(NSString *)imageUrl withSize:(long long)imageSize andFilePath:(NSString *)pathForImage {
    
    @synchronized(self) {  
        
        sqlite3_stmt *select_statement = nil;
        NSString *select_query = @"SELECT * from ImageCache WHERE Url = ?";
        
        int result = sqlite3_prepare_v2(database, [select_query UTF8String], -1, &select_statement, NULL);
        if ( result != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(select_statement, 1, [imageUrl UTF8String], -1, SQLITE_TRANSIENT);
        result = sqlite3_step(select_statement);
        if (result == SQLITE_ROW) {
            return YES;
        }
        
        
        sqlite3_finalize(select_statement);
        
        sqlite3_stmt *insert_statement = NULL;
        
        
        static char *insertQuery = "INSERT INTO ImageCache (Url, FilePath, size , lastAccessedTime) values (?, ?, ?, ?)";
        
        if (sqlite3_prepare_v2(database, insertQuery, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        
        sqlite3_bind_text(insert_statement, 1, [imageUrl UTF8String],                -1, SQLITE_TRANSIENT);	// Image Url
        sqlite3_bind_text(insert_statement, 2, [pathForImage UTF8String],              -1, SQLITE_TRANSIENT);	//filepath
        sqlite3_bind_int64(insert_statement,3, imageSize);
        sqlite3_bind_int64(insert_statement,4, [DateUtil getTimeInMilliSecondsForDate:[NSDate date]]);	
        
        int success = sqlite3_step(insert_statement);
        sqlite3_finalize(insert_statement);
        
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: failed to create settings table with message '%s'.", sqlite3_errmsg(database));
        }
        return YES;
    }
    return NO; 
}


- (BOOL)deleteRecordsForGivenSize:(long long)imageSize {
    @synchronized(self) {  
        
        
        NSMutableArray *ImageUrlsToBeDeleted = [[NSMutableArray alloc] init];
        
        BOOL numberOfRows = NO;
        sqlite3_stmt *select_statement = nil;
        NSString *selectQuery = @"SELECT * FROM ImageCache ORDER BY lastAccessedTime";
        
        if (sqlite3_prepare_v2(database, [selectQuery UTF8String], -1, &select_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        long long tempTotalSize = 0;
        long long size;
        
        while (sqlite3_step(select_statement) == SQLITE_ROW) {
            numberOfRows = YES;
            NSString *tempString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(select_statement, 2)];
            size = [tempString longLongValue];
            tempTotalSize = tempTotalSize + size;
            
            
            NSString *fileUrlToBeDeleted = [NSString stringWithUTF8String:(char *)sqlite3_column_text(select_statement, 0)];
            NSString *pathName = [NSString  stringWithUTF8String:(char *)sqlite3_column_text(select_statement, 1)];
            //NSLog(@"_____________________________ newImageSize   %ld   tempTotalSize %ld  size %d   for %@ ",imageSize,tempTotalSize,size,pathName );
            [ImageUrlsToBeDeleted addObject:fileUrlToBeDeleted];
            if([fileUrlToBeDeleted  rangeOfString:@"http://"].location == NSNotFound) {
                NSLog(@"file Url To Be Deleted not found");
            }
            else {
                
                [self deleteFileAtPath:pathName];
            }
            
            
            if (tempTotalSize  >= imageSize) {
                //lastAccessTime = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(select_statement, 2)];
                //dateInMilliseconds = [lastAccessTime intValue];
				[tempString release]; //Ranjeet has released "tempString"
                
                break;
            }
            [tempString release];
            tempString = nil;
        }   
        int success = sqlite3_step(select_statement);
        sqlite3_finalize(select_statement);
        
        if ([ImageUrlsToBeDeleted count] > 0) {
            
            
            sqlite3_stmt *delete_statement = nil;
            
            // NSString *deleteQuery = @"DELETE  FROM ImageCache WHERE lastAccessedTime <= ?";
            NSMutableString *deleteQuery =[NSMutableString stringWithString: @"DELETE  FROM ImageCache WHERE Url IN ("];
            for (int count = 0; count < [ImageUrlsToBeDeleted count]; count++) {
                
                if (count == ([ImageUrlsToBeDeleted count] - 1)) {
                    NSString *image = (NSString *) [ImageUrlsToBeDeleted objectAtIndex:count];
                    [deleteQuery appendFormat:@"'%@'",image];
                    break;
                }
                else {
                    NSString *image = (NSString *) [ImageUrlsToBeDeleted objectAtIndex:count];
                    [deleteQuery appendFormat:@" '%@  ',",image];
                }
            }
            
            [deleteQuery appendString:@")"];
            [ImageUrlsToBeDeleted release];
            if (numberOfRows) {
                if (sqlite3_prepare_v2(database, [deleteQuery UTF8String], -1, &delete_statement, NULL) != SQLITE_OK) {
                    NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
                }
                
                
                success = sqlite3_step(delete_statement);
                sqlite3_finalize(delete_statement);
                
                if (success == SQLITE_OK) {
					//[ImageUrlsToBeDeleted release];
                    return YES;
                }
                else {
					//[ImageUrlsToBeDeleted release];
                    return NO;
                }
            }
			//[ImageUrlsToBeDeleted release];
            return YES;
        }
		[ImageUrlsToBeDeleted release];
    }
    return NO;
}


- (long long)getTotalSize {
    @synchronized(self) {  
        long long totalSize = 0;
        sqlite3_stmt *select_statement = nil;
        NSString *selectQuery = @"SELECT SUM(size) FROM ImageCache ";             
        if (sqlite3_prepare_v2(database, [selectQuery UTF8String], -1, &select_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        if(sqlite3_step(select_statement) == SQLITE_ROW) {
            totalSize = sqlite3_column_int64(select_statement,0);//[tempString intValue];
            // [tempString release];
        }
        sqlite3_finalize(select_statement);
        return totalSize;
    }
    return 0;
}


- (BOOL)deleteAllRows {
    sqlite3_stmt * delete_statement;
    NSString *deleteQuery = @"Delete FROM ImageCache";
    
    if (sqlite3_prepare_v2(database, [deleteQuery UTF8String], -1, &delete_statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    else {
        sqlite3_step(delete_statement);
        sqlite3_finalize(delete_statement);
        
        return YES;
    }
    return NO;
}

- (BOOL)deleteFileAtPath:(NSString *)pathName {
    
    NSString *resourcePath = [[AMImageManager sharedInstance] getCacheDirectoryName];
    NSString *finalPath = [NSString stringWithFormat:@"%@/%@",resourcePath, pathName];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result =  [manager removeItemAtPath:finalPath error:nil];
    return result;
}


@end
