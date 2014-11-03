//
//  UILOneLineOfCode.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILOneLineOfCode.h"

@implementation UILOneLineOfCode

- (id) init
{
	self = [super init];

	if (self)
	{
		self.originalLineOfCode = nil;
		self.assemblyOperationName = nil;
		self.machineLanguageOpcode = UILOpcodeUndetermined;
		self.hasOperand = NO;
		self.operand = 0;
	}

	return self;
}

- (id) initWithOriginalString: (NSString *) string
		assemblyOperationName: (NSString *) name
					   opcode: (UILOpcode) opcode
				   hasOperand: (BOOL) hasOperand
					  operand: (NSInteger) operand
{
	self = [self init];

	if (self)
	{
		self.originalLineOfCode = string;
		self.assemblyOperationName = name;
		self.machineLanguageOpcode = opcode;
		self.hasOperand = hasOperand;
		self.operand = operand;
	}

	return self;
}

@end
