//
//  UILUserAppInRAM.m
//  WheelVM
//
//  Created by Ron Conescu on 11/2/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "UILUserAppInRAM.h"

@implementation UILUserAppInRAM

- (id) init
{
	self = [super init];

	if (self)
	{
		self.identifiers = [NSMutableArray new];
		self.integers = [NSMutableArray new];
		self.functions = [NSMutableDictionary new];
	}

	return self;
}

@end
