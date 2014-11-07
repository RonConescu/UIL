//
//  UILFoundVariableRecord.m
//  WheelVM
//
//  Created by Ron Conescu on 11/3/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILFoundVariableRecord.h"
#import "NSDictionary+Utilities.h"

@implementation UILFoundVariableRecord

- (id) init
{
	self = [super init];

	if (self)
	{
		self.mutableDictionaryContainingVariable = nil;
		self.immutableDictionaryContainingVariable = nil;
		self.name = nil;
		self.isNull = NO;
	}

	return self;
}

- (id) initWithName: (NSString *) variableName
{
	self = [self init];

	if (self)
	{
		self.name = variableName;
	}

	return self;
}

- (id) value
{
	id result = self.mutableDictionaryContainingVariable [self.name];

	if (result == nil)
		result = self.immutableDictionaryContainingVariable [self.name];

	return result;
}

- (void) setValue: (id) value
{
	if (self.isSettable)
		self.mutableDictionaryContainingVariable [self.name] = value;

	else
		NSLog (@"VariableRecord.set(): WARNING: Can't set because I'm looking at an immutable dictionary.");
}

- (void) setDictionaryBySearchingDictionaries: (NSArray *) dictionaries
{
	NSDictionary *dictionary = nil;

	for (NSDictionary *thisDictionary in dictionaries)
	{
		if (thisDictionary [self.name] != nil)
		{
			dictionary = thisDictionary;
			break;
		}
	}

	if (dictionary == nil)
		self.isNull = YES;

	else if (dictionary.isMutable)
		self.mutableDictionaryContainingVariable = (NSMutableDictionary *) dictionary;

	else
		self.immutableDictionaryContainingVariable = dictionary;
}

- (BOOL) isSettable
{
	return self.mutableDictionaryContainingVariable != nil;
}

@end
