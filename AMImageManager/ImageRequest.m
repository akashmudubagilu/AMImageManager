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
@synthesize dataDelegate;


- (void)dealloc {
    [uniqueId release];
    [super dealloc];
}


- (id)initWithRequestURL:(NSString *)strUrl {
    NSURL *imageUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if((self = [super initWithURL:imageUrl]) != nil) {
    }
	self.uniqueId = strUrl;
    
    return self;
}

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


@end
