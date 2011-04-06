//
//  RAUTaskPrivates.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface RAUTask ()
@property (readwrite)			int			progress;
@property (readwrite)			TaskResult	result;
@property (readwrite, retain)	NSTask		*task;

-(void)willFinish;
-(void)didFinish;
-(void)taskWillLaunch;
-(void)taskDidLaunch;
-(void)taskDidTerminate:(NSNotification *)notification;
-(void)receivedNewOutput:(NSNotification *)notification;
-(void)parseNewOutput:(NSString *)output;
-(int)parseProgressFromString:(NSString *)output;
@end