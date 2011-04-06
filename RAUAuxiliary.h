//
//  RAUAuxiliary.h
//  RarExtractor
//
//  Created by Michael Terry on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RAUPath;
@interface RAUAuxiliary : NSObject {
}

+(NSString *)uniqueSuffixForFilenames:(NSArray *)filePaths inPath:(RAUPath *)path;
+(RAUPath *)uniquePathForFilename:(RAUPath *)file inPath:(RAUPath *)path;
+(RAUPath *)uniquePathForStringFilename:(NSString *)file inStringPath:(NSString *)path isDirectory:(BOOL)shouldBeDirectory;
+(RAUPath *)uniqueTemporaryPath;
+(NSString *)stringPathForFilename:(RAUPath *)file inPath:(RAUPath *)path withSuffix:(NSString *)suffix;
+(int)filesInStringPath:(NSString *)path;
+(int)filesInPath:(RAUPath *)path;
+(void)revealInFinder:(RAUPath *)path;
+(NSFont *)fontFittingToSize:(NSSize)targetSize withText:(NSString *)text fontName:(NSString *)fontName minPtSize:(float)minSize maxPtSize:(float)maxSize;
+(BOOL)isStringPathDirectory:(NSString *)path;

@end