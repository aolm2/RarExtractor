//
//  ClickableText.h
//  RarExtractor
//
//  Created by Michael Terry on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
@interface NSColor (ClickableTextColors)

+ (NSColor *)basicClickableTextColor;
+ (NSColor *)trackingClickableTextColor;
+ (NSColor *)visitedClickableTextColor;

@end

@interface ClickableText : NSTextField {
	BOOL beingClicked, beenClicked;
}

- (id)initWithFrame:(NSRect)frame;

@end
