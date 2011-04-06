//
//  RAUPath.h
//  RarExtractor
//
//  Created by Michael Terry on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RAUPath : NSObject {
	NSString	*completePath;
	NSString	*withoutFilename;
	NSString	*filename;
	NSString	*multipartExtension;
	NSString	*extension;
	NSString	*completeExtension;
	NSString	*withoutExtensions;
	NSString	*filenameWithExtensions;
	BOOL		isDirectory;
}

@property (readwrite, copy)	NSString	*completePath;
@property (readwrite, copy)	NSString	*withoutFilename;
@property (readwrite, copy)	NSString	*filename;
@property (readwrite, copy)	NSString	*multipartExtension;
@property (readwrite, copy)	NSString	*extension;
@property (readwrite, copy)	NSString	*completeExtension;
@property (readwrite, copy)	NSString	*withoutExtensions;
@property (readwrite, copy)	NSString	*filenameWithExtensions;
@property (readwrite)		BOOL		isDirectory;

-(id)initWithString:(NSString *)_completePath isDirectory:(BOOL)_isDirectory;
-(id)initWithFile:(NSString *)pathToFile;
-(id)initWithDirectory:(NSString *)pathToDirectory;
+(id)pathWithString:(NSString *)path isDirectory:(BOOL)shouldBeDirectory;
+(id)pathWithFile:(NSString *)pathToFile;
+(id)pathWithDirectory:(NSString *)pathToDirectory;

@end
