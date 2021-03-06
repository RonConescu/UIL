//
//  UILOpcode_Internal.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//


/*
 Here's how this file works.
 
 ----------
 In brief
 ----------

 If you type:
	
	ENUM_ENTRY( HelloDude )
 
 then the word "HelloDude" will appear in various variable
 names, identifiers, strings, etc. throughout the app:
 
	UILOpcodeHelloDude	- the opcode enum value
	@"helloDude"		- the string generated by the compiler for a given opcode
	and maybe more
 
 This way, when the compiler generates a command like
 
	helloDude 12
 
 we can convert it to an opcode, call a method with a
 name based on that opcode, and print debugging statements
 to see what's going on.
 
 This mimics behavior we get for free with Java enums.
 In C, enums get compiled out, replaced with their integer
 values.  In Java, they don't; enum values are objects, with
 extra data and methods.  This means we get compile-time 
 checking for enum types, but can also convert back and
 forth to their string equivalents -- very much what we
 need when converting between integers (machine language),
 strings (assembly language), debug statements, and methods
 tied to those enums.

 
 ----------
 In detail
 ----------

 In various places, I define a macro ENUM_ENTRY(x).
 Immediately afterwards, I #include this file, which contains
 a bunch of things called ENUM_ENTRY(blah-blah-blah). Then
 I #undef ENUM_ENTRY.  This lets me create enums and strings
 based on the specified string, and functions that translate
 from each of those forms to another.
 
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
 */


/*
 Parameters to ENUM_ENTRY:
	param 1 (string):  Title-Cased version of assembly-language string
	param 2 (BOOL):    Whether that opcode requires a parameter
 */

// Error-handling during parsing
ENUM_ENTRY(Undetermined, NO)

// Looking stuff up
ENUM_ENTRY(Find, YES)					// find identifier of index X in global space
ENUM_ENTRY(FindAndMaybeDeclare, YES)	// declare identifier of index X as local variable if not found
ENUM_ENTRY(Declare, YES)				// declare variable with identifier of index X
ENUM_ENTRY(DeclareAndFind, YES)			// ...and put the address on the stack, for future assignments or whatever
ENUM_ENTRY(Integer, YES)				// load a pointer to a certain constant integer

// Flow of control
ENUM_ENTRY(InvokeMethod, YES)			// launch a method, consume params, put return value on the stack
ENUM_ENTRY(Return, YES)					// exit the method with the specified number of stack items as return values

// In-method commands
ENUM_ENTRY(Assign, NO)					// assign value at top of stack to variable whose address is in 2nd position on stack
ENUM_ENTRY(Multiply, NO)				// multiply the top 2 items on the stack, replacing them with the product

// Buh-bye
ENUM_ENTRY(Exit, YES)					// exit the app with the specified return code

















