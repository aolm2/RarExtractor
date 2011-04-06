//
//  RAUCheckTask.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RAUTask.h"
#import "RAUTaskPrivates.h"


#define CheckTaskDidFinishNotification	@"CheckTaskDidFinishNotification"
typedef enum {
	CheckTaskResultNone					= 0,
	CheckTaskResultArchiveInvalid		= 1,
	CheckTaskResultPasswordInvalid		= 2
} CheckTaskResult;

@class RAURarfile;
@interface RAUCheckTask : RAUTask {
	RAURarfile		*rarfile;
	CheckTaskResult	detailedResult;
	NSString		*passwordArgument;
}

@property (readonly, retain)	RAURarfile		*rarfile;
@property (readonly)			CheckTaskResult	detailedResult;
@property (readwrite, copy)		NSString		*passwordArgument;

-(id)initWithFile:(RAURarfile *)_rarfile;

@end
