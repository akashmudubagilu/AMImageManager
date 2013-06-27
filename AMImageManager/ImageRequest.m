//
//  ImageRequest.m
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageRequest.h"

@implementation ImageRequest
@synthesize uniqueId;
@synthesize url;

- (void)dealloc {
    [uniqueId release];
    [super dealloc];
}


- (id)initWithRequestURL:(NSString *)strUrl {
    NSURL *imageUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if((self = [super init]) != nil) {
        	self.uniqueId = strUrl;
        self.url = imageUrl;
    }
    return self;
}

-(void)makeRequestWithBlocfForSuccess:(void (^)(NSData *imageData, id uniqId))successBlock failure:(void(^)(NSError *error))FalureBlock{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSData *data = [[NSData alloc]initWithContentsOfURL:self.url options:NSDataReadingMappedIfSafe error:&error];
        
        if(error != nil){
            FalureBlock(error);
        }else{
            successBlock(data, self.uniqueId );
        }
    });
}


/*
- (void)requestFinished {
    
    @synchronized(self) {
        
        NSData *imageData = [super responseData];
        if ([imageData length] > 0) {
            if ((self.dataDelegate != nil) && ([self.dataDelegate conformsToProtocol:@protocol(ImageRequestProtocol)])) {
                [self.dataDelegate  imageResponseRecieved:imageData withUnicId:self.uniqueId];
            }
        }
        else {
            [self failWithError:nil];
        }
    }
}


- (void)failWithError:(NSError *)theError {
    
    @synchronized(self) {
        if ( (self.dataDelegate != nil) && ([self.dataDelegate conformsToProtocol:@protocol(ImageRequestProtocol)])) {
            [self.dataDelegate  imageRequestFailedWithError:theError];
        }
    }
}
*/

@end
