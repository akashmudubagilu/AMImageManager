//
//  ImageRequest.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol ImageRequestProtocol  

-(void)imageResponseRecieved:(NSData *)imageData withUnicId:(id)uniqueId;
-(void)imageRequestFailedWithError:(NSError*)error;

@end


@interface ImageRequest : ASIHTTPRequest{
    
    id uniqueId;
    id dataDelegate;
    
}

@property(nonatomic, retain) id uniqueId;
@property(nonatomic, assign) id dataDelegate;

- (id)initWithRequestURL:(NSString *)strUrl ;
@end
