//
//  UILOpcode_Internal.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//


/*
 Here's how this file works:

 In various places, I define a macro ENUM_ENTRY(x).
 Immediately afterwards, I #include this file. Then
 I #undef ENUM_ENTRY.  This lets me create enums, strings,
 arrays, and functions that translate from each of those
 types to the others.
 
 If you want to add to this file, the basic requirement is:
 specify the TitleCase version of each ENUM_ENTRY.  I'll
 camelCase it in the code for the appropriate situations.
 Those camelCased versions, in particular, become the words
 we recognize in the incoming assembly-language file.
 (I may add the traditional 3-letter codes, later, but
 there's no need, for now.  I think.)

 Example:  for the entry ENUM_ENTRY(Find), the characters
 "Find" will become:

 - an enum value, UILOpcodeFind, which you can use at
   compile time and for syntax-checking

 - a string, @"find", to be matched against the incoming
   assembly code

 - a string, @"Find", for debug-printing (maybe)

 - dictionary keys in two names-to-opcodes dictionaries,
   so we can generate machine-language code from assembly
   keywords:  key = @"find", value = @(UILOpcodeFind)

 - dictionary values in two opcodes-to-names dictionaries,
   so I can see what machine-language instruction I'm
   processing

 - ...and probably more.

 
 This is something we get for free in Java:  we declare
 an enum, and then each enum value can give us its *name*
 as well as its *value* (and a lot more).  This is a way
 to get that same functionality in Objective-C.
 
 Please TitleCase all these -- start with an initial capital
 letter.  This lets us join them to the prefix "UILOpcode"
 and have it look like standard Objective-C.  I'll lowercase
 them internally for comparison with the assembler and for
 debugging.
 */


// Error-handling during parsing
ENUM_ENTRY(Undetermined)

// Looking stuff up
ENUM_ENTRY(Identifier)				// pull address of a certain identifying string
ENUM_ENTRY(Integer)					// load a certain integer
ENUM_ENTRY(Find)					// find in global space
ENUM_ENTRY(FindOrDeclareAndFind)	// declare as local variable if not found
ENUM_ENTRY(Load)					// put value of variable on stack

// Flow of control
ENUM_ENTRY(InvokeMethod)			// launch a method, consume params, put return value on the stack
ENUM_ENTRY(Return)					// exit the method
ENUM_ENTRY(Exit)					// exit the app

// In-method commands
ENUM_ENTRY(Assign)					// assign value at top of stack to variable whose address is in 2nd position on stack
ENUM_ENTRY(Declare)					// declare variable whose identifier's address is on the stack
ENUM_ENTRY(DeclareAndFind)			// ...and leave the address on the stack, for future assignments or whatever
ENUM_ENTRY(Multiply)				// multiply the top 2 items on the stack, replacing them with the product

// Special stack stuff
ENUM_ENTRY(PushMethodBarrier)		// for safety: when an invoked method consumes params, it can't go past here
