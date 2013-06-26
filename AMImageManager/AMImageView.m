//
//  AMImageView.m
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AMImageView.h"
#import "AMImageManager.h"
#import "ImageRequest.h"

@implementation AMImageView

@synthesize placeholderImage;


-(void)dealloc{

    [placeholderImage release];
    [super dealloc];
}

-(UIImageView *)initWithPlaceholderImage:(UIImage *)tempPlaceholderImage{

    if (self == [super init]) {
        self.placeholderImage = tempPlaceholderImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
 		self.userInteractionEnabled = YES;
 		
        [super setImage:placeholderImage];
     }

    return self;
    
}

- (void)setImage:(id)img  {
  
		UIImage *tempImage = self.placeholderImage;	
		if ([img isKindOfClass:[NSString class]]) {
			NSData *imgData = [[AMImageManager sharedInstance] imageWithImageUrl:(NSString *)[img lastPathComponent]];
			tempImage = [UIImage imageWithData:imgData];
			if (tempImage == nil) {
				tempImage = self.placeholderImage;
                [self fetchIcon:img];
				[super setImage:tempImage];
			} else {
				if ([tempImage isKindOfClass:[UIImage class]]) {
                    [super setImage:tempImage];				}			
			}
			
			
		}
		if ([img isKindOfClass:[UIImage class]]) {
			[super setImage:img];
		}		
	
    
}

#pragma mark ImageRequest delegate

- (void)fetchIcon:(NSString *)sUrl {
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	ImageRequest *imageRequest = [[ImageRequest alloc] initWithRequestURL:sUrl];
	imageRequest.dataDelegate = self;
	[queue addOperation:imageRequest];
	[imageRequest release];	
}

- (void)imageResponseRecieved:(NSData *)imageData withUnicId:(NSString *)url {
	UIImage *img = [UIImage	imageWithData:imageData];
	if (img != nil) {
		[[AMImageManager sharedInstance] storeImage:imageData withImageUrl:url];
        [super setImage:img];							
	}
}

- (void)imageRequestFailedWithError:(NSError *)theError {
	NSLog(@"imageRequestFailedWithError = %@", [theError description]);
}





@end
