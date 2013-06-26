//
//  Database.m
//  Auto Generator Tool
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Database.h"

static NSString *const DATABASE_NAME = @"database.dat";
static sqlite3 *staticDB = NULL;

@implementation Database

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
	
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
	if (success) { 
		return;
	}
    
	// The writable database does not exist, so create the default to the appropriate location.
	success = [fileManager createFileAtPath:writableDBPath contents:nil attributes:nil];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


- (id)init {
	
	if	((self = [super init]) !=  nil) {
		[self loadDataBase];
	}
	return self;
}


- (void)loadDataBase {
	[self createEditableCopyOfDatabaseIfNeeded];
    if (staticDB == NULL) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
            // Open the database. The database was prepared outside the application.
        if (sqlite3_open([writableDBPath UTF8String], &staticDB) != SQLITE_OK) {
                // Even though the open failed, call close to properly clean up resources.
            sqlite3_close(staticDB);
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
            
        }
        NSLog(@"Open Db");
        database = staticDB;
    } else {
        database = staticDB;
    }
}


- (void)dealloc {
    // Close the database.
	[self closeDb];
	
	[super dealloc];
}


- (void)closeDb {
    
    int success = sqlite3_close(database);
    
    if (success != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    staticDB = database = NULL;
    NSLog(@"After closing the DB status is %d ",success);
}


- (void)createTableIfNeededWithQuery:(char *)sql {
	
	sqlite3_stmt *create_statement = NULL;
	
	if (sqlite3_prepare_v2(database, sql, -1, &create_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	int success = sqlite3_step(create_statement);
	sqlite3_finalize(create_statement);
	
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to create settings table with message '%s'.", sqlite3_errmsg(database));
	}
}

@end
