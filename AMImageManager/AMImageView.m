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
@synthesize indicator;

-(void)dealloc{
    [indicator release];
    [placeholderImage release];
    [super dealloc];
}

-(id)init{
    if (self = [super init]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
 		self.userInteractionEnabled = YES;
        int width = 100;
        int height = 40;
        self.indicator = [[[Indicator alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - width/2 , self.frame.size.height/2 - height/2, width, height) labelText:@"loading..."] autorelease];
        [self.indicator editColor:BACKGROUND_DARK];
        [self addSubview:self.indicator];
        return self;
    }
    return nil;
}


-(UIImageView *)initWithPlaceholderImage:(UIImage *)tempPlaceholderImage andFrame:(CGRect)frame{

    if (self = [super init]) {
        self.placeholderImage = tempPlaceholderImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
 		self.userInteractionEnabled = YES;
 		self.frame = frame;
        [super setImage:placeholderImage];
        int width = 200;
        int height = 130;
        //NSLog(@"width = %d : height = %d",self.frame.size.width, self.frame.size.height);
        self.indicator = [[[Indicator alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - width/2 , self.frame.size.height/2 - height/2, width, height) labelText:@"loading..."] autorelease];
        [self.indicator editColor:BACKGROUND_DARK];
        [self addSubview:self.indicator];
        [self observeValueForKeyPath:@"self.frame" ofObject:self change:nil context:nil];
        return self;
     }
    
    return nil;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (keyPath == @"self.frame") {
        int width = 200;
        int height = 130;
        NSLog(@"changing frame");
        self.indicator.frame =   CGRectMake(self.frame.size.width/2 - width/2 , self.frame.size.height/2 - height/2, width, height);  
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    int width = 200;
    int height = 130;

    self.indicator.frame =   CGRectMake(self.frame.size.width/2 - width/2 , self.frame.size.height/2 - height/2, width, height);  


}


- (void)setImage:(id)img  {
        [self.indicator startSpinner ];

		UIImage *tempImage = self.placeholderImage;	
		if ([img isKindOfClass:[NSString class]]) {
			//NSData *imgData = [[AMImageManager sharedInstance] imageWithImageUrl:(NSString *)[img lastPathComponent]];
            NSData *imgData = [[AMImageManager sharedInstance] imageWithImageUrl:(NSString *)img];
			tempImage = [UIImage imageWithData:imgData];
			if (tempImage == nil) {
                if (self.placeholderImage != nil) {
                    tempImage = self.placeholderImage;
                     [super setImage:tempImage];
                    [self.indicator stopSpinner ];

                }else{
                    [super setImage:nil];
                }
                
                [self fetchIcon:img];

			} else {
				if ([tempImage isKindOfClass:[UIImage class]]) {
                    [super setImage:tempImage];		
                    [self.indicator stopSpinner ];

                }			
			}
			
			
		}
		if ([img isKindOfClass:[UIImage class]]) {
			[super setImage:img];
            [self.indicator stopSpinner ];

		}		
}

#pragma mark ImageRequest delegate

- (void)fetchIcon:(NSString *)sUrl {
    
    ImageRequest *imageRequest = [[ImageRequest alloc] initWithRequestURL:sUrl];
    [imageRequest makeRequestWithBlocfForSuccess:^(NSData *imageData, id uniqId) {
        
        UIImage *img = [UIImage	imageWithData:imageData];
        if (img != nil) {
            [[AMImageManager sharedInstance] storeImage:imageData withImageUrl:uniqId];
            [super setImage:img];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"imageRequestFailedWithError = %@", [error description]);
        
    }];
    
    
    
    //	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    //	ImageRequest *imageRequest = [[ImageRequest alloc] initWithRequestURL:sUrl];
    //	imageRequest.dataDelegate = self;
    //	[queue addOperation:imageRequest];
    //	[imageRequest release];
}




@end
