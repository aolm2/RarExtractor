//
//  RAUPasswordWindow.m
//  RarExtractor
//
//  Created by Michael Terry on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAUPasswordWindow.h"


@implementation RAUPasswordWindow

@synthesize delegate;
@synthesize titleLabel, passwordTextField, OKButton, cancelButton;

-(IBAction)passwordWindowOKButtonPressed:(id)sender {
	[delegate passwordWindowOKButtonPressed:self];
}

-(IBAction)passwordWindowCancelButtonPressed:(id)sender {
	[delegate passwordWindowCancelButtonPressed:self];
}

@end
