//
//  RAUMainWindow.m
//  RarExtractor
//
//  Created by Michael Terry on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAUMainWindow.h"


@implementation RAUMainWindow
@synthesize introLabel;
#pragma mark -
#pragma mark Dragging

-(void)awakeFromNib {
	//Register the main window to accept drags
	[self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]]; 
}

/* Automatically called when someone drags a file into the window. We need this method to report to the OS we accept the drag */
-(NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard]; //The pastboard that contains the dragged elements
	
    if ([[pboard types] containsObject:NSFilenamesPboardType]) { //Dragged item was a file
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		
		BOOL isRarfileContained = NO;
		for (NSString *file in files) {
			if ([[[file pathExtension] lowercaseString] isEqualToString:@"rar"] == YES) {
				isRarfileContained = YES;
				break;
			}
		}
		
		return isRarfileContained ?NSDragOperationCopy:NSDragOperationNone; 
    }
    return NSDragOperationNone; //No file? Permit the drag
}

/* Automatically called when the user releases drags over our app */
-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard]; //The dragged elements
	
    if ([[pboard types] containsObject:NSFilenamesPboardType]) { //Dragged items were files
		//Get the files and tell our app delegate to open them
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		[[[NSApplication sharedApplication] delegate] application:nil openFiles:files];
    }
	
    return YES;
}


#pragma mark -
#pragma mark Expand/Collapse animations

/* Sets the duration for a resize (expand/collapse) animation */
-(NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame {
	return 0.55;
}


/* Expands the window vertically */
-(void)expandBy:(int)expandBy animate:(BOOL)animate {
	NSRect windowFrame = self.frame;
	NSRect newWindowFrame = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y-expandBy, 
									   windowFrame.size.width, windowFrame.size.height+expandBy); 
	
	[self setFrame:newWindowFrame
		   display:YES 
		   animate:animate];
}
-(void)expandBy:(int)expandBy {
	[self expandBy:expandBy animate:YES];
}

/* Collapses the window vertically */
-(void)collapseBy:(int)collapseBy animate:(BOOL)animate {
	NSRect windowFrame = self.frame;
	NSRect newWindowFrame = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y+collapseBy, 
									   windowFrame.size.width, windowFrame.size.height-collapseBy);
	
	[self setFrame:newWindowFrame
		   display:YES 
		   animate:animate];
}

-(void)collapseBy:(int)collapseBy {
	[self collapseBy:collapseBy animate:YES];
}


@end
