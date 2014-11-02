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
		self.machineLanguageOpcode = UILOpcodeUnknown;
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

+ (void) printOpCodes
{
	NSMutableString *string = [NSMutableString new];

	for (NSInteger code = UILOpcodeUnknown; code <= UILOpcodePushMethodFrameWithParameters; code ++)
	{
		NSString *name = nil;

		switch (code) {
			case UILOpcodeUnknown: name = @"unknown"; break;
			case UILOpcodeIdentifier: name = @"identifier"; break;
			case UILOpcodeInteger: name = @"integer"; break;
			case UILOpcodeFind: name = @"find"; break;
			case UILOpcodeFindInObject: name = @"findInObject"; break;
			case UILOpcodeLoad: name = @"load"; break;
			case UILOpcodeInvokeMethod: name = @"invokeMethod"; break;
			case UILOpcodeReturn: name = @"return"; break;
			case UILOpcodeExit: name = @"exit"; break;
			case UILOpcodeAssign: name = @"assign"; break;
			case UILOpcodeDeclare: name = @"declare"; break;
			case UILOpcodeMultiply: name = @"multiply"; break;
			case UILOpcodePushThis: name = @"pushThis"; break;
			case UILOpcodePushMethodFrameWithParameters: name = @"pushMethodFrame"; break;

			default: name = @"unknown (seriously)"; break;
		}

		[string appendFormat: @"   %d %@", (int) code, name];
	}

	NSLog (@ "For reference, the opcodes are:  %@", string);
}

@end
