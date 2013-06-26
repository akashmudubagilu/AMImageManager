//
//  AMImageView.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>

@interface AMImageView : UIImageView
{
    UIImage *placeholderImage;

}

@property(nonatomic, retain)    UIImage *placeholderImage;

- (void)fetchIcon:(NSString *)sUrl ;
@end
