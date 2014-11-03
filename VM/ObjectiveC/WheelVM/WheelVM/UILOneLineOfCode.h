//
//  UILOneLineOfCode.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 The integers behind these values ARE my machine language.

 Fow now, these will all be effectively random increasing integers.  That's fine; I'm still trying to make this work at all, so I'm using fully human-readable "assembly"-language commands.

 At the moment, these opcodes take either 0 or 1 parameters.  Either way, they probably operate on the stack.
 */
typedef enum : NSUInteger {

	// Error-handling during parsing
	UILOpcodeUndetermined,

	// Looking stuff up
	UILOpcodeIdentifier,		// pull address of a certain identifying string
	UILOpcodeInteger,			// load a certain integer
	UILOpcodeFind,				// find in global space
	UILOpcodeFindInObject,		// find in the 'this' on the stack
	UILOpcodeLoad,				// put value of variable on stack

	// Flow of control
	UILOpcodeInvokeMethod,		// launch a method, consume params, put return value on the stack
	UILOpcodeReturn,			// exit the method
	UILOpcodeExit,				// exit the app

	// In-method commands
	UILOpcodeAssign,			// assign value at top of stack to variable whose address is in 2nd position on stack
	UILOpcodeDeclare,			// declare variable whose identifier's address is on the stack
	UILOpcodeMultiply,			// multiply the top 2 items on the stack, replacing them with the product

	// Special stack items
	UILOpcodePushThis,			// push a special code meaning "this" onto the stack (?)
	UILOpcodePushMethodFrameWithParameters,		// push a special code meaning "method invocation" onto the stack, and tell the VM to actually instantiate a new method frame

} UILOpcode;




@interface UILOneLineOfCode : NSObject

@property (nonatomic, strong) NSString *originalLineOfCode;
@property (nonatomic, strong) NSString *assemblyOperationName;
@property (nonatomic, assign) UILOpcode machineLanguageOpcode;
@property (nonatomic, assign) BOOL hasOperand;
@property (nonatomic, assign) NSInteger operand;

+ (void) printOpCodes;

- (id) initWithOriginalString: (NSString *) string
		assemblyOperationName: (NSString *) name
					   opcode: (UILOpcode) opcode
				   hasOperand: (BOOL) hasOperand
					  operand: (NSInteger) operand;

@end
