//
//  RAUPath.m
//  RarExtractor
//
//  Created by Michael Terry on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAUPath.h"

@implementation RAUPath

@synthesize completePath, withoutFilename, filename, multipartExtension, extension;
@synthesize completeExtension, withoutExtensions, filenameWithExtensions, isDirectory;

-(id)initWithString:(NSString *)_completePath isDirectory:(BOOL)_isDirectory {
	if (self = [super init]) {
		self.completePath		= _completePath;
		self.isDirectory		= _isDirectory;
		
		if (self.isDirectory == NO) {
			//filename is just the name with no extensions, so remove extension and multipart extension if they exist
			self.filename			= [[[_completePath lastPathComponent] stringByDeletingPathExtension] stringByDeletingPathExtension];
			self.extension			= [_completePath pathExtension];
			self.multipartExtension	= [[_completePath stringByDeletingPathExtension] pathExtension];
			
			//multipartExtension should only be "partXX". If it is anything else, it should be part of the filename
			if ([self.multipartExtension length] > 0
				&& [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"part[0-9]+"] evaluateWithObject:self.multipartExtension] == NO) {
				self.filename			= [NSString stringWithFormat:@"%@.%@", self.filename, self.multipartExtension];
				self.multipartExtension	= nil;
			}
			
			//Get the completeExtension, which is MPExtension and extension including dots
			if ([self.extension length] > 0) {
				if ([self.multipartExtension length] > 0) {
					self.completeExtension = [NSString stringWithFormat:@".%@.%@", self.multipartExtension, self.extension];
				} else {
					self.completeExtension = [NSString stringWithFormat:@".%@", self.extension];
				}
			} else {
				self.completeExtension = nil;
			}
		} else { //directories have no extension
			self.filename			= [_completePath lastPathComponent];
			self.extension			= nil;
			self.multipartExtension	= nil;
			self.completeExtension	= nil;
		}
		
		self.withoutFilename		= [_completePath stringByDeletingLastPathComponent]; 
		self.withoutExtensions		= [self.withoutFilename stringByAppendingPathComponent:self.filename];
		self.filenameWithExtensions = [NSString stringWithFormat:@"%@%@", self.filename, self.completeExtension];
	}
	return self;
}

-(id)initWithFile:(NSString *)pathToFile {
	return [self initWithString:pathToFile isDirectory:NO];
}

-(id)initWithDirectory:(NSString *)pathToDirectory {
	return [self initWithString:pathToDirectory isDirectory:YES];
}

+(id)pathWithString:(NSString *)path isDirectory:(BOOL)shouldBeDirectory {
	return [[[RAUPath alloc] initWithString:path	isDirectory:shouldBeDirectory] autorelease];
}
+(id)pathWithFile:(NSString *)pathToFile {
	return [[[RAUPath alloc] initWithFile:pathToFile] autorelease];
}
+(id)pathWithDirectory:(NSString *)pathToDirectory {
	return [[[RAUPath alloc] initWithDirectory:pathToDirectory] autorelease];
}

-(id)copyWithZone:(NSZone *)zone {
	return [self retain]; //Because this object is immutable, we don't need a real copy
}

-(void)dealloc {	
	self.completePath			= nil;
	self.withoutFilename		= nil;
	self.filename				= nil;
	self.multipartExtension		= nil;
	self.extension				= nil;
	self.completeExtension		= nil;
	self.withoutExtensions		= nil;
	self.filenameWithExtensions	= nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Getters
/* Write getters for all properties so that they return an empty string instead of nil */

-(NSString *)completePath {
	if (completePath == nil)	return @"";
	else						return completePath;
}

-(NSString *)withoutFilename {
	if (withoutFilename == nil)	return @"";
	else						return withoutFilename;
}

-(NSString *)filename {
	if (filename == nil)	return @"";
	else					return filename;
}

-(NSString *)multipartExtension {
	if (multipartExtension == nil)	return @"";
	else							return multipartExtension;
}

-(NSString *)extension {
	if (extension == nil)	return @"";
	else					return extension;
}

-(NSString *)completeExtension {
	if (completeExtension == nil)	return @"";
	else							return completeExtension;
}

-(NSString *)withoutExtensions {
	if (withoutExtensions == nil)	return @"";
	else							return withoutExtensions;
}

-(NSString *)filenameWithExtensions {
	if (filenameWithExtensions == nil)	return @"";
	else								return filenameWithExtensions;
}

@end
