//
//  UILOneLineOfCode.h
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UILOpcodeHelper.h"


@interface UILOneLineOfCode : NSObject

@property (nonatomic, strong) NSString *originalLineOfCode;
@property (nonatomic, strong) NSString *assemblyOperationName;
@property (nonatomic, assign) UILOpcode machineLanguageOpcode;
@property (nonatomic, assign) BOOL hasOperand;
@property (nonatomic, assign) NSInteger operand;

- (id) initWithOriginalString: (NSString *) string
		assemblyOperationName: (NSString *) name
					   opcode: (UILOpcode) opcode
				   hasOperand: (BOOL) hasOperand
					  operand: (NSInteger) operand;

@end
