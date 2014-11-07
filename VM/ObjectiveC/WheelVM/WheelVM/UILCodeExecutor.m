//
//  UILCodeExecutor.m
//  WheelVM
//
//  Created by Ron Conescu on 11/3/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILCodeExecutor.h"
#import "UILOpcode.h"
#import "UILFunction.h"
#import "UILMethodFrame.h"
#import "UILOneLineOfCode.h"
#import "UILFoundVariableRecord.h"

@interface UILCodeExecutor ()
@property (nonatomic, strong) NSMutableArray *functionStack;
@property (nonatomic, strong) UILUserAppInRAM *app;
@end

@implementation UILCodeExecutor


// ---------------------------------------------------------
#pragma mark - Startup
// ---------------------------------------------------------

- (id) init
{
	self = [super init];

	if (self)
	{
		self.functionStack = [NSMutableArray new];
	}

	return self;
}

- (void) runApp: (UILUserAppInRAM *) app
{
	self.app = app;
	UILFunction *startFunction = app.functions [APP_MAIN_FUNCTION_NAME];
	[self invokeMethod: startFunction withCountOfParametersToRetrieveFromStack: 0];
}



// ---------------------------------------------------------
#pragma mark - Launching and Returning from Methods
// ---------------------------------------------------------

- (void)                        invokeMethod: (UILFunction *) function
	withCountOfParametersToRetrieveFromStack: (NSInteger) countOfActualInboundParameters
{
	/*
	 Create a new stack frame.  Don't push it on the function
	 stack yet, so we can easily pull stuff from the previous
	 frame's operation stack.
	 */
	UILMethodFrame *frame = [UILMethodFrame new];

	/*
	 Add the parameters.  By popping them off the stack, they'll
	 be in reverse order; we'll fix that shortly.
	 */
	NSMutableArray *reversedParameters = [NSMutableArray new];

	for (NSInteger parameterIndex = 0;
		 parameterIndex < countOfActualInboundParameters;
		 parameterIndex ++)
	{
		[reversedParameters addObject: [self popOperationStackItem]];
	}

	// Reverse them:
	NSEnumerator *enumerator = reversedParameters.reverseObjectEnumerator;
	id nextObject = nil;
	while ((nextObject = enumerator.nextObject) != nil)
	{
		[frame.passedInParameters addObject: nextObject];
	}

	// Assign them to names:
	NSInteger parameterIndex = 0;

	for (id value in frame.passedInParameters)
	{
		id chosenValue = value;

		if (parameterIndex >= function.declaredParameterNames.count)
			break;

		else
		{
			NSString *parameterName = function.declaredParameterNames [parameterIndex];

			if ([chosenValue isKindOfClass: [UILFoundVariableRecord class]])
			{
				UILFoundVariableRecord *variable = chosenValue;
				chosenValue = variable.value;

				NSLog (@"Executor.invokeMethod(): Dereferencing param #%d [%@] from a Variable to [%@].",
					   (int) parameterIndex,
					   parameterName,
					   chosenValue);
			}

			frame.declaredParametersAndValues [parameterName] = chosenValue;

			NSLog (@"Executor.invokeMethod(): Setting formal param #%d [%@] to [%@].",
				   (int) parameterIndex,
				   parameterName,
				   chosenValue);

			parameterIndex ++;
		}
	}

	// Finally, push the new frame on the function stack.
	[self pushFunctionStackFrame: frame];


	//
	// Whew.  Ok.  Run the function!
	//
	for (NSInteger byteIndex = 0; byteIndex < function.machineLanguage.length; byteIndex ++)
	{
		UILOpcode opcode = UILOpcodeUndetermined;
		Byte parameter = 0;

		[function.machineLanguage getBytes: &opcode
									 range: NSMakeRange (byteIndex, 1)];

		BOOL requiresParameter = [UILOpcodeHelper opcodeRequiresParameter: opcode];

		if (requiresParameter)
		{
			byteIndex ++;

			[function.machineLanguage getBytes: &parameter
										 range: NSMakeRange (byteIndex, 1)];
		}

		switch (opcode)
		{
			case UILOpcodeFind:					[self handleOpcodeFind					: opcode  withParameter: parameter];  break;
			case UILOpcodeFindAndMaybeDeclare:	[self handleOpcodeFindAndMaybeDeclare	: opcode  withParameter: parameter];  break;
			case UILOpcodeDeclare:				[self handleOpcodeDeclare				: opcode  withParameter: parameter];  break;
			case UILOpcodeDeclareAndFind:		[self handleOpcodeDeclareAndFind		: opcode  withParameter: parameter];  break;
			case UILOpcodeInteger:				[self handleOpcodeInteger				: opcode  withParameter: parameter];  break;

			case UILOpcodeInvokeMethod:			[self handleOpcodeInvokeMethod			: opcode  withParameter: parameter];  break;
			case UILOpcodeReturn:				[self handleOpcodeReturn				: opcode  withParameter: parameter];  break;
			case UILOpcodeExit:					[self handleOpcodeExit					: opcode  withParameter: parameter];  break;

			case UILOpcodeAssign:				[self handleOpcodeAssign				: opcode  withParameter: parameter];  break;

			case UILOpcodeMultiply:				[self handleOpcodeMultiply				: opcode  withParameter: parameter];  break;

			default:

				NSLog (@"Executor.invokeMethod(): Don't know how to handle opcode # %d [%@]. Skipping. This is probably bad.", (int) opcode, [UILOpcodeHelper camelCaseNameForOpcode: opcode]);
				break;
		}
	}
}



// ---------------------------------------------------------
#pragma mark - The actual operations (opcodes)
// ---------------------------------------------------------

- (void) handleOpcodeFind: (UILOpcode) opcode
			withParameter: (Byte) parameter
{
	NSInteger indexOfIdentifierToFind = (NSInteger) parameter;
	UILFoundVariableRecord *variable = [self findObjectWithIdentifierIndex: indexOfIdentifierToFind];

	if (variable.isNull)
		NSLog (@"Executor.handleFind(): Couldn't find variable named [%@]. Adding NULL to stack.", variable.name);
	else
		NSLog (@"Executor.handleFind(): Adding pointer to variable [%@] on stack", variable.name);

	[self pushOperationStackItem: variable];
}

- (void) handleOpcodeFindAndMaybeDeclare: (UILOpcode) opcode
						   withParameter: (Byte) parameter
{
	NSInteger indexOfNameOfVariableToDeclare = parameter;
	UILFoundVariableRecord *variable = [self findObjectWithIdentifierIndex: indexOfNameOfVariableToDeclare];

	if (variable.isNull)
	{
		NSLog (@"Executor.handleFindOrDeclare(): Creating local variable [%@] in top method frame", variable.name);

		[self declareLocalVariableWithIdentifierIndex: indexOfNameOfVariableToDeclare];

		UILMethodFrame *topFrame = self.functionStack.lastObject;
		[variable setDictionaryBySearchingDictionaries: @[ topFrame.localVariables ]];
	}

	NSLog (@"Executor.handleFindOrDeclare(): Adding pointer to variable [%@] on stack", variable.name);

	[self pushOperationStackItem: variable];
}

- (void) handleOpcodeDeclare: (UILOpcode) opcode
			   withParameter: (Byte) parameter
{
	// debug only
	NSString *identifier = [self identifierWithIndex: parameter];
	NSLog (@"Executor.handleFindOrDeclare(): Creating local variable [%@] in top method frame", identifier);

	[self declareLocalVariableWithIdentifierIndex: parameter];
}

- (void) handleOpcodeDeclareAndFind: (UILOpcode) opcode
					  withParameter: (Byte) parameter
{
	[self handleOpcodeDeclare: opcode withParameter: parameter];
	[self handleOpcodeFind: opcode withParameter: parameter];
}

- (void) handleOpcodeInteger: (UILOpcode) opcode
			   withParameter: (Byte) parameter
{
	NSNumber *integer = [self integerWithIndex: parameter];

	// Push the int itself (or its Number) onto the stack.
	[self pushOperationStackItem: integer];

	NSLog (@"Executor.handleInteger(): Adding integer value [%@] on stack", integer);
}

- (void) handleOpcodeInvokeMethod: (UILOpcode) opcode
					withParameter: (Byte) parameter
{
	NSInteger countOfParametersOnStack = (NSInteger) parameter;
	UILFoundVariableRecord *pointerToMethodToInvoke = [self popOperationStackItem];

	if ([pointerToMethodToInvoke.value isKindOfClass: [UILFunction class]])
	{
		NSLog (@"Executor.invokeMethod(): Invoking method [%@], expecting %d parameters on stack.", pointerToMethodToInvoke.name, (int) countOfParametersOnStack);
		[self invokeMethod: pointerToMethodToInvoke.value withCountOfParametersToRetrieveFromStack: countOfParametersOnStack];
	}

	else
	{
		NSLog (@"Executor.invokeMethod(): WARNING: User tried to invoke [%@] as if it's a method, but it's not.  Ignoring.  This is probably bad.", pointerToMethodToInvoke.name);
	}
}

- (void) handleOpcodeReturn: (UILOpcode) opcode
			  withParameter: (Byte) parameter
{
	BOOL hasReturnValue = (BOOL) parameter;
	id returnValue = nil;

	if (hasReturnValue)
	{
		returnValue = [self popOperationStackItem];
	}

	[self popFunctionStackFrame];

	if (hasReturnValue)
	{
		[self pushOperationStackItem: returnValue];
	}
}

- (void) handleOpcodeExit: (UILOpcode) opcode
			withParameter: (Byte) parameter
{

}

- (void) handleOpcodeAssign: (UILOpcode) opcode
			  withParameter: (Byte) parameter
{
	id value = [self popOperationStackItem];
	id something = [self popOperationStackItem];

	if (! [something isKindOfClass: [UILFoundVariableRecord class]])
		NSLog (@"Executor.handleAssign(): Uh-oh. Didn't find a variable on the operation stack when I expected to.  Instead, it's: [%@]", something);

	else
	{
		UILFoundVariableRecord *variable = something;
		NSLog (@"Executor.handleAssign(): Setting variable [%@] to value [%@].", variable.name, value);

		// This may print a warning, if we attempt to set an unsettable dictionary!
		variable.value = value;
	}
}

/**
 I don't think I need to do all this checking.  Instead, I should
 just come up with a known way to put stuff on the stack, and
 make the compiler do that.  Um...  right?
 */
- (void) handleOpcodeMultiply: (UILOpcode) opcode
				withParameter: (Byte) parameter
{
	id value2 = [self popOperationStackItem];
	id value1 = [self popOperationStackItem];
	UILFoundVariableRecord *variable = nil;
	NSNumber *number1 = nil, *number2 = nil;
	NSMutableArray *errors = [NSMutableArray new];

	if (value2 == nil)
		[errors addObject: @"Nothing on stack. Nothing to multiply."];

	else if (value1 == nil)
		[errors addObject: [NSString stringWithFormat: @"Only one item on stack [%@]. Can't multiply.", value2]];

	else
	{
		if ([value1 isKindOfClass: [NSNumber class]])
		{
			number1 = value1;
		}

		else if ([value1 isKindOfClass: [UILFoundVariableRecord class]])
		{
			variable = value1;
			value1 = variable.value;

			if ([value1 isKindOfClass: [NSNumber class]])
			{
				number1 = value1;
			}
			else
			{
				[errors addObject: [NSString stringWithFormat: @"First value [%@] is a variable, but not a number. Can't multiply.", value1]];
			}
		}
		else
		{
			[errors addObject: [NSString stringWithFormat: @"First value [%@] is neither a Number or a Variable. Can't multiply.", value1]];
		}


		if ([value2 isKindOfClass: [NSNumber class]])
		{
			number2 = value2;
		}

		else if ([value2 isKindOfClass: [UILFoundVariableRecord class]])
		{
			variable = value2;
			value2 = variable.value;

			if ([value2 isKindOfClass: [NSNumber class]])
			{
				number2 = value2;
			}
			else
			{
				[errors addObject: [NSString stringWithFormat: @"Second value [%@] is a variable, but not a number. Can't multiply.", value2]];
			}
		}
		else
		{
			[errors addObject: [NSString stringWithFormat: @"Second value [%@] is neither a Number or a Variable. Can't multiply.", value2]];
		}
 	}

	if (errors.count > 0)
	{
		NSLog (@"Executor.multiply(): Can't multiply, because of the following issues.  Skipping.  This is probably bad.");

		for (NSString *error in errors)
			NSLog (@"-  %@", error);
	}

	else if (number1 == nil || number2 == nil)
	{
		NSLog (@"Executor.multiply(): Can't multiply, but don't know why.  Skipping.  This is probably bad.");
	}

	else
	{
		NSNumber *result = @(number1.integerValue * number2.integerValue);
		NSLog (@"Executor.multiply(): Multiplying %@ * %@ == %@, and putting on the stack.", number1, number2, result);

		[self pushOperationStackItem: result];
	}
}



// ---------------------------------------------------------
#pragma mark - Common methods across opcodes
// ---------------------------------------------------------

- (void) pushOperationStackItem: (id) thingy
{
	[[self.functionStack.lastObject operationStack] addObject: thingy];
}

- (id) popOperationStackItem
{
	UILMethodFrame *currentFrame = self.functionStack.lastObject;

	id topItem = currentFrame.operationStack.lastObject;
	[currentFrame.operationStack removeLastObject];

	return topItem;
}

- (void) pushFunctionStackFrame: (UILMethodFrame *) frame
{
	[self.functionStack addObject: frame];
}

- (UILMethodFrame *) popFunctionStackFrame
{
	id frame = self.functionStack.lastObject;
	[self.functionStack removeLastObject];
	return frame;
}

/**
 In an upcoming version, I'll keep searching up the
 enclosing blocks, methods, classes, containers, etc.
 For now, just search in the top method frame and the
 list of functions in the app.

 Note:  I'm not actually allocating memory myself, so I
 actually don't know where this variable is, so I can't
 put its address on the stack to be played with.  Now what?
 I'm inventing a "variable" object to hold this, but I'm
 still faking it.

 @return Always returns a new UILFoundVariableRecord.  However,
 its isNull flag will be YES if the item in question was not
 found.
 */
- (UILFoundVariableRecord *) findObjectWithIdentifierIndex: (NSInteger) identifierIndex
{
	NSString *identifier = [self identifierWithIndex: identifierIndex];
	UILMethodFrame *topFrame = self.functionStack.lastObject;
	UILFoundVariableRecord *result = [[UILFoundVariableRecord alloc] initWithName: identifier];

	[result setDictionaryBySearchingDictionaries: @[topFrame.localVariables,
													topFrame.declaredParametersAndValues,
													self.app.functions,
													]];

	return result;
}

- (void) declareLocalVariableWithIdentifierIndex: (NSInteger) identifierIndex
{
	NSString *identifier = [self identifierWithIndex: identifierIndex];
	UILMethodFrame *topFrame = self.functionStack.lastObject;

	// If it's already declared, holler.
	id existingValue = topFrame.localVariables [identifier];

	if (existingValue != nil)
	{
		NSLog (@"Executor.declare-low-level(): Declaring [%@] in top frame, but it's already there, set to [%@]!", identifier, existingValue);
	}

	topFrame.localVariables [identifier] = [NSNull null];
}

- (NSString *) identifierWithIndex: (NSInteger) identifierIndex
{
	return self.app.identifiers [identifierIndex];
}

- (NSNumber *) integerWithIndex: (NSInteger) integerIndex
{
	return self.app.integers [integerIndex];
}

@end








