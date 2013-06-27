//
//  Indicator.m
//  AMImageManager
//  Created by Akash Mudubagilu on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.//

#import "Indicator.h"
 #import <QuartzCore/QuartzCore.h> 

@implementation Indicator

@synthesize myLabel;
@synthesize myIndicator;

- (id)initWithFrame:(CGRect)frame labelText:(NSString *)text{
    
	if ((self = [super initWithFrame:frame])) {
		
		self.userInteractionEnabled = NO;
		
        // Initialization code
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 40, frame.size.height/2 - 15, 20, 20)];
		indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		self.myIndicator = indicator;
		[self addSubview:indicator];
		[indicator release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - 6 , frame.size.height/2 - 19, 100, 25)];
		label.backgroundColor = [UIColor clearColor];
	    label.textColor = [UIColor whiteColor];
		label.text = text;
		label.hidden = YES;
		self.myLabel = label;
		[self addSubview:label];
		[label release];
		
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.50];
        
        self.layer.cornerRadius = 9.0;
	}
    return self;
}

-(void)editTextColor:(UIColor *) color{


		

}

-(void)editColor: (NSInteger) value{
	
 if (value == 1) {
	 self.myIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	 self.myLabel.textColor = [UIColor whiteColor];
 }
 else {
	 
	 self.myIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	 self.myLabel.textColor = [UIColor blackColor];
 }
	


}


-(void)startSpinner{

    self.hidden = NO;
	[self.myIndicator startAnimating];
	self.myLabel.hidden = NO;
    self.myLabel.hidden = NO;


}



-(void)stopSpinner{
	
	[self.myIndicator stopAnimating];
	 self.myIndicator.hidesWhenStopped = YES;
	self.myLabel.hidden = YES;
    self.hidden = YES;

	
	
}




- (void)dealloc {
    [super dealloc];
}


@end
