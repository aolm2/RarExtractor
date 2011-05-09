//
//  RAURarfile.m
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAURarfile.h"
#import "RAUCheckTask.h"
#import "RAUPath.h"
#import "RAUAuxiliary.h"

@interface RAURarfile ()
@property (readwrite, copy)	RAUPath		*path;
@property (readwrite)		BOOL		isValid;
@property (readwrite)		BOOL		isPasswordProtected;
@property (readwrite)		int			numberOfParts;
@property (readwrite)		BOOL		passwordFound;
@property (readwrite, copy)	NSString	*correctPassword;

-(void)rarfileWasChecked:(RAUCheckTask *)checkTask;
-(void)passwordWasChecked:(RAUCheckTask *)finishedTask;
@end


@implementation RAURarfile
#pragma mark -
@synthesize path, isValid, isPasswordProtected, numberOfParts;


-(id)initWithFilePath:(RAUPath *)_path {
	if (self = [super init]) {
		self.path					= _path;
		self.isValid				= NO;
		self.isPasswordProtected	= NO;
		self.numberOfParts			= 0;
		self.passwordFound			= NO;
		self.correctPassword		= nil;
		
		//Do the initial check to see if the rarfile is valid or password-protected
		RAUCheckTask *checkTask = [[RAUCheckTask alloc] initWithFile:self];
		[checkTask setDelegate:self];
		[checkTask launchTask];
	}
	
	return self;
}


/* Automatically called when the initial check of the rarfile is done */
-(void)rarfileWasChecked:(RAUCheckTask *)checkTask {
	self.isValid				= (checkTask.detailedResult != CheckTaskResultArchiveInvalid);
	self.isPasswordProtected	= (checkTask.detailedResult == CheckTaskResultPasswordInvalid);
	
	//See if file is multiparted and how many parts it has
	self.numberOfParts = 0;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//First, check for the naming convention name.partXX.rar
	NSArray *filesAtPath = [fileManager contentsOfDirectoryAtPath:self.path.withoutFilename error:nil];
	if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"part[0-9]+"] evaluateWithObject:self.path.multipartExtension]) {
		NSPredicate *isPart = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:@"%@.part[0-9]+.%@", self.path.filename, self.path.extension]];
		for (NSString *fileAtPath in filesAtPath) {
			if ([isPart evaluateWithObject:fileAtPath] == YES) self.numberOfParts++;
		}
	}
	
	//Now for the naming convention name.rXX
	if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"r[0-9]+"] evaluateWithObject:self.path.extension] && self.numberOfParts == 0) {
		NSPredicate *isPart = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:@"%@.r[0-9]+", self.path.filename]];
		for (NSString *fileAtPath in filesAtPath) {
			if ([isPart evaluateWithObject:fileAtPath] == YES) self.numberOfParts++;
		}
	}
	
	//If none of the previous did something, we have only a single part
	if (self.numberOfParts == 0) self.numberOfParts = 1;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:RarfileWasCheckedNotification object:self];
}

-(void)dealloc {
	self.path				= nil;
	self.correctPassword	= nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Passwords
@synthesize passwordFound, correctPassword;

/* Checks if a password is correct for this rarfile */
-(void)checkPassword:(NSString *)passwordToCheck {
	RAUCheckTask *checkTask = [[RAUCheckTask alloc] initWithFile:self];
	[checkTask setDelegate:self];
	[checkTask setPasswordArgument:passwordToCheck];
	[checkTask launchTask];
}

/* Automatically called when a password check finished */
-(void)passwordWasChecked:(RAUCheckTask *)finishedTask {
	if (finishedTask.detailedResult != CheckTaskResultPasswordInvalid) {
		self.passwordFound = YES;
		self.correctPassword = finishedTask.passwordArgument;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:RarfilePasswordWasCheckedNotification object:self];
}

#pragma mark -
#pragma mark RAUTaskDelegate

/*  Automatically Called when a checkTask finishes (RAUTaskDelegate) */
-(void)taskDidFinish:(RAUTask *)finishedTask {
	RAUCheckTask *checkTask = (RAUCheckTask *)finishedTask;
	
	if (checkTask.passwordArgument == nil) { //finishedTask was the initial checkTask
		[self rarfileWasChecked:checkTask];
	} else { //finishedTask was a password check
		[self passwordWasChecked:checkTask];
	}
	
	[checkTask release];
}

/* Automatically called when a checkTask updates its progress (RAUTaskDelegate) */
-(void)taskProgressWasUpdated:(RAUTask *)updatedTask {}

@end
