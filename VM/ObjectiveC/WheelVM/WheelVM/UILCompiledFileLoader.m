//
//  UILCompiledFileLoader.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILCompiledFileLoader.h"
#import "Util.h"
#import "UILFunction.h"
#import "UILOneLineOfCode.h"
#import "UILOpcode.h"

typedef enum : NSUInteger {
	UILCompiledFileSectionTypeNotInteresting,
	UILCompiledFileSectionTypeIdentifiers,
	UILCompiledFileSectionTypeIntegers,
	UILCompiledFileSectionTypeOneFunction,
} UILCompiledFileSectionType;

#define FILE_NAME @"sampleWheelApp.txt"
#define DEBUG__LOAD_FROM_BUNDLE_NOT_USER_SPACE YES

// Anything longer than these is fine.
#define ASSEMBLY_LANGUAGE_SECTION_DIVIDER_PREFIX_1 @"============="
#define ASSEMBLY_LANGUAGE_SECTION_DIVIDER_PREFIX_2 @"-------------"
#define ASSEMBLY_LANGUAGE_SECTION_MARKER_IDENTIFIERS @"identifiers"
#define ASSEMBLY_LANGUAGE_SECTION_MARKER_INTEGERS @"integers"
#define ASSEMBLY_LANGUAGE_SECTION_MARKER_FUNCTION @"function:"
#define ASSEMBLY_LANGUAGE_SECTION_MARKER_PARAMETERS @"parameters:"
#define ASSEMBLY_LANGUAGE_METHODS_NO_PARAMETERS_MARKER @"none"
#define ASSEMBLY_LANGUAGE_METHODS_PARAMETER_SEPARATOR @", "


@implementation UILCompiledFileLoader

- (UILUserAppInRAM *) loadFromDisk
{
	UILUserAppInRAM *app = [UILUserAppInRAM new];
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
			NSArray *sections = [self scanForSections: contents];

			for (NSArray *section in sections)
			{
				UILCompiledFileSectionType type = [self detectSectionType: section];

				switch (type)
				{
					default:
					case UILCompiledFileSectionTypeNotInteresting:
						break;

					case UILCompiledFileSectionTypeIdentifiers:
						[app setListOfDetectedIdentifiers: [self extractIdentifiersFromSection: section]];
						break;

					case UILCompiledFileSectionTypeIntegers:
						[app setListOfDetectedIntegers: [self extractIntegersFromSection: section]];
						break;

					case UILCompiledFileSectionTypeOneFunction:
					{
						UILFunction *function = [self extractOneFunctionFromSection: section];

						if (function != nil)
							[app addDetectedFunction: function];

						break;
					}
				}
			}

			/**
			 A hack, for this method.  See explanation over
			 the internal (private) "functions" property.
			 */
			[app recomputePubliclyVisibleFunctions];
		}
	}

	[UILOpcodeHelper printAll];

	return app;
}

- (NSArray*) scanForSections: (NSString *) fileContents
{
	NSMutableArray *result = [NSMutableArray new];
	NSArray *lines = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
	NSMutableArray *currentSetOfLines = [NSMutableArray new];
	NSInteger dividerCount = 0;

	for (NSString *line in lines)
	{
		if ([line hasPrefix: ASSEMBLY_LANGUAGE_SECTION_DIVIDER_PREFIX_1] ||
			[line hasPrefix: ASSEMBLY_LANGUAGE_SECTION_DIVIDER_PREFIX_2])
		{
			dividerCount ++;
		}

		if (dividerCount == 3)
		{
			dividerCount = 1;

			if (currentSetOfLines.count > 0)
			{
				[result addObject: currentSetOfLines];
			}

			currentSetOfLines = [NSMutableArray new];
		}

		[currentSetOfLines addObject: line];
	}

	if (! [result containsObject: currentSetOfLines])
		[result addObject: currentSetOfLines];

	return result;
}

- (UILCompiledFileSectionType) detectSectionType: (NSArray *) sectionOfLinesFromFile
{
	NSString *label = [sectionOfLinesFromFile [1] lowercaseString];

	UILCompiledFileSectionType result =
	(
	  [label hasPrefix: ASSEMBLY_LANGUAGE_SECTION_MARKER_IDENTIFIERS] ? UILCompiledFileSectionTypeIdentifiers :
	  [label hasPrefix: ASSEMBLY_LANGUAGE_SECTION_MARKER_INTEGERS]    ? UILCompiledFileSectionTypeIntegers :
	  [label hasPrefix: ASSEMBLY_LANGUAGE_SECTION_MARKER_FUNCTION]    ? UILCompiledFileSectionTypeOneFunction :
	  UILCompiledFileSectionTypeNotInteresting
	);

	return result;
}

- (NSArray *) extractIdentifiersFromSection: (NSArray *) sectionOfLinesFromFile
{
	NSMutableArray *identifiers = [NSMutableArray new];
	BOOL startReading = NO;
	BOOL isFirstLine = YES;
	NSString *dividerString = nil;

	for (NSString *line in sectionOfLinesFromFile)
	{
		if (isFirstLine)
		{
			dividerString = line;
			isFirstLine = NO;
		}

		else if ([line isEqualToString: dividerString])
			startReading = YES;

		else if (! startReading)
		{
			// Ignore it.  We're still in the header/comment section.
		}

		else
		{
			NSString *trimmedLine = [self trimAfterStrippingTrailingCommentFromLine: line];

			if (trimmedLine != nil)
				[identifiers addObject: trimmedLine];
		}
	}

	if (identifiers.count == 0) identifiers = nil;

	NSLog (@"Found these identifiers: %@", [identifiers componentsJoinedByString: @", "]);

	return identifiers;
}

- (NSArray *) extractIntegersFromSection: (NSArray *) sectionOfLinesFromFile
{
	NSMutableArray *integers = [NSMutableArray new];

	BOOL startReading = NO;
	BOOL isFirstLine = YES;
	NSString *dividerString = nil;

	for (NSString *line in sectionOfLinesFromFile)
	{
		if (isFirstLine)
		{
			dividerString = line;
			isFirstLine = NO;
		}

		else if ([line isEqualToString: dividerString])
			startReading = YES;

		else if (! startReading)
		{
			// Ignore it.  We're still in the header/comment section.
		}

		else
		{
			NSString *trimmedLine = [self trimAfterStrippingTrailingCommentFromLine: line];
			NSInteger intValue = [trimmedLine integerValue];
			NSString *verificationString = [NSString stringWithFormat: @"%d", (int) intValue];
			if ([trimmedLine isEqualToString: verificationString])
			{
				[integers addObject: @(intValue)];
			}
		}
	}

	if (integers.count == 0) integers = nil;

	NSLog (@"Found these integers: %@", [integers componentsJoinedByString: @", "]);

	return integers;
}

- (UILFunction *) extractOneFunctionFromSection: (NSArray *) sectionOfLinesFromFile
{
	UILFunction *function = [UILFunction new];

	BOOL isFirstLine = YES;
	BOOL isInHeaderSection = YES;
	NSString *dividerString = nil;

	for (NSString *line in sectionOfLinesFromFile)
	{
		if (isFirstLine)
		{
			dividerString = line;
			isFirstLine = NO;
		}

		else if ([line isEqualToString: dividerString])
			isInHeaderSection = NO;

		else if (isInHeaderSection)
		{
			[self tryToExtractFunctionNameFromString: line intoFunction: function];
			[self tryToExtractDeclaredParametersFromString: line intoFunction: function];
		}

		else
		{
			NSString *trimmedLine = [self trimAfterStrippingTrailingCommentFromLine: line];

			if (trimmedLine != nil)
			{
				NSArray *opcodeAndOperand = [trimmedLine componentsSeparatedByString: @" "];

				NSString *assemblyCommand = opcodeAndOperand [0];

				UILOpcode opcode = [UILOpcodeHelper opcodeForCamelCaseName: assemblyCommand];

				if (opcode == UILOpcodeUndetermined)
				{
					NSLog (@"Couldn't identify opcode in [%@].  (This is probably bad.)  Skipping.", trimmedLine);
				}

				else
				{
					BOOL haveOperand = NO;
					NSInteger operand = 0;

					if (opcodeAndOperand.count > 1)
					{
						NSString *operandString = opcodeAndOperand [1];
						operand = [operandString integerValue];
						NSString *verificationString = [NSString stringWithFormat: @"%d", (int) operand];

						if ([operandString isEqualToString: verificationString])
						{
							haveOperand = YES;
						}
					}

					UILOneLineOfCode *lineOfCode = [[UILOneLineOfCode alloc] initWithOriginalString: trimmedLine
																			  assemblyOperationName: assemblyCommand
																							 opcode: opcode
																						 hasOperand: haveOperand
																							operand: operand];

					[function.code addObject: lineOfCode];
				}
			}
		}
	}

	[function generatePackedAssemblyAndMachineLanguage];

	return function;
}

- (NSString *) trimAfterStrippingTrailingCommentFromLine: (NSString *) line
{
	NSString *result = nil;
	NSRange semicolonLocation = [line rangeOfString: @";"];

	if (semicolonLocation.location != NSNotFound)
		result = [line substringToIndex: semicolonLocation.location];
	else
		result = line;

	result = [result stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if (result.length == 0) result = nil;

	return result;
}

- (void) tryToExtractFunctionNameFromString: (NSString *) line intoFunction: (UILFunction *) function
{
	line = [self trimAfterStrippingHeader: ASSEMBLY_LANGUAGE_SECTION_MARKER_FUNCTION fromString: line];

	if (line != nil)
	{
		function.name = line;
		NSLog (@"Found function with name [%@].", function.name);
	}
}

- (void) tryToExtractDeclaredParametersFromString: (NSString *) line
									 intoFunction: (UILFunction *) function
{
	line = [self trimAfterStrippingHeader: ASSEMBLY_LANGUAGE_SECTION_MARKER_PARAMETERS fromString: line];

	if (line != nil)
	{
		/*
		 Split on anything NOT an alphanumeric character.  For example,
		 if the line is "parameters: one, two, three", we'll delete
		 the "parameters:" part (above), and then split on the ", "
		 separating the parameter names.
		 */
		NSArray *parameterNames = [line componentsSeparatedByString: ASSEMBLY_LANGUAGE_METHODS_PARAMETER_SEPARATOR];

		if (parameterNames.count == 1 && [parameterNames.firstObject isEqualToString: ASSEMBLY_LANGUAGE_METHODS_NO_PARAMETERS_MARKER])
		{
			parameterNames = nil;
		}

		function.declaredParameterNames = parameterNames;

		if (parameterNames.count > 0)
		{
			NSLog (@"Function [%@] has parameters [%@].", function.name, [function.declaredParameterNames componentsJoinedByString: @", "]);
		}
	}
}

- (NSString *) trimAfterStrippingHeader: (NSString *) headerPhrase fromString: (NSString *) lineFromFile
{
	NSString *result = nil;

	if ([lineFromFile hasPrefix: headerPhrase])
	{
		result = [lineFromFile substringFromIndex: headerPhrase.length];

		result = [result stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

		if (result.length == 0)
			result = nil;
	}

	return result;
}

@end











