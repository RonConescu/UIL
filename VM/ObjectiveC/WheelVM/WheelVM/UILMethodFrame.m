//
//  UILMethodFrame.m
//  WheelVM
//
//  Created by Ron Conescu on 11/3/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILMethodFrame.h"

@implementation UILMethodFrame

- (id) init
{
	self = [super init];

	if (self)
	{
		self.operationStack = [NSMutableArray new];
		self.localVariables = [NSMutableDictionary new];
		self.declaredParametersAndValues = [NSMutableDictionary new];
		self.passedInParameters = [NSMutableArray new];
	}

	return self;
}

@end
