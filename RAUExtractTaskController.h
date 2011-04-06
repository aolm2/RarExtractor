//
//  RAUExtractTaskController.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAUTaskController.h"
#import "RAUTaskControllerPrivates.h"

@class RAUExtractTask;
@interface RAUExtractTaskController : RAUTaskController {
	RAUExtractTask *extractTask;
}

@property (readonly)	RAUExtractTask	*extractTask;

-(id)initWithFilePath:(RAUPath *)_rarfilePath;
-(id)initWithStringPath:(NSString *)pathToExtract;

@end
