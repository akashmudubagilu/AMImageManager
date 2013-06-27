//
//  Indicator.h
//  AMImageManager
//
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  This is a UIView subclass which contains an progress indicator and a string                      for describing the progress. Can be used by just creating the object of the class using the custom Init method. 

#import <UIKit/UIKit.h>

#define BACKGROUND_DARK    1
#define BACKGROUND_LIGHT   2



@interface Indicator : UIView {
	
	UIActivityIndicatorView *myIndicator;
	UILabel *myLabel;	

}

@property (nonatomic, retain) UIActivityIndicatorView *myIndicator;
@property (nonatomic, retain) UILabel *myLabel;



-(id)initWithFrame:(CGRect) frame labelText:(NSString *)text;
-(void)startSpinner;
-(void)stopSpinner;
-(void)editTextColor:(UIColor *) color;
-(void)editColor: (NSInteger) value;

@end
