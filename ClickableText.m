//
//  ClickableText.m
//  RarExtractor
//
//  Created by Michael Terry on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClickableText.h"


@implementation NSColor (ClickableTextColors)

+ (NSColor *)basicClickableTextColor
{
	static NSColor *cachedColor = nil;
	
	if (!cachedColor)
		cachedColor = [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0] retain];
	
	return cachedColor;
}

+ (NSColor *)trackingClickableTextColor
{
	static NSColor *cachedColor = nil;
	
	if (!cachedColor)
		cachedColor = [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:1.0] retain];
	
	return cachedColor;
}

+ (NSColor *)visitedClickableTextColor
{
	static NSColor *cachedColor = nil;
	
	if (!cachedColor)
		cachedColor = [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0] retain];
	
	return cachedColor;
}

@end

@implementation ClickableText

- (void)finishInitialization
{
	[self setBordered:NO];
	[self setBezeled:NO];
	[self setDrawsBackground:NO];
	[self setEditable:NO];
	[self setSelectable:NO];
	[self setEnabled:YES];
	[self setTextColor:[NSColor basicClickableTextColor]];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder])
	{
		[self finishInitialization];
	}
	
	return self;
}

- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self finishInitialization];
	}
	
	return self;
}

- (void)mouseDown:(NSEvent *)event
{
	BOOL mouseInside = YES;
	
	beingClicked = YES;
	[self setTextColor:[NSColor trackingClickableTextColor]];
	
	while (beingClicked && (event = [[self window] nextEventMatchingMask:(NSLeftMouseUpMask | NSLeftMouseDraggedMask)]))
	{
		NSEventType type = [event type];
		NSPoint location = [event locationInWindow];
		
		location = [self convertPoint:location fromView:nil];
		mouseInside = NSPointInRect(location, [self bounds]);
		
		if (mouseInside)
			[self setTextColor:[NSColor trackingClickableTextColor]];
		else if (beenClicked)
			[self setTextColor:[NSColor visitedClickableTextColor]];
		else
			[self setTextColor:[NSColor basicClickableTextColor]];
		
		if (type == NSLeftMouseUp)
			beingClicked = NO;
	}
	
	if (mouseInside)
	{
		beenClicked = YES;
		[self setTextColor:[NSColor visitedClickableTextColor]];
		[self sendAction:[self action] to:[self target]];
	}
}

@end