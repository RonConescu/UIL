//
//  UILCompiledFileLoader.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILCompiledFileLoader.h"
#import "Util.h"


#define FILE_NAME @"sampleWheelApp.txt"
#define DEBUG__LOAD_FROM_BUNDLE_NOT_USER_SPACE YES


@implementation UILCompiledFileLoader

+ (UILUserAppInRAM *) loadFromDisk
{
	UILUserAppInRAM *app = nil;
	NSFileManager *fileSystem = [NSFileManager defaultManager];
	NSError *error = nil;


	//
	// Where's the user file?
	//

	NSURL *documentsDir = [Util urlForDocumentsDirectory];

	NSURL *dataFile = (DEBUG__LOAD_FROM_BUNDLE_NOT_USER_SPACE ?
					   [[NSBundle mainBundle] URLForResource: FILE_NAME withExtension: nil] :
					   [documentsDir URLByAppendingPathComponent: FILE_NAME]);

	NSLog (@"Attempting to load user-data file at [%@].", dataFile.path);


	//
	// If the file exists, load it, and try to parse it.
	//

	if (! [fileSystem fileExistsAtPath: [dataFile path]])
	{
		NSLog (@"Couldn't find that file!");
	}

	else
	{
		NSString *contents = [NSString stringWithContentsOfURL: dataFile encoding: NSUTF8StringEncoding error: &error];

		if (error)
		{
			NSLog (@"Couldn't load the file, because: [%@]", error);
		}
		else
		{


		}
	}

	return app;
}


@end
