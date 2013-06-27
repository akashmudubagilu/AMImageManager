//
//  AMImageManager.m
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AMImageManager.h"
#import "ImageCachingDatabaseService.h"
#import "AMImageCache.h"

@implementation AMImageManager

static AMImageManager *sharedImageManager = nil;

- (id)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}

+ (AMImageManager *)sharedInstance {
    if (sharedImageManager == nil) {
        sharedImageManager = [[AMImageManager alloc]init];
    }
    return sharedImageManager;
}


//return path and ,updates last access time 
- (NSString *)pathNameForImageUrl:(NSString *)imageUrl {
    @synchronized(self) {  
        
        NSString *pathOfImage = [[ImageCachingDatabaseService sharedImageCachingDatabaseService] pathNameForImageUrl:imageUrl];
        NSString *resourcePath = [[AMImageManager sharedInstance] getCacheDirectoryName];            //[[NSBundle mainBundle] resourcePath];
        NSString *finalPath = [NSString stringWithFormat:@"%@/%@",resourcePath, pathOfImage];
        return pathOfImage;
    }
}

//Given the path , returns the image data
- (NSData *)imageForPath:(NSString *)path {
    @synchronized(self) {  
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSData *imageData = [NSData dataWithContentsOfFile:path];
            
            if (imageData != nil) {
                return imageData;
            }
        }
        return nil;
    }
}


#pragma mark 
#pragma mark Methods to store images

//Store Image in fileSystem,Database,Cache 
- (void)storeImage:(NSData *)imageData withImageUrl:(NSString *)imageUrl {
    @synchronized(self) {  
        NSLog(@"saving image in cache");
        long long  imageSize = ( long long )[imageData bytes];
        if(imageUrl != nil) {
            BOOL available = [[AMImageManager sharedInstance] checkIfSpaceAvailableForImageOfSize:imageSize];
            if (!available) {
                [[AMImageManager sharedInstance] createSpaceForImageOfSize:imageSize];
            }
            NSString *pathForImage = [[AMImageManager sharedInstance] fileNameForImageWithUrl:imageUrl];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            //pathForImage = [pathForImage lastPathComponent];
            
            //creating file and storing image in it
            BOOL result = [fileManager createFileAtPath:pathForImage contents:imageData attributes:nil];
            if (result) {
                //storing image name in database
                //            NSString *imageName = [imageUrl lastPathComponent];
                [[ImageCachingDatabaseService sharedImageCachingDatabaseService] insertNewImageWithUrl:imageUrl withSize:imageSize andFilePath:pathForImage];
            }
            
            //storing in the on memory cache
            [[AMImageCache sharedInstance] storeImage:imageData withImageUrl:imageUrl andSize:imageSize];
        }
    }
}

//check if space available by checking in the data base
- (BOOL)checkIfSpaceAvailableForImageOfSize:( long long )imageSize {
    @synchronized(self) {  
        long long   totalSize = [[ImageCachingDatabaseService sharedImageCachingDatabaseService] getTotalSize];
        
        
        totalSize = totalSize + imageSize;
        if (totalSize > MAXIMUM_FILESYSTEM_SIZE) {
            return NO;
        }
        return YES;
    }
}


//deletes the images using LRU
- (void)createSpaceForImageOfSize:( long long )imageSize {
    @synchronized(self) {  
        [[ImageCachingDatabaseService sharedImageCachingDatabaseService] deleteRecordsForGivenSize:imageSize];
    }
}

//Saving FileName
- (NSString *)fileNameForImageWithUrl:(NSString *)imageUrl {
    @synchronized(self) {  
            NSString *pathNameOfImage = [imageUrl lastPathComponent];
        NSString *resourcePath = [[AMImageManager sharedInstance] getCacheDirectoryName];            //[[NSBundle mainBundle] resourcePath];
        NSString *finalPath = [NSString stringWithFormat:@"%@/%@",resourcePath, pathNameOfImage];
        return finalPath;
    }
}

- (NSString *)getCacheDirectoryName {
    @synchronized(self) {  
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:DIRECTORY_NAME];
        NSFileManager *manager = [NSFileManager defaultManager];
		if (![manager fileExistsAtPath:cacheDirectoryName]) {
			[manager createDirectoryAtPath:cacheDirectoryName attributes:nil];
		}
        return cacheDirectoryName;
    }
}


- (NSData *)imageWithImageUrl:(NSString *)imageUrl {
    
    @synchronized(self) {    
        NSData *image = [[AMImageCache sharedInstance] imageWithImageUrl:imageUrl];
        if (image != nil) {
            NSLog(@"image fetched from cache");
            return image;
        }
        
        // Lets check inside file system
        NSData *imageData = nil;
        NSString *imagePath = [[AMImageManager sharedInstance] pathNameForImageUrl:imageUrl];
        if (imagePath != nil) {
            imageData = [[AMImageManager sharedInstance] imageForPath:imagePath];
            if (imageData !=  nil) {
                NSLog(@"image fetched db");
                [self storeImage:imageData withImageUrl:imageUrl ];


            }
            return imageData;
        }
    }
    return nil;
}


@end
