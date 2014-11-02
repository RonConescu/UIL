//
//  UILFunction.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILFunction.h"
#import "UILOneLineOfCode.h"

@implementation UILFunctionZZZ

- (id) init
{
	self = [super init];

	if (self)
	{
		self.Zname = @"UntitledFunction";
		self.ZinboundParameters = [NSMutableDictionary new];
		self.ZdeclaredParameters = [NSMutableDictionary new];
		self.ZreturnValue = nil;
		self.Zcode = [NSMutableArray new];
		self.ZassemblyLanguage = nil;
		self.ZmachineLanguage = nil;
	}

	return self;
}

- (void) generatePackedAssemblyAndMachineLanguage
{
	if (self.Zcode.count > 0)
	{
		NSMutableString *assembly = [NSMutableString new];
		NSMutableData *machine = [NSMutableData new];

		for (UILOneLineOfCode *line in self.Zcode)
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

		self.ZassemblyLanguage = assembly;
		self.ZmachineLanguage = machine;

		NSMutableString *machineLanguageValidationString = [NSMutableString new];

		for (NSInteger byteIndex = 0; byteIndex < self.ZmachineLanguage.length; byteIndex ++)
		{
			Byte thisByte = 0;
			[self.ZmachineLanguage getBytes: &thisByte range: NSMakeRange (byteIndex, 1)];
			[machineLanguageValidationString appendFormat: @"%d ", thisByte];
		}

		NSLog (@"Function [%@]:  generated this code:", self.Zname);
		NSLog (@"- assembly: [%@]", self.ZassemblyLanguage);
		NSLog (@"- machine:  [%@]", machineLanguageValidationString);
	}
}

@end
