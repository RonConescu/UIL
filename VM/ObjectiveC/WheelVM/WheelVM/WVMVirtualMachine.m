//
//  WVMVirtualMachine.m
//  WheelVM
//
//  Created by Ron Conescu on 11/1/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "WVMVirtualMachine.h"

@interface WVMVirtualMachine ()
@property (nonatomic, strong) NSMutableDictionary *identifiers;
@property (nonatomic, strong) NSMutableDictionary *classes;
@property (nonatomic, strong) NSMutableDictionary *methods;
@property (nonatomic, strong) NSMutableArray *methodFrames;
@property (nonatomic, strong) NSMutableArray *processingStack;
@property (nonatomic, strong) NSMutableArray *threads;
@property (nonatomic, strong) NSDictionary *opcodes;
@end

@implementation WVMVirtualMachine

- (id) init
{
	self = [super init];

	if (self)
	{
		self.identifiers = [NSMutableDictionary new];
		self.classes = [NSMutableDictionary new];
		self.methods = [NSMutableDictionary new];
		self.methodFrames = [NSMutableArray new];
		self.processingStack = [NSMutableArray new];
		self.threads = [NSMutableArray new];

		self.opcodes = @{
						 @(1):	@"find",
						 @(2):	@"subfind",
						 @(3):	@"identifier",
						 @(4):	@"integer",

						 @(5):	@"loadClass",
						 @(6):	@"loadMethod",

						 @(7):	@"runMethod",
						 @(8):	@"declare",
						 @(9):	@"popParam",
						 @(10):	@"flushParams",
						 @(12):	@"findClass",
						 @(11):	@"return",

						 @(13):	@"assign",
						 @(14):	@"add",
						 @(15):	@"multiply",
						 @(16):	@"load",
						 @(17):	@"push",
						 @(18):	@"store",
						 };
	}

	return self;
}


@end
