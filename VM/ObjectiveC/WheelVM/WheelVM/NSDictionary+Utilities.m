//
//  NSDictionary+Utilities.m
//  WheelVM
//
//  Created by Ron Conescu on 11/4/14.
//  Copyright (c) 2014 EmpowerEveryone. All rights reserved.
//

#import "NSDictionary+Utilities.h"

@implementation NSDictionary (Utilities)

- (BOOL) isMutable
{
	return [self isKindOfClass: [NSMutableDictionary class]];
}

@end
