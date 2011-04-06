//
//  RAURarfile.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAUTask.h"

#define RarfileWasCheckedNotification			@"RarfileWasCheckedNotification"
#define RarfilePasswordWasCheckedNotification	@"RarfilePasswordWasCheckedNotification"


@class RAUPath;
@interface RAURarfile : NSObject <RAUTaskDelegate> {
	RAUPath		*path;
	BOOL		isValid;
	BOOL		isPasswordProtected;
	int			numberOfParts;
	BOOL		passwordFound;
	NSString	*correctPassword;
}

@property (readonly, copy)	RAUPath		*path;
@property (readonly)		BOOL		isValid;
@property (readonly)		BOOL		isPasswordProtected;
@property (readonly)		int			numberOfParts;
@property (readonly)		BOOL		passwordFound;
@property (readonly, copy)	NSString	*correctPassword;

-(id)initWithFilePath:(RAUPath *)_path;
-(void)checkPassword:(NSString *)passwordToCheck;

@end
