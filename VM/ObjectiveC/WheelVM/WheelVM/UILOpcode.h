//
//  UILOpcode.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 The integers behind these values ARE my machine language.

 Fow now, these will all be effectively random increasing
 integers.  That's fine; I'm still trying to make this work
 at all, so I'm using fully human-readable "assembly"-language
 commands.

 At the moment, these opcodes take either 0 or 1 parameters.
 Either way, they probably operate on the stack.
 
 ----
 Note the funky syntax:
 - the file UILOpcodeEntries.h contains definitions
 - this file says:  "when you get one of those entries, do *this* with it"
 
 My .m file does a couple more of these.
 Helpful docs:
 - https://gcc.gnu.org/onlinedocs/cpp/Concatenation.html
 
 Notes:
 - most important:  use #include, not #import.
 - "##" is a "join" operator; the spaces are ignored.

 See UILOpcodeEntries.h for more information.
 */
typedef enum : NSUInteger {

	#define ENUM_ENTRY(itemName) UILOpcode ## itemName ,
	#include "UILOpcode_Internal.h"
	#undef ENUM_ENTRY

} UILOpcode;




/**
 This class provides helper methods for the enum "UILOpcode."
 See the file UILOpcodeEntries.h for a lot more information.
 
 (I'll probably move that documentation out here.)

 (Actually, I hope I'll figure out a way to automatically
 generate all three of these files for ANY enum.)
 */
@interface UILOpcodeHelper : NSObject

+ (UILOpcode) opcodeForCamelCaseName: (NSString *) name;
+ (UILOpcode) opcodeForTitleCaseName: (NSString *) name;
+ (NSString *) camelCaseNameForOpcode: (UILOpcode) opcode;
+ (NSString *) titleCaseNameForOpcode: (UILOpcode) opcode;

+ (void) printAll;

@end
