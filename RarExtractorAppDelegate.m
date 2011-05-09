//
//  RarExtractorAppDelegate.m
//  RarExtractor
//
//  Created by Michael Terry on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RarExtractorAppDelegate.h"
#import "RAURarfile.h"
#import "RAUMainWindow.h"
#import "RAUExtractTaskController.h"
#import "RAUPath.h"
#import "RAUAuxiliary.h"
#import "RAUTaskViewController.h"


@implementation RarExtractorAppDelegate

@synthesize window, windowView;
@synthesize applicationDidFinishLaunching, terminateWhenDone, terminating;

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
	NSMutableArray				*_taskController				= [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray				*_passwordWindowWaitingTasks	= [[NSMutableArray alloc] initWithCapacity:1];
	
	self.applicationDidFinishLaunching	= NO; 
	self.terminateWhenDone				= NO; //determines if the application terminates when the last task is done
	self.terminating					= NO; //YES if the application is in the process of terminating
	self.taskController					= _taskController; //currently running tasks
	self.passwordWindowIsShowing		= NO;
	self.passwordWindowCurrentTask		= nil; //the taskController the passwordWindow is currently obtaining a password for
	self.passwordWindowWaitingTasks		= _passwordWindowWaitingTasks; //tasks waiting for the passwordWindow
	
	[_taskController				release];
	[_passwordWindowWaitingTasks	release];
	
	[self.window			setDelegate:self];
	[self.passwordWindow	setDelegate:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	self.applicationDidFinishLaunching = YES;
}

/* Automatically called when the user opens files or drags them onto the application (NSApplicationDelegate) */
- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
	//If this is called before didFinishLaunching, app was opened by double-clicking a rar-file - terminate after finishing
	if (self.applicationDidFinishLaunching == NO) 
		self.terminateWhenDone = YES;
	
	NSMutableArray *archiveFiles	=	[NSMutableArray arrayWithCapacity:0];
	NSMutableArray *nonArchiveFiles	=	[NSMutableArray arrayWithCapacity:0];
	for (NSString *file in filenames) {
		if ([[[file pathExtension] lowercaseString] isEqualToString:@"rar"] == YES) {
			[archiveFiles addObject:file];
			break;
		}
		else 
			[nonArchiveFiles addObject:file];
	}
	
	//One Archive and other files? Add the files to the archive
	if ([archiveFiles count] == 1 && [nonArchiveFiles count] > 0) {
		//impossible for rar extractor
	}
	else {
		for (NSString *archiveFile in archiveFiles) {
			RAUPath *archiveFilePath = [RAUPath pathWithFile:archiveFile];
			RAUExtractTaskController *newController = [[RAUExtractTaskController alloc] initWithFilePath:archiveFilePath];
			[self addTaskController:newController];
			[newController release];
		}
		
		if ([nonArchiveFiles count] > 0) {
			//impossible for rar extractor
		}
	}

}

-(IBAction) chooseAFile:(id)sender {
	[[NSOpenPanel openPanel] beginSheetForDirectory:nil
											   file:nil
											  types:[NSArray arrayWithObjects:@"rar",nil]
									 modalForWindow:[self window]
									  modalDelegate:self
									 didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
										contextInfo:nil];
}

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode
            contextInfo:(void *)contextInfo {
	if(returnCode == NSOKButton) {
		NSString *archiveFile = [[[sheet filenames] objectAtIndex:0] copy];
		[sheet close];
		
		self.terminateWhenDone = NO;
		RAUPath *archiveFilePath = [RAUPath pathWithFile:archiveFile];
		RAUExtractTaskController *newController = [[RAUExtractTaskController alloc] initWithFilePath:archiveFilePath];
		[self addTaskController:newController];
		[newController release];
		
		[archiveFile release];
		

	}
}



/* Automatically called when the application gets the terminate signal by terminate: or the user pressing CMD+Q (NSApplicationDelegate) */
-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	if ([self.taskController count] == 0) return NSTerminateNow; 
	/* If there are tasks still going on, they shouldn't leave mess behind. Stop them and tell the OS we will terminate later
	 When the last task stopped, controllerDidFinish: will automatically call [NSApp terminate] again which will cause termination */
	else {
		self.terminating = YES; 
		for (RAUTaskController *runningController in self.taskController) {
			[runningController terminateTask];
		}
		return NSTerminateCancel;
	}
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[window			release];
	[passwordWindow	release];
	
	self.taskController				= nil;
	self.passwordWindowCurrentTask	= nil;
	self.passwordWindowWaitingTasks	= nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Window

/* Automatically called when a window loses the focus (NSWindowDelegate) */
-(void)windowDidResignMain:(NSNotification *)notification {
	if ([notification object] == self.window) {
		for (RAUTaskController *currentTask in self.taskController) {
			[currentTask.viewController.stopButton setEnabled:NO];
		}
	}
}

/* Automatically called when a windows get the focus (NSWindowDelegate) */
-(void)windowDidBecomeMain:(NSNotification *)notification {
	if ([notification object] == self.window) {
		for (RAUTaskController *currentTask in self.taskController) {
			[currentTask.viewController.stopButton setEnabled:YES];
		}
	}
}

/* Automatically called when the user clicks the close-button of a window (NSWindowDelegate) */
-(BOOL)windowShouldClose:(id)sender {
	if (sender == self.window) {
		[NSApp terminate:nil];
	}
	return YES;
}

#pragma mark -
#pragma mark TaskController
@synthesize taskController;

/* Adds a TaskController to be tracked by the appDelegate, which adds the UI to the main window and listens to messages */
-(void)addTaskController:(RAUTaskController *)newController {
	[newController setDelegate:self];
	[newController.viewController.stopButton setEnabled:self.window.isMainWindow];
	
	NSView *newView = newController.viewController.view;
	
	//The expand animation. Not done for the first task, because the window is intialized with room for one taskview
	if ([self.taskController count] != 0) 
		[self.window expandBy:newView.frame.size.height];
	
	[newView				setFrameOrigin:NSMakePoint(0,-1)]; //A cosmetic thing to hide the black line on the bottom of the last view
	[self.windowView		addSubview:newView];
	[self.window.introLabel	setHidden:YES];
	[self.window.chooseAFile	setHidden:YES];
	[self.window.imageView	setHidden:YES];
	[self.taskController addObject:newController];

}

/* Automatically called when a TaskController detected the rarfile its rarfile is invalid and it can't proceed (RAUTaskControlerDelegate) */
-(void)taskControllerRarfileInvalid:(RAUTaskController *)invalidController {
	NSString *filenameToDisplay = [NSString stringWithFormat:@"%@.%@", invalidController.rarfile.path.filename, invalidController.rarfile.path.extension];
	NSString *errorMessage = nil;
	if ([invalidController isKindOfClass:[RAUExtractTaskController class]]) {
		errorMessage = [NSString stringWithFormat:NSLocalizedString(@"\"%@\" can't be extracted. It may be not a RAR file, or it is damaged.", nil), filenameToDisplay];
	}

	[invalidController showErrorAndFinish:errorMessage];
}

/* Automatically called when a TaskControllers task is ready to be launched (RAUTaskControlerDelegate) */
-(void)taskControllerIsReady:(RAUTaskController *)readyController {
	if (readyController == self.passwordWindowCurrentTask) {
		[self dismissPasswordWindow];
	}
	
	[readyController launchTask];
}


/* Automatically called when a TaskController finishes its work (RAUTaskControlerDelegate) */
-(void)taskControllerDidFinish:(RAUTaskController *)finishedController {
	if ([self.taskController containsObject:finishedController]) { //To prevent double-cancelling (double-clicking X for example)
		NSRect finishedFrame = finishedController.viewController.view.frame;
		
		/* UI: The finished taskview will be removed and leave a space. We need to move every taskview below the removed one up
		 We don't want any UI changes if we are terminating - it'd be just a waste of time */
		if (self.terminating == NO) {
			for (RAUTaskController *anotherController in self.taskController) {
				NSPoint anotherOrigin = anotherController.viewController.view.frame.origin; 
				if (anotherOrigin.y < finishedFrame.origin.y) { //anotherController is below finishedController
					[anotherController.viewController.view setFrameOrigin:NSMakePoint(anotherOrigin.x, 
																					  anotherOrigin.y + finishedFrame.size.height)];
				}
			}
			
			[finishedController.viewController.view removeFromSuperview];
			
			//Collapse animation - not done for the last controller, as we always want a window the size of one taskController
			if ([self.taskController count] != 1) [self.window collapseBy:finishedFrame.size.height]; 
		}
		
		[self.taskController removeObject:finishedController];
		
		//No controller left and terminating is YES (which means the user pressed CMD+Q or something)
		if ([self.taskController count] == 0 && self.terminating == YES) {
			[NSApp terminate:nil];
			//We are done and terminateWhenDone is YES: - terminate.
		} else if ([self.taskController count] == 0 && self.terminateWhenDone == YES) {
			[NSApp terminate:nil];
			//If there are no controllers left and we didn't terminate: Show the intro label
		} else if ([self.taskController count] == 0) {
			[self.window.introLabel setHidden:NO];
			[self.window.chooseAFile	setHidden:NO];
			[self.window.imageView	setHidden:NO];
		}
	}
}

/* Automatically called when a task controller detected its rarfile is protected and asks for a password (RAUTaskControlerDelegate) */
-(void)taskControllerNeedsPassword:(RAUTaskController *)needyController isWrong:(BOOL)bWrongPassword {	
	[self showPasswordWindowForTaskController:needyController isWrongPassword:bWrongPassword];
}

#pragma mark -
#pragma mark Password Window
@synthesize passwordWindow;
@synthesize passwordWindowIsShowing, passwordWindowCurrentTask, passwordWindowWaitingTasks;

-(void)showPasswordWindowForTaskController:(RAUTaskController *)needyController isWrongPassword:(BOOL)bWrongPassword {
	if (self.passwordWindowIsShowing == NO || needyController == self.passwordWindowCurrentTask) {
		/* If the password window was not shown yet, prepare the UI and show it. If it was but needyController is the same controller as
		 the one the window was shown for, simply reset the UI (enable all UI elements, clear the textfield etc.) */
		NSString *title;
		if (bWrongPassword) {
			title = @"Incorrect password. Please enter again:";
		} else {
			title = @"Please enter password:";
		}
		
		/*
		NSFont *titleFontFitting = [RAUAuxiliary fontFittingToSize:passwordWindow.titleLabel.frame.size
														  withText:title 
														  fontName:[[NSFont boldSystemFontOfSize:0] fontName]
														 minPtSize:10.0
														 maxPtSize:13.5];*/
		
		//[self.passwordWindow.titleLabel			setFont:titleFontFitting];
		[self.passwordWindow.titleLabel			setStringValue:title];
		[self.passwordWindow.passwordTextField	setStringValue:@""];
		[self.passwordWindow.passwordTextField	setEnabled:YES];
		[self.passwordWindow.OKButton			setEnabled:YES];
		[self.passwordWindow.cancelButton		setEnabled:YES];
		
		if (self.passwordWindowIsShowing == NO) {
			[NSApp beginSheet:self.passwordWindow modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
			self.passwordWindowIsShowing = YES;
			
			self.passwordWindowCurrentTask = [needyController retain];
		}
		
		//Force the app to front to make the user aware of the password window and make the passwordTextField the first responder
		[NSApp					activateIgnoringOtherApps:YES];
		[self.window			makeFirstResponder:self.passwordWindow];
		[self.passwordWindow	makeFirstResponder:self.passwordWindow.passwordTextField];
	}
	//If a new controller comes in while the password sheet is already shown, add the controller to the sheet-queue
	else if ([self.passwordWindowWaitingTasks containsObject:needyController] == NO) {
		[self.passwordWindowWaitingTasks addObject:needyController];
	}
}

/* Automatically called when the OK button on the passwordWindow was pressed (RAUPasswordWindowDelegate) */
-(void)passwordWindowOKButtonPressed:(RAUPasswordWindow *)sendingPasswordWindow {
	if ([[self.passwordWindow.passwordTextField stringValue] length] > 0) {
		/* The UI is disabled until showPasswordWindowForTaskController: is called (either for the same controller if the password was wrong
		 or for a new controller */
		[self.passwordWindow.passwordTextField	setEnabled:NO];
		[self.passwordWindow.OKButton			setEnabled:NO];
		[self.passwordWindow.cancelButton		setEnabled:NO];
		
		[self.passwordWindowCurrentTask setPasswordArgument:[self.passwordWindow.passwordTextField stringValue]];
	}
}

/* Automatically called when the Cancel button on the passwordWindow was pressed (RAUPasswordWindowDelegate) */
-(void)passwordWindowCancelButtonPressed:(RAUPasswordWindow *)sendingPasswordWindow {
	[self.passwordWindowCurrentTask terminateTask];
	[self dismissPasswordWindow];
}

-(void)dismissPasswordWindow {
	[self.passwordWindowCurrentTask release];
	self.passwordWindowCurrentTask = nil;
	
	[NSApp endSheet:self.passwordWindow];
	[self.passwordWindow orderOut:self];
	self.passwordWindowIsShowing	= NO;
	
	//If there are TaskControllers in queue for the password sheet, pick the next one and show the password sheet for it
	if ([self.passwordWindowWaitingTasks count] > 0) {
		RAUTaskController *needyController = (RAUTaskController *)[self.passwordWindowWaitingTasks objectAtIndex:0];
		[self taskControllerNeedsPassword:needyController isWrong:NO];
		[self.passwordWindowWaitingTasks removeObject:needyController];
	}
}

@end
