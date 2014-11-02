//
//  Util.m
//  LightMeUp
//
//  Created by Ron Conescu on 10/2/14.
//  Copyright (c) 2014 TheBlackTank. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (CGFloat) clampFloat: (CGFloat) value toMin: (CGFloat) min andMax: (CGFloat) max
{
	CGFloat result = (value < min ? min : value > max ? max : value);
	return result;
}

+ (NSInteger) clampInt: (NSInteger) value toMin: (NSInteger) min andMax: (NSInteger) max
{
	NSInteger result = (value < min ? min : value > max ? max : value);
	return result;
}

+ (NSInteger) clampIntPercent: (NSInteger) value
{
	NSInteger result = [self clampInt: value toMin: 0 andMax: 100];
	return result;
}

+ (CGFloat) clampFloatPercent: (CGFloat) value
{
	CGFloat result = [self clampFloat: value toMin: 0 andMax: 1];
	return result;
}

/**
 From http://stackoverflow.com/a/13066288 (the 2nd answer to http://stackoverflow.com/questions/6907381/what-is-the-documents-directory-nsdocumentdirectory )
 */
+ (NSURL *) urlForDocumentsDirectory
{
	NSFileManager* fileManager = [NSFileManager defaultManager];

	NSArray* possibleURLs = [fileManager URLsForDirectory: NSDocumentDirectory
												inDomains: NSUserDomainMask];

	return possibleURLs.firstObject;
}

@end
