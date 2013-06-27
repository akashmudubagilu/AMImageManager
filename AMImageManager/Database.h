//
//  Database.h
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  base database class which creates the database object. and define basic functionalities of database classes.


#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Database : NSObject {
	sqlite3 *database;
}

- (void)loadDataBase;
- (id)init;
- (void)createTableIfNeededWithQuery:(char *)sql;
- (void)closeDb;

@end
