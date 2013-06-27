//
//  AMImageView.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  its a custom image view to which the developer can either give an UIImage object or url of the image. if URL is received, it downloads the image asynchronously and stores that in the database and cache for future use.

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>
#import "ImageRequest.h"
#import "Indicator.h"

@interface AMImageView : UIImageView 
{
    UIImage *placeholderImage;
    Indicator *indicator;
}

@property(nonatomic, retain)    UIImage *placeholderImage;
@property(nonatomic, retain)    Indicator *indicator;

-(UIImageView *)initWithPlaceholderImage:(UIImage *)tempPlaceholderImage andFrame:(CGRect)frame;
- (void)setImage:(id)img ;
- (void)fetchIcon:(NSString *)sUrl ;
@end
