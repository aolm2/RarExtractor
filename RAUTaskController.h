//
//  RAUTaskController.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAUTask.h"

@class RAUTaskController;
@protocol RAUTaskControllerDelegate
-(void)taskControllerNeedsPassword:(RAUTaskController *)needyController isWrong:(BOOL)bWrongPassword;
-(void)taskControllerRarfileInvalid:(RAUTaskController *)invalidController;
-(void)taskControllerIsReady:(RAUTaskController *)readyController;
-(void)taskControllerDidFinish:(RAUTaskController *)finishedController;
@end

@class RAUPath, RAURarfile, RAUTask, RAUTaskViewController;
@interface RAUTaskController : NSObject <RAUTaskDelegate> {
	id<RAUTaskControllerDelegate>	delegate;
	RAUPath							*rarfilePath;
	RAURarfile						*rarfile;
	NSString						*passwordArgument;
	RAUTask							*task;
	NSDate							*taskStartDate;
	RAUTaskViewController			*viewController;
	double							ETAFirstHalfFactor;
	double							ETALastRuntime;
	double							ETALastTotalRuntime;
}

@property (readwrite, assign)	id<RAUTaskControllerDelegate>	delegate;
@property (readwrite, copy)		RAUPath							*rarfilePath;
@property (readonly, retain)	RAURarfile						*rarfile;
@property (readwrite, copy)		NSString						*passwordArgument;
@property (readonly, retain)	RAUTask							*task;
@property (readonly, retain)	RAUTaskViewController			*viewController;

-(void)launchTask;
-(void)terminateTask;
-(void)showErrorAndFinish:(NSString *)errorMessage;

@end
