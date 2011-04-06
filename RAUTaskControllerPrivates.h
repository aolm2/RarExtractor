//
//  RAUTaskControllerPrivates.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface RAUTaskController ()
@property (readwrite, retain)	RAURarfile				*rarfile;
@property (readwrite, retain)	RAUTask					*task;
@property (readwrite, retain)	NSDate					*taskStartDate;
@property (readwrite, retain)	RAUTaskViewController	*viewController;
@property (readwrite)			double					ETAFirstHalfFactor;
@property (readwrite)			double					ETALastRuntime;
@property (readwrite)			double					ETALastTotalRuntime;

-(void)initView;
-(void)didFinish;
-(void)rarfileWasChecked:(NSNotification *)notification;
-(void)passwordWasChecked:(NSNotification *)notification;
-(void)taskWillLaunch;
-(void)taskDidLaunch;
-(NSString *)getETAString;
@end