//
//  ImageRequest.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@protocol ImageRequestProtocol  

-(void)imageResponseRecieved:(NSData *)imageData withUnicId:(id)uniqueId;
-(void)imageRequestFailedWithError:(NSError*)error;

@end


@interface ImageRequest : NSObject{
    
    id uniqueId;
    NSURL  *url;
     
}

@property(nonatomic, retain) id uniqueId;
@property(nonatomic, retain) NSURL *url;

 
- (id)initWithRequestURL:(NSString *)strUrl ;
-(void)makeRequestWithBlocfForSuccess:(void (^)(NSData *imageData, id uniqId))successBlock failure:(void(^)(NSError *error))FalureBlock;


@end
