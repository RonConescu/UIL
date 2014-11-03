//
//  UILFunction.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILFunction.h"
#import "UILOneLineOfCode.h"

@implementation UILFunction

- (id) init
{
	self = [super init];

	if (self)
	{
		self.name = @"UntitledFunction";
		self.inboundParameters = [NSMutableDictionary new];
		self.declaredParameters = [NSMutableDictionary new];
		self.returnValue = nil;
		self.code = [NSMutableArray new];
		self.assemblyLanguage = nil;
		self.machineLanguage = nil;
	}

	return self;
}

- (void) generatePackedAssemblyAndMachineLanguage
{
	if (self.code.count > 0)
	{
		NSMutableString *assembly = [NSMutableString new];
		NSMutableData *machine = [NSMutableData new];

		for (UILOneLineOfCode *line in self.code)
		{
			if (line.hasOperand)
			{
				[assembly appendFormat: @"%@ %d ", line.assemblyOperationName, (int) line.operand];

				Byte opcodeAndOperand [] = {line.machineLanguageOpcode, line.operand};
				[machine appendBytes: opcodeAndOperand length: 2];
			}

			else
			{
				[assembly appendFormat: @"%@ ", line.assemblyOperationName];

				Byte opcodeAndOperand [] = {line.machineLanguageOpcode};
				[machine appendBytes: opcodeAndOperand length: 1];
			}
		}

		self.assemblyLanguage = assembly;
		self.machineLanguage = machine;

		NSMutableString *machineLanguageValidationString = [NSMutableString new];

		for (NSInteger byteIndex = 0; byteIndex < self.machineLanguage.length; byteIndex ++)
		{
			Byte thisByte = 0;
			[self.machineLanguage getBytes: &thisByte range: NSMakeRange (byteIndex, 1)];
			[machineLanguageValidationString appendFormat: @"%d ", thisByte];
		}

		NSLog (@"Function [%@] generated this assembly code [%@] and this machine code [%@]", self.name, self.assemblyLanguage, machineLanguageValidationString);
	}
}

@end
