//
//  RAUMainWindow.h
//  RarExtractor
//
//  Created by Michael Terry on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RAUMainWindow : NSWindow {
	NSTextField	*introLabel;
}

@property (readwrite, assign)	IBOutlet	NSTextField	*introLabel;

-(void)expandBy:(int)expandBy animate:(BOOL)animate;
-(void)expandBy:(int)expandBy;
-(void)collapseBy:(int)collapseBy animate:(BOOL)animate;
-(void)collapseBy:(int)collapseBy;

@end