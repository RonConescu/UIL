//
//  UILUserAppInRAM.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILUserAppInRAM.h"

@interface UILUserAppInRAM ()

@property (nonatomic, strong) NSMutableDictionary *functionsInternal;

/**
 I need to make sure I don't store a mutable dictionary
 in the world, even behind the scenes, because UILVariable
 checks the instance's superclass to see whether I *should*
 set a value -- and by the time it gets that dictionary,
 the pointer's been passed around for a while.
 */
@property (nonatomic, strong) NSDictionary *functions;

@end



@implementation UILUserAppInRAM

- (id) init
{
	self = [super init];

	if (self)
	{
		self.identifiers = nil;
		self.integers = nil;
		self.functionsInternal = nil;
		self.functions = nil;
	}

	return self;
}

- (void) setListOfDetectedIdentifiers: (NSArray *) list
{
	self.identifiers = list;
}

- (void) setListOfDetectedIntegers: (NSArray *) list
{
	self.integers = list;
}

- (void) addDetectedFunction: (UILFunction *) function
{
	if (self.functionsInternal == nil)
	{
		self.functionsInternal = [NSMutableDictionary new];
	}

	self.functionsInternal [function.name] = function;
}

- (void) recomputePubliclyVisibleFunctions
{
	self.functions = [NSDictionary dictionaryWithDictionary: self.functionsInternal];
}

@end
