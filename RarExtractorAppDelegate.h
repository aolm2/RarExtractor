//
//  RarExtractorAppDelegate.h
//  RarExtractor
//
//  Created by Michael Terry on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAUPasswordWindow.h"
#import "RAUTaskController.h"

@class RAUMainWindow;

@interface RarExtractorAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, RAUTaskControllerDelegate, RAUPasswordWindowDelegate> {
    RAUMainWindow				*window;
	NSView						*windowView;
	BOOL						applicationDidFinishLaunching;
	BOOL						terminateWhenDone;
	BOOL						terminating;
	NSMutableArray				*taskController;
	RAUPasswordWindow			*passwordWindow;
	BOOL						passwordWindowIsShowing;
	RAUTaskController			*passwordWindowCurrentTask;
	NSMutableArray				*passwordWindowWaitingTasks;

}

@property (readwrite, assign)	IBOutlet	RAUMainWindow		*window;
@property (readwrite, assign)	IBOutlet	NSView				*windowView;
@property (readwrite, assign)				BOOL				applicationDidFinishLaunching;
@property (readwrite, assign)				BOOL				terminateWhenDone;
@property (readwrite, assign)				BOOL				terminating;
@property (readwrite, retain)				NSMutableArray		*taskController;
@property (readwrite, assign)	IBOutlet	RAUPasswordWindow	*passwordWindow;
@property (readwrite, assign)				BOOL				passwordWindowIsShowing;
@property (readwrite, retain)				RAUTaskController	*passwordWindowCurrentTask;
@property (readwrite, retain)				NSMutableArray		*passwordWindowWaitingTasks;

-(IBAction) chooseAFile:(id)sender;

-(void)addTaskController:(RAUTaskController *)newController;
-(void)showPasswordWindowForTaskController:(RAUTaskController *)needyController isWrongPassword:(BOOL)bWrongPassword;
-(void)dismissPasswordWindow;



@end
