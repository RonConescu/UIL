//
//  UILOpcode.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILOpcode.h"


static NSDictionary *camelCaseNamesToOpcodes = nil;
static NSDictionary *titleCaseNamesToOpcodes = nil;
static NSDictionary *opcodesToCamelCaseNames = nil;
static NSDictionary *opcodesToTitleCaseNames = nil;



@interface NSString (UILOpcode)
@property (nonatomic, readonly) NSString *stringWithFirstLetterLowercase;
@end

@implementation NSString (UILOpcode)

- (NSString *) stringWithFirstLetterLowercase
{
	NSString *result = [NSString stringWithFormat: @"%@%@",
						[self substringToIndex: 1].lowercaseString,
						[self substringFromIndex: 1]
						];

	return result;
}

@end



@implementation UILOpcodeHelper

+ (void) initialize
{
	if (titleCaseNamesToOpcodes == nil)
	{
		/*
		 This stuff uses two C macro preprocssor "tricks":

		 - "token pasting":  The "##" operator.  Joins two words into
		    a single resulting string, specifically if one of those
		    words is a macro parameter.  Documentation:
			https://gcc.gnu.org/onlinedocs/cpp/Concatenation.html
		 
		 - "stringification":  The "#" operator.  Puts the specified
		    macro parameter in C-style quotes.  Documentation:
		    https://gcc.gnu.org/onlinedocs/cpp/Stringification.html
		 */

		titleCaseNamesToOpcodes = @{
							#define ENUM_ENTRY(itemName) (@#itemName): ( @(UILOpcode ## itemName) ),		// --> @"keyword": @(value),
							#include "UILOpcode_Internal.h"
							#undef ENUM_ENTRY
						   };

		camelCaseNamesToOpcodes = @{
							#define ENUM_ENTRY(itemName) [(@#itemName) stringWithFirstLetterLowercase]: ( @(UILOpcode ## itemName) ),		// --> @"keyword": @(value),
							#include "UILOpcode_Internal.h"
							#undef ENUM_ENTRY
						   };

		opcodesToTitleCaseNames = @{
							#define ENUM_ENTRY(itemName) ( @(UILOpcode ## itemName) ) : (@#itemName),		// --> @(value): @"keyword",
							#include "UILOpcode_Internal.h"
							#undef ENUM_ENTRY
						   };

		opcodesToCamelCaseNames = @{
							#define ENUM_ENTRY(itemName) ( @(UILOpcode ## itemName) ) : [(@#itemName) stringWithFirstLetterLowercase],		// --> @(value): @"keyword",
							#include "UILOpcode_Internal.h"
							#undef ENUM_ENTRY
						   };
	}
}

+ (UILOpcode) opcodeForCamelCaseName: (NSString *) name
{
	UILOpcode result = UILOpcodeUndetermined;

	NSNumber *maybeOpcode = camelCaseNamesToOpcodes [name];

	if (maybeOpcode != nil)
		result = (UILOpcode) maybeOpcode.integerValue;

	return result;
}

+ (UILOpcode) opcodeForTitleCaseName: (NSString *) name
{
	UILOpcode result = UILOpcodeUndetermined;

	NSNumber *maybeOpcode = titleCaseNamesToOpcodes [name];

	if (maybeOpcode != nil)
		result = (UILOpcode) maybeOpcode.integerValue;

	return result;
}

+ (NSString *) camelCaseNameForOpcode: (UILOpcode) opcode
{
	NSString *name = opcodesToCamelCaseNames [ @(UILOpcodeUndetermined) ];

	NSString *maybeName = opcodesToCamelCaseNames [ @(opcode) ];

	if (maybeName != nil)
		name = maybeName;

	return name;
}

+ (NSString *) titleCaseNameForOpcode: (UILOpcode) opcode
{
	NSString *name = opcodesToTitleCaseNames [ @(UILOpcodeUndetermined) ];

	NSString *maybeName = opcodesToTitleCaseNames [ @(opcode) ];

	if (maybeName != nil)
		name = maybeName;

	return name;
}

+ (void) printAll
{
	NSMutableString *string = [NSMutableString new];

	NSArray *sortedKeys = [opcodesToCamelCaseNames.allKeys sortedArrayUsingComparator:^NSComparisonResult (NSNumber *opcodeObj1, NSNumber *opcodeObj2) {
		return [opcodeObj1 compare: opcodeObj2];
	}];

	for (NSNumber *key in sortedKeys)
		[string appendFormat: @"   %@ %@", key, opcodesToCamelCaseNames [key]];

	NSLog (@ "For reference, the opcodes are:  %@", string);
}


@end







